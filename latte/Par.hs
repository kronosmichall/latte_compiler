{-# OPTIONS_GHC -w #-}
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
{-# LANGUAGE PatternSynonyms #-}

module Par
  ( happyError
  , myLexer
  , pProgram
  ) where

import Prelude

import qualified Abs
import Lex
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 (Abs.Ident)
	| HappyAbsSyn5 (Integer)
	| HappyAbsSyn6 (String)
	| HappyAbsSyn7 (Abs.Program)
	| HappyAbsSyn8 (Abs.TopDef)
	| HappyAbsSyn9 ([Abs.TopDef])
	| HappyAbsSyn10 (Abs.Arg)
	| HappyAbsSyn11 ([Abs.Arg])
	| HappyAbsSyn12 (Abs.Block)
	| HappyAbsSyn13 ([Abs.Stmt])
	| HappyAbsSyn14 (Abs.Stmt)
	| HappyAbsSyn15 (Abs.Item)
	| HappyAbsSyn16 ([Abs.Item])
	| HappyAbsSyn17 (Abs.Type)
	| HappyAbsSyn18 ([Abs.Type])
	| HappyAbsSyn19 (Abs.Expr)
	| HappyAbsSyn26 ([Abs.Expr])
	| HappyAbsSyn27 (Abs.AddOp)
	| HappyAbsSyn28 (Abs.MulOp)
	| HappyAbsSyn29 (Abs.RelOp)

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87,
 action_88,
 action_89,
 action_90,
 action_91,
 action_92,
 action_93,
 action_94,
 action_95,
 action_96,
 action_97,
 action_98,
 action_99,
 action_100,
 action_101,
 action_102,
 action_103,
 action_104,
 action_105,
 action_106,
 action_107,
 action_108,
 action_109,
 action_110 :: () => Prelude.Int -> ({-HappyReduction (Err) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35,
 happyReduce_36,
 happyReduce_37,
 happyReduce_38,
 happyReduce_39,
 happyReduce_40,
 happyReduce_41,
 happyReduce_42,
 happyReduce_43,
 happyReduce_44,
 happyReduce_45,
 happyReduce_46,
 happyReduce_47,
 happyReduce_48,
 happyReduce_49,
 happyReduce_50,
 happyReduce_51,
 happyReduce_52,
 happyReduce_53,
 happyReduce_54,
 happyReduce_55,
 happyReduce_56,
 happyReduce_57,
 happyReduce_58,
 happyReduce_59,
 happyReduce_60,
 happyReduce_61,
 happyReduce_62,
 happyReduce_63,
 happyReduce_64,
 happyReduce_65,
 happyReduce_66,
 happyReduce_67,
 happyReduce_68,
 happyReduce_69,
 happyReduce_70,
 happyReduce_71 :: () => ({-HappyReduction (Err) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,386) ([0,0,0,674,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,41472,2,0,0,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,0,0,0,0,0,0,0,34816,10,0,0,4,0,0,0,1,0,0,0,0,16384,0,0,0,0,0,0,0,32768,0,0,0,43136,0,0,0,0,0,0,0,0,0,0,8704,41032,7423,0,32768,2120,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,33312,64004,463,0,0,0,256,0,0,0,0,0,0,0,0,0,32768,520,0,0,0,576,0,0,0,32788,29,0,0,0,0,4,0,0,4,0,0,2048,8192,1796,0,8704,32776,7184,0,32768,0,28738,0,0,0,0,0,0,0,0,0,0,32,0,0,0,8328,16897,112,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,0,0,0,8192,130,49416,1,0,8,0,0,0,16384,0,0,0,0,0,0,0,33312,2048,449,0,0,0,0,0,16384,0,0,0,0,0,0,0,0,0,0,0,32768,520,1056,7,0,2082,4224,28,0,0,0,0,0,33312,2048,449,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2082,4224,28,0,0,0,0,0,0,0,0,0,2176,8194,1796,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32768,0,0,0,1024,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,8704,32776,7184,0,0,256,0,0,0,1024,0,0,32768,520,1056,7,0,16384,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,16384,0,0,0,0,0,0,0,0,0,16384,0,32768,520,1056,7,0,0,0,0,0,33312,0,0,0,0,0,0,0,16384,2,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,64,0,0,0,8328,65153,115,0,33312,64004,463,0,0,0,0,0,0,0,0,0,0,0,0,0,8192,130,49416,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2176,59410,1855,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pProgram","Ident","Integer","String","Program","TopDef","ListTopDef","Arg","ListArg","Block","ListStmt","Stmt","Item","ListItem","Type","ListType","Expr6","Expr5","Expr4","Expr3","Expr2","Expr1","Expr","ListExpr","AddOp","MulOp","RelOp","'!'","'!='","'%'","'&&'","'('","')'","'*'","'+'","'++'","','","'-'","'--'","'/'","';'","'<'","'<='","'='","'=='","'>'","'>='","'boolean'","'else'","'false'","'if'","'int'","'return'","'string'","'true'","'void'","'while'","'{'","'||'","'}'","L_Ident","L_integ","L_quoted","%eof"]
        bit_start = st Prelude.* 66
        bit_end = (st Prelude.+ 1) Prelude.* 66
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..65]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (50) = happyShift action_7
action_0 (54) = happyShift action_8
action_0 (56) = happyShift action_9
action_0 (58) = happyShift action_10
action_0 (7) = happyGoto action_3
action_0 (8) = happyGoto action_4
action_0 (9) = happyGoto action_5
action_0 (17) = happyGoto action_6
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (63) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (66) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (50) = happyShift action_7
action_4 (54) = happyShift action_8
action_4 (56) = happyShift action_9
action_4 (58) = happyShift action_10
action_4 (8) = happyGoto action_4
action_4 (9) = happyGoto action_12
action_4 (17) = happyGoto action_6
action_4 _ = happyReduce_6

action_5 _ = happyReduce_4

action_6 (63) = happyShift action_2
action_6 (4) = happyGoto action_11
action_6 _ = happyFail (happyExpListPerState 6)

action_7 _ = happyReduce_33

action_8 _ = happyReduce_31

action_9 _ = happyReduce_32

action_10 _ = happyReduce_34

action_11 (34) = happyShift action_13
action_11 _ = happyFail (happyExpListPerState 11)

action_12 _ = happyReduce_7

action_13 (50) = happyShift action_7
action_13 (54) = happyShift action_8
action_13 (56) = happyShift action_9
action_13 (58) = happyShift action_10
action_13 (10) = happyGoto action_14
action_13 (11) = happyGoto action_15
action_13 (17) = happyGoto action_16
action_13 _ = happyReduce_9

action_14 (39) = happyShift action_19
action_14 _ = happyReduce_10

action_15 (35) = happyShift action_18
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (63) = happyShift action_2
action_16 (4) = happyGoto action_17
action_16 _ = happyFail (happyExpListPerState 16)

action_17 _ = happyReduce_8

action_18 (60) = happyShift action_22
action_18 (12) = happyGoto action_21
action_18 _ = happyFail (happyExpListPerState 18)

action_19 (50) = happyShift action_7
action_19 (54) = happyShift action_8
action_19 (56) = happyShift action_9
action_19 (58) = happyShift action_10
action_19 (10) = happyGoto action_14
action_19 (11) = happyGoto action_20
action_19 (17) = happyGoto action_16
action_19 _ = happyReduce_9

action_20 _ = happyReduce_11

action_21 _ = happyReduce_5

action_22 (30) = happyShift action_37
action_22 (34) = happyShift action_38
action_22 (40) = happyShift action_39
action_22 (43) = happyShift action_40
action_22 (50) = happyShift action_7
action_22 (52) = happyShift action_41
action_22 (53) = happyShift action_42
action_22 (54) = happyShift action_8
action_22 (55) = happyShift action_43
action_22 (56) = happyShift action_9
action_22 (57) = happyShift action_44
action_22 (58) = happyShift action_10
action_22 (59) = happyShift action_45
action_22 (60) = happyShift action_22
action_22 (63) = happyShift action_2
action_22 (64) = happyShift action_46
action_22 (65) = happyShift action_47
action_22 (4) = happyGoto action_23
action_22 (5) = happyGoto action_24
action_22 (6) = happyGoto action_25
action_22 (12) = happyGoto action_26
action_22 (13) = happyGoto action_27
action_22 (14) = happyGoto action_28
action_22 (17) = happyGoto action_29
action_22 (19) = happyGoto action_30
action_22 (20) = happyGoto action_31
action_22 (21) = happyGoto action_32
action_22 (22) = happyGoto action_33
action_22 (23) = happyGoto action_34
action_22 (24) = happyGoto action_35
action_22 (25) = happyGoto action_36
action_22 _ = happyReduce_13

action_23 (34) = happyShift action_78
action_23 (38) = happyShift action_79
action_23 (41) = happyShift action_80
action_23 (46) = happyShift action_81
action_23 _ = happyReduce_38

action_24 _ = happyReduce_39

action_25 _ = happyReduce_43

action_26 _ = happyReduce_16

action_27 (62) = happyShift action_77
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (30) = happyShift action_37
action_28 (34) = happyShift action_38
action_28 (40) = happyShift action_39
action_28 (43) = happyShift action_40
action_28 (50) = happyShift action_7
action_28 (52) = happyShift action_41
action_28 (53) = happyShift action_42
action_28 (54) = happyShift action_8
action_28 (55) = happyShift action_43
action_28 (56) = happyShift action_9
action_28 (57) = happyShift action_44
action_28 (58) = happyShift action_10
action_28 (59) = happyShift action_45
action_28 (60) = happyShift action_22
action_28 (63) = happyShift action_2
action_28 (64) = happyShift action_46
action_28 (65) = happyShift action_47
action_28 (4) = happyGoto action_23
action_28 (5) = happyGoto action_24
action_28 (6) = happyGoto action_25
action_28 (12) = happyGoto action_26
action_28 (13) = happyGoto action_76
action_28 (14) = happyGoto action_28
action_28 (17) = happyGoto action_29
action_28 (19) = happyGoto action_30
action_28 (20) = happyGoto action_31
action_28 (21) = happyGoto action_32
action_28 (22) = happyGoto action_33
action_28 (23) = happyGoto action_34
action_28 (24) = happyGoto action_35
action_28 (25) = happyGoto action_36
action_28 _ = happyReduce_13

action_29 (63) = happyShift action_2
action_29 (4) = happyGoto action_73
action_29 (15) = happyGoto action_74
action_29 (16) = happyGoto action_75
action_29 _ = happyFail (happyExpListPerState 29)

action_30 _ = happyReduce_47

action_31 _ = happyReduce_49

action_32 (32) = happyShift action_70
action_32 (36) = happyShift action_71
action_32 (42) = happyShift action_72
action_32 (28) = happyGoto action_69
action_32 _ = happyReduce_51

action_33 (37) = happyShift action_67
action_33 (40) = happyShift action_68
action_33 (27) = happyGoto action_66
action_33 _ = happyReduce_53

action_34 (31) = happyShift action_59
action_34 (33) = happyShift action_60
action_34 (44) = happyShift action_61
action_34 (45) = happyShift action_62
action_34 (47) = happyShift action_63
action_34 (48) = happyShift action_64
action_34 (49) = happyShift action_65
action_34 (29) = happyGoto action_58
action_34 _ = happyReduce_55

action_35 (61) = happyShift action_57
action_35 _ = happyReduce_57

action_36 (43) = happyShift action_56
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (34) = happyShift action_38
action_37 (52) = happyShift action_41
action_37 (57) = happyShift action_44
action_37 (63) = happyShift action_2
action_37 (64) = happyShift action_46
action_37 (65) = happyShift action_47
action_37 (4) = happyGoto action_49
action_37 (5) = happyGoto action_24
action_37 (6) = happyGoto action_25
action_37 (19) = happyGoto action_55
action_37 _ = happyFail (happyExpListPerState 37)

action_38 (30) = happyShift action_37
action_38 (34) = happyShift action_38
action_38 (40) = happyShift action_39
action_38 (52) = happyShift action_41
action_38 (57) = happyShift action_44
action_38 (63) = happyShift action_2
action_38 (64) = happyShift action_46
action_38 (65) = happyShift action_47
action_38 (4) = happyGoto action_49
action_38 (5) = happyGoto action_24
action_38 (6) = happyGoto action_25
action_38 (19) = happyGoto action_30
action_38 (20) = happyGoto action_31
action_38 (21) = happyGoto action_32
action_38 (22) = happyGoto action_33
action_38 (23) = happyGoto action_34
action_38 (24) = happyGoto action_35
action_38 (25) = happyGoto action_54
action_38 _ = happyFail (happyExpListPerState 38)

action_39 (34) = happyShift action_38
action_39 (52) = happyShift action_41
action_39 (57) = happyShift action_44
action_39 (63) = happyShift action_2
action_39 (64) = happyShift action_46
action_39 (65) = happyShift action_47
action_39 (4) = happyGoto action_49
action_39 (5) = happyGoto action_24
action_39 (6) = happyGoto action_25
action_39 (19) = happyGoto action_53
action_39 _ = happyFail (happyExpListPerState 39)

action_40 _ = happyReduce_15

action_41 _ = happyReduce_41

action_42 (34) = happyShift action_52
action_42 _ = happyFail (happyExpListPerState 42)

action_43 (30) = happyShift action_37
action_43 (34) = happyShift action_38
action_43 (40) = happyShift action_39
action_43 (43) = happyShift action_51
action_43 (52) = happyShift action_41
action_43 (57) = happyShift action_44
action_43 (63) = happyShift action_2
action_43 (64) = happyShift action_46
action_43 (65) = happyShift action_47
action_43 (4) = happyGoto action_49
action_43 (5) = happyGoto action_24
action_43 (6) = happyGoto action_25
action_43 (19) = happyGoto action_30
action_43 (20) = happyGoto action_31
action_43 (21) = happyGoto action_32
action_43 (22) = happyGoto action_33
action_43 (23) = happyGoto action_34
action_43 (24) = happyGoto action_35
action_43 (25) = happyGoto action_50
action_43 _ = happyFail (happyExpListPerState 43)

action_44 _ = happyReduce_40

action_45 (34) = happyShift action_48
action_45 _ = happyFail (happyExpListPerState 45)

action_46 _ = happyReduce_2

action_47 _ = happyReduce_3

action_48 (30) = happyShift action_37
action_48 (34) = happyShift action_38
action_48 (40) = happyShift action_39
action_48 (52) = happyShift action_41
action_48 (57) = happyShift action_44
action_48 (63) = happyShift action_2
action_48 (64) = happyShift action_46
action_48 (65) = happyShift action_47
action_48 (4) = happyGoto action_49
action_48 (5) = happyGoto action_24
action_48 (6) = happyGoto action_25
action_48 (19) = happyGoto action_30
action_48 (20) = happyGoto action_31
action_48 (21) = happyGoto action_32
action_48 (22) = happyGoto action_33
action_48 (23) = happyGoto action_34
action_48 (24) = happyGoto action_35
action_48 (25) = happyGoto action_98
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (34) = happyShift action_78
action_49 _ = happyReduce_38

action_50 (43) = happyShift action_97
action_50 _ = happyFail (happyExpListPerState 50)

action_51 _ = happyReduce_22

action_52 (30) = happyShift action_37
action_52 (34) = happyShift action_38
action_52 (40) = happyShift action_39
action_52 (52) = happyShift action_41
action_52 (57) = happyShift action_44
action_52 (63) = happyShift action_2
action_52 (64) = happyShift action_46
action_52 (65) = happyShift action_47
action_52 (4) = happyGoto action_49
action_52 (5) = happyGoto action_24
action_52 (6) = happyGoto action_25
action_52 (19) = happyGoto action_30
action_52 (20) = happyGoto action_31
action_52 (21) = happyGoto action_32
action_52 (22) = happyGoto action_33
action_52 (23) = happyGoto action_34
action_52 (24) = happyGoto action_35
action_52 (25) = happyGoto action_96
action_52 _ = happyFail (happyExpListPerState 52)

action_53 _ = happyReduce_45

action_54 (35) = happyShift action_95
action_54 _ = happyFail (happyExpListPerState 54)

action_55 _ = happyReduce_46

action_56 _ = happyReduce_26

action_57 (30) = happyShift action_37
action_57 (34) = happyShift action_38
action_57 (40) = happyShift action_39
action_57 (52) = happyShift action_41
action_57 (57) = happyShift action_44
action_57 (63) = happyShift action_2
action_57 (64) = happyShift action_46
action_57 (65) = happyShift action_47
action_57 (4) = happyGoto action_49
action_57 (5) = happyGoto action_24
action_57 (6) = happyGoto action_25
action_57 (19) = happyGoto action_30
action_57 (20) = happyGoto action_31
action_57 (21) = happyGoto action_32
action_57 (22) = happyGoto action_33
action_57 (23) = happyGoto action_34
action_57 (24) = happyGoto action_35
action_57 (25) = happyGoto action_94
action_57 _ = happyFail (happyExpListPerState 57)

action_58 (30) = happyShift action_37
action_58 (34) = happyShift action_38
action_58 (40) = happyShift action_39
action_58 (52) = happyShift action_41
action_58 (57) = happyShift action_44
action_58 (63) = happyShift action_2
action_58 (64) = happyShift action_46
action_58 (65) = happyShift action_47
action_58 (4) = happyGoto action_49
action_58 (5) = happyGoto action_24
action_58 (6) = happyGoto action_25
action_58 (19) = happyGoto action_30
action_58 (20) = happyGoto action_31
action_58 (21) = happyGoto action_32
action_58 (22) = happyGoto action_93
action_58 _ = happyFail (happyExpListPerState 58)

action_59 _ = happyReduce_71

action_60 (30) = happyShift action_37
action_60 (34) = happyShift action_38
action_60 (40) = happyShift action_39
action_60 (52) = happyShift action_41
action_60 (57) = happyShift action_44
action_60 (63) = happyShift action_2
action_60 (64) = happyShift action_46
action_60 (65) = happyShift action_47
action_60 (4) = happyGoto action_49
action_60 (5) = happyGoto action_24
action_60 (6) = happyGoto action_25
action_60 (19) = happyGoto action_30
action_60 (20) = happyGoto action_31
action_60 (21) = happyGoto action_32
action_60 (22) = happyGoto action_33
action_60 (23) = happyGoto action_34
action_60 (24) = happyGoto action_92
action_60 _ = happyFail (happyExpListPerState 60)

action_61 _ = happyReduce_66

action_62 _ = happyReduce_67

action_63 _ = happyReduce_70

action_64 _ = happyReduce_68

action_65 _ = happyReduce_69

action_66 (30) = happyShift action_37
action_66 (34) = happyShift action_38
action_66 (40) = happyShift action_39
action_66 (52) = happyShift action_41
action_66 (57) = happyShift action_44
action_66 (63) = happyShift action_2
action_66 (64) = happyShift action_46
action_66 (65) = happyShift action_47
action_66 (4) = happyGoto action_49
action_66 (5) = happyGoto action_24
action_66 (6) = happyGoto action_25
action_66 (19) = happyGoto action_30
action_66 (20) = happyGoto action_31
action_66 (21) = happyGoto action_91
action_66 _ = happyFail (happyExpListPerState 66)

action_67 _ = happyReduce_61

action_68 _ = happyReduce_62

action_69 (30) = happyShift action_37
action_69 (34) = happyShift action_38
action_69 (40) = happyShift action_39
action_69 (52) = happyShift action_41
action_69 (57) = happyShift action_44
action_69 (63) = happyShift action_2
action_69 (64) = happyShift action_46
action_69 (65) = happyShift action_47
action_69 (4) = happyGoto action_49
action_69 (5) = happyGoto action_24
action_69 (6) = happyGoto action_25
action_69 (19) = happyGoto action_30
action_69 (20) = happyGoto action_90
action_69 _ = happyFail (happyExpListPerState 69)

action_70 _ = happyReduce_65

action_71 _ = happyReduce_63

action_72 _ = happyReduce_64

action_73 (46) = happyShift action_89
action_73 _ = happyReduce_27

action_74 (39) = happyShift action_88
action_74 _ = happyReduce_29

action_75 (43) = happyShift action_87
action_75 _ = happyFail (happyExpListPerState 75)

action_76 _ = happyReduce_14

action_77 _ = happyReduce_12

action_78 (30) = happyShift action_37
action_78 (34) = happyShift action_38
action_78 (40) = happyShift action_39
action_78 (52) = happyShift action_41
action_78 (57) = happyShift action_44
action_78 (63) = happyShift action_2
action_78 (64) = happyShift action_46
action_78 (65) = happyShift action_47
action_78 (4) = happyGoto action_49
action_78 (5) = happyGoto action_24
action_78 (6) = happyGoto action_25
action_78 (19) = happyGoto action_30
action_78 (20) = happyGoto action_31
action_78 (21) = happyGoto action_32
action_78 (22) = happyGoto action_33
action_78 (23) = happyGoto action_34
action_78 (24) = happyGoto action_35
action_78 (25) = happyGoto action_85
action_78 (26) = happyGoto action_86
action_78 _ = happyReduce_58

action_79 (43) = happyShift action_84
action_79 _ = happyFail (happyExpListPerState 79)

action_80 (43) = happyShift action_83
action_80 _ = happyFail (happyExpListPerState 80)

action_81 (30) = happyShift action_37
action_81 (34) = happyShift action_38
action_81 (40) = happyShift action_39
action_81 (52) = happyShift action_41
action_81 (57) = happyShift action_44
action_81 (63) = happyShift action_2
action_81 (64) = happyShift action_46
action_81 (65) = happyShift action_47
action_81 (4) = happyGoto action_49
action_81 (5) = happyGoto action_24
action_81 (6) = happyGoto action_25
action_81 (19) = happyGoto action_30
action_81 (20) = happyGoto action_31
action_81 (21) = happyGoto action_32
action_81 (22) = happyGoto action_33
action_81 (23) = happyGoto action_34
action_81 (24) = happyGoto action_35
action_81 (25) = happyGoto action_82
action_81 _ = happyFail (happyExpListPerState 81)

action_82 (43) = happyShift action_105
action_82 _ = happyFail (happyExpListPerState 82)

action_83 _ = happyReduce_20

action_84 _ = happyReduce_19

action_85 (39) = happyShift action_104
action_85 _ = happyReduce_59

action_86 (35) = happyShift action_103
action_86 _ = happyFail (happyExpListPerState 86)

action_87 _ = happyReduce_17

action_88 (63) = happyShift action_2
action_88 (4) = happyGoto action_73
action_88 (15) = happyGoto action_74
action_88 (16) = happyGoto action_102
action_88 _ = happyFail (happyExpListPerState 88)

action_89 (30) = happyShift action_37
action_89 (34) = happyShift action_38
action_89 (40) = happyShift action_39
action_89 (52) = happyShift action_41
action_89 (57) = happyShift action_44
action_89 (63) = happyShift action_2
action_89 (64) = happyShift action_46
action_89 (65) = happyShift action_47
action_89 (4) = happyGoto action_49
action_89 (5) = happyGoto action_24
action_89 (6) = happyGoto action_25
action_89 (19) = happyGoto action_30
action_89 (20) = happyGoto action_31
action_89 (21) = happyGoto action_32
action_89 (22) = happyGoto action_33
action_89 (23) = happyGoto action_34
action_89 (24) = happyGoto action_35
action_89 (25) = happyGoto action_101
action_89 _ = happyFail (happyExpListPerState 89)

action_90 _ = happyReduce_48

action_91 (32) = happyShift action_70
action_91 (36) = happyShift action_71
action_91 (42) = happyShift action_72
action_91 (28) = happyGoto action_69
action_91 _ = happyReduce_50

action_92 _ = happyReduce_54

action_93 (37) = happyShift action_67
action_93 (40) = happyShift action_68
action_93 (27) = happyGoto action_66
action_93 _ = happyReduce_52

action_94 _ = happyReduce_56

action_95 _ = happyReduce_44

action_96 (35) = happyShift action_100
action_96 _ = happyFail (happyExpListPerState 96)

action_97 _ = happyReduce_21

action_98 (35) = happyShift action_99
action_98 _ = happyFail (happyExpListPerState 98)

action_99 (30) = happyShift action_37
action_99 (34) = happyShift action_38
action_99 (40) = happyShift action_39
action_99 (43) = happyShift action_40
action_99 (50) = happyShift action_7
action_99 (52) = happyShift action_41
action_99 (53) = happyShift action_42
action_99 (54) = happyShift action_8
action_99 (55) = happyShift action_43
action_99 (56) = happyShift action_9
action_99 (57) = happyShift action_44
action_99 (58) = happyShift action_10
action_99 (59) = happyShift action_45
action_99 (60) = happyShift action_22
action_99 (63) = happyShift action_2
action_99 (64) = happyShift action_46
action_99 (65) = happyShift action_47
action_99 (4) = happyGoto action_23
action_99 (5) = happyGoto action_24
action_99 (6) = happyGoto action_25
action_99 (12) = happyGoto action_26
action_99 (14) = happyGoto action_108
action_99 (17) = happyGoto action_29
action_99 (19) = happyGoto action_30
action_99 (20) = happyGoto action_31
action_99 (21) = happyGoto action_32
action_99 (22) = happyGoto action_33
action_99 (23) = happyGoto action_34
action_99 (24) = happyGoto action_35
action_99 (25) = happyGoto action_36
action_99 _ = happyFail (happyExpListPerState 99)

action_100 (30) = happyShift action_37
action_100 (34) = happyShift action_38
action_100 (40) = happyShift action_39
action_100 (43) = happyShift action_40
action_100 (50) = happyShift action_7
action_100 (52) = happyShift action_41
action_100 (53) = happyShift action_42
action_100 (54) = happyShift action_8
action_100 (55) = happyShift action_43
action_100 (56) = happyShift action_9
action_100 (57) = happyShift action_44
action_100 (58) = happyShift action_10
action_100 (59) = happyShift action_45
action_100 (60) = happyShift action_22
action_100 (63) = happyShift action_2
action_100 (64) = happyShift action_46
action_100 (65) = happyShift action_47
action_100 (4) = happyGoto action_23
action_100 (5) = happyGoto action_24
action_100 (6) = happyGoto action_25
action_100 (12) = happyGoto action_26
action_100 (14) = happyGoto action_107
action_100 (17) = happyGoto action_29
action_100 (19) = happyGoto action_30
action_100 (20) = happyGoto action_31
action_100 (21) = happyGoto action_32
action_100 (22) = happyGoto action_33
action_100 (23) = happyGoto action_34
action_100 (24) = happyGoto action_35
action_100 (25) = happyGoto action_36
action_100 _ = happyFail (happyExpListPerState 100)

action_101 _ = happyReduce_28

action_102 _ = happyReduce_30

action_103 _ = happyReduce_42

action_104 (30) = happyShift action_37
action_104 (34) = happyShift action_38
action_104 (40) = happyShift action_39
action_104 (52) = happyShift action_41
action_104 (57) = happyShift action_44
action_104 (63) = happyShift action_2
action_104 (64) = happyShift action_46
action_104 (65) = happyShift action_47
action_104 (4) = happyGoto action_49
action_104 (5) = happyGoto action_24
action_104 (6) = happyGoto action_25
action_104 (19) = happyGoto action_30
action_104 (20) = happyGoto action_31
action_104 (21) = happyGoto action_32
action_104 (22) = happyGoto action_33
action_104 (23) = happyGoto action_34
action_104 (24) = happyGoto action_35
action_104 (25) = happyGoto action_85
action_104 (26) = happyGoto action_106
action_104 _ = happyReduce_58

action_105 _ = happyReduce_18

action_106 _ = happyReduce_60

action_107 (51) = happyShift action_109
action_107 _ = happyReduce_23

action_108 _ = happyReduce_25

action_109 (30) = happyShift action_37
action_109 (34) = happyShift action_38
action_109 (40) = happyShift action_39
action_109 (43) = happyShift action_40
action_109 (50) = happyShift action_7
action_109 (52) = happyShift action_41
action_109 (53) = happyShift action_42
action_109 (54) = happyShift action_8
action_109 (55) = happyShift action_43
action_109 (56) = happyShift action_9
action_109 (57) = happyShift action_44
action_109 (58) = happyShift action_10
action_109 (59) = happyShift action_45
action_109 (60) = happyShift action_22
action_109 (63) = happyShift action_2
action_109 (64) = happyShift action_46
action_109 (65) = happyShift action_47
action_109 (4) = happyGoto action_23
action_109 (5) = happyGoto action_24
action_109 (6) = happyGoto action_25
action_109 (12) = happyGoto action_26
action_109 (14) = happyGoto action_110
action_109 (17) = happyGoto action_29
action_109 (19) = happyGoto action_30
action_109 (20) = happyGoto action_31
action_109 (21) = happyGoto action_32
action_109 (22) = happyGoto action_33
action_109 (23) = happyGoto action_34
action_109 (24) = happyGoto action_35
action_109 (25) = happyGoto action_36
action_109 _ = happyFail (happyExpListPerState 109)

action_110 _ = happyReduce_24

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyTerminal (PT _ (TV happy_var_1)))
	 =  HappyAbsSyn4
		 (Abs.Ident happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyTerminal (PT _ (TI happy_var_1)))
	 =  HappyAbsSyn5
		 ((read happy_var_1) :: Integer
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_1  6 happyReduction_3
happyReduction_3 (HappyTerminal (PT _ (TL happy_var_1)))
	 =  HappyAbsSyn6
		 (happy_var_1
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  7 happyReduction_4
happyReduction_4 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn7
		 (Abs.Program happy_var_1
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happyReduce 6 8 happyReduction_5
happyReduction_5 ((HappyAbsSyn12  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyAbsSyn17  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (Abs.FnDef happy_var_1 happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_6 = happySpecReduce_1  9 happyReduction_6
happyReduction_6 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn9
		 ((:[]) happy_var_1
	)
happyReduction_6 _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_2  9 happyReduction_7
happyReduction_7 (HappyAbsSyn9  happy_var_2)
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn9
		 ((:) happy_var_1 happy_var_2
	)
happyReduction_7 _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  10 happyReduction_8
happyReduction_8 (HappyAbsSyn4  happy_var_2)
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn10
		 (Abs.Arg happy_var_1 happy_var_2
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_0  11 happyReduction_9
happyReduction_9  =  HappyAbsSyn11
		 ([]
	)

happyReduce_10 = happySpecReduce_1  11 happyReduction_10
happyReduction_10 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn11
		 ((:[]) happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_3  11 happyReduction_11
happyReduction_11 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn11
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  12 happyReduction_12
happyReduction_12 _
	(HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (Abs.Block happy_var_2
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_0  13 happyReduction_13
happyReduction_13  =  HappyAbsSyn13
		 ([]
	)

happyReduce_14 = happySpecReduce_2  13 happyReduction_14
happyReduction_14 (HappyAbsSyn13  happy_var_2)
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 ((:) happy_var_1 happy_var_2
	)
happyReduction_14 _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_1  14 happyReduction_15
happyReduction_15 _
	 =  HappyAbsSyn14
		 (Abs.Empty
	)

happyReduce_16 = happySpecReduce_1  14 happyReduction_16
happyReduction_16 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn14
		 (Abs.BStmt happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_3  14 happyReduction_17
happyReduction_17 _
	(HappyAbsSyn16  happy_var_2)
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn14
		 (Abs.Decl happy_var_1 happy_var_2
	)
happyReduction_17 _ _ _  = notHappyAtAll 

happyReduce_18 = happyReduce 4 14 happyReduction_18
happyReduction_18 (_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Abs.Ass happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_19 = happySpecReduce_3  14 happyReduction_19
happyReduction_19 _
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn14
		 (Abs.Incr happy_var_1
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  14 happyReduction_20
happyReduction_20 _
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn14
		 (Abs.Decr happy_var_1
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  14 happyReduction_21
happyReduction_21 _
	(HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn14
		 (Abs.Ret happy_var_2
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_2  14 happyReduction_22
happyReduction_22 _
	_
	 =  HappyAbsSyn14
		 (Abs.VRet
	)

happyReduce_23 = happyReduce 5 14 happyReduction_23
happyReduction_23 ((HappyAbsSyn14  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Abs.Cond happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_24 = happyReduce 7 14 happyReduction_24
happyReduction_24 ((HappyAbsSyn14  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn14  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Abs.CondElse happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_25 = happyReduce 5 14 happyReduction_25
happyReduction_25 ((HappyAbsSyn14  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn19  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn14
		 (Abs.While happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_26 = happySpecReduce_2  14 happyReduction_26
happyReduction_26 _
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn14
		 (Abs.SExp happy_var_1
	)
happyReduction_26 _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  15 happyReduction_27
happyReduction_27 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn15
		 (Abs.NoInit happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_3  15 happyReduction_28
happyReduction_28 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn15
		 (Abs.Init happy_var_1 happy_var_3
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  16 happyReduction_29
happyReduction_29 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn16
		 ((:[]) happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_3  16 happyReduction_30
happyReduction_30 (HappyAbsSyn16  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn16
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_30 _ _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  17 happyReduction_31
happyReduction_31 _
	 =  HappyAbsSyn17
		 (Abs.Int
	)

happyReduce_32 = happySpecReduce_1  17 happyReduction_32
happyReduction_32 _
	 =  HappyAbsSyn17
		 (Abs.Str
	)

happyReduce_33 = happySpecReduce_1  17 happyReduction_33
happyReduction_33 _
	 =  HappyAbsSyn17
		 (Abs.Bool
	)

happyReduce_34 = happySpecReduce_1  17 happyReduction_34
happyReduction_34 _
	 =  HappyAbsSyn17
		 (Abs.Void
	)

happyReduce_35 = happySpecReduce_0  18 happyReduction_35
happyReduction_35  =  HappyAbsSyn18
		 ([]
	)

happyReduce_36 = happySpecReduce_1  18 happyReduction_36
happyReduction_36 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn18
		 ((:[]) happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  18 happyReduction_37
happyReduction_37 (HappyAbsSyn18  happy_var_3)
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn18
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  19 happyReduction_38
happyReduction_38 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn19
		 (Abs.EVar happy_var_1
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  19 happyReduction_39
happyReduction_39 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn19
		 (Abs.ELitInt happy_var_1
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_1  19 happyReduction_40
happyReduction_40 _
	 =  HappyAbsSyn19
		 (Abs.ELitTrue
	)

happyReduce_41 = happySpecReduce_1  19 happyReduction_41
happyReduction_41 _
	 =  HappyAbsSyn19
		 (Abs.ELitFalse
	)

happyReduce_42 = happyReduce 4 19 happyReduction_42
happyReduction_42 (_ `HappyStk`
	(HappyAbsSyn26  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn19
		 (Abs.EApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_43 = happySpecReduce_1  19 happyReduction_43
happyReduction_43 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn19
		 (Abs.EString happy_var_1
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  19 happyReduction_44
happyReduction_44 _
	(HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn19
		 (happy_var_2
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_2  20 happyReduction_45
happyReduction_45 (HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn19
		 (Abs.Neg happy_var_2
	)
happyReduction_45 _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_2  20 happyReduction_46
happyReduction_46 (HappyAbsSyn19  happy_var_2)
	_
	 =  HappyAbsSyn19
		 (Abs.Not happy_var_2
	)
happyReduction_46 _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_1  20 happyReduction_47
happyReduction_47 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  21 happyReduction_48
happyReduction_48 (HappyAbsSyn19  happy_var_3)
	(HappyAbsSyn28  happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Abs.EMul happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  21 happyReduction_49
happyReduction_49 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  22 happyReduction_50
happyReduction_50 (HappyAbsSyn19  happy_var_3)
	(HappyAbsSyn27  happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Abs.EAdd happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_1  22 happyReduction_51
happyReduction_51 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1
	)
happyReduction_51 _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  23 happyReduction_52
happyReduction_52 (HappyAbsSyn19  happy_var_3)
	(HappyAbsSyn29  happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Abs.ERel happy_var_1 happy_var_2 happy_var_3
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  23 happyReduction_53
happyReduction_53 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  24 happyReduction_54
happyReduction_54 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Abs.EAnd happy_var_1 happy_var_3
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_1  24 happyReduction_55
happyReduction_55 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1
	)
happyReduction_55 _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  25 happyReduction_56
happyReduction_56 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (Abs.EOr happy_var_1 happy_var_3
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_1  25 happyReduction_57
happyReduction_57 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_1
	)
happyReduction_57 _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_0  26 happyReduction_58
happyReduction_58  =  HappyAbsSyn26
		 ([]
	)

happyReduce_59 = happySpecReduce_1  26 happyReduction_59
happyReduction_59 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn26
		 ((:[]) happy_var_1
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  26 happyReduction_60
happyReduction_60 (HappyAbsSyn26  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn26
		 ((:) happy_var_1 happy_var_3
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_1  27 happyReduction_61
happyReduction_61 _
	 =  HappyAbsSyn27
		 (Abs.Plus
	)

happyReduce_62 = happySpecReduce_1  27 happyReduction_62
happyReduction_62 _
	 =  HappyAbsSyn27
		 (Abs.Minus
	)

happyReduce_63 = happySpecReduce_1  28 happyReduction_63
happyReduction_63 _
	 =  HappyAbsSyn28
		 (Abs.Times
	)

happyReduce_64 = happySpecReduce_1  28 happyReduction_64
happyReduction_64 _
	 =  HappyAbsSyn28
		 (Abs.Div
	)

happyReduce_65 = happySpecReduce_1  28 happyReduction_65
happyReduction_65 _
	 =  HappyAbsSyn28
		 (Abs.Mod
	)

happyReduce_66 = happySpecReduce_1  29 happyReduction_66
happyReduction_66 _
	 =  HappyAbsSyn29
		 (Abs.LTH
	)

happyReduce_67 = happySpecReduce_1  29 happyReduction_67
happyReduction_67 _
	 =  HappyAbsSyn29
		 (Abs.LE
	)

happyReduce_68 = happySpecReduce_1  29 happyReduction_68
happyReduction_68 _
	 =  HappyAbsSyn29
		 (Abs.GTH
	)

happyReduce_69 = happySpecReduce_1  29 happyReduction_69
happyReduction_69 _
	 =  HappyAbsSyn29
		 (Abs.GE
	)

happyReduce_70 = happySpecReduce_1  29 happyReduction_70
happyReduction_70 _
	 =  HappyAbsSyn29
		 (Abs.EQU
	)

happyReduce_71 = happySpecReduce_1  29 happyReduction_71
happyReduction_71 _
	 =  HappyAbsSyn29
		 (Abs.NE
	)

happyNewToken action sts stk [] =
	action 66 66 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 30;
	PT _ (TS _ 2) -> cont 31;
	PT _ (TS _ 3) -> cont 32;
	PT _ (TS _ 4) -> cont 33;
	PT _ (TS _ 5) -> cont 34;
	PT _ (TS _ 6) -> cont 35;
	PT _ (TS _ 7) -> cont 36;
	PT _ (TS _ 8) -> cont 37;
	PT _ (TS _ 9) -> cont 38;
	PT _ (TS _ 10) -> cont 39;
	PT _ (TS _ 11) -> cont 40;
	PT _ (TS _ 12) -> cont 41;
	PT _ (TS _ 13) -> cont 42;
	PT _ (TS _ 14) -> cont 43;
	PT _ (TS _ 15) -> cont 44;
	PT _ (TS _ 16) -> cont 45;
	PT _ (TS _ 17) -> cont 46;
	PT _ (TS _ 18) -> cont 47;
	PT _ (TS _ 19) -> cont 48;
	PT _ (TS _ 20) -> cont 49;
	PT _ (TS _ 21) -> cont 50;
	PT _ (TS _ 22) -> cont 51;
	PT _ (TS _ 23) -> cont 52;
	PT _ (TS _ 24) -> cont 53;
	PT _ (TS _ 25) -> cont 54;
	PT _ (TS _ 26) -> cont 55;
	PT _ (TS _ 27) -> cont 56;
	PT _ (TS _ 28) -> cont 57;
	PT _ (TS _ 29) -> cont 58;
	PT _ (TS _ 30) -> cont 59;
	PT _ (TS _ 31) -> cont 60;
	PT _ (TS _ 32) -> cont 61;
	PT _ (TS _ 33) -> cont 62;
	PT _ (TV happy_dollar_dollar) -> cont 63;
	PT _ (TI happy_dollar_dollar) -> cont 64;
	PT _ (TL happy_dollar_dollar) -> cont 65;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 66 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

happyThen :: () => Err a -> (a -> Err b) -> Err b
happyThen = ((>>=))
happyReturn :: () => a -> Err a
happyReturn = (return)
happyThen1 m k tks = ((>>=)) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> Err a
happyReturn1 = \a tks -> (return) a
happyError' :: () => ([(Token)], [Prelude.String]) -> Err a
happyError' = (\(tokens, _) -> happyError tokens)
pProgram tks = happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn7 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


type Err = Either String

happyError :: [Token] -> Err a
happyError ts = Left $
  "syntax error at " ++ tokenPos ts ++
  case ts of
    []      -> []
    [Err _] -> " due to lexer error"
    t:_     -> " before `" ++ (prToken t) ++ "'"

myLexer :: String -> [Token]
myLexer = tokens
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $










































data Happy_IntList = HappyCons Prelude.Int Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action









































indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x Prelude.< y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `Prelude.div` 16)) (bit `Prelude.mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Prelude.Int ->                    -- token number
         Prelude.Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Prelude.- ((1) :: Prelude.Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Prelude.Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n Prelude.- ((1) :: Prelude.Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Prelude.- ((1)::Prelude.Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ((HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
