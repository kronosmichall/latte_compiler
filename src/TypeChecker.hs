module TypeChecker where

import Abs
import Data.Map hiding (map)
import qualified Data.Map as Map hiding (map)
import Control.Monad.State
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
    deriving (Eq)

instance Show MyType where
    show MyInt = "Int"
    show MyStr = "Str"
    show MyBool = "Bool"
    show MyVoid = "Void"
    show (MyFun ret args) = "Fun " ++ show ret ++ " " ++ show args

err :: (Show a1, Show a2) => [Char] -> Maybe (a1, a2) -> a3
err msg (Just (l, c)) = error $ "ERROR\n    Error at line " ++ show l ++ ", column " ++ show c ++ ": " ++ msg
err msg Nothing = error $ "ERROR\n  Error: " ++ msg

errTop :: [Char] -> a
errTop msg = error ("ERROR\n" ++ msg)

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
        then err ("Type mismatch: expected " ++ show typ ++ ", but got " ++ show exprTyp) line
        else newVarInit typ name

varType :: BNFC'Position -> Varname -> MyMonad MyType
varType line name = do
    (vars, _, _) <- get
    case Map.lookup name vars of
        Just (typ, _) -> return typ
        Nothing -> err ("Variable " ++ name ++ " not declared") line

eval :: Expr -> MyMonad MyType
eval (EVar line (Ident name)) = varType line name
eval (ELitInt _ _) = return MyInt
eval (ELitTrue _) = return MyBool
eval (ELitFalse _) = return MyBool
eval (EApp line ident exprs) = getFunType line ident exprs
eval (EString _ _) = return MyStr
eval (Not line e) = do
    typ <- eval e
    if typ /= MyBool
        then err ("Type mismatch: expected Bool, but got " ++ show typ) line
        else return MyBool
eval (Neg line e) = do
    typ <- eval e
    if typ /= MyInt
        then err ("Type mismatch: expected Int, but got " ++ show typ) line
        else return MyInt
eval (EMul line e1 _ e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    if typ1 /= MyInt || typ2 /= MyInt
        then err ("Type mismatch: expected Int, but got " ++ show typ1 ++ " and " ++ show typ2) line
        else return MyInt

eval (EAdd line e1 _ e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    if (typ1 /= MyInt && typ1 /= MyStr) || typ1 /= typ2
        then err ("Type mismatch: expected " ++ show typ1 ++ ", but got " ++ show typ2) line
        else return typ1

eval (ERel line e1 op e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    case op of
        EQU _ -> if typ1 /= typ2
            then err ("Type mismatch: expected " ++ show typ1 ++ ", but got " ++ show typ2) line
            else return MyBool
        NE _-> if typ1 /= typ2
            then err ("Type mismatch: expected " ++ show typ1 ++ ", but got " ++ show typ2) line
            else return MyBool
        _ -> if typ1 /= MyInt || typ2 /= MyInt
            then err ("Type mismatch: expected Int, but got " ++ show typ1 ++ " and " ++ show typ2) line
            else return MyBool

eval (EAnd line e1 e2) = do
    typ1 <- eval e1
    typ2 <- eval e2
    if typ1 /= MyBool || typ2 /= MyBool
        then err ("Type mismatch: expected Bool, but got " ++ show typ1 ++ " and " ++ show typ2) line
        else return MyBool

eval (EOr line e1 e2) = eval (EAnd line e1 e2)

getFunType :: BNFC'Position -> Ident -> [Expr] -> MyMonad MyType
getFunType line (Ident name) exprs = do
    typ <- varType line name
    case typ of
        MyFun typ' args -> do
            if length args /= length exprs
                then err ("Wrong number of arguments: expected " ++ show (length args) ++ ", but got " ++ show (length exprs)) line
                else do
                    types <- mapM eval exprs
                    if types /= args
                        then err ("Type mismatch in arguments: expected " ++ show args ++ ", but got " ++ show types) line
                        else return typ'
        _ -> err ("Not a function: " ++ name) line 


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

findMultiDecl :: BNFC'Position -> [Stmt] -> MyMonad ()
findMultiDecl line stmts = do
    let decls = Prelude.filter isDecl stmts
    let items = concatMap getItems decls
    let names = map itemName items
    if hasDuplicates names
        then err "Multiple declarations of the same variable" line
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
exec (Ass line (Ident name) expr : xs) = do
    typ1 <- varType line name
    typ2 <- eval expr
    if typ1 /= typ2
        then err ("Type mismatch in assignment: expected " ++ show typ1 ++ ", but got " ++ show typ2) line
        else exec xs
exec (Incr line (Ident name) : xs) = do
    typ <- varType line name
    if typ /= MyInt
        then err ("Type mismatch: expected Int for increment, but got " ++ show typ) line
        else exec xs
exec (Decr line  ident : xs) = exec (Incr line ident : xs)
exec (Ret line expr : xs) = do
    (vars, ret, _) <- get
    typ <- eval expr
    put (vars, ret, True)
    if typ /= ret
        then err ("Type mismatch in return: expected " ++ show ret ++ ", but got " ++ show typ) line
        else exec xs
exec (VRet line : xs) = do
    (_, ret, _) <- get
    if ret /= MyVoid
        then err ("Type mismatch: expected " ++ show ret  ++ " return type, but got void") line
        else exec xs
exec (Cond line expr stmt : xs) = do
    typ <- eval expr
    (vars, ret, hret) <- get
    if typ /= MyBool
        then err ("Type mismatch in condition: expected Bool, but got " ++ show typ) line
        else exec [stmt]
    (_, _, hret2) <- get
    isBool <- isBoolCond expr
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
hasMain [] = errTop "No main function found"
hasMain (FnDef line typ (Ident name) args (Block _ _) : xs) = do
    let funType = MyFun (typeToMy typ) (map (\(Arg _ typ' _) -> typeToMy typ') args)
    if name == "main"
        then
            if funType /= MyFun MyInt []
                then err "Main function must have type Int" line
                else
                    if args /= []
                        then err "Main function must have no arguments" line
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
    unless res $ err ("Function " ++ name ++ " is missing a return") line

execTopDef :: TopDef -> MyMonad Bool
execTopDef (FnDef line typ (Ident _) args (Block _ stmts)) = do
    (vars, _, _) <- get
    put (vars, typeToMy typ, False)
    forM_ args $ \(Arg _ typ' (Ident name)) -> newVarOverShadow (typeToMy typ') name
    findMultiDecl line stmts
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