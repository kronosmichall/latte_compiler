module TypeChecker where

import Abs
import Data.Map hiding (map)
import qualified Data.Map as Map hiding (map)
import Control.Monad.State
import Debug.Trace (trace)
import qualified Data.Set as Set

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
    (vars, ret, hret) <- get
    put (Map.insert name (typ, val) vars, ret, hret)
    -- def <- defined name
    -- if def
    --     then error $ "Variable " ++ name ++ " already declared"
    --     else do
    --         (vars, ret, hret) <- get
    --         put (Map.insert name (typ, val) vars, ret, hret)

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
eval (Not e) = do
    typ <- eval e
    if typ /= Bool
        then error $ "Type mismatch: expected Bool, but got " ++ show typ
        else return Bool
eval (Neg e) = do
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


isDecl :: Stmt -> Bool
isDecl (Decl _ _) = True
isDecl _ = False

getItems :: Stmt -> [Item]
getItems (Decl _ items) = items
getItems _ = []

itemName :: Item -> Varname
itemName (NoInit (Ident name)) = name
itemName (Init (Ident name) _) = name

hasDuplicates :: [Varname] -> Bool
hasDuplicates xs = length xs /= Set.size (Set.fromList xs)

findMultiDecl :: [Stmt] -> MyMonad ()
findMultiDecl stmts = do
    let decls = Prelude.filter isDecl stmts
    trace (show decls) $ return ()
    trace (show stmts) $ return ()
    let items = concatMap getItems decls
    let names = map itemName items
    if hasDuplicates names
        then error "Multiple declarations of the same variable"
        else return ()

exec :: [Stmt] ->  MyMonad ()
exec [] = return ()
exec (Empty : xs) = exec xs
exec (BStmt (Block stmts) : xs) = do
    (vars, ret, _) <- get
    exec stmts
    (_, _, hret2) <- get
    put (vars, ret, hret2)
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
    trace (show isBool ++ " " ++ show hret2) $ return ()
    if hret2 && not hret && isBool == Just True
        then put (vars, ret, hret2)
        else put (vars, ret, hret)
    exec xs

exec (CondElse expr stmt1 stmt2 : xs) = do
    isBool <- isBoolCond expr
    (vars, ret, hret) <- get

    if isBool == Just True
        then do
            exec [stmt1]
            (_, _, hret1) <- get
            put (vars, ret, hret || hret1)
        else if isBool == Just False
            then do
                exec [stmt2]
                (_, _, hret2) <- get
                put (vars, ret, hret || hret2)
        else do
            exec [stmt1]
            (_, _, hret1) <- get
            exec [stmt2]
            (_, _, hret2) <- get
            put (vars, ret, hret || (hret1 && hret2))
            -- trace (show hret1 ++ " " ++ show hret2) $ return ()

    exec xs

exec (While expr stmt : xs) = exec (Cond expr stmt : xs)
exec (SExp expr : xs) = do
    typ <- eval expr
    exec xs

isBoolCond :: Expr -> MyMonad (Maybe Bool)
isBoolCond (Not e) = do
    x <- isBoolCond e
    case x of
        Just x' -> return $ Just $ not x'
        Nothing -> return Nothing

isBoolCond (EAnd e1 e2) = do
    x <- isBoolCond e1
    y <- isBoolCond e2
    case x of
        Nothing -> return Nothing
        Just x' -> case y of
            Nothing -> return Nothing
            Just y' -> return $ Just $ x' && y'

isBoolCond (EOr e1 e2) = do
    x <- isBoolCond e1
    y <- isBoolCond e2
    case x of
        Nothing -> return Nothing
        Just x' -> case y of
            Nothing -> return Nothing
            Just y' -> return $ Just $ x' || y'

isBoolCond ELitTrue = return $ Just True
isBoolCond ELitFalse = return $ Just False
isBoolCond _ = return Nothing

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
    forM_ topdefs execTopDefError

execTopDefError :: TopDef -> MyMonad ()
execTopDefError (FnDef typ (Ident name) args (Block stmts)) = do
    res <- execTopDef (FnDef typ (Ident name) args (Block stmts))
    unless res $ error $ "Function " ++ name ++ " is missing a return"

execTopDef :: TopDef -> MyMonad Bool
execTopDef (FnDef typ (Ident _) args (Block stmts)) = do
    (vars, _, _) <- get
    put (vars, typ, False)
    forM_ args $ \(Arg typ' (Ident name)) -> newVarOverShadow typ' name
    findMultiDecl stmts
    exec stmts
    (_, retAfter, hretAfter) <- get
    let ret = retAfter == Void || hretAfter
    put (vars, Void, False)
    return ret



initPrints :: MyMonad()
initPrints = do
    newVarInit (Fun Void [Int]) "printInt"
    newVarInit (Fun Void [Str]) "printString"
    newVarInit (Fun Void [Bool]) "printBool"
    newVarInit (Fun Int []) "readInt"
    newVarInit (Fun Str []) "readString"
    newVarInit (Fun Bool []) "readBool"


newState :: (Map Varname Var, RetType, HasReturn)
newState  = (Map.empty, Void, False)

comp :: Program -> IO ()
comp prog = do
    let func = runState (execProgram prog)
    let ((), (_, _, res)) = func newState
    res `seq` return ()
    putStrLn "OK"