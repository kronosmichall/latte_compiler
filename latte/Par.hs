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
	| HappyAbsSyn4 ((Abs.BNFC'Position, Abs.Ident))
	| HappyAbsSyn5 ((Abs.BNFC'Position, Integer))
	| HappyAbsSyn6 ((Abs.BNFC'Position, String))
	| HappyAbsSyn7 ((Abs.BNFC'Position, Abs.Program))
	| HappyAbsSyn8 ((Abs.BNFC'Position, Abs.TopDef))
	| HappyAbsSyn9 ((Abs.BNFC'Position, [Abs.TopDef]))
	| HappyAbsSyn10 ((Abs.BNFC'Position, Abs.Arg))
	| HappyAbsSyn11 ((Abs.BNFC'Position, [Abs.Arg]))
	| HappyAbsSyn12 ((Abs.BNFC'Position, Abs.CBlock))
	| HappyAbsSyn13 ((Abs.BNFC'Position, Abs.CDef))
	| HappyAbsSyn14 ((Abs.BNFC'Position, [Abs.CDef]))
	| HappyAbsSyn15 ((Abs.BNFC'Position, Abs.Block))
	| HappyAbsSyn16 ((Abs.BNFC'Position, [Abs.Stmt]))
	| HappyAbsSyn17 ((Abs.BNFC'Position, Abs.Stmt))
	| HappyAbsSyn18 ((Abs.BNFC'Position, Abs.Item))
	| HappyAbsSyn19 ((Abs.BNFC'Position, [Abs.Item]))
	| HappyAbsSyn20 ((Abs.BNFC'Position, Abs.Type))
	| HappyAbsSyn21 ((Abs.BNFC'Position, [Abs.Type]))
	| HappyAbsSyn22 ((Abs.BNFC'Position, Abs.Expr))
	| HappyAbsSyn29 ((Abs.BNFC'Position, [Abs.Expr]))
	| HappyAbsSyn30 ((Abs.BNFC'Position, Abs.AddOp))
	| HappyAbsSyn31 ((Abs.BNFC'Position, Abs.MulOp))
	| HappyAbsSyn32 ((Abs.BNFC'Position, Abs.RelOp))

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
 action_110,
 action_111,
 action_112,
 action_113,
 action_114,
 action_115,
 action_116,
 action_117,
 action_118,
 action_119,
 action_120,
 action_121,
 action_122,
 action_123,
 action_124,
 action_125,
 action_126,
 action_127,
 action_128,
 action_129,
 action_130,
 action_131,
 action_132,
 action_133,
 action_134,
 action_135,
 action_136,
 action_137,
 action_138,
 action_139 :: () => Prelude.Int -> ({-HappyReduction (Err) = -}
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
 happyReduce_71,
 happyReduce_72,
 happyReduce_73,
 happyReduce_74,
 happyReduce_75,
 happyReduce_76,
 happyReduce_77,
 happyReduce_78,
 happyReduce_79,
 happyReduce_80,
 happyReduce_81,
 happyReduce_82,
 happyReduce_83 :: () => ({-HappyReduction (Err) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,448) ([0,0,0,34912,66,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8576,266,0,0,0,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1024,32,0,0,1,0,0,0,0,0,0,0,0,0,34848,66,0,0,0,0,0,0,0,0,1024,0,0,0,41480,16,0,0,8192,17032,0,0,0,0,128,0,0,0,0,4,0,0,0,512,0,0,512,0,0,0,32768,0,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,2048,0,0,0,8320,266,0,0,0,0,0,0,1024,16,0,0,0,0,0,0,0,0,0,0,0,0,0,33280,1064,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4096,1089,64994,28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,4352,8260,53214,1,0,0,0,256,0,0,257,0,0,0,0,0,0,0,0,8260,0,0,0,0,18,0,0,0,160,472,0,0,0,0,0,4,0,0,585,0,0,0,64,18432,1796,0,4096,65,4384,28,0,1024,32768,28740,0,0,0,0,0,0,0,0,0,0,0,256,0,0,0,0,0,41480,16,0,4352,68,49426,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,32768,0,0,0,0,0,0,128,0,16384,260,17536,112,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1041,4608,449,0,16384,64,0,0,0,0,0,0,0,0,8,0,0,0,4096,16,0,0,0,0,1,0,0,0,1024,0,0,0,0,0,0,0,0,1041,4608,449,0,17408,16,1096,7,0,16656,8192,7185,0,0,0,0,0,0,4352,4,49426,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16656,8192,7185,0,0,0,0,0,0,0,0,0,0,0,4164,18432,1796,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17408,16,1096,7,0,0,0,1024,0,0,32768,0,0,0,0,2,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1041,4608,449,0,0,8,0,0,0,512,0,0,0,0,0,0,0,0,0,0,16384,0,0,4164,18432,1796,0,0,0,0,0,0,2048,0,0,0,0,0,0,0,0,4096,129,0,0,0,0,0,0,0,0,288,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,128,0,0,512,0,0,0,0,0,0,0,0,8192,0,0,0,0,0,0,0,0,4096,1089,64994,28,0,1088,34833,29687,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4096,65,4384,28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16656,57860,7421,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pProgram_internal","Ident","Integer","String","Program","TopDef","ListTopDef","Arg","ListArg","CBlock","CDef","ListCDef","Block","ListStmt","Stmt","Item","ListItem","Type","ListType","Expr6","Expr5","Expr4","Expr3","Expr2","Expr1","Expr","ListExpr","AddOp","MulOp","RelOp","'!'","'!='","'%'","'&&'","'('","')'","'*'","'+'","'++'","','","'-'","'--'","'.'","'/'","';'","'<'","'<='","'='","'=='","'>'","'>='","'boolean'","'class'","'else'","'extends'","'false'","'if'","'int'","'new'","'null'","'return'","'string'","'true'","'void'","'while'","'{'","'||'","'}'","L_Ident","L_integ","L_quoted","%eof"]
        bit_start = st Prelude.* 74
        bit_end = (st Prelude.+ 1) Prelude.* 74
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..73]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (54) = happyShift action_8
action_0 (55) = happyShift action_9
action_0 (60) = happyShift action_10
action_0 (64) = happyShift action_11
action_0 (66) = happyShift action_12
action_0 (71) = happyShift action_2
action_0 (4) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 (8) = happyGoto action_5
action_0 (9) = happyGoto action_6
action_0 (20) = happyGoto action_7
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (71) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 _ = happyReduce_42

action_4 (74) = happyAccept
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (54) = happyShift action_8
action_5 (55) = happyShift action_9
action_5 (60) = happyShift action_10
action_5 (64) = happyShift action_11
action_5 (66) = happyShift action_12
action_5 (71) = happyShift action_2
action_5 (4) = happyGoto action_3
action_5 (8) = happyGoto action_5
action_5 (9) = happyGoto action_15
action_5 (20) = happyGoto action_7
action_5 _ = happyReduce_8

action_6 _ = happyReduce_4

action_7 (71) = happyShift action_2
action_7 (4) = happyGoto action_14
action_7 _ = happyFail (happyExpListPerState 7)

action_8 _ = happyReduce_40

action_9 (71) = happyShift action_2
action_9 (4) = happyGoto action_13
action_9 _ = happyFail (happyExpListPerState 9)

action_10 _ = happyReduce_38

action_11 _ = happyReduce_39

action_12 _ = happyReduce_41

action_13 (57) = happyShift action_18
action_13 (68) = happyShift action_19
action_13 (12) = happyGoto action_17
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (37) = happyShift action_16
action_14 _ = happyFail (happyExpListPerState 14)

action_15 _ = happyReduce_9

action_16 (54) = happyShift action_8
action_16 (60) = happyShift action_10
action_16 (64) = happyShift action_11
action_16 (66) = happyShift action_12
action_16 (71) = happyShift action_2
action_16 (4) = happyGoto action_3
action_16 (10) = happyGoto action_24
action_16 (11) = happyGoto action_25
action_16 (20) = happyGoto action_26
action_16 _ = happyReduce_11

action_17 _ = happyReduce_6

action_18 (71) = happyShift action_2
action_18 (4) = happyGoto action_23
action_18 _ = happyFail (happyExpListPerState 18)

action_19 (54) = happyShift action_8
action_19 (60) = happyShift action_10
action_19 (64) = happyShift action_11
action_19 (66) = happyShift action_12
action_19 (71) = happyShift action_2
action_19 (4) = happyGoto action_3
action_19 (13) = happyGoto action_20
action_19 (14) = happyGoto action_21
action_19 (20) = happyGoto action_22
action_19 _ = happyReduce_17

action_20 (54) = happyShift action_8
action_20 (60) = happyShift action_10
action_20 (64) = happyShift action_11
action_20 (66) = happyShift action_12
action_20 (71) = happyShift action_2
action_20 (4) = happyGoto action_3
action_20 (13) = happyGoto action_20
action_20 (14) = happyGoto action_33
action_20 (20) = happyGoto action_22
action_20 _ = happyReduce_17

action_21 (70) = happyShift action_32
action_21 _ = happyFail (happyExpListPerState 21)

action_22 (71) = happyShift action_2
action_22 (4) = happyGoto action_31
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (68) = happyShift action_19
action_23 (12) = happyGoto action_30
action_23 _ = happyFail (happyExpListPerState 23)

action_24 (42) = happyShift action_29
action_24 _ = happyReduce_12

action_25 (38) = happyShift action_28
action_25 _ = happyFail (happyExpListPerState 25)

action_26 (71) = happyShift action_2
action_26 (4) = happyGoto action_27
action_26 _ = happyFail (happyExpListPerState 26)

action_27 _ = happyReduce_10

action_28 (68) = happyShift action_38
action_28 (15) = happyGoto action_37
action_28 _ = happyFail (happyExpListPerState 28)

action_29 (54) = happyShift action_8
action_29 (60) = happyShift action_10
action_29 (64) = happyShift action_11
action_29 (66) = happyShift action_12
action_29 (71) = happyShift action_2
action_29 (4) = happyGoto action_3
action_29 (10) = happyGoto action_24
action_29 (11) = happyGoto action_36
action_29 (20) = happyGoto action_26
action_29 _ = happyReduce_11

action_30 _ = happyReduce_7

action_31 (37) = happyShift action_34
action_31 (47) = happyShift action_35
action_31 _ = happyFail (happyExpListPerState 31)

action_32 _ = happyReduce_14

action_33 _ = happyReduce_18

action_34 (54) = happyShift action_8
action_34 (60) = happyShift action_10
action_34 (64) = happyShift action_11
action_34 (66) = happyShift action_12
action_34 (71) = happyShift action_2
action_34 (4) = happyGoto action_3
action_34 (10) = happyGoto action_24
action_34 (11) = happyGoto action_65
action_34 (20) = happyGoto action_26
action_34 _ = happyReduce_11

action_35 _ = happyReduce_16

action_36 _ = happyReduce_13

action_37 _ = happyReduce_5

action_38 (33) = happyShift action_53
action_38 (37) = happyShift action_54
action_38 (43) = happyShift action_55
action_38 (47) = happyShift action_56
action_38 (54) = happyShift action_8
action_38 (58) = happyShift action_57
action_38 (59) = happyShift action_58
action_38 (60) = happyShift action_10
action_38 (61) = happyShift action_59
action_38 (63) = happyShift action_60
action_38 (64) = happyShift action_11
action_38 (65) = happyShift action_61
action_38 (66) = happyShift action_12
action_38 (67) = happyShift action_62
action_38 (68) = happyShift action_38
action_38 (71) = happyShift action_2
action_38 (72) = happyShift action_63
action_38 (73) = happyShift action_64
action_38 (4) = happyGoto action_39
action_38 (5) = happyGoto action_40
action_38 (6) = happyGoto action_41
action_38 (15) = happyGoto action_42
action_38 (16) = happyGoto action_43
action_38 (17) = happyGoto action_44
action_38 (20) = happyGoto action_45
action_38 (22) = happyGoto action_46
action_38 (23) = happyGoto action_47
action_38 (24) = happyGoto action_48
action_38 (25) = happyGoto action_49
action_38 (26) = happyGoto action_50
action_38 (27) = happyGoto action_51
action_38 (28) = happyGoto action_52
action_38 _ = happyReduce_20

action_39 (37) = happyShift action_104
action_39 (71) = happyReduce_42
action_39 _ = happyReduce_46

action_40 _ = happyReduce_47

action_41 _ = happyReduce_51

action_42 _ = happyReduce_23

action_43 (70) = happyShift action_103
action_43 _ = happyFail (happyExpListPerState 43)

action_44 (33) = happyShift action_53
action_44 (37) = happyShift action_54
action_44 (43) = happyShift action_55
action_44 (47) = happyShift action_56
action_44 (54) = happyShift action_8
action_44 (58) = happyShift action_57
action_44 (59) = happyShift action_58
action_44 (60) = happyShift action_10
action_44 (61) = happyShift action_59
action_44 (63) = happyShift action_60
action_44 (64) = happyShift action_11
action_44 (65) = happyShift action_61
action_44 (66) = happyShift action_12
action_44 (67) = happyShift action_62
action_44 (68) = happyShift action_38
action_44 (71) = happyShift action_2
action_44 (72) = happyShift action_63
action_44 (73) = happyShift action_64
action_44 (4) = happyGoto action_39
action_44 (5) = happyGoto action_40
action_44 (6) = happyGoto action_41
action_44 (15) = happyGoto action_42
action_44 (16) = happyGoto action_102
action_44 (17) = happyGoto action_44
action_44 (20) = happyGoto action_45
action_44 (22) = happyGoto action_46
action_44 (23) = happyGoto action_47
action_44 (24) = happyGoto action_48
action_44 (25) = happyGoto action_49
action_44 (26) = happyGoto action_50
action_44 (27) = happyGoto action_51
action_44 (28) = happyGoto action_52
action_44 _ = happyReduce_20

action_45 (71) = happyShift action_2
action_45 (4) = happyGoto action_99
action_45 (18) = happyGoto action_100
action_45 (19) = happyGoto action_101
action_45 _ = happyFail (happyExpListPerState 45)

action_46 (37) = happyShift action_97
action_46 (45) = happyShift action_98
action_46 _ = happyReduce_59

action_47 _ = happyReduce_61

action_48 (35) = happyShift action_94
action_48 (39) = happyShift action_95
action_48 (46) = happyShift action_96
action_48 (31) = happyGoto action_93
action_48 _ = happyReduce_63

action_49 (40) = happyShift action_91
action_49 (43) = happyShift action_92
action_49 (30) = happyGoto action_90
action_49 _ = happyReduce_65

action_50 (34) = happyShift action_83
action_50 (36) = happyShift action_84
action_50 (48) = happyShift action_85
action_50 (49) = happyShift action_86
action_50 (51) = happyShift action_87
action_50 (52) = happyShift action_88
action_50 (53) = happyShift action_89
action_50 (32) = happyGoto action_82
action_50 _ = happyReduce_67

action_51 (69) = happyShift action_81
action_51 _ = happyReduce_69

action_52 (41) = happyShift action_77
action_52 (44) = happyShift action_78
action_52 (47) = happyShift action_79
action_52 (50) = happyShift action_80
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (37) = happyShift action_54
action_53 (58) = happyShift action_57
action_53 (61) = happyShift action_59
action_53 (65) = happyShift action_61
action_53 (71) = happyShift action_2
action_53 (72) = happyShift action_63
action_53 (73) = happyShift action_64
action_53 (4) = happyGoto action_68
action_53 (5) = happyGoto action_40
action_53 (6) = happyGoto action_41
action_53 (22) = happyGoto action_76
action_53 _ = happyFail (happyExpListPerState 53)

action_54 (33) = happyShift action_53
action_54 (37) = happyShift action_54
action_54 (43) = happyShift action_55
action_54 (58) = happyShift action_57
action_54 (61) = happyShift action_59
action_54 (65) = happyShift action_61
action_54 (71) = happyShift action_2
action_54 (72) = happyShift action_63
action_54 (73) = happyShift action_64
action_54 (4) = happyGoto action_74
action_54 (5) = happyGoto action_40
action_54 (6) = happyGoto action_41
action_54 (22) = happyGoto action_46
action_54 (23) = happyGoto action_47
action_54 (24) = happyGoto action_48
action_54 (25) = happyGoto action_49
action_54 (26) = happyGoto action_50
action_54 (27) = happyGoto action_51
action_54 (28) = happyGoto action_75
action_54 _ = happyFail (happyExpListPerState 54)

action_55 (37) = happyShift action_54
action_55 (58) = happyShift action_57
action_55 (61) = happyShift action_59
action_55 (65) = happyShift action_61
action_55 (71) = happyShift action_2
action_55 (72) = happyShift action_63
action_55 (73) = happyShift action_64
action_55 (4) = happyGoto action_68
action_55 (5) = happyGoto action_40
action_55 (6) = happyGoto action_41
action_55 (22) = happyGoto action_73
action_55 _ = happyFail (happyExpListPerState 55)

action_56 _ = happyReduce_22

action_57 _ = happyReduce_49

action_58 (37) = happyShift action_72
action_58 _ = happyFail (happyExpListPerState 58)

action_59 (54) = happyShift action_8
action_59 (60) = happyShift action_10
action_59 (64) = happyShift action_11
action_59 (66) = happyShift action_12
action_59 (71) = happyShift action_2
action_59 (4) = happyGoto action_3
action_59 (20) = happyGoto action_71
action_59 _ = happyFail (happyExpListPerState 59)

action_60 (33) = happyShift action_53
action_60 (37) = happyShift action_54
action_60 (43) = happyShift action_55
action_60 (47) = happyShift action_70
action_60 (58) = happyShift action_57
action_60 (61) = happyShift action_59
action_60 (65) = happyShift action_61
action_60 (71) = happyShift action_2
action_60 (72) = happyShift action_63
action_60 (73) = happyShift action_64
action_60 (4) = happyGoto action_68
action_60 (5) = happyGoto action_40
action_60 (6) = happyGoto action_41
action_60 (22) = happyGoto action_46
action_60 (23) = happyGoto action_47
action_60 (24) = happyGoto action_48
action_60 (25) = happyGoto action_49
action_60 (26) = happyGoto action_50
action_60 (27) = happyGoto action_51
action_60 (28) = happyGoto action_69
action_60 _ = happyFail (happyExpListPerState 60)

action_61 _ = happyReduce_48

action_62 (37) = happyShift action_67
action_62 _ = happyFail (happyExpListPerState 62)

action_63 _ = happyReduce_2

action_64 _ = happyReduce_3

action_65 (38) = happyShift action_66
action_65 _ = happyFail (happyExpListPerState 65)

action_66 (68) = happyShift action_38
action_66 (15) = happyGoto action_125
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (33) = happyShift action_53
action_67 (37) = happyShift action_54
action_67 (43) = happyShift action_55
action_67 (58) = happyShift action_57
action_67 (61) = happyShift action_59
action_67 (65) = happyShift action_61
action_67 (71) = happyShift action_2
action_67 (72) = happyShift action_63
action_67 (73) = happyShift action_64
action_67 (4) = happyGoto action_68
action_67 (5) = happyGoto action_40
action_67 (6) = happyGoto action_41
action_67 (22) = happyGoto action_46
action_67 (23) = happyGoto action_47
action_67 (24) = happyGoto action_48
action_67 (25) = happyGoto action_49
action_67 (26) = happyGoto action_50
action_67 (27) = happyGoto action_51
action_67 (28) = happyGoto action_124
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (37) = happyShift action_104
action_68 _ = happyReduce_46

action_69 (47) = happyShift action_123
action_69 _ = happyFail (happyExpListPerState 69)

action_70 _ = happyReduce_29

action_71 _ = happyReduce_54

action_72 (33) = happyShift action_53
action_72 (37) = happyShift action_54
action_72 (43) = happyShift action_55
action_72 (58) = happyShift action_57
action_72 (61) = happyShift action_59
action_72 (65) = happyShift action_61
action_72 (71) = happyShift action_2
action_72 (72) = happyShift action_63
action_72 (73) = happyShift action_64
action_72 (4) = happyGoto action_68
action_72 (5) = happyGoto action_40
action_72 (6) = happyGoto action_41
action_72 (22) = happyGoto action_46
action_72 (23) = happyGoto action_47
action_72 (24) = happyGoto action_48
action_72 (25) = happyGoto action_49
action_72 (26) = happyGoto action_50
action_72 (27) = happyGoto action_51
action_72 (28) = happyGoto action_122
action_72 _ = happyFail (happyExpListPerState 72)

action_73 (37) = happyShift action_97
action_73 (45) = happyShift action_98
action_73 _ = happyReduce_57

action_74 (37) = happyShift action_104
action_74 (38) = happyShift action_121
action_74 _ = happyReduce_46

action_75 (38) = happyShift action_120
action_75 _ = happyFail (happyExpListPerState 75)

action_76 (37) = happyShift action_97
action_76 (45) = happyShift action_98
action_76 _ = happyReduce_58

action_77 (47) = happyShift action_119
action_77 _ = happyFail (happyExpListPerState 77)

action_78 (47) = happyShift action_118
action_78 _ = happyFail (happyExpListPerState 78)

action_79 _ = happyReduce_33

action_80 (33) = happyShift action_53
action_80 (37) = happyShift action_54
action_80 (43) = happyShift action_55
action_80 (58) = happyShift action_57
action_80 (61) = happyShift action_59
action_80 (65) = happyShift action_61
action_80 (71) = happyShift action_2
action_80 (72) = happyShift action_63
action_80 (73) = happyShift action_64
action_80 (4) = happyGoto action_68
action_80 (5) = happyGoto action_40
action_80 (6) = happyGoto action_41
action_80 (22) = happyGoto action_46
action_80 (23) = happyGoto action_47
action_80 (24) = happyGoto action_48
action_80 (25) = happyGoto action_49
action_80 (26) = happyGoto action_50
action_80 (27) = happyGoto action_51
action_80 (28) = happyGoto action_117
action_80 _ = happyFail (happyExpListPerState 80)

action_81 (33) = happyShift action_53
action_81 (37) = happyShift action_54
action_81 (43) = happyShift action_55
action_81 (58) = happyShift action_57
action_81 (61) = happyShift action_59
action_81 (65) = happyShift action_61
action_81 (71) = happyShift action_2
action_81 (72) = happyShift action_63
action_81 (73) = happyShift action_64
action_81 (4) = happyGoto action_68
action_81 (5) = happyGoto action_40
action_81 (6) = happyGoto action_41
action_81 (22) = happyGoto action_46
action_81 (23) = happyGoto action_47
action_81 (24) = happyGoto action_48
action_81 (25) = happyGoto action_49
action_81 (26) = happyGoto action_50
action_81 (27) = happyGoto action_51
action_81 (28) = happyGoto action_116
action_81 _ = happyFail (happyExpListPerState 81)

action_82 (33) = happyShift action_53
action_82 (37) = happyShift action_54
action_82 (43) = happyShift action_55
action_82 (58) = happyShift action_57
action_82 (61) = happyShift action_59
action_82 (65) = happyShift action_61
action_82 (71) = happyShift action_2
action_82 (72) = happyShift action_63
action_82 (73) = happyShift action_64
action_82 (4) = happyGoto action_68
action_82 (5) = happyGoto action_40
action_82 (6) = happyGoto action_41
action_82 (22) = happyGoto action_46
action_82 (23) = happyGoto action_47
action_82 (24) = happyGoto action_48
action_82 (25) = happyGoto action_115
action_82 _ = happyFail (happyExpListPerState 82)

action_83 _ = happyReduce_83

action_84 (33) = happyShift action_53
action_84 (37) = happyShift action_54
action_84 (43) = happyShift action_55
action_84 (58) = happyShift action_57
action_84 (61) = happyShift action_59
action_84 (65) = happyShift action_61
action_84 (71) = happyShift action_2
action_84 (72) = happyShift action_63
action_84 (73) = happyShift action_64
action_84 (4) = happyGoto action_68
action_84 (5) = happyGoto action_40
action_84 (6) = happyGoto action_41
action_84 (22) = happyGoto action_46
action_84 (23) = happyGoto action_47
action_84 (24) = happyGoto action_48
action_84 (25) = happyGoto action_49
action_84 (26) = happyGoto action_50
action_84 (27) = happyGoto action_114
action_84 _ = happyFail (happyExpListPerState 84)

action_85 _ = happyReduce_78

action_86 _ = happyReduce_79

action_87 _ = happyReduce_82

action_88 _ = happyReduce_80

action_89 _ = happyReduce_81

action_90 (33) = happyShift action_53
action_90 (37) = happyShift action_54
action_90 (43) = happyShift action_55
action_90 (58) = happyShift action_57
action_90 (61) = happyShift action_59
action_90 (65) = happyShift action_61
action_90 (71) = happyShift action_2
action_90 (72) = happyShift action_63
action_90 (73) = happyShift action_64
action_90 (4) = happyGoto action_68
action_90 (5) = happyGoto action_40
action_90 (6) = happyGoto action_41
action_90 (22) = happyGoto action_46
action_90 (23) = happyGoto action_47
action_90 (24) = happyGoto action_113
action_90 _ = happyFail (happyExpListPerState 90)

action_91 _ = happyReduce_73

action_92 _ = happyReduce_74

action_93 (33) = happyShift action_53
action_93 (37) = happyShift action_54
action_93 (43) = happyShift action_55
action_93 (58) = happyShift action_57
action_93 (61) = happyShift action_59
action_93 (65) = happyShift action_61
action_93 (71) = happyShift action_2
action_93 (72) = happyShift action_63
action_93 (73) = happyShift action_64
action_93 (4) = happyGoto action_68
action_93 (5) = happyGoto action_40
action_93 (6) = happyGoto action_41
action_93 (22) = happyGoto action_46
action_93 (23) = happyGoto action_112
action_93 _ = happyFail (happyExpListPerState 93)

action_94 _ = happyReduce_77

action_95 _ = happyReduce_75

action_96 _ = happyReduce_76

action_97 (33) = happyShift action_53
action_97 (37) = happyShift action_54
action_97 (43) = happyShift action_55
action_97 (58) = happyShift action_57
action_97 (61) = happyShift action_59
action_97 (65) = happyShift action_61
action_97 (71) = happyShift action_2
action_97 (72) = happyShift action_63
action_97 (73) = happyShift action_64
action_97 (4) = happyGoto action_68
action_97 (5) = happyGoto action_40
action_97 (6) = happyGoto action_41
action_97 (22) = happyGoto action_46
action_97 (23) = happyGoto action_47
action_97 (24) = happyGoto action_48
action_97 (25) = happyGoto action_49
action_97 (26) = happyGoto action_50
action_97 (27) = happyGoto action_51
action_97 (28) = happyGoto action_105
action_97 (29) = happyGoto action_111
action_97 _ = happyReduce_70

action_98 (71) = happyShift action_2
action_98 (4) = happyGoto action_110
action_98 _ = happyFail (happyExpListPerState 98)

action_99 (50) = happyShift action_109
action_99 _ = happyReduce_34

action_100 (42) = happyShift action_108
action_100 _ = happyReduce_36

action_101 (47) = happyShift action_107
action_101 _ = happyFail (happyExpListPerState 101)

action_102 _ = happyReduce_21

action_103 _ = happyReduce_19

action_104 (33) = happyShift action_53
action_104 (37) = happyShift action_54
action_104 (43) = happyShift action_55
action_104 (58) = happyShift action_57
action_104 (61) = happyShift action_59
action_104 (65) = happyShift action_61
action_104 (71) = happyShift action_2
action_104 (72) = happyShift action_63
action_104 (73) = happyShift action_64
action_104 (4) = happyGoto action_68
action_104 (5) = happyGoto action_40
action_104 (6) = happyGoto action_41
action_104 (22) = happyGoto action_46
action_104 (23) = happyGoto action_47
action_104 (24) = happyGoto action_48
action_104 (25) = happyGoto action_49
action_104 (26) = happyGoto action_50
action_104 (27) = happyGoto action_51
action_104 (28) = happyGoto action_105
action_104 (29) = happyGoto action_106
action_104 _ = happyReduce_70

action_105 (42) = happyShift action_134
action_105 _ = happyReduce_71

action_106 (38) = happyShift action_133
action_106 _ = happyFail (happyExpListPerState 106)

action_107 _ = happyReduce_24

action_108 (71) = happyShift action_2
action_108 (4) = happyGoto action_99
action_108 (18) = happyGoto action_100
action_108 (19) = happyGoto action_132
action_108 _ = happyFail (happyExpListPerState 108)

action_109 (33) = happyShift action_53
action_109 (37) = happyShift action_54
action_109 (43) = happyShift action_55
action_109 (58) = happyShift action_57
action_109 (61) = happyShift action_59
action_109 (65) = happyShift action_61
action_109 (71) = happyShift action_2
action_109 (72) = happyShift action_63
action_109 (73) = happyShift action_64
action_109 (4) = happyGoto action_68
action_109 (5) = happyGoto action_40
action_109 (6) = happyGoto action_41
action_109 (22) = happyGoto action_46
action_109 (23) = happyGoto action_47
action_109 (24) = happyGoto action_48
action_109 (25) = happyGoto action_49
action_109 (26) = happyGoto action_50
action_109 (27) = happyGoto action_51
action_109 (28) = happyGoto action_131
action_109 _ = happyFail (happyExpListPerState 109)

action_110 _ = happyReduce_52

action_111 (38) = happyShift action_130
action_111 _ = happyFail (happyExpListPerState 111)

action_112 _ = happyReduce_60

action_113 (35) = happyShift action_94
action_113 (39) = happyShift action_95
action_113 (46) = happyShift action_96
action_113 (31) = happyGoto action_93
action_113 _ = happyReduce_62

action_114 _ = happyReduce_66

action_115 (40) = happyShift action_91
action_115 (43) = happyShift action_92
action_115 (30) = happyGoto action_90
action_115 _ = happyReduce_64

action_116 _ = happyReduce_68

action_117 (47) = happyShift action_129
action_117 _ = happyFail (happyExpListPerState 117)

action_118 _ = happyReduce_27

action_119 _ = happyReduce_26

action_120 _ = happyReduce_56

action_121 (62) = happyShift action_128
action_121 _ = happyFail (happyExpListPerState 121)

action_122 (38) = happyShift action_127
action_122 _ = happyFail (happyExpListPerState 122)

action_123 _ = happyReduce_28

action_124 (38) = happyShift action_126
action_124 _ = happyFail (happyExpListPerState 124)

action_125 _ = happyReduce_15

action_126 (33) = happyShift action_53
action_126 (37) = happyShift action_54
action_126 (43) = happyShift action_55
action_126 (47) = happyShift action_56
action_126 (54) = happyShift action_8
action_126 (58) = happyShift action_57
action_126 (59) = happyShift action_58
action_126 (60) = happyShift action_10
action_126 (61) = happyShift action_59
action_126 (63) = happyShift action_60
action_126 (64) = happyShift action_11
action_126 (65) = happyShift action_61
action_126 (66) = happyShift action_12
action_126 (67) = happyShift action_62
action_126 (68) = happyShift action_38
action_126 (71) = happyShift action_2
action_126 (72) = happyShift action_63
action_126 (73) = happyShift action_64
action_126 (4) = happyGoto action_39
action_126 (5) = happyGoto action_40
action_126 (6) = happyGoto action_41
action_126 (15) = happyGoto action_42
action_126 (17) = happyGoto action_137
action_126 (20) = happyGoto action_45
action_126 (22) = happyGoto action_46
action_126 (23) = happyGoto action_47
action_126 (24) = happyGoto action_48
action_126 (25) = happyGoto action_49
action_126 (26) = happyGoto action_50
action_126 (27) = happyGoto action_51
action_126 (28) = happyGoto action_52
action_126 _ = happyFail (happyExpListPerState 126)

action_127 (33) = happyShift action_53
action_127 (37) = happyShift action_54
action_127 (43) = happyShift action_55
action_127 (47) = happyShift action_56
action_127 (54) = happyShift action_8
action_127 (58) = happyShift action_57
action_127 (59) = happyShift action_58
action_127 (60) = happyShift action_10
action_127 (61) = happyShift action_59
action_127 (63) = happyShift action_60
action_127 (64) = happyShift action_11
action_127 (65) = happyShift action_61
action_127 (66) = happyShift action_12
action_127 (67) = happyShift action_62
action_127 (68) = happyShift action_38
action_127 (71) = happyShift action_2
action_127 (72) = happyShift action_63
action_127 (73) = happyShift action_64
action_127 (4) = happyGoto action_39
action_127 (5) = happyGoto action_40
action_127 (6) = happyGoto action_41
action_127 (15) = happyGoto action_42
action_127 (17) = happyGoto action_136
action_127 (20) = happyGoto action_45
action_127 (22) = happyGoto action_46
action_127 (23) = happyGoto action_47
action_127 (24) = happyGoto action_48
action_127 (25) = happyGoto action_49
action_127 (26) = happyGoto action_50
action_127 (27) = happyGoto action_51
action_127 (28) = happyGoto action_52
action_127 _ = happyFail (happyExpListPerState 127)

action_128 _ = happyReduce_55

action_129 _ = happyReduce_25

action_130 _ = happyReduce_53

action_131 _ = happyReduce_35

action_132 _ = happyReduce_37

action_133 _ = happyReduce_50

action_134 (33) = happyShift action_53
action_134 (37) = happyShift action_54
action_134 (43) = happyShift action_55
action_134 (58) = happyShift action_57
action_134 (61) = happyShift action_59
action_134 (65) = happyShift action_61
action_134 (71) = happyShift action_2
action_134 (72) = happyShift action_63
action_134 (73) = happyShift action_64
action_134 (4) = happyGoto action_68
action_134 (5) = happyGoto action_40
action_134 (6) = happyGoto action_41
action_134 (22) = happyGoto action_46
action_134 (23) = happyGoto action_47
action_134 (24) = happyGoto action_48
action_134 (25) = happyGoto action_49
action_134 (26) = happyGoto action_50
action_134 (27) = happyGoto action_51
action_134 (28) = happyGoto action_105
action_134 (29) = happyGoto action_135
action_134 _ = happyReduce_70

action_135 _ = happyReduce_72

action_136 (56) = happyShift action_138
action_136 _ = happyReduce_30

action_137 _ = happyReduce_32

action_138 (33) = happyShift action_53
action_138 (37) = happyShift action_54
action_138 (43) = happyShift action_55
action_138 (47) = happyShift action_56
action_138 (54) = happyShift action_8
action_138 (58) = happyShift action_57
action_138 (59) = happyShift action_58
action_138 (60) = happyShift action_10
action_138 (61) = happyShift action_59
action_138 (63) = happyShift action_60
action_138 (64) = happyShift action_11
action_138 (65) = happyShift action_61
action_138 (66) = happyShift action_12
action_138 (67) = happyShift action_62
action_138 (68) = happyShift action_38
action_138 (71) = happyShift action_2
action_138 (72) = happyShift action_63
action_138 (73) = happyShift action_64
action_138 (4) = happyGoto action_39
action_138 (5) = happyGoto action_40
action_138 (6) = happyGoto action_41
action_138 (15) = happyGoto action_42
action_138 (17) = happyGoto action_139
action_138 (20) = happyGoto action_45
action_138 (22) = happyGoto action_46
action_138 (23) = happyGoto action_47
action_138 (24) = happyGoto action_48
action_138 (25) = happyGoto action_49
action_138 (26) = happyGoto action_50
action_138 (27) = happyGoto action_51
action_138 (28) = happyGoto action_52
action_138 _ = happyFail (happyExpListPerState 138)

action_139 _ = happyReduce_31

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn4
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Ident (tokenText happy_var_1))
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn5
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), (read (tokenText happy_var_1)) :: Integer)
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_1  6 happyReduction_3
happyReduction_3 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn6
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), ((\(PT _ (TL s)) -> s) happy_var_1))
	)
happyReduction_3 _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_1  7 happyReduction_4
happyReduction_4 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn7
		 ((fst happy_var_1, Abs.Program (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happyReduce 6 8 happyReduction_5
happyReduction_5 ((HappyAbsSyn15  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyAbsSyn20  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((fst happy_var_1, Abs.FnDef (fst happy_var_1) (snd happy_var_1) (snd happy_var_2) (snd happy_var_4) (snd happy_var_6))
	) `HappyStk` happyRest

happyReduce_6 = happySpecReduce_3  8 happyReduction_6
happyReduction_6 (HappyAbsSyn12  happy_var_3)
	(HappyAbsSyn4  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn8
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.CTopDef (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2) (snd happy_var_3))
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happyReduce 5 8 happyReduction_7
happyReduction_7 ((HappyAbsSyn12  happy_var_5) `HappyStk`
	(HappyAbsSyn4  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.CTopExtDef (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2) (snd happy_var_4) (snd happy_var_5))
	) `HappyStk` happyRest

happyReduce_8 = happySpecReduce_1  9 happyReduction_8
happyReduction_8 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn9
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_8 _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_2  9 happyReduction_9
happyReduction_9 (HappyAbsSyn9  happy_var_2)
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn9
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_2))
	)
happyReduction_9 _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_2  10 happyReduction_10
happyReduction_10 (HappyAbsSyn4  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn10
		 ((fst happy_var_1, Abs.Arg (fst happy_var_1) (snd happy_var_1) (snd happy_var_2))
	)
happyReduction_10 _ _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_0  11 happyReduction_11
happyReduction_11  =  HappyAbsSyn11
		 ((Abs.BNFC'NoPosition, [])
	)

happyReduce_12 = happySpecReduce_1  11 happyReduction_12
happyReduction_12 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn11
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  11 happyReduction_13
happyReduction_13 (HappyAbsSyn11  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn11
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  12 happyReduction_14
happyReduction_14 _
	(HappyAbsSyn14  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn12
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.CBlock (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happyReduce 6 13 happyReduction_15
happyReduction_15 ((HappyAbsSyn15  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyAbsSyn20  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 ((fst happy_var_1, Abs.MthDef (fst happy_var_1) (snd happy_var_1) (snd happy_var_2) (snd happy_var_4) (snd happy_var_6))
	) `HappyStk` happyRest

happyReduce_16 = happySpecReduce_3  13 happyReduction_16
happyReduction_16 _
	(HappyAbsSyn4  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn13
		 ((fst happy_var_1, Abs.Attr (fst happy_var_1) (snd happy_var_1) (snd happy_var_2))
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_0  14 happyReduction_17
happyReduction_17  =  HappyAbsSyn14
		 ((Abs.BNFC'NoPosition, [])
	)

happyReduce_18 = happySpecReduce_2  14 happyReduction_18
happyReduction_18 (HappyAbsSyn14  happy_var_2)
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn14
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_2))
	)
happyReduction_18 _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  15 happyReduction_19
happyReduction_19 _
	(HappyAbsSyn16  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn15
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Block (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_0  16 happyReduction_20
happyReduction_20  =  HappyAbsSyn16
		 ((Abs.BNFC'NoPosition, [])
	)

happyReduce_21 = happySpecReduce_2  16 happyReduction_21
happyReduction_21 (HappyAbsSyn16  happy_var_2)
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn16
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_2))
	)
happyReduction_21 _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_1  17 happyReduction_22
happyReduction_22 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn17
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Empty (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  17 happyReduction_23
happyReduction_23 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, Abs.BStmt (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  17 happyReduction_24
happyReduction_24 _
	(HappyAbsSyn19  happy_var_2)
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, Abs.Decl (fst happy_var_1) (snd happy_var_1) (snd happy_var_2))
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happyReduce 4 17 happyReduction_25
happyReduction_25 (_ `HappyStk`
	(HappyAbsSyn22  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 ((fst happy_var_1, Abs.Ass (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_26 = happySpecReduce_3  17 happyReduction_26
happyReduction_26 _
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, Abs.Incr (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_3  17 happyReduction_27
happyReduction_27 _
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, Abs.Decr (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_27 _ _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_3  17 happyReduction_28
happyReduction_28 _
	(HappyAbsSyn22  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn17
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Ret (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_2  17 happyReduction_29
happyReduction_29 _
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn17
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.VRet (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happyReduce 5 17 happyReduction_30
happyReduction_30 ((HappyAbsSyn17  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Cond (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_3) (snd happy_var_5))
	) `HappyStk` happyRest

happyReduce_31 = happyReduce 7 17 happyReduction_31
happyReduction_31 ((HappyAbsSyn17  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn17  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.CondElse (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_3) (snd happy_var_5) (snd happy_var_7))
	) `HappyStk` happyRest

happyReduce_32 = happyReduce 5 17 happyReduction_32
happyReduction_32 ((HappyAbsSyn17  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn17
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.While (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_3) (snd happy_var_5))
	) `HappyStk` happyRest

happyReduce_33 = happySpecReduce_2  17 happyReduction_33
happyReduction_33 _
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, Abs.SExp (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_33 _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  18 happyReduction_34
happyReduction_34 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn18
		 ((fst happy_var_1, Abs.NoInit (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  18 happyReduction_35
happyReduction_35 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn18
		 ((fst happy_var_1, Abs.Init (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  19 happyReduction_36
happyReduction_36 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn19
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  19 happyReduction_37
happyReduction_37 (HappyAbsSyn19  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn19
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  20 happyReduction_38
happyReduction_38 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Int (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  20 happyReduction_39
happyReduction_39 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Str (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_1  20 happyReduction_40
happyReduction_40 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Bool (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_1  20 happyReduction_41
happyReduction_41 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn20
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Void (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  20 happyReduction_42
happyReduction_42 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn20
		 ((fst happy_var_1, Abs.Class (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_0  21 happyReduction_43
happyReduction_43  =  HappyAbsSyn21
		 ((Abs.BNFC'NoPosition, [])
	)

happyReduce_44 = happySpecReduce_1  21 happyReduction_44
happyReduction_44 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  21 happyReduction_45
happyReduction_45 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_1  22 happyReduction_46
happyReduction_46 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Abs.EVar (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_1  22 happyReduction_47
happyReduction_47 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Abs.ELitInt (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  22 happyReduction_48
happyReduction_48 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.ELitTrue (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  22 happyReduction_49
happyReduction_49 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.ELitFalse (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happyReduce 4 22 happyReduction_50
happyReduction_50 (_ `HappyStk`
	(HappyAbsSyn29  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 ((fst happy_var_1, Abs.EApp (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_51 = happySpecReduce_1  22 happyReduction_51
happyReduction_51 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Abs.EString (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_51 _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  22 happyReduction_52
happyReduction_52 (HappyAbsSyn4  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Abs.EAttr (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happyReduce 4 22 happyReduction_53
happyReduction_53 (_ `HappyStk`
	(HappyAbsSyn29  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 ((fst happy_var_1, Abs.EMet (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_54 = happySpecReduce_2  22 happyReduction_54
happyReduction_54 (HappyAbsSyn20  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.ENew (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_54 _ _  = notHappyAtAll 

happyReduce_55 = happyReduce 4 22 happyReduction_55
happyReduction_55 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn22
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.ENull (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	) `HappyStk` happyRest

happyReduce_56 = happySpecReduce_3  22 happyReduction_56
happyReduction_56 _
	(HappyAbsSyn22  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), (snd happy_var_2))
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_2  23 happyReduction_57
happyReduction_57 (HappyAbsSyn22  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Neg (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_57 _ _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_2  23 happyReduction_58
happyReduction_58 (HappyAbsSyn22  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn22
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Not (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_58 _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_1  23 happyReduction_59
happyReduction_59 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_59 _  = notHappyAtAll 

happyReduce_60 = happySpecReduce_3  24 happyReduction_60
happyReduction_60 (HappyAbsSyn22  happy_var_3)
	(HappyAbsSyn31  happy_var_2)
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Abs.EMul (fst happy_var_1) (snd happy_var_1) (snd happy_var_2) (snd happy_var_3))
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_1  24 happyReduction_61
happyReduction_61 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_61 _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_3  25 happyReduction_62
happyReduction_62 (HappyAbsSyn22  happy_var_3)
	(HappyAbsSyn30  happy_var_2)
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Abs.EAdd (fst happy_var_1) (snd happy_var_1) (snd happy_var_2) (snd happy_var_3))
	)
happyReduction_62 _ _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_1  25 happyReduction_63
happyReduction_63 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_63 _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_3  26 happyReduction_64
happyReduction_64 (HappyAbsSyn22  happy_var_3)
	(HappyAbsSyn32  happy_var_2)
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Abs.ERel (fst happy_var_1) (snd happy_var_1) (snd happy_var_2) (snd happy_var_3))
	)
happyReduction_64 _ _ _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_1  26 happyReduction_65
happyReduction_65 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_65 _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_3  27 happyReduction_66
happyReduction_66 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Abs.EAnd (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_66 _ _ _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_1  27 happyReduction_67
happyReduction_67 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_67 _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_3  28 happyReduction_68
happyReduction_68 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, Abs.EOr (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_68 _ _ _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_1  28 happyReduction_69
happyReduction_69 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_69 _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_0  29 happyReduction_70
happyReduction_70  =  HappyAbsSyn29
		 ((Abs.BNFC'NoPosition, [])
	)

happyReduce_71 = happySpecReduce_1  29 happyReduction_71
happyReduction_71 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn29
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_71 _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_3  29 happyReduction_72
happyReduction_72 (HappyAbsSyn29  happy_var_3)
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn29
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_72 _ _ _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_1  30 happyReduction_73
happyReduction_73 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn30
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Plus (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_73 _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_1  30 happyReduction_74
happyReduction_74 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn30
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Minus (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_74 _  = notHappyAtAll 

happyReduce_75 = happySpecReduce_1  31 happyReduction_75
happyReduction_75 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn31
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Times (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_75 _  = notHappyAtAll 

happyReduce_76 = happySpecReduce_1  31 happyReduction_76
happyReduction_76 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn31
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Div (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_76 _  = notHappyAtAll 

happyReduce_77 = happySpecReduce_1  31 happyReduction_77
happyReduction_77 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn31
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Mod (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_77 _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_1  32 happyReduction_78
happyReduction_78 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.LTH (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_78 _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_1  32 happyReduction_79
happyReduction_79 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.LE (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_79 _  = notHappyAtAll 

happyReduce_80 = happySpecReduce_1  32 happyReduction_80
happyReduction_80 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.GTH (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_80 _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_1  32 happyReduction_81
happyReduction_81 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.GE (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_81 _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_1  32 happyReduction_82
happyReduction_82 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.EQU (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_82 _  = notHappyAtAll 

happyReduce_83 = happySpecReduce_1  32 happyReduction_83
happyReduction_83 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn32
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.NE (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_83 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 74 74 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 33;
	PT _ (TS _ 2) -> cont 34;
	PT _ (TS _ 3) -> cont 35;
	PT _ (TS _ 4) -> cont 36;
	PT _ (TS _ 5) -> cont 37;
	PT _ (TS _ 6) -> cont 38;
	PT _ (TS _ 7) -> cont 39;
	PT _ (TS _ 8) -> cont 40;
	PT _ (TS _ 9) -> cont 41;
	PT _ (TS _ 10) -> cont 42;
	PT _ (TS _ 11) -> cont 43;
	PT _ (TS _ 12) -> cont 44;
	PT _ (TS _ 13) -> cont 45;
	PT _ (TS _ 14) -> cont 46;
	PT _ (TS _ 15) -> cont 47;
	PT _ (TS _ 16) -> cont 48;
	PT _ (TS _ 17) -> cont 49;
	PT _ (TS _ 18) -> cont 50;
	PT _ (TS _ 19) -> cont 51;
	PT _ (TS _ 20) -> cont 52;
	PT _ (TS _ 21) -> cont 53;
	PT _ (TS _ 22) -> cont 54;
	PT _ (TS _ 23) -> cont 55;
	PT _ (TS _ 24) -> cont 56;
	PT _ (TS _ 25) -> cont 57;
	PT _ (TS _ 26) -> cont 58;
	PT _ (TS _ 27) -> cont 59;
	PT _ (TS _ 28) -> cont 60;
	PT _ (TS _ 29) -> cont 61;
	PT _ (TS _ 30) -> cont 62;
	PT _ (TS _ 31) -> cont 63;
	PT _ (TS _ 32) -> cont 64;
	PT _ (TS _ 33) -> cont 65;
	PT _ (TS _ 34) -> cont 66;
	PT _ (TS _ 35) -> cont 67;
	PT _ (TS _ 36) -> cont 68;
	PT _ (TS _ 37) -> cont 69;
	PT _ (TS _ 38) -> cont 70;
	PT _ (TV _) -> cont 71;
	PT _ (TI _) -> cont 72;
	PT _ (TL _) -> cont 73;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 74 tk tks = happyError' (tks, explist)
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
pProgram_internal tks = happySomeParser where
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

-- Entrypoints

pProgram :: [Token] -> Err Abs.Program
pProgram = fmap snd . pProgram_internal
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
