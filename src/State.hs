module State where

import Types
import Control.Monad.State
import qualified Data.Map.Strict as Map
import Data.List (intercalate)

type VarState = (VarMap, NextRef)
type TopDefState = (FunMap, StructMap, ClassMap)
type RefState = Map.Map RefID RefCount
type MyState = (VarState, TopDefState, [Instr], RefState)
type MyMonad = State MyState

newState :: TopDefState -> MyState
newState topDefs = do
  let vars = (Map.empty, 0)
  let refs = Map.empty
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

getRefs :: MyMonad RefState
getRefs = gets (\(_, _, _, ref) -> ref)

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
  (sts, reg) <- getVars
  addReg
  return reg

lastReg :: MyMonad Register
lastReg = do
  (_, reg) <- getVars
  return $ reg - 1

lastInstr :: MyMonad Instr
lastInstr = do
  last <$> getRes