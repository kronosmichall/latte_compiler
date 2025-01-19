module Types where

import Abs

import Data.Map hiding (foldl, map)

-- type Attributes = [VarReg]
-- type ClassName = String
-- type Method =
-- type Methods = [Method]
-- type Class = (ClassName, ParentClass, Attributes, Methods)

type Instr = String
type Refs = Integer
type Register = Integer
type NextRef = Integer
type VarMap = Map VarName VarReg
type FunMap = Map VarName (MyType, [MyType])
type FunName = String
type AttrName = String
type ParentClass = String
type Memsize = Integer
type ClassMap = Map VarName (ParentClass, Memsize, [FunName], [AttrName])
type StructMap = Map VarName (Memsize, [AttrName])

type VarName = String
data VarVal = VarString String | VarInt Integer | VarBool Integer | VarReg VarReg | VarVoid
type VarReg = (Register, RefID, MyType)
type RefID = Integer
type RefCount = Integer
instance Show VarVal where
  show (VarString x) = "i8* " ++ x
  show (VarInt x) = "i64 " ++ show x
  show (VarBool x) = "i1 " ++ show x
  show (VarReg (reg, ref, typ)) = show typ ++ " %var" ++ show reg

-- show (VarTmp t) = show t

data MyType = MyInt | MyStr | MyBool | MyVoid | MyPtr MyType | MyClass String | MyStruct String
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
