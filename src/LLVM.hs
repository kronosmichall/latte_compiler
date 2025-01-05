module LLVM where

import Abs
import Control.Monad.State
import Data.Map hiding (foldl, map)
import qualified Data.Map as Map hiding (foldl, map)
import Debug.Trace (trace)
import TypeChecker (Var)
import Data.List (intercalate)

type Result = [Instr]
type Instr = String
type Refs = Integer
type Register = Integer
type NextRef = Integer
type NextTmp = Integer
type VarMap = Map VarName (Register, Refs)
type FunMap = Map VarName (MyType, [MyType])
type MyState = (VarMap, FunMap, NextRef, NextTmp, Result)
type MyMonad = State MyState

type VarName = String
data VarVal = VarString String | VarInt Integer | VarBool Integer | VarTmp Integer

instance Show VarVal where
    show (VarString x) = "i8* " ++ x
    show (VarInt x) = "i64 " ++ show x
    show (VarBool x) = "i1 " ++ show x
    show (VarTmp t) = show t


data MyType = MyInt | MyStr | MyBool | MyVoid | MyFun MyType [MyType]
    deriving (Eq)

instance Show MyType where
    show MyInt = "i64"
    show MyStr = "i8*"
    show MyBool = "i1"
    show MyVoid = "void"
    show (MyFun ret args) = undefined

typeToMy :: Type -> MyType
typeToMy (Int _) = MyInt
typeToMy (Str _) = MyStr
typeToMy (Bool _) = MyBool
typeToMy (Void _) = MyVoid
typeToMy (Fun _ typ typs) = MyFun (typeToMy typ) (map typeToMy typs)

newVarNoInit :: MyType -> VarName -> MyMonad ()
newVarNoInit typ name = do
    (_, _, ref, _, _) <- get
    let instr = case typ of
            MyInt -> "%ref" ++ show ref ++ " = alloca i64"
            MyBool -> "%ref" ++ show ref ++ " = alloca i1"
            MyStr -> "%ref" ++ show ref ++ " = alloca i8*"
            _ -> undefined
    modify (\(sts, funs,  _, tmp, res) -> (Map.insert name (ref, 1) sts, funs, ref + 1, tmp, res ++ [instr]))


assign :: VarName -> VarVal -> MyMonad ()
assign var val = do
    (sts, funs, reg, tmp, res) <- get
    let (register, refs) = case Map.lookup var sts of
            Just val' -> val'
            Nothing -> error $ "Variable " ++ var ++ " not found"
    case val of
        VarInt x -> do
            let instr = "store i64 " ++ show x ++ ", i64* %ref" ++ show register
            put (sts, funs, reg, tmp, res ++ [instr])
        VarBool x -> do
            let instr = "store i1 " ++ show x ++ ", i1* %ref" ++ show register
            put (sts, funs, reg, tmp, res ++ [instr])
        VarString x -> do
            undefined
        e -> do
            error $ "Cannot assign void" ++ show e


-- int only
assignLastTmp :: VarName -> MyMonad ()
assignLastTmp var = do
    (sts, funs, reg, tmp, res) <- get
    let (register, refs) = case Map.lookup var sts of
            Just val' -> val'
            Nothing -> error $ "Variable " ++ var ++ " not found"

    let lastTmp = tmp - 1
    let instr = "store i64 %" ++ "tmp" ++ show lastTmp ++ ", i64* %ref" ++ show register
    put (sts, funs, reg, tmp, res ++ [instr])

assignItem :: VarName -> Expr -> MyMonad ()
assignItem name expr = do
    val <- eval expr
    case val of
        (VarTmp t) -> assignLastTmp name
        _ -> assign name val

declareItem :: MyType -> Item -> MyMonad ()
declareItem typ (NoInit line (Ident name)) = newVarNoInit typ name
declareItem typ (Init line (Ident name) expr) = do
    newVarNoInit typ name
    assignItem name expr


mulOp :: MulOp -> VarVal -> VarVal -> MyMonad VarVal
mulOp op var1 var2 = do
    case (var1, var2) of
        (VarInt x, VarInt y) -> case op of
            Times _ -> return (VarInt (x * y))
            Div _ -> return (VarInt (x `div` y))
            Mod _ -> return (VarInt (x `mod` y))
        _ -> undefined

relOp :: RelOp -> VarVal -> VarVal -> MyMonad VarVal
relOp op var1 var2 = do
    case (var1, var2) of
        (VarInt x, VarInt y) -> case op of
            LTH _ -> return (VarBool (if x < y then 1 else 0))
            LE _ -> return (VarBool (if x <= y then 1 else 0))
            GTH _ -> return (VarBool (if x > y then 1 else 0))
            GE _ -> return (VarBool (if x >= y then 1 else 0))
            EQU _ -> return (VarBool (if x == y then 1 else 0))
            NE _ -> return (VarBool (if x /= y then 1 else 0))
        _ -> undefined


-- int only
loadVarToTmp :: VarName -> MyMonad Integer
loadVarToTmp var = do
    (sts, funs, reg, tmp, res) <- get
    let (register, refs) = case Map.lookup var sts of
            Just val' -> val'
            Nothing -> error $ "Variable " ++ var ++ " not found"
    let instr = "%" ++ "tmp" ++ show tmp ++ " = load i64, i64* %ref" ++ show register
    put (sts, funs, reg, tmp + 1, res ++ [instr])
    return tmp

loadValToTmp :: VarVal -> MyMonad Integer
loadValToTmp val = do
    (sts, funs, reg, tmp, res) <- get
    let instr = "%" ++ "tmp" ++ show tmp ++ " = add " ++ show val ++ ", 0"
    put (sts, funs, reg, tmp + 1, res ++ [instr])
    return tmp


-- addLastTwoTmps :: 
opLastTwoTmps :: Integer -> Integer -> String -> MyType  -> MyMonad Integer
opLastTwoTmps t1 t2 op typ = do
    (sts, funs, reg, tmp, res) <- get
    let instr = "%tmp" ++ show tmp ++ " = " ++ op  ++ " " ++ show typ ++ " %tmp" ++ show t1 ++ ", %tmp" ++ show t2
    put (sts, funs, reg, tmp + 1, res ++ [instr])
    return tmp

addTwoLastTmps :: Integer -> Integer -> MyMonad Integer
addTwoLastTmps t1 t2 = opLastTwoTmps t1 t2 "add" MyInt

mulTwoLastTmps :: Integer -> Integer -> MyMonad Integer
mulTwoLastTmps t1 t2 = opLastTwoTmps t1 t2 "mul" MyInt

divTwoLastTmps :: Integer -> Integer -> MyMonad Integer
divTwoLastTmps t1 t2 = opLastTwoTmps t1 t2 "sdiv" MyInt

modTwoLastTmps :: Integer -> Integer -> MyMonad Integer
modTwoLastTmps t1 t2 = opLastTwoTmps t1 t2 "srem" MyInt

mulOpTwoLastTmps :: Integer -> Integer -> MulOp -> MyMonad Integer
mulOpTwoLastTmps t1 t2 (Times _) = mulTwoLastTmps t1 t2
mulOpTwoLastTmps t1 t2 (Div _) = divTwoLastTmps t1 t2
mulOpTwoLastTmps t1 t2(Mod _) = modTwoLastTmps t1 t2

negateTmp :: Integer -> MyMonad Integer
negateTmp t = do
    (sts, funs, reg, tmp, res) <- get
    let instr = "%tmp" ++ show tmp ++ " = sub i64 0, %tmp" ++ show t
    put (sts, funs, reg, tmp + 1, res ++ [instr])
    return tmp

varValShowNoType :: VarVal -> String
varValShowNoType (VarString x) = x
varValShowNoType (VarInt x) = show x
varValShowNoType (VarBool x) = show x
varValShowNoType (VarTmp x) = "%tmp" ++ show x

funApply :: VarName -> [VarVal] -> MyMonad Integer
funApply funName args = do
    (sts, funs, reg, tmp, res) <- get
    let (typ, argTypes) = case Map.lookup funName funs of
            Just val' -> val'
            Nothing -> error $ "Function " ++ funName ++ " not found"
    let args2 = zipWith (\argType arg -> show argType ++ " " ++ varValShowNoType arg) argTypes args

    if typ == MyVoid then do
        let instr = "call void @" ++ funName ++ "(" ++ intercalate ", " args2 ++ ")"
        put (sts, funs, reg, tmp, res ++ [instr])
        return 0
    else do
        let instr = "%tmp" ++ show tmp ++" = call " ++ show typ ++ " @" ++ funName ++ "(" ++ intercalate ", " args2 ++ ")"
        put (sts, funs, reg, tmp + 1, res ++ [instr])
        return tmp

eval :: Expr -> MyMonad VarVal
eval (EVar line (Ident name)) = do
    tmp <- loadVarToTmp name
    return (VarTmp tmp)
eval (ELitInt _ x) = return (VarInt x)
eval (ELitTrue _) = return (VarBool 1)
eval (ELitFalse _) = return (VarBool 0)
eval (EApp line (Ident name) exprs) = do
    vals <- mapM eval exprs
    tmp <- funApply name vals
    return (VarTmp tmp)
eval (EString _ _) = undefined
eval (Not line e) = do
    val <- eval e
    case val of
        VarBool x -> return ( VarBool (1 - x))
        _ -> undefined
eval (Neg line e) = do
    val <- eval e
    case val of
        VarInt x -> return (VarInt (-x))
        _ -> error "Negation of non-int"
eval (EMul line e1 op e2) = do
    val1 <- eval e1
    val2 <- eval e2
    case (val1, val2) of
        (VarInt x, VarInt y) -> mulOp op val1 val2
        (VarTmp t1, VarTmp t2) -> do
            tmp <- mulOpTwoLastTmps t1 t2 op
            return (VarTmp tmp)
        (VarInt x, VarTmp t2) -> do
            t1 <- loadValToTmp (VarInt x)
            tmp <- mulOpTwoLastTmps t1 t2 op
            return (VarTmp tmp)
        (VarTmp t1, VarInt y) -> do
            t2 <- loadValToTmp (VarInt y)
            tmp <- mulOpTwoLastTmps t1 t2 op
            return (VarTmp tmp)
        _ -> undefined

eval (EAdd line e1 (Plus _) e2) = do
    val1 <- eval e1
    val2 <- eval e2
    case (val1, val2) of
        (VarInt x, VarInt y) -> return (VarInt (x + y))
        (VarTmp t1, VarTmp t2) -> do
            tmp <- addTwoLastTmps t1 t2
            return (VarTmp tmp)
        (VarInt x, VarTmp t2) -> do
            t1 <- loadValToTmp (VarInt x)
            tmp <- addTwoLastTmps t1 t2
            return (VarTmp tmp)
        (VarTmp t1, VarInt y) -> do
            t2 <- loadValToTmp (VarInt y)
            tmp <- addTwoLastTmps t1 t2
            return (VarTmp tmp)
        _ -> undefined

eval (EAdd line e1 (Minus _) e2) = do
    val1 <- eval e1
    val2 <- eval e2
    case (val1, val2) of
        (VarInt x, VarInt y) -> return (VarInt (x - y))
        (VarTmp t1, VarTmp t2) -> do
            t2neg <- negateTmp t2
            tmp <- addTwoLastTmps t1 t2neg
            return (VarTmp tmp)
        (VarInt x, VarTmp t2) -> do
            t1 <- loadValToTmp (VarInt x)
            t2neg <- negateTmp t2
            tmp <- addTwoLastTmps t1 t2neg
            return (VarTmp tmp)
        (VarTmp t1, VarInt y) -> do
            t2 <- loadValToTmp (VarInt y)
            t2neg <- negateTmp t2
            tmp <- addTwoLastTmps t1 t2neg
            return (VarTmp tmp)
        _ -> undefined

eval (ERel line e1 op e2) = do
    val1 <- eval e1
    val2 <- eval e2
    relOp op val1 val2

eval (EAnd line e1 e2) = do
    val1 <- eval e1
    val2 <- eval e2
    case (val1, val2) of
        (VarBool x, VarBool y) -> return (VarBool (if x == 1 && y == 1 then 1 else 0))
        _ -> undefined
eval (EOr line e1 e2) = do
    val1 <- eval e1
    val2 <- eval e2
    case (val1, val2) of
        (VarBool x, VarBool y) -> return (VarBool (if x == 1 || y == 1 then 1 else 0))
        _ -> undefined

exec :: [Stmt] ->  MyMonad ()
exec [] = return ()
exec (Empty _ : xs) = exec xs
exec (BStmt _ (Block _ stmts) : xs) = do
    (sts, funs, ref, tmp, res) <- get
    exec stmts
    (_, funs2, ref2, tmp2, res2) <- get
    put (sts, funs2, ref2, tmp2, res2)
    exec xs

exec (Decl _ typ items : xs) = do
    mapM_ (declareItem (typeToMy typ)) items
    exec xs

exec (Ass line (Ident name) expr : xs) = do
    assignItem name expr
    exec xs

-- exec (Incr line (Ident name) : xs) = do

-- exec (Decr line  ident : xs) = 
exec (Ret line expr : xs) = do
    t1 <- eval expr
    (sts, funs, ref, tmp, res) <- get
    let command = case t1 of
            VarInt x -> "ret i64 " ++ show x
            VarBool x -> "ret i1 " ++ show x
            VarTmp t -> "ret i64 %tmp" ++ show t
            _ -> error "Unsupported return type"
    put (sts, funs, ref, tmp, res ++ [command])
    exec xs

exec (VRet line : xs) = do
    (sts, funs, ref, tmp, res) <- get
    let command = "ret"
    put (sts, funs, ref, tmp, res ++ [command])
    -- exec xs

-- exec (Cond line expr stmt : xs) = do


-- exec (CondElse _ expr stmt1 stmt2 : xs) = do


-- exec (While line expr stmt : xs) = 
exec (SExp _ expr : xs) = do
    tmp <- eval expr
    exec xs

exec other = do
    trace ("myFunction called with " ++ show other) undefined

header :: String
header = unlines [
    "@format = internal constant [4 x i8] c\"%d\\0A\\00\"",
    "declare i64 @printf(i8*, ...)",
    "",
    "define void @printInt(i64 %x) {",
    "\tcall i64 (i8*, ...) @printf(i8* getelementptr([4 x i8], [4 x i8]* @format, i64 0, i64 0), i64 %x)",
    "\tret void",
    "}",
    ""
    ]

findMain :: [TopDef] -> TopDef
findMain topdefs =
    head (Prelude.filter isMain topdefs)
    where
        isMain (FnDef _ _ (Ident "main") _ _) = True
        isMain _ = False

topDefHeader :: TopDef -> String
topDefHeader (FnDef _ typ (Ident name) args _) = "define " ++ show (typeToMy typ) ++ " @" ++ name ++ "(" ++ intercalate ", " (map (\(Arg _ typ (Ident name)) -> show (typeToMy typ) ++ " %" ++ name) args) ++ ") {"

execTopDef :: TopDef -> MyMonad ()
execTopDef topdef = do
    let funHeader = topDefHeader topdef
    trace funHeader $ return ()
    (sts, funs, ref, tmp, res) <- get
    put (sts, funs, ref, tmp, res ++ [funHeader])
    case topdef of
        (FnDef _ _ _ _ (Block _ stmts)) -> do
            exec stmts

    (sts', funs', ref', tmp', res') <- get
    put (sts', funs', ref', tmp', res' ++ ["}"])

initTopDef :: TopDef -> MyMonad ()
initTopDef (FnDef pos typ (Ident name) args block) = do
    let typ' = typeToMy typ
    let args' = map (\(Arg _ typ (Ident name)) -> typeToMy typ) args
    modify (\(sts, funs, ref, tmp, res) -> (sts, Map.insert name (typ', args') funs, ref, tmp, res))

-- topDefLineEnd :: Int -> [Int] -> Int
-- topDefLineEnd line (x:xs) = 

topDefCode :: (Int, Int) -> String -> String
topDefCode (start, end) code = unlines $ Prelude.take (end - start) $ Prelude.drop start $ lines code


execProgram :: Program -> MyMonad ()
execProgram (Program _ topdefs) = do
    -- initPrints
    let funs = Prelude.filter (\(FnDef _ _ (Ident name) _ _) -> name /= "main") topdefs
    forM_  funs initTopDef
    forM_  funs execTopDef
    -- let main = findMain topdefs
    -- execTopDef main

newFunctionsMap :: FunMap
newFunctionsMap = Map.insert "printBool" (MyVoid, [MyBool]) $
                  Map.insert "printString" (MyVoid, [MyStr]) $
                  Map.insert "printInt" (MyVoid, [MyInt]) $
                  Map.insert "main" (MyInt, []) Map.empty

newState :: MyState
newState  = (Map.empty, newFunctionsMap, 1, 1, [])

comp :: Program -> String
comp prog = do
    let func = runState (execProgram prog)
    let ((), (_, _, _, _, res)) = func newState
    unlines $ header : res


showSts :: MyMonad ()
showSts = do
    (sts, funs, ref, tmp, res) <- get
    trace (show sts) $ return ()

showFuns :: MyMonad ()
showFuns = do
    (sts, funs, ref, tmp, res) <- get
    trace (show funs) $ return ()

showRef :: MyMonad ()
showRef = do
    (sts, funs, ref, tmp, res) <- get
    trace (show ref) $ return ()

showTmp :: MyMonad ()
showTmp = do
    (sts, funs, ref, tmp, res) <- get
    trace (show tmp) $ return ()

showRes :: MyMonad ()
showRes = do
    (sts, funs, ref, tmp, res) <- get
    trace (unlines res) $ return ()

showAll :: MyMonad ()
showAll = do
    showSts
    -- showFuns
    showRef
    showTmp
    showRes