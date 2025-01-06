module LLVM where

import Abs
import Control.Monad.State
import Data.Map hiding (foldl, map)
import qualified Data.Map as Map hiding (foldl, map)
import Debug.Trace (trace)
import Data.List (intercalate)

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
    put (sts, funs, ref, res ++ ["\t" ++ instr])

combineInstr :: [Instr] -> Instr
combineInstr = intercalate "\n\t"


typeToPtr :: MyType -> MyType
typeToPtr MyInt = MyPtr MyInt
typeToPtr MyStr = MyStr
typeToPtr MyBool = MyPtr MyBool
typeToPtr e = error $ "Unsupported type" ++ show e

createVar :: VarName -> MyType -> MyMonad ()
createVar name typ = do
    (sts, funs, ref, res) <- get
    let val = (ref, 1, typeToPtr typ)
    let instr = "%var" ++ show ref ++ " = alloca " ++ show typ
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
newVarNoInit typ name = do
    createVar name typ

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
            VarString x -> undefined
            VarReg (reg2, ref2, MyPtr typ2) -> do
                let i1 = "%var" ++ show newRef ++ " = load " ++ show typ2 ++ ", " ++ show (MyPtr typ2) ++ " %var" ++ show reg2
                let i2 = "store " ++ show typ2 ++ " %var" ++ show newRef ++ ", " ++ show typ ++ " %var" ++ show reg
                combineInstr [i1, i2]
            VarReg (reg2, ref2, typ2) -> "store i64 %var" ++ show reg2 ++ ", i64* %var" ++ show reg
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
    (sts, funs, reg,  res) <- get
    let (typ, argTypes) = case Map.lookup funName funs of
            Just val' -> val'
            Nothing -> error $ "Function " ++ funName ++ " not found"
    let args2 = mapM show args

    if typ == MyVoid then do
        let instr = "call void @" ++ funName ++ "(" ++ join args2 ++ ")"
        addInstr instr
        return VarVoid
    else do
        let instr = "%var" ++ show reg ++ " = call " ++ show typ ++ " @" ++ funName ++ "(" ++ intercalate ", " args2 ++ ")"
        put (sts, funs, reg + 1 , res ++ [instr])
        return (VarReg (reg, 1, typ))

unwrap :: VarVal -> MyMonad VarVal
unwrap (VarReg (reg, ref, MyPtr typ)) = do
    newRef <- nextReg
    let instr = "%var" ++ show newRef ++ " = load " ++ show typ ++ ", " ++ show (MyPtr typ) ++ " %var" ++ show reg
    addInstr instr
    addReg
    return (VarReg (newRef, 1, typ))
unwrap x = return x


eval :: Expr -> MyMonad VarVal
eval (EVar line (Ident name)) = do
    reg <- getVarReg name
    return (VarReg reg)
eval (ELitInt _ x) = return (VarInt x)
eval (ELitTrue _) = return (VarBool 1)
eval (ELitFalse _) = return (VarBool 0)
eval (EApp line (Ident name) exprs) = do
    args <- mapM eval exprs
    args2 <- mapM  unwrap args
    funApply name args2
eval (EString _ _) = do
    undefined
eval (Not line e) = do
    undefined
eval (Neg line e) = do
    undefined
eval (EMul line e1 op e2) = do
    undefined
eval (EAdd line e1 op e2) = do
    let opStr = case op of
            Plus _ -> "add"
            Minus _ -> "sub"
    v1 <- eval e1
    v2 <- eval e2
    case (v1, v2) of
        (VarInt x, VarInt y) -> return (VarInt (x + y))
        (VarReg (r1, ref1, MyPtr MyInt), VarInt y) -> do
            v1' <- unwrap v1
            newRef <- nextReg
            r1' <- getValReg v1'
            let instr = "%var" ++ show newRef ++ " = " ++ opStr ++ " i64 " ++ show r1' ++ ", " ++ show y
            addInstr instr
            addReg
            return (VarReg (newRef, 1, MyInt))
        e -> error $ "Unsupported type" ++ show e

eval (ERel line e1 op e2) = do
    undefined
eval (EAnd line e1 e2) = do
    undefined
eval (EOr line e1 e2) = do
    undefined
exec :: [Stmt] ->  MyMonad ()
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

-- initArg :: Arg -> MyMonad ()
-- initArg (Arg _ _ (Ident name)) = do
--     modify (\(sts, funs,  ref,  res) -> (Map.insert name (ref, 1) sts, funs, ref + 1,  res))

-- initArgs :: [Arg] -> MyMonad ()
-- initArgs = mapM_ initArg

execTopDef :: TopDef -> MyMonad ()
execTopDef topdef = do
    let funHeader = topDefHeader topdef
    trace funHeader $ return ()
    (sts, funs, ref,  res) <- get
    put (sts, funs, ref,  res ++ [funHeader])
    case topdef of
        (FnDef line ret name args (Block _ stmts)) -> do
            -- initArgs args
            exec stmts

    (sts', funs', ref',  res') <- get
    put (sts, funs', ref,  res' ++ ["}", ""])

initTopDef :: TopDef -> MyMonad ()
initTopDef (FnDef pos typ (Ident name) args block) = do
    let typ' = typeToMy typ
    let args' = map (\(Arg _ typ (Ident name)) -> typeToMy typ) args
    modify (\(sts, funs, ref,  res) -> (sts, Map.insert name (typ', args') funs, ref,  res))

topDefCode :: (Int, Int) -> String -> String
topDefCode (start, end) code = unlines $ Prelude.take (end - start) $ Prelude.drop start $ lines code

execProgram :: Program -> MyMonad ()
execProgram (Program _ topdefs) = do
    -- initPrints
    let funs = Prelude.filter (\(FnDef _ _ (Ident name) _ _) -> name /= "main") topdefs
    forM_  funs initTopDef
    forM_  funs execTopDef
    let main = findMain topdefs
    execTopDef main

newFunctionsMap :: FunMap
newFunctionsMap = Map.insert "printBool" (MyVoid, [MyBool]) $
                  Map.insert "printString" (MyVoid, [MyStr]) $
                  Map.insert "printInt" (MyVoid, [MyInt]) $
                  Map.insert "main" (MyInt, []) Map.empty

newState :: MyState
newState  = (Map.empty, newFunctionsMap, 1,  [])

comp :: Program -> String
comp prog = do
    let func = runState (execProgram prog)
    let ((), (_, _, _,  res)) = func newState
    unlines $ header : res


showSts :: MyMonad ()
showSts = do
    (sts, funs, ref,  res) <- get
    trace (show sts) $ return ()

