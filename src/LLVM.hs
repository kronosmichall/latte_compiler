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

import Common
import qualified Objects
import qualified PostProcess
import State
import Types
import qualified Control.Monad

addLabel :: String -> MyMonad ()
addLabel str = do
  let instr = "; <label>:" ++ str
  addNoTabInstr instr

typeToPtr :: MyType -> MyType
typeToPtr = MyPtr

createVar :: VarName -> MyType -> MyMonad Integer
createVar name typ = do
  (sts, reg) <- getVars
  let val = (reg, -1, typeToPtr typ)
  let instr =
        "%var" ++ show reg ++ " = alloca " ++ show typ

  putVars (Map.insert name val sts, reg + 1)
  addInstr instr
  return reg

createVarSetNull :: VarName -> MyType -> MyMonad ()
createVarSetNull name typ = do
  reg <- createVar name typ
  case typ of
    MyStruct _ -> do
      let instr2 = "store i8* null, i8** %var" ++ show reg
      addInstr instr2
    MyClass _ -> do
      let instr2 = "store i8* null, i8** %var" ++ show reg
      addInstr instr2
    _ -> return ()

getValReg :: VarVal -> MyMonad Register
getValReg (VarReg (reg, ref, typ)) = return reg
getValReg _ = error "Not a register"

newVarNoInit :: MyType -> VarName -> MyMonad ()
newVarNoInit typ name = createVarSetNull name typ

setVar :: VarReg -> VarVal -> MyMonad ()
setVar (reg, refID, typ) v1 = do
  newReg <- nextReg
  v2 <- unwrap v1
  let instr = case v2 of
        VarInt x -> "store i64 " ++ show x ++ ", " ++ show typ ++ " %var" ++ show reg
        VarBool x -> "store i1 " ++ show x ++ ", " ++ show typ ++ " %var" ++ show reg
        VarString x -> error "Strings should always be references"
        VarReg (reg2, refID2, MyStr) -> "store i8* %var" ++ show reg2 ++ ", " ++ show typ ++ " %var" ++ show reg
        VarReg (reg2, refID2, typ2) -> "store " ++ show typ2 ++ " %var" ++ show reg2 ++ ", " ++ show typ ++ " %var" ++ show reg
        _ -> error "Unsupported type"
  case v2 of
    VarReg (_, refID2, _) -> do
      addRef refID2
      subRef refID
    _ -> return ()

  oldCount <- getIDCount refID
  Control.Monad.when (oldCount == 0 && refID /= -1) $ freeIDs [refID]
  addInstr instr


declareItem :: MyType -> Item -> MyMonad ()
declareItem typ (NoInit line (Ident name)) = newVarNoInit typ name
declareItem typ (Init line (Ident name) expr) = do
  v <- eval expr
  _ <- createVar name typ
  (reg, refID, typ2) <- getVarReg name
  setVar (reg, refID, typ2) v

  case v of
    VarReg (_, refID2, _) -> do
      modifyVars (\(mapp, ref) -> (Map.insert name (reg, refID2, typ2) mapp, ref))
    _ -> return ()

  debugGC

funApply :: VarName -> [VarVal] -> MyMonad VarVal
funApply funName args = do
  reg <- getRegIncrement
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
      refID <- getRefIDIncrement
      addRef refID
      return (VarReg (reg, refID, typ))

unwrap :: VarVal -> MyMonad VarVal
unwrap (VarReg (reg, ref, MyPtr typ)) = do
  newRef <- getRegIncrement
  let instr = "%var" ++ show newRef ++ " = load " ++ show typ ++ ", " ++ show (MyPtr typ) ++ " %var" ++ show reg
  addInstr instr
  return (VarReg (newRef, ref, typ))
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
  refID <- getRefIDIncrement
  addRef refID
  return $ VarReg (newRef, refID, MyStr)

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
  refID <- getRefIDIncrement
  addInstr $ combineInstr [i1, i2]
  return $ VarReg (ref, refID, MyStr)

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
  let typ =
        if capitalised name
          then MyClass name
          else MyStruct name
  reg <- getRegIncrement
  reg2 <- getRegIncrement
  let i1 = "%var" ++ show reg ++ "= load i64, i64* @." ++ name ++ "size"
  let i2 = "%var" ++ show reg2 ++ " = call i8* @calloc(i64 1, i64 %var" ++ show reg ++ ")"
  addInstr $ combineInstr [i1, i2]
  refID <- getRefIDIncrement
  -- addRef refID
  return $ VarReg (reg2, refID, typ)
eval (ENew _ _) = undefined
eval (EAttr line (Ident obj) attrIdent) = do
  v1 <- eval (EVar line (Ident obj))
  v2 <- unwrap v1
  ceval v2 attrIdent [obj]

eval (ENull _ ) = do
  undefined
eval (ESelfMet _ _) = do
  undefined
-- eval (ENull _ (Ident cls)) = do
--   let typ =
--         if capitalised cls -- classes
--           then MyPtr (MyClass cls)
--           else MyPtr (MyStruct cls)

--   reg <- getRegIncrement
--   let i1 = "%var" ++ show reg ++ " = alloca i8*"
--   let i2 = "store i8* null, i8** %var" ++ show reg
--   addInstr $ combineInstr [i1, i2]
--   return $ VarReg (reg, -1, typ)

eval (EMet line (Ident obj) chain) = do
  v1 <- eval (EVar line (Ident obj))
  v2 <- unwrap v1
  res <- foldM (evalChain obj) v2 chain
  return res
  
  where
    evalChain :: VarName -> VarVal -> EChain -> MyMonad VarVal
    evalChain obj v2 (EChain line sident exprs) = do
      v3 <- cevalMethChain v2 sident [obj]
      args <- mapM eval exprs
      args2 <- mapM unwrap args
      let methodName = getMethName sident
      case v3 of 
        VarReg (reg, ref, MyClass clsName) -> do
          let funName = clsName ++ "." ++ methodName
          funApply funName (v3 : args2) 
        _ -> error "unexpected chain"

eval (EMet _ (Ident obj) [])  = do
  undefined
--   v1 <- eval e
--   v2 <- unwrap v1
--   case v2 of
--     VarReg(reg, ref, MyClass clsName) -> 
--       let funName = clsName ++ "." ++ name
--       in do
--         args <- mapM eval exprs
--         args2 <- mapM unwrap args
--         funApply funName (v1 : args2)
--     x-> error $ "unexpected call method for " ++ show x


cevalMethChain ::VarVal -> SIdent -> [String] -> MyMonad VarVal
cevalMethChain v (SIdentAttr line (Ident attr) sident) path = ceval v (SIdentAttr line (Ident attr) sident) path
cevalMethChain v (SIdent _ (Ident attr)) path = do 
  return v

getMethName :: SIdent -> String
getMethName (SIdent _ (Ident name)) = name
getMethName (SIdentAttr _ (Ident name) sident) = getMethName sident

ceval :: VarVal -> SIdent -> [String] -> MyMonad VarVal
ceval v (SIdent _ (Ident attr)) path = do
  let path2 = intercalate "." $ path ++ [attr]
  v2 <- unwrap v
  case v2 of
    VarReg (reg, ref, typ2) -> do
      let objName = case typ2 of
            MyClass x -> x
            MyStruct x -> x
            _ -> undefined
      shift <- getAttrShift objName attr
      typ <- getAttrType objName attr
      reg2 <- getRegIncrement
      reg3 <- getRegIncrement
      let i1 = "%var" ++ show reg2 ++ " = getelementptr  i8, i8* %var" ++ show reg ++ ", i64 " ++ show shift
      let i2 = "%var" ++ show reg3 ++ " = bitcast i8* %var" ++ show reg2 ++ " to " ++ show (typeToPtr typ)
      addInstr $ combineInstr [i1, i2]
      (sts, _) <- getVars
      case Map.lookup path2 sts of
        Just (_, refID2, _) -> return $ VarReg (reg3, refID2, typeToPtr typ)
        Nothing -> do
          refID <- getRefIDIncrement
          addRef refID
          return $ VarReg (reg3, refID, typeToPtr typ)
    _ -> undefined


ceval v (SIdentAttr line (Ident attr) sident) path = do
  let path2 = path ++ [attr]
  v2 <- ceval v (SIdent line (Ident attr)) path2
  ceval v2 sident path2

ceval2 :: SIdent -> MyMonad VarVal
ceval2 (SIdent line (Ident attr)) = do
  eval (EVar line (Ident attr))
ceval2 (SIdentAttr line (Ident attr) sident) = do
  v <- ceval2 (SIdent line (Ident attr))
  ceval v sident [attr]


lastInstrIsRet :: MyMonad Bool
lastInstrIsRet = do
  instr <- lastInstr
  return $ "\tret " `isInfixOf` instr

freeIDs :: [RefID] -> MyMonad ()
freeIDs refIDs = do
  (sts, _) <- getVars
  let vars = Map.toList sts
  let regs = map snd vars
  let toFree = filter (\(_, ref, _) -> ref `elem` refIDs) regs
  let uniq = foldr (\x acc -> if getRefID x `elem` map getRefID acc then acc else x : acc) [] toFree
  let uniq2= filter isHeapAllocated uniq
  varVals <- mapM (\(reg, ref, typ) -> unwrap (VarReg (reg, ref, typ))) uniq2
  let instrs = map (\(VarReg (reg, ref, typ)) -> "call void @free (i8* %var" ++ show reg ++ ")") varVals
  addInstr $ combineInstr instrs
  where
    getRefID :: VarReg -> RefID
    getRefID (_, ref, _) = ref
    isHeapAllocated :: VarReg -> Bool
    isHeapAllocated (_, ref, typ) = ref /= -1 && "i8*" `isInfixOf` show typ

-- closeVars :: VarMap -> VarMap -> MyMonad ()
-- closeVars mold mnew = do
--   let keys = Map.keys mold
--   let keys2 = Map.keys mnew
--   let keys3 = filter (`notElem` keys2) keys
--   let baseKeys = filter (\x -> not $ "." `isInfixOf` x) keys3
--   debug $ "decrementing base vars " ++ show baseKeys
--   baseIDs <- mapM (`getRef` mold) baseKeys
--   let keysWithIds = zip baseKeys baseIDs
--   forM_ baseIDs $ \i -> do
--     subRef i

--   refMap <- getRefMap
--   let zeroedKeysWithIds = filter (\(k,kid) -> refMap Map.! kid == 0) keysWithIds
--   let zeroKeys = map fst zeroedKeysWithIds
--   let nestedKeys = concatMap (\x -> filter (isPrefixOf $ x ++ ".") keys3) zeroKeys
--   nestedIDs <- mapM (`getRef` mold) nestedKeys


--   debug $ "decrementing nested vars " ++ show nestedKeys
--   forM_ nestedIDs $ \i -> do
--     subRef i

--   where
--     getRef :: String -> VarMap -> MyMonad RefID
--     getRef k mapp = case Map.lookup k mapp of
--               Just (_, ref, _) -> return ref
--               Nothing -> error "Variable not found"


sIdentToString :: SIdent -> String
sIdentToString (SIdent _ (Ident name)) = name
sIdentToString (SIdentAttr _ (Ident name) sIdent) = name ++ "." ++ sIdentToString sIdent

mapEndingVars :: VarMap -> VarMap -> MyMonad ()
mapEndingVars vold vnew = do
  let kold = Map.keys vold
  let knew = Map.keys vnew
  let kdiff = filter (`notElem` knew) kold
  forM_ kdiff mapEndingVar

  where
    mapEndingVar :: String -> MyMonad ()
    mapEndingVar name = do
      (reg, ref, typ) <- getVarReg name
      let newName = show reg ++ "tofree"
      modifyVars (\(mapp, ref2) -> (Map.delete name mapp, ref2))
      modifyVars (\(mapp, ref2) -> (Map.insert newName (reg, ref, typ) mapp, ref2))

exec :: [Stmt] -> MyMonad ()
exec [] = return ()
exec (Empty _ : xs) = exec xs
exec (BStmt _ (Block _ stmts) : xs) = do
  (sts, reg) <- getVars
  exec stmts
  (sts2, reg2) <- getVars
  mapEndingVars sts2 sts
  -- closeVars sts2 sts
  -- idsToFree <- getIDsToFree
  -- freeIDs idsToFree
  -- cleanIDsToFree
  -- modifyVars (\(_, reg3) -> (sts, reg3))

  debugGC

  exec xs
exec (Decl _ typ items : xs) = do
  mapM_ (declareItem (typeToMy typ)) items
  exec xs
exec (Ass line sIdent expr : xs) = do
  v1 <- ceval2 sIdent
  v2 <- eval expr
  case v1 of
    VarReg (reg, refID, typ) -> do
      debug $ "old id" ++ show refID
      setVar (reg, refID, typ) v2
      case v2 of
        VarReg (_, refID2, _) -> do
          modifyVars (\(mapp, ref) -> (Map.insert (sIdentToString sIdent) (reg, refID2, typ) mapp, ref))
        x -> error $  "unexpected type " ++ show x
    x -> error $ "unexpected type " ++ show x
  debugGC
  exec xs
exec (Incr line sIdent : xs) = do
  let e2 = ELitInt line 1
  let expr = case sIdent of
        SIdent _ (Ident attr) -> EAdd line (EVar line (Ident attr)) (Plus line) e2
        SIdentAttr _ (Ident name) sIdent2 -> EAdd line (EAttr line (Ident name) sIdent2) (Plus line) e2
  exec (Ass line sIdent expr : xs)
exec (Decr line sIdent : xs) = do
  let e2 = ELitInt line 1
  let expr = case sIdent of
        SIdent _ (Ident attr) -> EAdd line (EVar line (Ident attr)) (Minus line) e2
        SIdentAttr _ (Ident name) sIdent2 -> EAdd line (EAttr line (Ident name) sIdent2) (Plus line) e2
  exec (Ass line sIdent expr : xs)
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
  res1 <- getRes
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
funHeader (FnDef _ typ (Ident name) args _) = "define " ++ show (typeToMy typ) ++ " @" ++ name ++ "(" ++ intercalate ", " (map (\(Arg _ xtyp (Ident x)) -> show (typeToMy xtyp) ++ " %" ++ x) args) ++ ") {"
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
  addNoTabInstr "; topdef-end"

initFun :: TopDef -> MyMonad ()
initFun (FnDef pos typ (Ident name) args block) = do
  let typ' = typeToMy typ
  let args' = map (\(Arg _ _ (Ident _)) -> typeToMy typ) args
  modifyTopDefs (\(funs, cls, str) -> (Map.insert name (typ', args') funs, cls, str))
initFun _ = return ()

getAttrShift :: String -> String -> MyMonad Integer
getAttrShift objName attrName = do
  attrs <- getAttrs objName
  let (_, shift2) = foldl (\(found, shift) (name, typ) -> if found then (found, shift) else if name == attrName then (True, shift) else (False, shift + 1)) (False, 0) attrs
  return $ shift2 * 8

getAttrType :: String -> String -> MyMonad MyType
getAttrType objName attrName = do
  attrs <- getAttrs objName

  case find (\(n, t) -> n == attrName) attrs of
    Just (_, typ) -> return typ
    Nothing -> error $ "Attribute " ++ attrName ++ " not found"

getAttrs :: String -> MyMonad [Attr]
getAttrs objName = do
    if capitalised objName
      then do
        (_, _, cls) <- getTopDefs
        case Map.lookup objName cls of
              Just (_, _, a2) -> return a2
              Nothing -> error $ "Class " ++ objName ++ " not found"
      else do
        (_, str, _) <- getTopDefs
        case Map.lookup objName str of
              Just x -> return x
              Nothing -> error $ "Struct " ++ objName ++ " not found"

calcStrSize :: CBlock -> Integer
calcStrSize (CBlock _ defs) = do
  let attrs = filter isAttr defs
  8 * fromIntegral (length attrs)

isAttr :: CDef' a -> Bool
isAttr (Attr{}) = True
isAttr _ = False

initClsAttrs :: String -> CBlock -> MyMonad ()
initClsAttrs clsName (CBlock _ defs) = do
  let attrs = map (\(Attr _ typ (Ident attrName)) -> (attrName, typeToMy typ)) $ filter isAttr defs
  let clsVal = (clsName, [], attrs) -- if does not extend then parentClass == self
  modifyTopDefs (\(funs, str, cls) -> (funs, str, Map.insert clsName clsVal cls))

initCls :: TopDef -> MyMonad ()
initCls (CTopDef _ (Ident name) (CBlock _ stmts)) = do
  let instr = "@." ++ name ++ "size = private constant i64 " ++ show (calcStrSize (CBlock BNFC'NoPosition stmts))
  addTopInstr instr
  initClsAttrs name (CBlock BNFC'NoPosition stmts)
initCls _ = undefined

initStrAttrs :: String -> CBlock -> MyMonad ()
initStrAttrs strName (CBlock _ defs) = do
  let attrs = map (\(Attr _ typ (Ident attrName)) -> (attrName, typeToMy typ)) $ filter isAttr defs
  modifyTopDefs (\(funs, str, cls) -> (funs, Map.insert strName attrs str, cls))

initStr :: TopDef -> MyMonad ()
initStr (CTopDef _ (Ident name) (CBlock _ stmts)) = do
  let instr = "@." ++ name ++ "size = private constant i64 " ++ show (calcStrSize (CBlock BNFC'NoPosition stmts))
  addTopInstr instr
  initStrAttrs name (CBlock BNFC'NoPosition stmts)
initStr _ = undefined

topDefCode :: (Int, Int) -> String -> String
topDefCode (start, end) code = unlines $ Prelude.take (end - start) $ Prelude.drop start $ lines code

getFuns :: [TopDef] -> [TopDef]
getFuns [] = []
getFuns (x : xs) = case x of
  (FnDef _ _ (Ident name) _ _) ->
    if name == "main"
      then getFuns xs
      else x : getFuns xs
  _ -> getFuns xs

getStrDef :: [TopDef] -> [TopDef]
getStrDef [] = []
getStrDef (x : xs) = case x of
  (CTopDef _ (Ident name) _) -> if capitalised name then getStrDef xs else x : getStrDef xs
  _ -> getStrDef xs

getClsDef :: [TopDef] -> [TopDef]
getClsDef [] = []
getClsDef (x : xs) = case x of
  (CTopDef _ (Ident name) _) -> if capitalised name then x : getClsDef xs else getClsDef xs
  _ -> getClsDef xs

execProgram :: Program -> MyMonad ()
execProgram (Program _ topdefs) = do
  let strs = getStrDef topdefs
  forM_ strs initStr
  let cls = getClsDef topdefs
  forM_ cls initCls
  let classFuns = concatMap Objects.convertMethods cls
  -- error $ show classFuns
  let funs = getFuns topdefs
  let funs2 = funs ++ classFuns
  forM_ funs2 initFun
  forM_ funs2 execFun
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
