module TypeChecker where

import Abs
import Data.Map hiding (map)
import qualified Data.Map as Map hiding (map)
import Control.Monad.State
import Debug.Trace (trace)
import qualified Data.Set as Set

type Loc = Int
type MyState = (Map Varname Var, RetType, HasReturn)
type MyMonad = State MyState
type Initialized = Bool
type Var = (MyType, Initialized)
type Varname = String
type RetType = MyType
type HasReturn = Bool

data MyType = MyInt | MyStr | MyBool | MyVoid | MyFun MyType [MyType]
    deriving (Eq, Show)

typeToMy :: Type -> MyType
typeToMy (Int _) = MyInt
typeToMy (Str _) = MyStr
typeToMy (Bool _) = MyBool
typeToMy (Void _) = MyVoid
typeToMy (Fun _ typ typs) = MyFun (typeToMy typ) (map typeToMy typs)

defined :: Varname -> MyMonad Bool
defined name = do
    (vars, _, _) <- get
    return $ Map.member name vars

newVar :: MyType -> Varname -> Initialized -> MyMonad ()
newVar typ name val = do
    (vars, ret, hret) <- get
    put (Map.insert name (typ, val) vars, ret, hret)

newVarOverShadow :: MyType -> Varname -> MyMonad ()
newVarOverShadow typ name = do
    (vars, ret, hret) <- get
    put (Map.insert name (typ, True) vars, ret, hret)

newVarNoInit :: MyType -> Varname -> MyMonad ()
newVarNoInit typ name = newVar typ name False

newVarInit :: MyType -> Varname -> MyMonad ()
newVarInit typ name = newVar typ name True

declareItem :: MyType -> Item -> MyMonad ()
declareItem typ (NoInit line (Ident name)) = newVarNoInit typ name
declareItem typ (Init line (Ident name) expr) = do
    exprTyp <- eval expr
    if typ /= exprTyp
        then error $ "Type mismatch: expected " ++ show typ ++ ", but got " ++ show exprTyp
        else newVarInit typ name

varType :: Varname -> MyMonad MyType
varType name = do
    (vars, _, _) <- get
    case Map.lookup name vars of
        Just (typ, _) -> return typ
        Nothing -> error $ "Variable " ++ name ++ " not declared"

eval :: Expr -> MyMonad MyType
eval (EVar line (Ident name)) = varType name
eval (ELitInt _ _) = return MyInt
eval (ELitTrue _) = return MyBool
eval (ELitFalse _) = return MyBool
eval (EApp _ ident exprs) = getFunType ident exprs
eval (EString _ _) = return MyStr
eval (Not line e) = do
    typ <- eval e
    if typ /= MyBool
        then error $ "Type mismatch: expected Bool, but got " ++ show typ
        else return MyBool
eval (Neg line e) = do
    typ <- eval e
    if typ /= MyInt
        then error $ "Type mismatch: expected Int, but got " ++ show typ
        else return MyInt
eval (EMul line e1 _ e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    if typ1 /= MyInt || typ2 /= MyInt
        then error $ "Type mismatch: expected Int, but got " ++ show typ1 ++ " and " ++ show typ2
        else return MyInt

eval (EAdd line e1 _ e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    if (typ1 /= MyInt && typ1 /= MyStr) || typ1 /= typ2
        then error $ "Type mismatch: expected " ++ show typ1 ++ ", but got " ++ show typ2
        else return typ1

eval (ERel line e1 op e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    case op of
        EQU _ -> if typ1 /= typ2
            then error $ "Type mismatch: expected " ++ show typ1 ++ ", but got " ++ show typ2
            else return MyBool
        NE _-> if typ1 /= typ2
            then error $ "Type mismatch: expected " ++ show typ1 ++ ", but got " ++ show typ2
            else return MyBool
        _ -> if typ1 /= MyInt || typ2 /= MyInt
            then error $ "Type mismatch: expected Int, but got " ++ show typ1 ++ " and " ++ show typ2
            else return MyBool

eval (EAnd line e1 e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    if typ1 /= MyBool || typ2 /= MyBool
        then error $ "Type mismatch: expected Bool, but got " ++ show typ1 ++ " and " ++ show typ2
        else return MyBool

eval (EOr line e1 e2) = eval (EAnd line e1 e2)

getFunType :: Ident -> [Expr] -> MyMonad MyType
getFunType (Ident name) exprs = do
    trace "get fun typ" $ return ()
    typ <- varType name
    case typ of
        MyFun typ' args -> do
            if length args /= length exprs
                then error $ "Wrong number of arguments: expected " ++ show (length args) ++ ", but got " ++ show (length exprs)
                else do
                    types <- mapM eval exprs
                    if trace (show typ' ++ ": " ++ show args ++ " got <- " ++ show types) types /= args
                        then error $ "Type mismatch in arguments: expected " ++ show args ++ ", but got " ++ show types
                        else return typ'
        _ -> error $ "Not a function: " ++ name


isDecl :: Stmt -> Bool
isDecl (Decl _ _ _) = True
isDecl _ = False

getItems :: Stmt -> [Item]
getItems (Decl _ _ items) = items
getItems _ = []

itemName :: Item -> Varname
itemName (NoInit _ (Ident name)) = name
itemName (Init _ (Ident name) _) = name

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
exec (Empty _ : xs) = exec xs
exec (BStmt _ (Block _ stmts) : xs) = do
    (vars, ret, _) <- get
    exec stmts
    (_, _, hret2) <- get
    put (vars, ret, hret2)
    exec xs
exec (Decl _ typ items : xs) = do
    mapM_ (declareItem (typeToMy typ)) items
    exec xs
exec (Ass _ (Ident name) expr : xs) = do
    typ1 <- varType name
    typ2 <- eval expr
    if typ1 /= typ2
        then error $ "Type mismatch in assignment: expected " ++ show typ1 ++ ", but got " ++ show typ2
        else exec xs
exec (Incr _ (Ident name) : xs) = do
    typ <- varType name
    if typ /= MyInt
        then error $ "Type mismatch: expected Int for increment, but got " ++ show typ
        else exec xs
exec (Decr line  ident : xs) = exec (Incr line ident : xs)
exec (Ret _ expr : xs) = do
    (vars, ret, _) <- get
    typ <- eval expr
    put (vars, ret, True)
    if typ /= ret
        then error $ "Type mismatch in return: expected " ++ show ret ++ ", but got " ++ show typ
        else exec xs
exec (VRet _ : xs) = do
    (_, ret, _) <- get
    if ret /= MyVoid
        then error $ "Type mismatch: expected " ++ show ret  ++ " return type, but got void"
        else exec xs
exec (Cond _ expr stmt : xs) = do
    typ <- eval expr
    (vars, ret, hret) <- get
    if typ /= MyBool
        then error $ "Type mismatch in condition: expected Bool, but got " ++ show typ
        else exec [stmt]
    (_, _, hret2) <- get
    isBool <- isBoolCond expr
    trace (show isBool ++ " " ++ show hret2) $ return ()
    if hret2 && not hret && isBool == Just True
        then put (vars, ret, hret2)
        else put (vars, ret, hret)
    exec xs

exec (CondElse _ expr stmt1 stmt2 : xs) = do
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

exec (While line expr stmt : xs) = exec (Cond line expr stmt : xs)
exec (SExp _ expr : xs) = do
    typ <- eval expr
    exec xs

isBoolCond :: Expr -> MyMonad (Maybe Bool)
isBoolCond (Not _ e) = do
    x <- isBoolCond e
    case x of
        Just x' -> return $ Just $ not x'
        Nothing -> return Nothing

isBoolCond (EAnd _ e1 e2) = do
    x <- isBoolCond e1
    y <- isBoolCond e2
    case x of
        Nothing -> return Nothing
        Just x' -> case y of
            Nothing -> return Nothing
            Just y' -> return $ Just $ x' && y'

isBoolCond (EOr _ e1 e2) = do
    x <- isBoolCond e1
    y <- isBoolCond e2
    case x of
        Nothing -> return Nothing
        Just x' -> case y of
            Nothing -> return Nothing
            Just y' -> return $ Just $ x' || y'

isBoolCond (ELitTrue _) = return $ Just True
isBoolCond (ELitFalse _) = return $ Just False
isBoolCond _ = return Nothing

initTopDefs :: [TopDef] -> MyMonad ()
initTopDefs [] = return ()
initTopDefs (FnDef _ typ (Ident name) args (Block _ _) : xs) = do
    let funType = MyFun (typeToMy typ) (map (\(Arg _ typ' _) -> typeToMy typ') args)
    newVarInit funType name
    initTopDefs xs

hasMain :: [TopDef] -> MyMonad ()
hasMain [] = error "No main function found"
hasMain (FnDef _ typ (Ident name) args (Block _ _) : xs) = do
    let funType = MyFun (typeToMy typ) (map (\(Arg _ typ' _) -> typeToMy typ') args)
    if name == "main"
        then
            if funType /= MyFun MyInt []
                then error "Main function must have type Int"
                else
                    if args /= []
                        then error "Main function must have no arguments"
                        else return ()
        else hasMain xs

execProgram :: Program -> MyMonad ()
execProgram (Program _ topdefs) = do
    initPrints
    initTopDefs topdefs
    hasMain topdefs
    forM_ topdefs execTopDefError

execTopDefError :: TopDef -> MyMonad ()
execTopDefError (FnDef line typ (Ident name) args (Block bline stmts)) = do
    res <- execTopDef (FnDef line typ (Ident name) args (Block bline stmts))
    unless res $ error $ "Function " ++ name ++ " is missing a return"

execTopDef :: TopDef -> MyMonad Bool
execTopDef (FnDef _ typ (Ident _) args (Block _ stmts)) = do
    (vars, _, _) <- get
    put (vars, typeToMy typ, False)
    forM_ args $ \(Arg _ typ' (Ident name)) -> newVarOverShadow (typeToMy typ') name
    findMultiDecl stmts
    exec stmts
    (_, retAfter, hretAfter) <- get
    let ret = retAfter == MyVoid || hretAfter
    put (vars, MyVoid, False)
    return ret



initPrints :: MyMonad()
initPrints = do
    newVarInit (MyFun MyVoid [MyInt]) "printInt"
    newVarInit (MyFun MyVoid [MyStr]) "printString"
    newVarInit (MyFun MyVoid [MyBool]) "printBool"
    newVarInit (MyFun MyInt []) "readInt"
    newVarInit (MyFun MyStr []) "readString"
    newVarInit (MyFun MyBool []) "readBool"


newState :: (Map Varname Var, RetType, HasReturn)
newState  = (Map.empty, MyVoid, False)

comp :: Program -> IO ()
comp prog = do
    let func = runState (execProgram prog)
    let ((), (_, _, res)) = func newState
    res `seq` return ()
    putStrLn "OK"