{-# OPTIONS_GHC -Wno-name-shadowing #-}
module State where

import Control.Monad.State
import Data.List (intercalate)
import qualified Data.Map.Strict as Map
import Types

type VarState = (VarMap, NextRef)
type TopDefState = (FunMap, StructMap, ClassMap)
-- type RefState = (RefID, Map.Map RefID RefCount)
data RefState = RefState {
  nextID :: RefID,
  refMap :: Map.Map RefID (RefCount, [RefID])
} deriving (Show)

type MyState = (VarState, TopDefState, [Instr], RefState)
type MyMonad = State MyState

newState :: TopDefState -> MyState
newState topDefs = do
  let vars = (Map.empty, 0)
  let refs = RefState { nextID = 1, refMap = Map.empty }
  let res = []
  (vars, topDefs, res, refs)

modifyVars :: (VarState -> VarState) -> MyMonad ()
modifyVars fun = modify (\(v, t, r, ref) -> (fun v, t, r, ref))

modifyTopDefs :: (TopDefState -> TopDefState) -> MyMonad ()
modifyTopDefs fun = modify (\(v, t, r, ref) -> (v, fun t, r, ref))

modifyRes :: ([Instr] -> [Instr]) -> MyMonad ()
modifyRes fun = modify (\(v, t, r, ref) -> (v, t, fun r, ref))

modifyRefs :: (RefState -> RefState) -> MyMonad ()
modifyRefs fun = modify (\(v, t, r, ref) -> (v, t, r, fun ref))

getVars :: MyMonad VarState
getVars = gets (\(v, _, _, _) -> v)

getTopDefs :: MyMonad TopDefState
getTopDefs = gets (\(_, t, _, _) -> t)

getRes :: MyMonad [Instr]
getRes = gets (\(_, _, r, _) -> r)

getRefMap :: MyMonad (Map.Map RefID (RefCount, [RefID]))
getRefMap = do
  refMap <$> getRefs

addDep :: RefID -> RefID -> MyMonad ()
addDep refID depID = do
  refs <- getRefs
  let mapp = refMap refs
  case Map.lookup refID mapp of
    Just (count, deps) -> modifyRefs (\r -> r { refMap = Map.insert refID (count, depID:deps) mapp })
    Nothing -> error $ "cannot add dep form a key " ++ show refID ++ "that does not exist; to " ++ show depID
    -- modifyRefs (\r -> r { refMap = Map.insert refID (1, [depID]) mapp })

getRefs :: MyMonad RefState
getRefs = gets (\(_, _, _, ref) -> ref)

getRefIDIncrement :: MyMonad RefID
getRefIDIncrement = do
  refs <- getRefs
  let refID' = nextID refs
  modifyRefs (\r -> r { nextID = refID' + 1 })
  return refID'

addRef :: RefID -> MyMonad ()
addRef refID = do
  refs <- getRefs
  let mapp = refMap refs
  modifyRefs (\r -> r { refMap = Map.insertWith (\newVal (count, deps) -> (count+1, deps)) refID (1, []) mapp })

subRef :: RefID -> MyMonad ()
subRef refID = do
  refs <- getRefs
  let mapp = refMap refs
  modifyRefs (\r -> r { refMap = Map.update (\(count, ids) -> if count > 1 then Just (count - 1, ids) else Nothing) refID mapp })

getIDCount :: RefID -> MyMonad RefCount
getIDCount refID = do
  refs <- getRefs
  let mapp = refMap refs
  case Map.lookup refID mapp of
    Just (count, _) -> return count
    Nothing -> return 0

getIDDeps :: RefID -> MyMonad [RefID]
getIDDeps refID = do
  refs <- getRefs
  let mapp = refMap refs
  case Map.lookup refID mapp of
    Just (_, ids) -> return ids
    Nothing -> return []

putVars :: VarState -> MyMonad ()
putVars vars = modify (\(_, t, r, ref) -> (vars, t, r, ref))

putTopDefs :: TopDefState -> MyMonad ()
putTopDefs topDefs = modify (\(v, _, r, ref) -> (v, topDefs, r, ref))

putRes :: [Instr] -> MyMonad ()
putRes res = modify (\(v, t, _, ref) -> (v, t, res, ref))

putRefs :: RefState -> MyMonad ()
putRefs refs = modify (\(v, t, r, _) -> (v, t, r, refs))

addInstr :: Instr -> MyMonad ()
addInstr instr = do
  let instr2 = if length (lines instr) == 1 then ["\t" ++ instr] else map ("\t" ++) $ lines instr
  modifyRes (++ instr2)

addNoTabInstr :: Instr -> MyMonad ()
addNoTabInstr instr = do
  let instr2 = if length (lines instr) == 1 then [instr] else lines instr
  modifyRes (++ instr2)

addTopInstr :: Instr -> MyMonad ()
addTopInstr instr = do
  let instr2 = if length (lines instr) == 1 then [instr] else lines instr
  modifyRes (instr2 ++)

combineInstr :: [Instr] -> Instr
combineInstr = intercalate "\n"

getVarReg :: VarName -> MyMonad VarReg
getVarReg name = do
  (sts, _) <- getVars
  case Map.lookup name sts of
    Just reg -> return reg
    Nothing -> error $ "Variable " ++ name ++ " not found"

nextReg :: MyMonad Register
nextReg = do
  (_, reg) <- getVars
  return reg

addReg :: MyMonad ()
addReg = do
  (sts, reg) <- getVars
  putVars (sts, reg + 1)

getRegIncrement :: MyMonad Register
getRegIncrement = do
  (_, reg) <- getVars
  addReg
  return reg

lastReg :: MyMonad Register
lastReg = do
  (_, reg) <- getVars
  return $ reg - 1

lastInstr :: MyMonad Instr
lastInstr = do
  last <$> getRes

getIDsToFree :: MyMonad [RefID]
getIDsToFree = do
  ref <- getRefs
  let mapp = refMap ref
  return $ Map.keys $ Map.filter (\(count, _) -> count == 0) mapp

cleanIDsToFree :: MyMonad ()
cleanIDsToFree = do
  ref <- getRefs
  let mapp = refMap ref
  let refID' = nextID ref
  let mapp2 = Map.filter (\(count, _) -> count > 0) mapp
  putRefs (RefState { nextID = refID', refMap = mapp2})

debugGC :: MyMonad ()
debugGC = do
  refs <- getRefs
  vars <- getVars
  addNoTabInstr $ "; ref map " ++ show refs
  addNoTabInstr $ "; var map " ++ show vars

debug :: String -> MyMonad ()
debug str = addNoTabInstr $ "; " ++ str
