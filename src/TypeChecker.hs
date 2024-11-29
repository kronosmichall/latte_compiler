module TypeChecker where

import Abs
import Data.Map hiding (map)
import qualified Data.Map as Map hiding (map)
import Control.Monad.State
import Debug.Trace (trace)


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

newVarOverShadow :: Type -> Varname -> MyMonad ()
newVarOverShadow typ name = do
    (vars, ret, hret) <- get
    put (Map.insert name (typ, True) vars, ret, hret)

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
        else return typ1

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
    trace "get fun typ" $ return ()
    typ <- varType name
    case typ of
        Fun typ' args -> do
            if length args /= length exprs
                then error $ "Wrong number of arguments: expected " ++ show (length args) ++ ", but got " ++ show (length exprs)
                else do
                    types <- mapM eval exprs
                    if trace (show typ' ++ ": " ++ show args ++ " got <- " ++ show types) types /= args
                        then error $ "Type mismatch in arguments: expected " ++ show args ++ ", but got " ++ show types
                        else return typ'
        _ -> error $ "Not a function: " ++ name

exec :: [Stmt] -> MyMonad ()
exec [] = do
    (_, ret, hret) <- get
    if not hret && ret /= Void
        then error "Missing return statement"
        else return ()
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
exec (Decr ident : xs) = exec (Incr ident : xs)
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
        then error $ "Type mismatch: expected " ++ show ret  ++ " return type, but got void"
        else exec xs
exec (Cond expr stmt : xs) = do
    typ <- eval expr
    (vars, ret, hret) <- get
    if typ /= Bool
        then error $ "Type mismatch in condition: expected Bool, but got " ++ show typ
        else exec [stmt]
    (_, _, hret2) <- get
    isBool <- isBoolCond expr
    if hret2 && not hret && isBool
        then put (vars, ret, hret2)
        else put (vars, ret, hret)
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
exec (SExp expr : xs) = do
    typ <- eval expr
    exec xs

isBoolCond :: Expr -> MyMonad Bool
isBoolCond (Neg e) = do
    x <- isBoolCond e
    return $ not x
isBoolCond (EAnd e1 e2) = do
    x <- isBoolCond e1
    y <- isBoolCond e2
    return $ x && y
isBoolCond (EOr e1 e2) = do
    x <- isBoolCond e1
    y <- isBoolCond e2
    return $ x || y
isBoolCond ELitTrue = return True
isBoolCond ELitFalse = return False
isBoolCond _ = return False

initTopDefs :: [TopDef] -> MyMonad ()
initTopDefs [] = return ()
initTopDefs (FnDef typ (Ident name) args (Block _) : xs) = do
    let funType = Fun typ (map (\(Arg typ' _) -> typ') args)
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
    initPrints
    initTopDefs topdefs
    hasMain topdefs
    forM_ topdefs execTopDef

execTopDef :: TopDef -> MyMonad ()
execTopDef (FnDef typ (Ident _) args (Block stmts)) = do
    (vars, typ2, hret) <- get
    put (vars, typ, False)
    forM_ args $ \(Arg typ' (Ident name)) -> newVarOverShadow typ' name
    exec stmts
    (varst, typt, hrett) <- get
    put (vars, Void, False)


initPrints :: MyMonad()
initPrints = do
    newVarInit (Fun Void [Int]) "printInt"
    newVarInit (Fun Void [Str]) "printString"
    newVarInit (Fun Void [Bool]) "printBool"

newState :: (Map Varname Var, RetType, HasReturn)
newState  = (Map.empty, Void, False)

comp :: Program -> IO ()
comp prog = do
    let func = runState (execProgram prog)
    let ((), (_, _, res)) = func newState
    res `seq` return ()
    putStrLn "OK"