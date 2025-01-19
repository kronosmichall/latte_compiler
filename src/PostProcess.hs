{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Replace case with maybe" #-}
module PostProcess where

import Data.List (find, intercalate, isInfixOf, nub, stripPrefix)
import Data.List.Split (splitOn)
import Data.Map hiding (foldl, map)
import qualified Data.Map as Map hiding (foldl, map)
import Data.Maybe (isJust)
import Types

getLabelRemap :: [Instr] -> Map String Integer
getLabelRemap res = do
  let prefix = "; <label>:"
  let labels = Prelude.map (stripPrefix prefix) res
  let labels2 = map (\(Just s) -> s) $ Prelude.filter (/= Nothing) labels
  let mapp = Map.fromList $ zip labels2 [1 ..]
  mapp

remapLabels :: Map String Integer -> [Instr] -> [Instr]
remapLabels labelMap = map (`mapInstr` labelMap)

mapLabel :: Instr -> Map String Integer -> String
mapLabel instr mapp = case Map.lookup instr mapp of
  Just val -> show val
  Nothing -> instr

safeAt :: [String] -> Int -> String
safeAt list i =
  if length list <= i
    then ""
    else list !! i

mapInstr :: Instr -> Map String Integer -> Instr
mapInstr instr mapp = do
  let br = stripPrefix "\tbr" instr
  let label = stripPrefix "; <label>:" instr
  let phi = "= phi" `isInfixOf` instr
  case () of
    _
      | phi -> do
          let split1 = splitOn ", %" instr
          let p1 = head split1 ++ ", %"
          let split2 = splitOn "]" (split1 !! 1)
          let p2 = head split2
          let p2mapped = mapLabel p2 mapp
          let p3 = "]" ++ split2 !! 1
          let split3 = splitOn "]" (split1 !! 2)
          let p4 = head split3
          let p4mapped = mapLabel p4 mapp
          let p5 = "]"
          p1 ++ p2mapped ++ p3 ++ ", %" ++ p4mapped ++ p5
      | isJust br -> do
          let split1 = splitOn "label %" instr
          let p1 = head split1 ++ "label %"
          let p2 = head $ splitOn ", " (split1 !! 1)
          let p2mapped = mapLabel p2 mapp
          if length split1 == 2
            then p1 ++ p2mapped
            else do
              let p3 = ", label %"
              let p4 = safeAt split1 2
              let p4mapped = mapLabel p4 mapp
              p1 ++ p2mapped ++ p3 ++ p4mapped
      | isJust label -> do
          let split1 = splitOn "; <label>:" instr
          let p1 = "; <label>:"
          let p2 = split1 !! 1
          let p2mapped = mapLabel p2 mapp
          p1 ++ p2mapped
      | otherwise -> instr

findMemCpy :: [Instr] -> [Instr]
findMemCpy = Prelude.filter (\i -> "call void @memcpy" `isInfixOf` i)

fixRets :: [Instr] -> [Instr]
fixRets [] = []
fixRets [x] = [x]
fixRets (x : y : xs) = do
  let isRet = "\tret " `isInfixOf` x
  let isBr = "\tbr " `isInfixOf` y
  if isRet && isBr
    then x : fixRets xs
    else x : fixRets (y : xs)

getStrMapping :: [Instr] -> Map String Integer
getStrMapping res = do
  let literals = findMemCpy res
  let uniqliterals = nub literals
  let mapp = Map.fromList $ zip uniqliterals [1 ..]
  mapp

addConstLiterals :: Map String Integer -> [Instr]
addConstLiterals mapp = do
  let pairs = Map.toList mapp
  map addConstLiteral pairs

getLiteral :: String -> String
getLiteral str = do
  let split1 = splitOn "i8]* \"" str
  let split2 = splitOn "\"," (split1 !! 1)
  head split2

addConstLiteral :: (String, Integer) -> String
addConstLiteral (str, num) = do
  let literal = getLiteral str
  let instr = "@.str" ++ show num ++ " = private constant [" ++ show (length literal + 1) ++ " x i8] c\"" ++ literal ++ "\\00\""
  instr

replaceLiterals :: Map String Integer -> [Instr] -> [Instr]
replaceLiterals mapp = map (`replaceLiteral` mapp)

replaceLiteral :: Instr -> Map String Integer -> Instr
replaceLiteral instr mapp = do
  let isMemCpy = "call void @memcpy" `isInfixOf` instr
  if isMemCpy
    then do
      let split1 = splitOn "i8]* \"" instr
      let p1 = head split1 ++ "i8]* "
      let split2 = split1 !! 1
      let split3 = splitOn "\", " split2
      let p2 = head split3
      let p2mapped = case Map.lookup instr mapp of
            Just val -> "@.str" ++ show val
            Nothing -> error $ "String not found: " ++ instr ++ " in " ++ show mapp
      let p3 = ", " ++ split3 !! 1
      p1 ++ p2mapped ++ p3
    else do
      instr

runAll :: [Instr] -> [Instr]
runAll res = do
  let blocks = splitOn "; topdef-end" (unlines res)
  let blocks2 = map lines blocks
  let remappedBlocks = map (\b -> remapLabels (getLabelRemap b) b) blocks2
  let res2 = concat remappedBlocks
  let res3 = fixRets res2
  let strMapping = getStrMapping res3
  let res4 = addConstLiterals strMapping ++ res3
  replaceLiterals strMapping res4
