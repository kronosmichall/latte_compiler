module LLVM where

import Abs
import Control.Monad.State
import Data.Map hiding (map)
import qualified Data.Map as Map hiding (map)
import Debug.Trace (trace)

-- data Instr =
    -- PrintInt OriginLoc |
    -- PrintString OriginLoc |
    -- PrintBool OriginLoc |
    -- Add OriginLoc Loc Loc |
    -- Sub OriginLoc Loc Loc |
    -- Mul OriginLoc Loc Loc |
    -- Div OriginLoc Loc Loc |
    -- Store OriginLoc Integer

type Result = [Instr]
type Instr = String
-- type Loc = Integer
-- type Refs = Integer
-- type OriginLoc = Loc
-- type CurrentLoc = Loc
type Refs = Integer
type Register = Integer
type NextRef = Integer
type NextTmp = Integer
type MyState = (Map VarName (Register, Refs), NextRef, NextTmp, Result)
type MyMonad = State MyState

type VarName = String
data VarVal = VarString String | VarInt Integer | VarBool Integer

-- instance Show Instr where
--     show (PrintInt loc) = "call void @printInt(i64 " ++ "%_" ++ show loc ++ ")"
--     show (PrintString loc) = "call void @printString(i64 " ++ "%_" ++ show loc ++ ")"
--     show (PrintBool loc) = "call void @printBool(i64 " ++ "%_" ++ show loc ++ ")"
--     show (Add loc1 loc2 loc3) =  "%_" ++ show loc1 ++ " = add i64 %_" ++ show loc2 ++ ", %_" ++ show loc3
--     show (Sub loc1 loc2 loc3) =  "%_" ++ show loc1 ++ " = sub i64 %_" ++ show loc2 ++ ", %_" ++ show loc3
--     show (Mul loc1 loc2 loc3) =  "%_" ++ show loc1 ++ " = mul i64 %_" ++ show loc2 ++ ", %_" ++ show loc3
--     show (Div loc1 loc2 loc3) =  "%_" ++ show loc1 ++ " = sdiv i64 %_" ++ show loc2 ++ ", %_" ++ show loc3
--     show (Store loc val) = "%_" ++ show loc ++ " = add i64 0, " ++ show val



-- eval :: Expr -> MyMonad MyType
-- eval (EVar line (Ident name)) = 
-- eval (ELitInt _ _) = 
-- eval (ELitTrue _) =
-- eval (ELitFalse _) = 
-- eval (EApp line ident exprs) = 
-- eval (EString _ _) = 
-- eval (Not line e) = do

-- eval (Neg line e) = do

-- eval (EMul line e1 _ e2) = do

-- eval (EAdd line e1 _ e2) = do

-- eval (ERel line e1 op e2) = do


-- eval (EAnd line e1 e2) = do

-- eval (EOr line e1 e2) = 

data MyType = MyInt | MyStr | MyBool | MyVoid | MyFun MyType [MyType]
    deriving (Eq)

-- instance Show MyType where
--     show MyInt = "i64"
--     show MyStr = "???"
--     show MyBool = "i1"
--     show MyVoid = "Void"
--     show (MyFun ret args) = "Fun " ++ show ret ++ " " ++ show args

typeToMy :: Type -> MyType
typeToMy (Int _) = MyInt
typeToMy (Str _) = MyStr
typeToMy (Bool _) = MyBool
typeToMy (Void _) = MyVoid
typeToMy (Fun _ typ typs) = MyFun (typeToMy typ) (map typeToMy typs)

newVarNoInit :: MyType -> VarName -> MyMonad ()
newVarNoInit typ name = do
    (_, ref, _, _) <- get
    let instr = case typ of 
            MyInt -> "%" ++ show ref ++ "= alloca i64"
            MyBool -> "%" ++ show ref ++ "= alloca i1"
            MyStr -> "%" ++ show ref ++ "= alloca i8*"
            _ -> undefined
    modify (\(sts, _, tmp, res) -> (Map.insert name (ref, 1) sts, ref + 1, tmp, res ++ [instr]))


assign :: VarName -> VarVal -> MyMonad ()
assign var val = do
    (sts, reg, tmp, res) <- get
    let (register, refs) = case Map.lookup var sts of
            Just val' -> val'
            Nothing -> error $ "Variable " ++ var ++ " not found"
    case val of
        VarInt x -> do
            let instr = "store i64 " ++ show x ++ ", i64* %" ++ show register
            put (sts, reg, tmp, res ++ [instr])
        VarBool x -> do
            let instr = "store i1 " ++ show x ++ ", i1* %" ++ show register
            put (sts, reg, tmp, res ++ [instr])
        VarString x -> do
            undefined


declareItem :: MyType -> Item -> MyMonad ()
declareItem typ (NoInit line (Ident name)) = newVarNoInit typ name
declareItem typ (Init line (Ident name) expr) = do
    newVarNoInit typ name
    val <- eval expr
    assign name val

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

eval :: Expr -> MyMonad VarVal
eval (EVar line (Ident name)) = undefined 
eval (ELitInt _ x) = return (VarInt x)
eval (ELitTrue _) = return (VarBool 1)
eval (ELitFalse _) = return (VarBool 0) 
eval (EApp line ident exprs) = undefined 
eval (EString _ _) = undefined 
eval (Not line e) = do
    val <- eval e
    case val of
        VarBool x -> return (VarBool (1 - x))
        _ -> undefined 
eval (Neg line e) = do
    val <- eval e
    case val of
        VarInt x -> return (VarInt (-x))
        _ -> undefined 
eval (EMul line e1 op e2) = do
    val1 <- eval e1
    val2 <- eval e2
    mulOp op val1 val2

eval (EAdd line e1 _ e2) = do
    val1 <- eval e1
    val2 <- eval e2
    case (val1, val2) of
        (VarInt x, VarInt y) -> return (VarInt (x + y))
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
    (sts, ref, tmp, res) <- get
    exec stmts
    (_, ref2, tmp2, res2) <- get
    put (sts, ref2, tmp2, res2)
    exec xs

exec (Decl _ typ items : xs) = do
    mapM_ (declareItem (typeToMy typ)) items
    exec xs

-- exec (Ass line (Ident name) expr : xs) = do

-- exec (Incr line (Ident name) : xs) = do

-- exec (Decr line  ident : xs) = 
-- exec (Ret line expr : xs) = do

-- exec (VRet line : xs) = do

-- exec (Cond line expr stmt : xs) = do


-- exec (CondElse _ expr stmt1 stmt2 : xs) = do


-- exec (While line expr stmt : xs) = 
-- exec (SExp _ expr : xs) = do

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
    "",
    "define i64 @main(i64 %argc, i8** %argv) {"
    ]

footer :: String
footer = unlines [
  "\tret i64 0",
  "}"]


findMain :: [TopDef] -> TopDef
findMain topdefs = 
    head (Prelude.filter isMain topdefs)
    where
        isMain (FnDef _ _ (Ident "main") _ _) = True
        isMain _ = False


execMain :: [TopDef] -> MyMonad ()
execMain topdefs =  do
    let main = findMain topdefs
    case main of 
        FnDef _ _ _ _ (Block _ mainBlock) -> exec mainBlock

execProgram :: Program -> MyMonad ()
execProgram (Program _ topdefs) = do
    -- initPrints
    -- initTopDefs topdefs
    execMain topdefs

newState :: MyState
newState  = (Map.empty, 1, 1, [])

comp :: Program -> String
comp prog = do
    let func = runState (execProgram prog)
    let ((), (_, _, _, res)) = func newState
    unlines $ [header] ++ res ++ [footer]