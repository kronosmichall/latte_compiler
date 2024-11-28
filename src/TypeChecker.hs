module TypeChecker where

import Abs
import Data.Map hiding (map)
import qualified Data.Map as Map hiding (map)
import Control.Monad.State


data Instr =
    PrintInt Loc |
    PrintString Loc |
    PrintBool Loc |
    Add Loc Loc |
    Sub Loc Loc |
    Mul Loc Loc |
    Div Loc Loc

type Loc = Int
type MyState = (Map Varname Var, RetType, HasReturn)
type MyMonad = State MyState
type Initialized = Bool
type Var = (Type, Initialized)
type Varname = String
type RetType = Type
type HasReturn = Bool

defined :: Varname -> MyMonad Bool
defined name = do
    (vars, _, _) <- get
    return $ Map.member name vars

newVar :: Type -> Varname -> Initialized -> MyMonad ()
newVar typ name val = do
    def <- defined name
    if def
        then error $ "Variable " ++ name ++ " already declared"
        else do
            (vars, ret, hret) <- get
            put (Map.insert name (typ, val) vars, ret, hret)

newVarNoInit :: Type -> Varname -> MyMonad ()
newVarNoInit typ name = newVar typ name False

newVarInit :: Type -> Varname -> MyMonad ()
newVarInit typ name = newVar typ name True

declareItem :: Type -> Item -> MyMonad ()
declareItem typ (NoInit (Ident name)) = newVarNoInit typ name
declareItem typ (Init (Ident name) expr) = do
    exprTyp <- eval expr
    if typ /= exprTyp
        then error $ "Type mismatch: expected " ++ show typ ++ ", but got " ++ show exprTyp
        else newVarInit typ name

varType :: Varname -> MyMonad Type
varType name = do
    (vars, _, _) <- get
    case Map.lookup name vars of
        Just (typ, _) -> return typ
        Nothing -> error $ "Variable " ++ name ++ " not declared"

eval :: Expr -> MyMonad Type
eval (EVar (Ident name)) = varType name
eval (ELitInt _) = return Int
eval ELitTrue = return Bool
eval ELitFalse = return Bool
eval (EApp ident exprs) = getFunType ident exprs
eval (EString _) = return Str
eval (Neg e) = do
    typ <- eval e
    if typ /= Bool
        then error $ "Type mismatch: expected Bool, but got " ++ show typ
        else return Bool
eval (Not e) = do
    typ <- eval e
    if typ /= Int
        then error $ "Type mismatch: expected Int, but got " ++ show typ
        else return Int
eval (EMul e1 _ e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    if typ1 /= Int || typ2 /= Int
        then error $ "Type mismatch: expected Int, but got " ++ show typ1 ++ " and " ++ show typ2
        else return Int

eval (EAdd e1 _ e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    if (typ1 /= Int && typ1 /= Str) || typ1 /= typ2
        then error $ "Type mismatch: expected " ++ show typ1 ++ ", but got " ++ show typ2
        else return Int

eval (ERel e1 op e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    case op of 
        EQU -> if typ1 /= typ2
            then error $ "Type mismatch: expected " ++ show typ1 ++ ", but got " ++ show typ2
            else return Bool
        NE -> if typ1 /= typ2
            then error $ "Type mismatch: expected " ++ show typ1 ++ ", but got " ++ show typ2
            else return Bool
        _ -> if typ1 /= Int || typ2 /= Int
            then error $ "Type mismatch: expected Int, but got " ++ show typ1 ++ " and " ++ show typ2
            else return Bool

eval (EAnd e1 e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    if typ1 /= Bool || typ2 /= Bool
        then error $ "Type mismatch: expected Bool, but got " ++ show typ1 ++ " and " ++ show typ2
        else return Bool

eval (EOr e1 e2) = eval (EAnd e1 e2)

getFunType :: Ident -> [Expr] -> MyMonad Type
getFunType (Ident name) exprs = do
    typ <- varType name
    case typ of
        Fun typ' args -> do
            if length args /= length exprs
                then error $ "Wrong number of arguments: expected " ++ show (length args) ++ ", but got " ++ show (length exprs)
                else do
                    types <- mapM eval exprs
                    if types /= args
                        then error $ "Type mismatch in arguments: expected " ++ show args ++ ", but got " ++ show types
                        else return typ'
        _ -> error $ "Not a function: " ++ name

exec :: [Stmt] -> MyMonad ()
exec [] = return ()
exec (Empty : xs) = exec xs
exec (BStmt (Block stmts) : xs) = do
    (vars, ret, hret) <- get
    exec stmts
    put (vars, ret, hret)
    exec xs
exec (Decl typ items : xs) = do
    mapM_ (declareItem typ) items
    exec xs
exec (Ass (Ident name) expr : xs) = do
    typ1 <- varType name
    typ2 <- eval expr
    if typ1 /= typ2
        then error $ "Type mismatch in assignment: expected " ++ show typ1 ++ ", but got " ++ show typ2
        else exec xs
exec (Incr (Ident name) : xs) = do
    typ <- varType name
    if typ /= Int
        then error $ "Type mismatch: expected Int for increment, but got " ++ show typ
        else exec xs
exec (Decr ident : xs) = exec(Incr ident : xs)
exec (Ret expr : xs) = do
    (vars, ret, _) <- get
    typ <- eval expr
    put (vars, ret, True)
    if typ /= ret
        then error $ "Type mismatch in return: expected " ++ show ret ++ ", but got " ++ show typ
        else exec xs
exec (VRet : xs) = do
    (_, ret, _) <- get
    if ret /= Void
        then error $ "Type mismatch: expected Void return type, but got " ++ show ret
        else exec xs
exec (Cond expr stmt : xs) = do
    typ <- eval expr
    (vars, ret, hret) <- get
    -- is true expr?
    if typ /= Bool
        then error $ "Type mismatch in condition: expected Bool, but got " ++ show typ
        else exec [stmt]
    put(vars, ret, hret)
    exec xs


exec (CondElse _ stmt1 stmt2 : xs) = do
    (vars, ret, hret) <- get
    -- is true expr?
    exec [stmt1]
    (_, _, hret1) <- get
    exec [stmt2]
    (_, _, hret2) <- get
    put (vars, ret, hret || (hret1 && hret2))
    exec xs

exec (While expr stmt : xs) = exec (Cond expr stmt : xs)
exec (SExp _ : xs) = exec xs

initTopDefs :: [TopDef] -> MyMonad ()
initTopDefs [] = return ()
initTopDefs (FnDef typ (Ident name) args (Block _) : xs) = do
    let funType = Fun typ (map (\(Arg _ _) -> typ) args)
    newVarInit funType name
    initTopDefs xs

hasMain :: [TopDef] -> MyMonad ()
hasMain [] = error "No main function found"
hasMain (FnDef typ (Ident name) args (Block _) : xs) = do
    let funType = Fun typ (map (\(Arg _ _) -> typ) args)
    if name == "main"
        then
            if funType /= Fun Int []
                then error "Main function must have type Int"
                else
                    if args /= []
                        then error "Main function must have no arguments"
                        else return ()
        else hasMain xs

execProgram :: Program -> MyMonad ()
execProgram (Program topdefs) = do
    initTopDefs topdefs
    hasMain topdefs
    forM_ topdefs execTopDef

execTopDef :: TopDef -> MyMonad ()
execTopDef (FnDef typ (Ident _) _ (Block stmts)) = do
    (vars, _, hret) <- get
    put (vars, typ, hret)
    exec stmts
    

newState :: (Map Varname Var, RetType, HasReturn)
newState  = (Map.empty, Void, False)

comp :: Program -> IO ()
comp prog = do
    let func = runState (execProgram prog)
    let ((), (_, _, res)) = func newState
    putStrLn $ if res then "OK" else show res
