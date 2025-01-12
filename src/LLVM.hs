{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}
{-# OPTIONS_GHC -Wno-unused-matches #-}

module LLVM where

import Abs
import Control.Monad.State
import Data.List (intercalate, isInfixOf, nub, stripPrefix)
import Data.List.Split (splitOn)
import Data.Map hiding (foldl, map)
import qualified Data.Map as Map hiding (foldl, map)
import Data.Maybe (isNothing)
import Debug.Trace (trace)
import GHC.OldList (isPrefixOf)

type Result = [Instr]
type Instr = String
type Refs = Integer
type Register = Integer
type NextRef = Integer
type VarMap = Map VarName VarReg
type FunMap = Map VarName (MyType, [MyType])
type MyState = (VarMap, FunMap, NextRef, Result)
type MyMonad = State MyState

type VarName = String
data VarVal = VarString String | VarInt Integer | VarBool Integer | VarReg VarReg | VarVoid
type VarReg = (Register, Refs, MyType)

instance Show VarVal where
  show (VarString x) = "i8* " ++ x
  show (VarInt x) = "i64 " ++ show x
  show (VarBool x) = "i1 " ++ show x
  show (VarReg (reg, ref, typ)) = show typ ++ " %var" ++ show reg

-- show (VarTmp t) = show t

data MyType = MyInt | MyStr | MyBool | MyVoid | MyPtr MyType
  deriving (Eq)

instance Show MyType where
  show MyInt = "i64"
  show MyStr = "i8*"
  show MyBool = "i1"
  show MyVoid = "void"
  show (MyPtr typ) = show typ ++ "*"

-- show (MyFun ret args) = undefined

typeToMy :: Type -> MyType
typeToMy (Int _) = MyInt
typeToMy (Str _) = MyStr
typeToMy (Bool _) = MyBool
typeToMy (Void _) = MyVoid

-- typeToMy (Fun _ typ typs) = MyFun (typeToMy typ) (map typeToMy typs)

addInstr :: Instr -> MyMonad ()
addInstr instr = do
  (sts, funs, ref, res) <- get
  let instr2 = if length (lines instr) == 1 then ["\t" ++ instr] else map ("\t" ++) $ lines instr
  put (sts, funs, ref, res ++ instr2)

combineInstr :: [Instr] -> Instr
combineInstr = intercalate "\n"

addLabel :: String -> MyMonad ()
addLabel str = do
  let instr = "; <label>:" ++ str
  (sts, funs, ref, res) <- get
  put (sts, funs, ref, res ++ [instr])

typeToPtr :: MyType -> MyType
typeToPtr MyInt = MyPtr MyInt
typeToPtr MyStr = MyPtr MyStr
typeToPtr MyBool = MyPtr MyBool
typeToPtr e = error $ "Unsupported type" ++ show e

createVar :: VarName -> MyType -> MyMonad ()
createVar name typ = do
  (sts, funs, ref, res) <- get
  let val = (ref, 1, typeToPtr typ)
  let instr =
        "%var" ++ show ref ++ " = alloca " ++ show typ

  put (Map.insert name val sts, funs, ref + 1, res)
  addInstr instr

getVarReg :: VarName -> MyMonad VarReg
getVarReg name = do
  (sts, funs, ref, res) <- get
  case Map.lookup name sts of
    Just reg -> return reg
    Nothing -> error $ "Variable " ++ name ++ " not found"

getValReg :: VarVal -> MyMonad Register
getValReg (VarReg (reg, ref, typ)) = return reg
getValReg _ = error "Not a register"

-- setVar :: VarName -> VarVal -> MyMonad ()
-- setVar name val = do

newVarNoInit :: MyType -> VarName -> MyMonad ()
newVarNoInit typ name = createVar name typ

nextReg :: MyMonad Register
nextReg = do
  (sts, funs, ref, res) <- get
  return ref

addReg :: MyMonad ()
addReg = do
  (sts, funs, ref, res) <- get
  put (sts, funs, ref + 1, res)

setVar :: VarName -> VarVal -> MyMonad ()
setVar name val = do
  (reg, ref, typ) <- getVarReg name
  newRef <- nextReg
  let instr = case val of
        VarInt x -> "store i64 " ++ show x ++ ", " ++ show typ ++ " %var" ++ show reg
        VarBool x -> "store i1 " ++ show x ++ ", " ++ show typ ++ " %var" ++ show reg
        VarString x -> error "Strings should always be references"
        VarReg (reg2, ref2, MyPtr typ2) -> do
          let i1 = "%var" ++ show newRef ++ " = load " ++ show typ2 ++ ", " ++ show (MyPtr typ2) ++ " %var" ++ show reg2
          let i2 = "store " ++ show typ2 ++ " %var" ++ show newRef ++ ", " ++ show typ ++ " %var" ++ show reg
          combineInstr [i1, i2]
        VarReg (reg2, ref2, MyStr) -> "store i8* %var" ++ show reg2 ++ ", " ++ show typ ++ " %var" ++ show reg
        VarReg (reg2, ref2, typ2) -> "store " ++ show typ2 ++ " %var" ++ show reg2 ++ ", " ++ show typ ++ " %var" ++ show reg
        _ -> error "Unsupported type"
  addInstr instr
  case val of
    VarReg (reg2, ref2, MyPtr typ2) -> addReg
    _ -> return ()

declareItem :: MyType -> Item -> MyMonad ()
declareItem typ (NoInit line (Ident name)) = newVarNoInit typ name
declareItem typ (Init line (Ident name) expr) = do
  v <- eval expr
  newVarNoInit typ name
  setVar name v

funApply :: VarName -> [VarVal] -> MyMonad VarVal
funApply funName args = do
  (sts, funs, reg, res) <- get
  let (typ, argTypes) = case Map.lookup funName funs of
        Just val' -> val'
        Nothing -> error $ "Function " ++ funName ++ " not found"
  let args2 = mapM show args

  if typ == MyVoid
    then do
      let instr = "call void @" ++ funName ++ "(" ++ join args2 ++ ")"
      addInstr instr
      return VarVoid
    else do
      let instr = "%var" ++ show reg ++ " = call " ++ show typ ++ " @" ++ funName ++ "(" ++ intercalate ", " args2 ++ ")"
      put (sts, funs, reg + 1, res ++ [instr])
      return (VarReg (reg, 1, typ))

unwrap :: VarVal -> MyMonad VarVal
unwrap (VarReg (reg, ref, MyPtr typ)) = do
  newRef <- nextReg
  addReg
  let instr = "%var" ++ show newRef ++ " = load " ++ show typ ++ ", " ++ show (MyPtr typ) ++ " %var" ++ show reg
  addInstr instr
  return (VarReg (newRef, 1, typ))
unwrap x = return x

evalOp :: Expr' BNFC'Position -> String -> Expr' BNFC'Position -> MyMonad VarVal
evalOp e1 opStr e2 = do
  v1 <- eval e1
  v2 <- eval e2
  case (getBaseType v1, getBaseType v2) of
    (MyStr, MyStr) -> evalAddStr v1 v2
    _ -> evalOp' v1 opStr v2

evalAddStr :: VarVal -> VarVal -> MyMonad VarVal
evalAddStr v1 v2 = do
  v11 <- unwrap v1
  v22 <- unwrap v2
  r11 <- getValReg v11
  r22 <- getValReg v22
  newRef <- nextReg
  addReg
  let instr = "%var" ++ show newRef ++ " = call i8* @concat_strings(i8* %var" ++ show r11 ++ ", i8* %var" ++ show r22 ++ ")"
  addInstr instr
  return $ VarReg (newRef, 1, MyStr)

evalVarStr :: VarVal -> MyMonad String
evalVarStr (VarInt x) = return $ show x
evalVarStr (VarBool x) = return $ show x
evalVarStr (VarReg (r1, ref1, MyPtr typ)) = do
  v1' <- unwrap (VarReg (r1, ref1, MyPtr typ))
  r1' <- getValReg v1'
  return $ "%var" ++ show r1'
evalVarStr (VarReg (r1, ref1, typ)) = return $ "%var" ++ show r1
evalVarStr x = error $ "Unsupported type" ++ show x

getBaseType :: VarVal -> MyType
getBaseType (VarInt x) = MyInt
getBaseType (VarBool x) = MyBool
getBaseType (VarString x) = MyStr
getBaseType (VarReg (_, _, MyPtr typ)) = typ
getBaseType (VarReg (_, _, typ)) = typ

evalOp'' :: VarVal -> String -> VarVal -> MyType -> MyMonad VarVal
evalOp'' v1 opStr v2 typ = case (v1, v2) of
  -- (VarInt x, VarInt y) -> return (VarInt (x + y))
  (_, _) -> do
    newRef <- nextReg
    addReg
    s1 <- evalVarStr v1
    s2 <- evalVarStr v2
    let typ2 = getBaseType v1
    let instr = "%var" ++ show newRef ++ " = " ++ opStr ++ " " ++ show typ2 ++ " " ++ s1 ++ ", " ++ s2
    addInstr instr
    return (VarReg (newRef, 1, typ))

evalOp' :: VarVal -> String -> VarVal -> MyMonad VarVal
evalOp' v1 opStr v2 = do
  let typ = getBaseType v1
  evalOp'' v1 opStr v2 typ

evalStr :: String -> MyMonad VarVal
evalStr str = do
  let len = length str + 1
  let strTyp = "[" ++ show len ++ " x i8]"
  ref <- nextReg
  let i1 = "%var" ++ show ref ++ " = call i8* @calloc(i64 " ++ show len ++ ", i64 1)"
  let i2 = "call void @memcpy(i8* %var" ++ show ref ++ ", i8* getelementptr inbounds (" ++ strTyp ++ ", " ++ strTyp ++ "* " ++ show str ++ ", i64 0, i64 0), i64 " ++ show len ++ ")"
  addInstr $ combineInstr [i1, i2]
  addReg
  return $ VarReg (ref, 1, MyStr)

eval :: Expr -> MyMonad VarVal
eval (EVar line (Ident name)) = do
  reg <- getVarReg name
  return (VarReg reg)
eval (ELitInt _ x) = return (VarInt x)
eval (ELitTrue _) = return (VarBool 1)
eval (ELitFalse _) = return (VarBool 0)
eval (EApp line (Ident name) exprs) = do
  args <- mapM eval exprs
  args2 <- mapM unwrap args
  funApply name args2
eval (EString _ str) = evalStr str
eval (Not line e) = do
  v <- eval e
  let v2 = VarBool 1
  evalOp' v "xor" v2
eval (Neg line e) = do
  v1 <- eval e
  let v2 = VarInt (-1)
  evalOp' v1 "add" v2
eval (EMul line e1 op e2) = do
  let opStr = case op of
        Times _ -> "mul"
        Div _ -> "sdiv"
        Mod _ -> "srem"
  evalOp e1 opStr e2
eval (EAdd line e1 op e2) = do
  let opStr = case op of
        Plus _ -> "add"
        Minus _ -> "sub"
  evalOp e1 opStr e2
eval (ERel line e1 op e2) = do
  let opStr = case op of
        LTH _ -> "icmp slt"
        LE _ -> "icmp sle"
        GTH _ -> "icmp sgt"
        GE _ -> "icmp sge"
        EQU _ -> "icmp eq"
        NE _ -> "icmp ne"
  v1 <- eval e1
  v2 <- eval e2
  evalOp'' v1 opStr v2 MyBool
eval (EAnd line e1 e2) = do
  let opStr = "and"
  evalOp e1 opStr e2
eval (EOr line e1 e2) = do
  let opStr = "or"
  evalOp e1 opStr e2
exec :: [Stmt] -> MyMonad ()
exec [] = return ()
exec (Empty _ : xs) = exec xs
exec (BStmt _ (Block _ stmts) : xs) = do
  (sts, funs, ref, res) <- get
  exec stmts
  (_, funs2, ref2, res2) <- get
  put (sts, funs2, ref2, res2)
  exec xs
exec (Decl _ typ items : xs) = do
  mapM_ (declareItem (typeToMy typ)) items
  exec xs
exec (Ass line (Ident name) expr : xs) = do
  v <- eval expr
  setVar name v
  exec xs

-- exec (Incr line (Ident name) : xs) = do

-- exec (Decr line  ident : xs) =
exec (Ret line expr : xs) = do
  exec xs
  v <- eval expr
  let instr = "ret " ++ show v
  addInstr instr
exec (VRet line : xs) = do
  let instr = "ret"
  addInstr instr
-- exec xs

exec (Cond line expr stmt : xs) = do
  v <- eval expr
  case v of
    VarBool 0 -> exec xs
    VarBool 1 -> exec $ stmt : xs
    VarReg (reg, ref, _) -> do
      let l1 = show reg ++ "true"
      let l2 = show reg ++ "false"
      let instr = "br i1 %var" ++ show reg ++ ", label %" ++ l1 ++ ", label %" ++ l2
      addInstr instr
      addLabel l1
      exec [stmt]
      addInstr $ "br label %" ++ l2
      addLabel l2
      exec xs
    x -> error $ "unexpected type" ++ show x
exec (CondElse _ expr stmt1 stmt2 : xs) = do
  v <- eval expr
  case v of
    VarBool 0 -> exec $ stmt2 : xs
    VarBool 1 -> exec $ stmt1 : xs
    VarReg (reg, ref, _) -> do
      let l1 = show reg ++ "true"
      let l2 = show reg ++ "false"
      let l3 = show reg ++ "end"
      let i1 = "br i1 %var" ++ show reg ++ ", label %" ++ l1 ++ ", label %" ++ l2
      addInstr i1
      addLabel l1
      exec [stmt1]
      addInstr $ "br label %" ++ l3
      addLabel l2
      exec [stmt2]
      addInstr $ "br label %" ++ l3
      addLabel l3
      exec xs
    x -> error $ "unexpected type" ++ show x

-- exec (While line expr stmt : xs) =
exec (SExp _ expr : xs) = do
  tmp <- eval expr
  exec xs
exec other = trace ("myFunction called with " ++ show other) undefined

findMain :: [TopDef] -> TopDef
findMain topdefs =
  head (Prelude.filter isMain topdefs)
 where
  isMain (FnDef _ _ (Ident "main") _ _) = True
  isMain _ = False

topDefHeader :: TopDef -> String
topDefHeader (FnDef _ typ (Ident name) args _) = "define " ++ show (typeToMy typ) ++ " @" ++ name ++ "(" ++ intercalate ", " (map (\(Arg _ typ (Ident name)) -> show (typeToMy typ) ++ " %" ++ name) args) ++ ") {"

-- initArg :: Arg -> MyMonad ()
-- initArg (Arg _ _ (Ident name)) = do
--     modify (\(sts, funs,  ref,  res) -> (Map.insert name (ref, 1) sts, funs, ref + 1,  res))

-- initArgs :: [Arg] -> MyMonad ()
-- initArgs = mapM_ initArg

execTopDef :: TopDef -> MyMonad ()
execTopDef topdef = do
  let funHeader = topDefHeader topdef
  trace funHeader $ return ()
  (sts, funs, ref, res) <- get
  put (sts, funs, ref, res ++ [funHeader])
  case topdef of
    (FnDef line ret name args (Block _ stmts)) -> do
      -- initArgs args
      exec stmts

  (sts', funs', ref', res') <- get
  put (sts, funs', ref, res' ++ ["}", ""])

initTopDef :: TopDef -> MyMonad ()
initTopDef (FnDef pos typ (Ident name) args block) = do
  let typ' = typeToMy typ
  let args' = map (\(Arg _ typ (Ident name)) -> typeToMy typ) args
  modify (\(sts, funs, ref, res) -> (sts, Map.insert name (typ', args') funs, ref, res))

topDefCode :: (Int, Int) -> String -> String
topDefCode (start, end) code = unlines $ Prelude.take (end - start) $ Prelude.drop start $ lines code

execProgram :: Program -> MyMonad ()
execProgram (Program _ topdefs) = do
  -- initPrints
  let funs = Prelude.filter (\(FnDef _ _ (Ident name) _ _) -> name /= "main") topdefs
  forM_ funs initTopDef
  forM_ funs execTopDef
  let main = findMain topdefs
  execTopDef main
  labelMap <- getLabelRemap
  remapLabels labelMap
  strMapping <- getStrMapping
  addConstLiterals strMapping
  replaceLiterals strMapping

newFunctionsMap :: FunMap
newFunctionsMap =
  Map.insert "printString" (MyVoid, [MyStr]) $
    Map.insert "printInt" (MyVoid, [MyInt]) $
      Map.insert "error" (MyVoid, []) $
        Map.insert "main" (MyInt, []) Map.empty

newState :: MyState
newState = (Map.empty, newFunctionsMap, 1, [])

getLabelRemap :: MyMonad (Map String Integer)
getLabelRemap = do
  (sts, funs, ref, res) <- get
  let prefix = "; <label>:"
  let labels = Prelude.map (stripPrefix prefix) res
  let labels2 = map (\(Just s) -> s) $ Prelude.filter (/= Nothing) labels
  let mapp = Map.fromList $ zip labels2 [1 ..]
  return mapp

remapLabels :: Map String Integer -> MyMonad ()
remapLabels labelMap = do
  (sts, funs, ref, res) <- get
  res2 <- mapM (`mapInstr` labelMap) res
  put (sts, funs, ref, res2)

mapLabel :: Instr -> Map String Integer -> MyMonad String
mapLabel instr mapp = case Map.lookup instr mapp of
  Just val -> return $ show val
  Nothing -> return instr

safeAt :: [String] -> Int -> String
safeAt list i =
  if length list <= i
    then ""
    else list !! i

mapInstr :: Instr -> Map String Integer -> MyMonad Instr
mapInstr instr mapp = do
  let br = stripPrefix "\tbr" instr
  let label = stripPrefix "; <label>:" instr
  if isNothing br && isNothing label
    then return instr
    else
      if isNothing label
        then do
          let split1 = splitOn "label %" instr
          let p1 = head split1 ++ "label %"
          let p2 = head $ splitOn ", " (split1 !! 1)
          p2mapped <- mapLabel p2 mapp
          if length split1 == 2
            then return $ p1 ++ p2mapped
            else do
              let p3 = ", label %"
              let p4 = safeAt split1 2
              p4mapped <- mapLabel p4 mapp
              return $ p1 ++ p2mapped ++ p3 ++ p4mapped
        else do
          let split1 = splitOn "; <label>:" instr
          let p1 = "; <label>:"
          let p2 = split1 !! 1
          p2mapped <- mapLabel p2 mapp
          return $ p1 ++ p2mapped

findMemCpy :: [Instr] -> [Instr]
findMemCpy = Prelude.filter (\i -> "call void @memcpy" `isInfixOf` i)

getStrMapping :: MyMonad (Map String Integer)
getStrMapping = do
  (sts, funs, ref, res) <- get
  let literals = findMemCpy res
  let uniqliterals = nub literals
  let mapp = Map.fromList $ zip uniqliterals [1 ..]
  return mapp

addConstLiterals :: Map String Integer -> MyMonad ()
addConstLiterals mapp = do
  let pairs = Map.toList mapp
  instrs <- mapM addConstLiteral pairs
  (sts, funs, ref, res) <- get
  put (sts, funs, ref, instrs ++ res)

getLiteral :: String -> String
getLiteral str = do
  let split1 = splitOn "i8]* \"" str
  let split2 = splitOn "\"," (split1 !! 1)
  head split2

addConstLiteral :: (String, Integer) -> MyMonad String
addConstLiteral (str, num) = do
  let literal = getLiteral str
  let instr = "@.str" ++ show num ++ " = private constant [" ++ show (length literal + 1) ++ " x i8] c\"" ++ literal ++ "\\00\""
  return instr

replaceLiterals :: Map String Integer -> MyMonad ()
replaceLiterals mapp = do
  (sts, funs, ref, res) <- get
  instrs2 <- mapM (`replaceLiteral` mapp) res
  put (sts, funs, ref, instrs2)

replaceLiteral :: Instr -> Map String Integer -> MyMonad Instr
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
      return $ p1 ++ p2mapped ++ p3
    else do
      return instr

comp :: Program -> String
comp prog = do
  let func = runState (execProgram prog)
  let ((), (_, _, _, res)) = func newState
  unlines res

showSts :: MyMonad ()
showSts = do
  (sts, funs, ref, res) <- get
  trace (show sts) $ return ()
