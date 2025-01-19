{-# LANGUAGE BlockArguments #-}
{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# OPTIONS_GHC -Wno-unused-matches #-}

module LLVM where

import Abs
import Control.Monad.State
import Data.List (find, intercalate, isInfixOf)
import Data.List.Split (splitOn)
import qualified Data.Map as Map hiding (map)

import qualified PostProcess
import State
import Types
import Data.Char (isLower)
import Common

addLabel :: String -> MyMonad ()
addLabel str = do
  let instr = "; <label>:" ++ str
  addInstr instr

typeToPtr :: MyType -> MyType
typeToPtr = MyPtr

createVar :: VarName -> MyType -> MyMonad ()
createVar name typ = do
  (sts, reg) <- getVars
  let val = (reg, 1, typeToPtr typ)
  let instr =
        "%var" ++ show reg ++ " = alloca " ++ show typ

  putVars (Map.insert name val sts, reg + 1)
  addInstr instr

getValReg :: VarVal -> MyMonad Register
getValReg (VarReg (reg, ref, typ)) = return reg
getValReg _ = error "Not a register"

newVarNoInit :: MyType -> VarName -> MyMonad ()
newVarNoInit typ name = createVar name typ

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
  (sts, reg) <- getVars
  (funs, _, _) <- getTopDefs
  let (typ, _) = case Map.lookup funName funs of
        Just val' -> val'
        Nothing -> error $ "Function " ++ funName ++ " not found"
  let args2 :: [String]
      args2 = map show args

  if typ == MyVoid
    then do
      let instr = "call void @" ++ funName ++ "(" ++ intercalate "," args2 ++ ")"
      addInstr instr
      return VarVoid
    else do
      let instr = "%var" ++ show reg ++ " = call " ++ show typ ++ " @" ++ funName ++ "(" ++ intercalate ", " args2 ++ ")"
      addInstr instr
      addReg
      return (VarReg (reg, 1, typ))

unwrap :: VarVal -> MyMonad VarVal
unwrap (VarReg (reg, ref, MyPtr typ)) = do
  newRef <- getRegIncrement
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
  newRef <- getRegIncrement
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
getBaseType _ = undefined

evalOp'' :: VarVal -> String -> VarVal -> MyType -> MyMonad VarVal
evalOp'' v1 opStr v2 typ = case (v1, v2) of
  -- (VarInt x, VarInt y) -> return (VarInt (x + y))
  (_, _) -> do
    newRef <- getRegIncrement
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
  ref <- getRegIncrement
  let i1 = "%var" ++ show ref ++ " = call i8* @calloc(i64 " ++ show len ++ ", i64 1)"
  let i2 = "call void @memcpy(i8* %var" ++ show ref ++ ", i8* getelementptr inbounds (" ++ strTyp ++ ", " ++ strTyp ++ "* " ++ show str ++ ", i64 0, i64 0), i64 " ++ show len ++ ")"
  addInstr $ combineInstr [i1, i2]
  return $ VarReg (ref, 1, MyStr)

lastLbVar :: MyMonad String
lastLbVar = do
  res <- getRes
  let res2 = reverse res
  let lblstr = find (\s -> "%lbvar" `isInfixOf` s) res2
  let numstr = case lblstr of
        Just s -> head (splitOn " =" s)
        Nothing -> error "Label not found"
  return $ splitOn "\t" numstr !! 1

lastLbl :: MyMonad String
lastLbl = do
  res <- getRes
  let res2 = reverse res
  let lbls = Prelude.take 2 [x | x <- res2, "; <label>:" `isInfixOf` x]
  let lbl2 = lbls !! 1
  return $ splitOn "; <label>:" lbl2 !! 1

evalAnd :: Expr -> Expr -> MyMonad VarVal
evalAnd e1 e2 = do
  v1 <- eval e1
  v11 <- unwrap v1
  case v11 of
    VarBool 0 -> return $ VarBool 0
    VarBool 1 -> return v11
    VarReg (reg, ref, _) -> do
      newRef <- getRegIncrement
      let l1 = show reg ++ "false"
      let l2 = show reg ++ "true"
      let l3 = show reg ++ "end"
      let instr = "br i1 %var" ++ show reg ++ ", label %" ++ l2 ++ ", label %" ++ l1
      addInstr instr
      addLabel l1
      addInstr $ "br label %" ++ l3
      addLabel l2
      v2 <- eval e2
      v22 <- unwrap v2
      case v22 of
        VarBool x -> do
          newRef2 <- getRegIncrement
          addInstr $ "%lbvar" ++ show newRef2 ++ " = add i1 0, " ++ show x
        VarReg (reg2, ref2, _) -> do
          addInstr $ "%lbvar" ++ show reg2 ++ " = add i1 0, %var" ++ show reg2
        x -> error $ "unexpected type" ++ show x
      addInstr $ "br label %" ++ l3
      addLabel l3
      newRef22 <- case v22 of
        VarBool x -> do
          lastReg
        VarReg (reg2, ref2, _) -> return reg2
        _ -> undefined

      lbl <- lastLbl
      lbVar <- lastLbVar
      let ass = "%var" ++ show newRef ++ " = phi i1 [ " ++ lbVar ++ ", %" ++ lbl ++ "], [0, %" ++ l1 ++ "]"
      addInstr ass
      return (VarReg (newRef, 1, MyBool))
    _ -> undefined

evalOr :: Expr -> Expr -> MyMonad VarVal
evalOr e1 e2 = do
  v1 <- eval e1
  v11 <- unwrap v1
  case v11 of
    VarBool 0 -> eval e2
    VarBool 1 -> return $ VarBool 1
    VarReg (reg, ref, _) -> do
      newRef <- getRegIncrement
      let l1 = show reg ++ "true"
      let l2 = show reg ++ "false"
      let l3 = show reg ++ "end"
      let instr = "br i1 %var" ++ show reg ++ ", label %" ++ l1 ++ ", label %" ++ l2
      addInstr instr
      addLabel l1
      addInstr $ "br label %" ++ l3
      addLabel l2
      v2 <- eval e2
      v22 <- unwrap v2
      case v22 of
        VarBool x -> do
          newRef2 <- getRegIncrement
          addInstr $ "%lbvar" ++ show newRef2 ++ " = add i1 0, " ++ show x
        VarReg (reg2, ref2, _) -> do
          addInstr $ "%lbvar" ++ show reg2 ++ " = add i1 0, %var" ++ show reg2
        x -> error $ "unexpected type" ++ show x
      addInstr $ "br label %" ++ l3
      addLabel l3
      newRef22 <- case v22 of
        VarBool x -> do
          newRef2 <- nextReg
          return $ newRef2 - 1
        VarReg (reg2, ref2, _) -> return reg2
        _ -> undefined

      lbl <- lastLbl
      lbVar <- lastLbVar
      let ass = "%var" ++ show newRef ++ " = phi i1 [ " ++ lbVar ++ ", %" ++ lbl ++ "], [1, %" ++ l1 ++ "]"
      addInstr ass
      return (VarReg (newRef, 1, MyBool))
    _ -> undefined 

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
  evalOp' v1 "mul" v2
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
eval (EAnd line e1 e2) = evalAnd e1 e2
eval (EOr line e1 e2) = evalOr e1 e2
eval (ENew _ (Class _ (Ident name))) = do
  if capitalised name
    then do
      undefined
    else do
      reg <- getRegIncrement
      reg2 <- getRegIncrement
      let i1 = "%var" ++ show reg ++ "= load i64, i64* @." ++ name ++ "size"
      let i2 = "%var" ++ show reg2 ++ " = call i8* @calloc(i64 1, i64 %var" ++ show reg ++ ")"
      addInstr $ combineInstr [i1, i2]
      return $ VarReg (reg2, 1, MyStruct name)
eval _ = undefined

lastInstrIsRet :: MyMonad Bool
lastInstrIsRet = do
  instr <- lastInstr
  return $ "\tret " `isInfixOf` instr

exec :: [Stmt] -> MyMonad ()
exec [] = return ()
exec (Empty _ : xs) = exec xs
exec (BStmt _ (Block _ stmts) : xs) = do
  (sts, reg) <- getVars
  exec stmts
  (sts2, reg2) <- getVars
  putVars (sts, reg2)
  exec xs
exec (Decl _ typ items : xs) = do
  mapM_ (declareItem (typeToMy typ)) items
  exec xs
exec (Ass line (Ident name) expr : xs) = do
  v <- eval expr
  setVar name v
  exec xs
exec (Incr line (Ident name) : xs) = do
  let e1 = EVar line (Ident name)
  let e2 = ELitInt line 1
  let expr = EAdd line e1 (Plus line) e2
  exec (Ass line (Ident name) expr : xs)
exec (Decr line (Ident name) : xs) = do
  let e1 = EVar line (Ident name)
  let e2 = ELitInt line 1
  let expr = EAdd line e1 (Minus line) e2
  exec (Ass line (Ident name) expr : xs)
exec (Ret line expr : xs) = do
  v <- eval expr
  v1 <- unwrap v
  let instr = "ret " ++ show v1
  addInstr instr
-- exec xs
exec (VRet line : xs) = do
  let instr = "ret void"
  addInstr instr
-- exec xs

exec (Cond line expr stmt : xs) = do
  v <- eval expr
  v1 <- unwrap v
  case v1 of
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
  v1 <- unwrap v
  case v1 of
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
      ret1 <- lastInstrIsRet
      unless ret1 $ addInstr $ "br label %" ++ l3
      addLabel l2
      exec [stmt2]
      ret2 <- lastInstrIsRet
      unless ret2 $ addInstr $ "br label %" ++ l3
      unless (ret1 && ret2) $ addLabel l3
      exec xs
    x -> error $ "unexpected type" ++ show x
exec (While line expr stmt : xs) = do
  let l0 = show line ++ "while"
  let i0 = "br label %" ++ l0
  addInstr i0
  addLabel l0
  v <- eval expr
  v1 <- unwrap v
  case v1 of
    VarBool 0 -> exec xs
    VarBool 1 -> do
      let l1 = show line ++ "true"
      let i1 = "br label %" ++ l1
      addInstr i1
      addLabel l1
      exec [stmt]
      let instr = "br label %" ++ l1
      addInstr instr
    VarReg (reg, ref, _) -> do
      let l1 = show reg ++ "true"
      let l2 = show reg ++ "false"
      let instr = "br i1 %var" ++ show reg ++ ", label %" ++ l1 ++ ", label %" ++ l2
      addInstr instr
      addLabel l1
      exec [stmt]
      addInstr $ "br label %" ++ l0
      addLabel l2
      exec xs
    x -> error $ "unexpected type" ++ show x
exec (SExp _ expr : xs) = do
  tmp <- eval expr
  exec xs

findMain :: [TopDef] -> TopDef
findMain topdefs =
  head (Prelude.filter isMain topdefs)
 where
  isMain (FnDef _ _ (Ident "main") _ _) = True
  isMain _ = False

funHeader :: TopDef -> String
funHeader (FnDef _ typ (Ident name) args _) = "define " ++ show (typeToMy typ) ++ " @" ++ name ++ "(" ++ intercalate ", " (map (\(Arg _ _ (Ident _)) -> show (typeToMy typ) ++ " %" ++ name) args) ++ ") {"
funHeader _ = ""

initArg :: Arg -> MyMonad ()
initArg (Arg _ typ (Ident name)) = do
  let oldTyp = typeToMy typ
  let newTyp = typeToPtr oldTyp
  newVarNoInit oldTyp name
  (sts, reg) <- getVars
  let instr = "store " ++ show oldTyp ++ " %" ++ name ++ ", " ++ show newTyp ++ " %var" ++ show (reg - 1)
  addInstr instr

initArgs :: [Arg] -> MyMonad ()
initArgs = mapM_ initArg

execFun :: TopDef -> MyMonad ()
execFun topdef = do
  (sts, reg) <- getVars
  addNoTabInstr $ funHeader topdef
  case topdef of
    (FnDef line ret name args (Block _ stmts)) -> do
      initArgs args
      let stmts2 = case ret of
            Void _ -> stmts ++ [VRet BNFC'NoPosition]
            _ -> stmts
      exec stmts2
    _ -> return ()

  putVars (sts, reg)
  addNoTabInstr "}"
  addNoTabInstr ""
  addInstr "; topdef-end"

initFun :: TopDef -> MyMonad ()
initFun (FnDef pos typ (Ident name) args block) = do
  let typ' = typeToMy typ
  let args' = map (\(Arg _ _ (Ident _)) -> typeToMy typ) args
  modifyTopDefs (\(funs, cls, str) -> (Map.insert name (typ', args') funs, cls, str))
initFun _ = return ()


calculateSize :: CBlock -> Integer
calculateSize (CBlock _ defs) = 8 * fromIntegral (length defs)

initStr :: TopDef -> MyMonad ()
initStr (CTopDef _ (Ident name) (CBlock _ stmts)) = do
  let instr = "@." ++ name ++ "size = private constant i64 " ++ show (calculateSize (CBlock BNFC'NoPosition stmts))
  addTopInstr instr
initStr _ = undefined

topDefCode :: (Int, Int) -> String -> String
topDefCode (start, end) code = unlines $ Prelude.take (end - start) $ Prelude.drop start $ lines code

getFuns :: [TopDef] -> [TopDef]
getFuns [] = []
getFuns (x:xs) = case x of
  (FnDef _ _ (Ident name) _ _) ->  if name == "main" 
                                      then getFuns xs 
                                      else x : getFuns xs
  _ -> getFuns xs

getStrDef :: [TopDef] -> [TopDef]
getStrDef [] = []
getStrDef (x:xs) = case x of
  (CTopDef _ (Ident name) _ ) -> if capitalised name then getStrDef xs else x : getStrDef xs
  _ -> getStrDef xs


execProgram :: Program -> MyMonad ()
execProgram (Program _ topdefs) = do
  let strs = getStrDef topdefs
  forM_ strs initStr
  let funs = getFuns topdefs
  forM_ funs initFun
  forM_ funs execFun
  let main = findMain topdefs
  execFun main
  res <- getRes
  let res2 = PostProcess.runAll res
  putRes res2

newFunctionsMap :: FunMap
newFunctionsMap =
  Map.insert "printString" (MyVoid, [MyStr]) $
    Map.insert "printInt" (MyVoid, [MyInt]) $
      Map.insert "readInt" (MyInt, []) $
        Map.insert "readString" (MyStr, []) $
          Map.insert "error" (MyVoid, []) $
            Map.insert "main" (MyInt, []) Map.empty

newState2 :: MyState
newState2 = newState (newFunctionsMap, Map.empty, Map.empty)

comp :: Program -> String
comp prog = do
  let func = runState (execProgram prog)
  let ((), (_, _, res, _)) = func newState2
  unlines res
