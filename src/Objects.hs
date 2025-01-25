{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

module Objects
where

import Abs
import Data.Maybe

selfIdent :: Ident
selfIdent = Ident "selfik"

convertMethods :: TopDef -> [TopDef]
convertMethods (CTopDef _ clsIdent (CBlock line cdefs)) = do
  let methods = filter isMethod cdefs
  let attrs = filter (not . isMethod) cdefs
  let attrNames = map (\(Attr _ _ (Ident n)) -> n) attrs
  let maybeFuns = map (convertMethod (CTopDef line clsIdent (CBlock line cdefs)) attrNames) methods
  catMaybes maybeFuns
    where
      isMethod (MthDef {}) = True
      isMethod _ = False

convertMethod :: TopDef -> [String] -> CDef -> Maybe TopDef
convertMethod clsDef attrNames (MthDef line ret (Ident name) args (Block line2 stmts)) = do
  case clsDef of
    CTopDef _ (Ident clsName) _ -> do
      let clsTyp = Class line (Ident clsName)
      let clsArg = Arg line clsTyp selfIdent
      let args2 = clsArg : args
      let stmts2 = convertStmt attrNames stmts
      let block2 = Block line2 stmts2
      let name2 = Ident $ clsName ++ "." ++ name
      Just $ FnDef line ret name2 args2 block2
    _ -> Nothing
convertMethod _ _ _ = Nothing




convertStmt :: [String] -> [Stmt] -> [Stmt]
convertStmt _ [] = []
convertStmt attrNames (Ass line sident expr:xs) = do
  let s1 = convertSIdent attrNames sident
  let e2 = convertExpr attrNames expr
  Ass line s1 e2 : convertStmt attrNames xs
convertStmt attrNames (Incr line sident:xs) = do
  let s1 = convertSIdent attrNames sident
  Incr line s1 : convertStmt attrNames xs
convertStmt attrNames (Decr line sident:xs) = do
  let s1 = convertSIdent attrNames sident
  Incr line s1 : convertStmt attrNames xs
convertStmt attrNames (Ret line expr : xs) = do
  let e1 = convertExpr attrNames expr
  Ret line e1 : convertStmt attrNames xs
convertStmt attrNames (Empty _ : xs) = convertStmt attrNames xs
convertStmt attrNames (BStmt _ (Block _ stmts) : xs) = convertStmt attrNames (stmts ++ xs)
convertStmt attrNames (Cond line expr stmt : xs) = do
  let e1 = convertExpr attrNames expr
  let s1 = convertStmt attrNames [stmt]
  let s12 = BStmt BNFC'NoPosition (Block BNFC'NoPosition s1)
  Cond line e1 s12 : convertStmt attrNames xs
convertStmt attrNames (CondElse line expr stmt1 stmt2 : xs) = do
  let e1 = convertExpr attrNames expr
  let s1 = convertStmt attrNames [stmt1]
  let s2 = convertStmt attrNames [stmt2]
  let s12 = BStmt BNFC'NoPosition (Block BNFC'NoPosition s1)
  let s22 = BStmt BNFC'NoPosition (Block BNFC'NoPosition s2)
  CondElse line e1 s12 s22 : convertStmt attrNames xs
convertStmt attrNames (While line expr stmt : xs) = do
  let e1 = convertExpr attrNames expr
  let s1 = convertStmt attrNames [stmt]
  let s12 = BStmt BNFC'NoPosition (Block BNFC'NoPosition s1)
  While line e1 s12 : convertStmt attrNames xs
convertStmt attrNames (SExp line expr : xs) = do
  let e1 = convertExpr attrNames expr
  SExp line e1 : convertStmt attrNames xs
convertStmt attrNames (e : xs) = e : convertStmt attrNames xs


convertExpr :: [String] -> Expr -> Expr
convertExpr attrNames (EVar line (Ident name)) =
  if name `elem` attrNames
    then do
      let e = EVar BNFC'NoPosition selfIdent
      EAttr BNFC'NoPosition selfIdent (SIdent line (Ident name))
    else EVar line (Ident name)
convertExpr attrNames (EApp line (Ident name) exprs) = do
  let exprs2 = map (convertExpr attrNames) exprs
  EApp line (Ident name) exprs2
convertExpr _ e = e

convertSIdent :: [String] -> SIdent -> SIdent
convertSIdent attrNames (SIdent line (Ident attr)) =
  if attr `elem` attrNames
    then do
      SIdentAttr line selfIdent (SIdent line (Ident attr))
    else SIdent line (Ident attr)
convertSIdent attrNames (SIdentAttr line (Ident attr) attrs) = do 
  if attr `elem` attrNames
    then do
      SIdentAttr line selfIdent (SIdentAttr line (Ident attr) attrs)
    else SIdent line (Ident attr)

convertSIdent2 :: [String] -> SIdent -> Expr
convertSIdent2 attrNames (SIdent line (Ident attr)) =
  if attr `elem` attrNames
    then do
      EAttr BNFC'NoPosition selfIdent (SIdent line (Ident attr))
    else EVar line (Ident attr)
convertSIdent2 attrNames (SIdentAttr line (Ident attr) attrs) = do 
  if attr `elem` attrNames
    then do
      EAttr BNFC'NoPosition selfIdent (SIdentAttr line (Ident attr) attrs)
    else EVar line (Ident attr)