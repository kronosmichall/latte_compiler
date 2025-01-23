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
	| HappyAbsSyn15 ((Abs.BNFC'Position, Abs.SIdent))
	| HappyAbsSyn16 ((Abs.BNFC'Position, Abs.Block))
	| HappyAbsSyn17 ((Abs.BNFC'Position, [Abs.Stmt]))
	| HappyAbsSyn18 ((Abs.BNFC'Position, Abs.Stmt))
	| HappyAbsSyn19 ((Abs.BNFC'Position, Abs.Item))
	| HappyAbsSyn20 ((Abs.BNFC'Position, [Abs.Item]))
	| HappyAbsSyn21 ((Abs.BNFC'Position, Abs.Type))
	| HappyAbsSyn22 ((Abs.BNFC'Position, [Abs.Type]))
	| HappyAbsSyn23 ((Abs.BNFC'Position, Abs.Expr))
	| HappyAbsSyn32 ((Abs.BNFC'Position, Abs.EChain))
	| HappyAbsSyn33 ((Abs.BNFC'Position, [Abs.EChain]))
	| HappyAbsSyn34 ((Abs.BNFC'Position, [Abs.Expr]))
	| HappyAbsSyn35 ((Abs.BNFC'Position, Abs.AddOp))
	| HappyAbsSyn36 ((Abs.BNFC'Position, Abs.MulOp))
	| HappyAbsSyn37 ((Abs.BNFC'Position, Abs.RelOp))

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
 action_139,
 action_140,
 action_141,
 action_142,
 action_143,
 action_144,
 action_145,
 action_146,
 action_147,
 action_148,
 action_149,
 action_150,
 action_151,
 action_152 :: () => Prelude.Int -> ({-HappyReduction (Err) = -}
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
 happyReduce_83,
 happyReduce_84,
 happyReduce_85,
 happyReduce_86,
 happyReduce_87,
 happyReduce_88,
 happyReduce_89,
 happyReduce_90,
 happyReduce_91,
 happyReduce_92 :: () => ({-HappyReduction (Err) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (Err) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (Err) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,546) ([0,0,0,3072,4257,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3072,4257,0,0,0,0,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8192,512,0,0,512,0,0,0,0,0,0,0,0,0,0,1024,4257,0,0,0,0,0,0,0,0,0,4096,0,0,0,1024,4257,0,0,0,1024,4257,0,0,0,0,2048,0,0,0,0,4096,0,0,0,0,512,0,0,16384,0,0,0,0,1024,0,0,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,512,0,0,0,1024,4257,0,0,0,0,0,0,0,512,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1024,4257,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,33312,50184,29695,0,0,512,2,0,0,0,0,0,0,0,0,0,0,0,0,0,8192,65,0,0,0,0,0,0,0,0,0,0,2048,0,0,33312,50184,29695,0,0,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2176,4,0,0,0,36864,0,0,0,0,320,944,0,0,0,0,0,1024,0,0,0,8,0,0,0,512,16384,28758,0,0,33312,16384,28758,0,0,512,16384,28758,0,0,0,0,0,0,0,0,0,0,0,0,512,0,0,0,0,0,1024,4257,0,0,0,0,0,0,0,33312,16392,28758,0,0,0,0,4096,0,0,0,0,0,0,0,512,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1024,0,0,0,0,0,0,512,0,0,33312,16384,28758,0,0,0,2,0,0,0,512,0,0,0,0,0,2,0,0,0,0,0,0,0,0,512,2,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,33312,16384,28758,0,0,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,33312,16384,28758,0,0,33312,16384,28758,0,0,0,0,0,0,0,33312,16384,28758,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,33312,16384,28758,0,0,0,0,0,0,0,0,0,0,0,0,33312,16384,28758,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0,16384,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,8,0,0,0,33312,16384,28758,0,0,33312,16384,28758,0,0,0,0,4096,0,0,512,0,0,0,0,0,0,0,0,0,16384,0,0,0,0,1024,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4096,0,0,33312,16384,28758,0,0,0,0,0,0,0,2176,4,0,0,0,0,0,0,0,0,36864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,4096,0,0,0,0,4096,0,0,33312,16384,28758,0,0,0,0,4096,0,0,1024,0,0,0,0,0,0,0,0,0,33312,50184,29695,0,0,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,512,0,0,0,0,33312,50184,29695,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,33312,16384,28758,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,33312,50184,29695,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_pProgram_internal","Ident","Integer","String","Program","TopDef","ListTopDef","Arg","ListArg","CBlock","CDef","ListCDef","SIdent","Block","ListStmt","Stmt","Item","ListItem","Type","ListType","Expr8","Expr7","Expr6","Expr5","Expr4","Expr3","Expr2","Expr1","Expr","EChain","ListEChain","ListExpr","AddOp","MulOp","RelOp","'!'","'!='","'%'","'&&'","'('","')'","'*'","'+'","'++'","','","'-'","'--'","'.'","'/'","';'","'<'","'<='","'='","'=='","'>'","'>='","'boolean'","'class'","'else'","'extends'","'false'","'if'","'int'","'new'","'null'","'return'","'self.'","'string'","'true'","'void'","'while'","'{'","'||'","'}'","L_Ident","L_integ","L_quoted","%eof"]
        bit_start = st Prelude.* 80
        bit_end = (st Prelude.+ 1) Prelude.* 80
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..79]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (59) = happyShift action_8
action_0 (60) = happyShift action_9
action_0 (65) = happyShift action_10
action_0 (70) = happyShift action_11
action_0 (72) = happyShift action_12
action_0 (77) = happyShift action_2
action_0 (4) = happyGoto action_3
action_0 (7) = happyGoto action_4
action_0 (8) = happyGoto action_5
action_0 (9) = happyGoto action_6
action_0 (21) = happyGoto action_7
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (77) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 _ = happyReduce_44

action_4 (80) = happyAccept
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (59) = happyShift action_8
action_5 (60) = happyShift action_9
action_5 (65) = happyShift action_10
action_5 (70) = happyShift action_11
action_5 (72) = happyShift action_12
action_5 (77) = happyShift action_2
action_5 (4) = happyGoto action_3
action_5 (8) = happyGoto action_5
action_5 (9) = happyGoto action_15
action_5 (21) = happyGoto action_7
action_5 _ = happyReduce_8

action_6 _ = happyReduce_4

action_7 (77) = happyShift action_2
action_7 (4) = happyGoto action_14
action_7 _ = happyFail (happyExpListPerState 7)

action_8 _ = happyReduce_42

action_9 (77) = happyShift action_2
action_9 (4) = happyGoto action_13
action_9 _ = happyFail (happyExpListPerState 9)

action_10 _ = happyReduce_40

action_11 _ = happyReduce_41

action_12 _ = happyReduce_43

action_13 (62) = happyShift action_18
action_13 (74) = happyShift action_19
action_13 (12) = happyGoto action_17
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (42) = happyShift action_16
action_14 _ = happyFail (happyExpListPerState 14)

action_15 _ = happyReduce_9

action_16 (59) = happyShift action_8
action_16 (65) = happyShift action_10
action_16 (70) = happyShift action_11
action_16 (72) = happyShift action_12
action_16 (77) = happyShift action_2
action_16 (4) = happyGoto action_3
action_16 (10) = happyGoto action_24
action_16 (11) = happyGoto action_25
action_16 (21) = happyGoto action_26
action_16 _ = happyReduce_11

action_17 _ = happyReduce_6

action_18 (77) = happyShift action_2
action_18 (4) = happyGoto action_23
action_18 _ = happyFail (happyExpListPerState 18)

action_19 (59) = happyShift action_8
action_19 (65) = happyShift action_10
action_19 (70) = happyShift action_11
action_19 (72) = happyShift action_12
action_19 (77) = happyShift action_2
action_19 (4) = happyGoto action_3
action_19 (13) = happyGoto action_20
action_19 (14) = happyGoto action_21
action_19 (21) = happyGoto action_22
action_19 _ = happyReduce_17

action_20 (59) = happyShift action_8
action_20 (65) = happyShift action_10
action_20 (70) = happyShift action_11
action_20 (72) = happyShift action_12
action_20 (77) = happyShift action_2
action_20 (4) = happyGoto action_3
action_20 (13) = happyGoto action_20
action_20 (14) = happyGoto action_33
action_20 (21) = happyGoto action_22
action_20 _ = happyReduce_17

action_21 (76) = happyShift action_32
action_21 _ = happyFail (happyExpListPerState 21)

action_22 (77) = happyShift action_2
action_22 (4) = happyGoto action_31
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (74) = happyShift action_19
action_23 (12) = happyGoto action_30
action_23 _ = happyFail (happyExpListPerState 23)

action_24 (47) = happyShift action_29
action_24 _ = happyReduce_12

action_25 (43) = happyShift action_28
action_25 _ = happyFail (happyExpListPerState 25)

action_26 (77) = happyShift action_2
action_26 (4) = happyGoto action_27
action_26 _ = happyFail (happyExpListPerState 26)

action_27 _ = happyReduce_10

action_28 (74) = happyShift action_38
action_28 (16) = happyGoto action_37
action_28 _ = happyFail (happyExpListPerState 28)

action_29 (59) = happyShift action_8
action_29 (65) = happyShift action_10
action_29 (70) = happyShift action_11
action_29 (72) = happyShift action_12
action_29 (77) = happyShift action_2
action_29 (4) = happyGoto action_3
action_29 (10) = happyGoto action_24
action_29 (11) = happyGoto action_36
action_29 (21) = happyGoto action_26
action_29 _ = happyReduce_11

action_30 _ = happyReduce_7

action_31 (42) = happyShift action_34
action_31 (52) = happyShift action_35
action_31 _ = happyFail (happyExpListPerState 31)

action_32 _ = happyReduce_14

action_33 _ = happyReduce_18

action_34 (59) = happyShift action_8
action_34 (65) = happyShift action_10
action_34 (70) = happyShift action_11
action_34 (72) = happyShift action_12
action_34 (77) = happyShift action_2
action_34 (4) = happyGoto action_3
action_34 (10) = happyGoto action_24
action_34 (11) = happyGoto action_70
action_34 (21) = happyGoto action_26
action_34 _ = happyReduce_11

action_35 _ = happyReduce_16

action_36 _ = happyReduce_13

action_37 _ = happyReduce_5

action_38 (38) = happyShift action_56
action_38 (42) = happyShift action_57
action_38 (48) = happyShift action_58
action_38 (52) = happyShift action_59
action_38 (59) = happyShift action_8
action_38 (63) = happyShift action_60
action_38 (64) = happyShift action_61
action_38 (65) = happyShift action_10
action_38 (66) = happyShift action_62
action_38 (67) = happyShift action_63
action_38 (68) = happyShift action_64
action_38 (69) = happyShift action_65
action_38 (70) = happyShift action_11
action_38 (71) = happyShift action_66
action_38 (72) = happyShift action_12
action_38 (73) = happyShift action_67
action_38 (74) = happyShift action_38
action_38 (77) = happyShift action_2
action_38 (78) = happyShift action_68
action_38 (79) = happyShift action_69
action_38 (4) = happyGoto action_39
action_38 (5) = happyGoto action_40
action_38 (6) = happyGoto action_41
action_38 (15) = happyGoto action_42
action_38 (16) = happyGoto action_43
action_38 (17) = happyGoto action_44
action_38 (18) = happyGoto action_45
action_38 (21) = happyGoto action_46
action_38 (23) = happyGoto action_47
action_38 (24) = happyGoto action_48
action_38 (25) = happyGoto action_49
action_38 (26) = happyGoto action_50
action_38 (27) = happyGoto action_51
action_38 (28) = happyGoto action_52
action_38 (29) = happyGoto action_53
action_38 (30) = happyGoto action_54
action_38 (31) = happyGoto action_55
action_38 _ = happyReduce_22

action_39 (42) = happyShift action_110
action_39 (46) = happyReduce_19
action_39 (49) = happyReduce_19
action_39 (50) = happyShift action_111
action_39 (55) = happyReduce_19
action_39 (77) = happyReduce_44
action_39 _ = happyReduce_55

action_40 _ = happyReduce_56

action_41 _ = happyReduce_60

action_42 (46) = happyShift action_107
action_42 (49) = happyShift action_108
action_42 (55) = happyShift action_109
action_42 _ = happyFail (happyExpListPerState 42)

action_43 _ = happyReduce_25

action_44 (76) = happyShift action_106
action_44 _ = happyFail (happyExpListPerState 44)

action_45 (38) = happyShift action_56
action_45 (42) = happyShift action_57
action_45 (48) = happyShift action_58
action_45 (52) = happyShift action_59
action_45 (59) = happyShift action_8
action_45 (63) = happyShift action_60
action_45 (64) = happyShift action_61
action_45 (65) = happyShift action_10
action_45 (66) = happyShift action_62
action_45 (67) = happyShift action_63
action_45 (68) = happyShift action_64
action_45 (69) = happyShift action_65
action_45 (70) = happyShift action_11
action_45 (71) = happyShift action_66
action_45 (72) = happyShift action_12
action_45 (73) = happyShift action_67
action_45 (74) = happyShift action_38
action_45 (77) = happyShift action_2
action_45 (78) = happyShift action_68
action_45 (79) = happyShift action_69
action_45 (4) = happyGoto action_39
action_45 (5) = happyGoto action_40
action_45 (6) = happyGoto action_41
action_45 (15) = happyGoto action_42
action_45 (16) = happyGoto action_43
action_45 (17) = happyGoto action_105
action_45 (18) = happyGoto action_45
action_45 (21) = happyGoto action_46
action_45 (23) = happyGoto action_47
action_45 (24) = happyGoto action_48
action_45 (25) = happyGoto action_49
action_45 (26) = happyGoto action_50
action_45 (27) = happyGoto action_51
action_45 (28) = happyGoto action_52
action_45 (29) = happyGoto action_53
action_45 (30) = happyGoto action_54
action_45 (31) = happyGoto action_55
action_45 _ = happyReduce_22

action_46 (77) = happyShift action_2
action_46 (4) = happyGoto action_102
action_46 (19) = happyGoto action_103
action_46 (20) = happyGoto action_104
action_46 _ = happyFail (happyExpListPerState 46)

action_47 _ = happyReduce_54

action_48 _ = happyReduce_61

action_49 _ = happyReduce_64

action_50 _ = happyReduce_66

action_51 (40) = happyShift action_99
action_51 (44) = happyShift action_100
action_51 (51) = happyShift action_101
action_51 (36) = happyGoto action_98
action_51 _ = happyReduce_68

action_52 (45) = happyShift action_96
action_52 (48) = happyShift action_97
action_52 (35) = happyGoto action_95
action_52 _ = happyReduce_70

action_53 (39) = happyShift action_88
action_53 (41) = happyShift action_89
action_53 (53) = happyShift action_90
action_53 (54) = happyShift action_91
action_53 (56) = happyShift action_92
action_53 (57) = happyShift action_93
action_53 (58) = happyShift action_94
action_53 (37) = happyGoto action_87
action_53 _ = happyReduce_72

action_54 (75) = happyShift action_86
action_54 _ = happyReduce_74

action_55 (52) = happyShift action_85
action_55 _ = happyFail (happyExpListPerState 55)

action_56 (42) = happyShift action_57
action_56 (63) = happyShift action_60
action_56 (66) = happyShift action_62
action_56 (67) = happyShift action_63
action_56 (69) = happyShift action_65
action_56 (71) = happyShift action_66
action_56 (77) = happyShift action_2
action_56 (78) = happyShift action_68
action_56 (79) = happyShift action_69
action_56 (4) = happyGoto action_77
action_56 (5) = happyGoto action_40
action_56 (6) = happyGoto action_41
action_56 (23) = happyGoto action_47
action_56 (24) = happyGoto action_48
action_56 (25) = happyGoto action_84
action_56 _ = happyFail (happyExpListPerState 56)

action_57 (38) = happyShift action_56
action_57 (42) = happyShift action_57
action_57 (48) = happyShift action_58
action_57 (63) = happyShift action_60
action_57 (66) = happyShift action_62
action_57 (67) = happyShift action_63
action_57 (69) = happyShift action_65
action_57 (71) = happyShift action_66
action_57 (77) = happyShift action_2
action_57 (78) = happyShift action_68
action_57 (79) = happyShift action_69
action_57 (4) = happyGoto action_77
action_57 (5) = happyGoto action_40
action_57 (6) = happyGoto action_41
action_57 (23) = happyGoto action_47
action_57 (24) = happyGoto action_48
action_57 (25) = happyGoto action_49
action_57 (26) = happyGoto action_50
action_57 (27) = happyGoto action_51
action_57 (28) = happyGoto action_52
action_57 (29) = happyGoto action_53
action_57 (30) = happyGoto action_54
action_57 (31) = happyGoto action_83
action_57 _ = happyFail (happyExpListPerState 57)

action_58 (42) = happyShift action_57
action_58 (63) = happyShift action_60
action_58 (66) = happyShift action_62
action_58 (67) = happyShift action_63
action_58 (69) = happyShift action_65
action_58 (71) = happyShift action_66
action_58 (77) = happyShift action_2
action_58 (78) = happyShift action_68
action_58 (79) = happyShift action_69
action_58 (4) = happyGoto action_77
action_58 (5) = happyGoto action_40
action_58 (6) = happyGoto action_41
action_58 (23) = happyGoto action_47
action_58 (24) = happyGoto action_48
action_58 (25) = happyGoto action_82
action_58 _ = happyFail (happyExpListPerState 58)

action_59 _ = happyReduce_24

action_60 _ = happyReduce_58

action_61 (42) = happyShift action_81
action_61 _ = happyFail (happyExpListPerState 61)

action_62 (59) = happyShift action_8
action_62 (65) = happyShift action_10
action_62 (70) = happyShift action_11
action_62 (72) = happyShift action_12
action_62 (77) = happyShift action_2
action_62 (4) = happyGoto action_3
action_62 (21) = happyGoto action_80
action_62 _ = happyFail (happyExpListPerState 62)

action_63 _ = happyReduce_48

action_64 (38) = happyShift action_56
action_64 (42) = happyShift action_57
action_64 (48) = happyShift action_58
action_64 (52) = happyShift action_79
action_64 (63) = happyShift action_60
action_64 (66) = happyShift action_62
action_64 (67) = happyShift action_63
action_64 (69) = happyShift action_65
action_64 (71) = happyShift action_66
action_64 (77) = happyShift action_2
action_64 (78) = happyShift action_68
action_64 (79) = happyShift action_69
action_64 (4) = happyGoto action_77
action_64 (5) = happyGoto action_40
action_64 (6) = happyGoto action_41
action_64 (23) = happyGoto action_47
action_64 (24) = happyGoto action_48
action_64 (25) = happyGoto action_49
action_64 (26) = happyGoto action_50
action_64 (27) = happyGoto action_51
action_64 (28) = happyGoto action_52
action_64 (29) = happyGoto action_53
action_64 (30) = happyGoto action_54
action_64 (31) = happyGoto action_78
action_64 _ = happyFail (happyExpListPerState 64)

action_65 (77) = happyShift action_2
action_65 (4) = happyGoto action_73
action_65 (15) = happyGoto action_74
action_65 (32) = happyGoto action_75
action_65 (33) = happyGoto action_76
action_65 _ = happyReduce_76

action_66 _ = happyReduce_57

action_67 (42) = happyShift action_72
action_67 _ = happyFail (happyExpListPerState 67)

action_68 _ = happyReduce_2

action_69 _ = happyReduce_3

action_70 (43) = happyShift action_71
action_70 _ = happyFail (happyExpListPerState 70)

action_71 (74) = happyShift action_38
action_71 (16) = happyGoto action_135
action_71 _ = happyFail (happyExpListPerState 71)

action_72 (38) = happyShift action_56
action_72 (42) = happyShift action_57
action_72 (48) = happyShift action_58
action_72 (63) = happyShift action_60
action_72 (66) = happyShift action_62
action_72 (67) = happyShift action_63
action_72 (69) = happyShift action_65
action_72 (71) = happyShift action_66
action_72 (77) = happyShift action_2
action_72 (78) = happyShift action_68
action_72 (79) = happyShift action_69
action_72 (4) = happyGoto action_77
action_72 (5) = happyGoto action_40
action_72 (6) = happyGoto action_41
action_72 (23) = happyGoto action_47
action_72 (24) = happyGoto action_48
action_72 (25) = happyGoto action_49
action_72 (26) = happyGoto action_50
action_72 (27) = happyGoto action_51
action_72 (28) = happyGoto action_52
action_72 (29) = happyGoto action_53
action_72 (30) = happyGoto action_54
action_72 (31) = happyGoto action_134
action_72 _ = happyFail (happyExpListPerState 72)

action_73 (50) = happyShift action_133
action_73 _ = happyReduce_19

action_74 (42) = happyShift action_132
action_74 _ = happyFail (happyExpListPerState 74)

action_75 (50) = happyShift action_131
action_75 _ = happyReduce_77

action_76 _ = happyReduce_50

action_77 (42) = happyShift action_110
action_77 (50) = happyShift action_130
action_77 _ = happyReduce_55

action_78 (52) = happyShift action_129
action_78 _ = happyFail (happyExpListPerState 78)

action_79 _ = happyReduce_31

action_80 _ = happyReduce_51

action_81 (38) = happyShift action_56
action_81 (42) = happyShift action_57
action_81 (48) = happyShift action_58
action_81 (63) = happyShift action_60
action_81 (66) = happyShift action_62
action_81 (67) = happyShift action_63
action_81 (69) = happyShift action_65
action_81 (71) = happyShift action_66
action_81 (77) = happyShift action_2
action_81 (78) = happyShift action_68
action_81 (79) = happyShift action_69
action_81 (4) = happyGoto action_77
action_81 (5) = happyGoto action_40
action_81 (6) = happyGoto action_41
action_81 (23) = happyGoto action_47
action_81 (24) = happyGoto action_48
action_81 (25) = happyGoto action_49
action_81 (26) = happyGoto action_50
action_81 (27) = happyGoto action_51
action_81 (28) = happyGoto action_52
action_81 (29) = happyGoto action_53
action_81 (30) = happyGoto action_54
action_81 (31) = happyGoto action_128
action_81 _ = happyFail (happyExpListPerState 81)

action_82 _ = happyReduce_62

action_83 (43) = happyShift action_127
action_83 _ = happyFail (happyExpListPerState 83)

action_84 _ = happyReduce_63

action_85 _ = happyReduce_35

action_86 (38) = happyShift action_56
action_86 (42) = happyShift action_57
action_86 (48) = happyShift action_58
action_86 (63) = happyShift action_60
action_86 (66) = happyShift action_62
action_86 (67) = happyShift action_63
action_86 (69) = happyShift action_65
action_86 (71) = happyShift action_66
action_86 (77) = happyShift action_2
action_86 (78) = happyShift action_68
action_86 (79) = happyShift action_69
action_86 (4) = happyGoto action_77
action_86 (5) = happyGoto action_40
action_86 (6) = happyGoto action_41
action_86 (23) = happyGoto action_47
action_86 (24) = happyGoto action_48
action_86 (25) = happyGoto action_49
action_86 (26) = happyGoto action_50
action_86 (27) = happyGoto action_51
action_86 (28) = happyGoto action_52
action_86 (29) = happyGoto action_53
action_86 (30) = happyGoto action_54
action_86 (31) = happyGoto action_126
action_86 _ = happyFail (happyExpListPerState 86)

action_87 (38) = happyShift action_56
action_87 (42) = happyShift action_57
action_87 (48) = happyShift action_58
action_87 (63) = happyShift action_60
action_87 (66) = happyShift action_62
action_87 (67) = happyShift action_63
action_87 (69) = happyShift action_65
action_87 (71) = happyShift action_66
action_87 (77) = happyShift action_2
action_87 (78) = happyShift action_68
action_87 (79) = happyShift action_69
action_87 (4) = happyGoto action_77
action_87 (5) = happyGoto action_40
action_87 (6) = happyGoto action_41
action_87 (23) = happyGoto action_47
action_87 (24) = happyGoto action_48
action_87 (25) = happyGoto action_49
action_87 (26) = happyGoto action_50
action_87 (27) = happyGoto action_51
action_87 (28) = happyGoto action_125
action_87 _ = happyFail (happyExpListPerState 87)

action_88 _ = happyReduce_92

action_89 (38) = happyShift action_56
action_89 (42) = happyShift action_57
action_89 (48) = happyShift action_58
action_89 (63) = happyShift action_60
action_89 (66) = happyShift action_62
action_89 (67) = happyShift action_63
action_89 (69) = happyShift action_65
action_89 (71) = happyShift action_66
action_89 (77) = happyShift action_2
action_89 (78) = happyShift action_68
action_89 (79) = happyShift action_69
action_89 (4) = happyGoto action_77
action_89 (5) = happyGoto action_40
action_89 (6) = happyGoto action_41
action_89 (23) = happyGoto action_47
action_89 (24) = happyGoto action_48
action_89 (25) = happyGoto action_49
action_89 (26) = happyGoto action_50
action_89 (27) = happyGoto action_51
action_89 (28) = happyGoto action_52
action_89 (29) = happyGoto action_53
action_89 (30) = happyGoto action_124
action_89 _ = happyFail (happyExpListPerState 89)

action_90 _ = happyReduce_87

action_91 _ = happyReduce_88

action_92 _ = happyReduce_91

action_93 _ = happyReduce_89

action_94 _ = happyReduce_90

action_95 (38) = happyShift action_56
action_95 (42) = happyShift action_57
action_95 (48) = happyShift action_58
action_95 (63) = happyShift action_60
action_95 (66) = happyShift action_62
action_95 (67) = happyShift action_63
action_95 (69) = happyShift action_65
action_95 (71) = happyShift action_66
action_95 (77) = happyShift action_2
action_95 (78) = happyShift action_68
action_95 (79) = happyShift action_69
action_95 (4) = happyGoto action_77
action_95 (5) = happyGoto action_40
action_95 (6) = happyGoto action_41
action_95 (23) = happyGoto action_47
action_95 (24) = happyGoto action_48
action_95 (25) = happyGoto action_49
action_95 (26) = happyGoto action_50
action_95 (27) = happyGoto action_123
action_95 _ = happyFail (happyExpListPerState 95)

action_96 _ = happyReduce_82

action_97 _ = happyReduce_83

action_98 (38) = happyShift action_56
action_98 (42) = happyShift action_57
action_98 (48) = happyShift action_58
action_98 (63) = happyShift action_60
action_98 (66) = happyShift action_62
action_98 (67) = happyShift action_63
action_98 (69) = happyShift action_65
action_98 (71) = happyShift action_66
action_98 (77) = happyShift action_2
action_98 (78) = happyShift action_68
action_98 (79) = happyShift action_69
action_98 (4) = happyGoto action_77
action_98 (5) = happyGoto action_40
action_98 (6) = happyGoto action_41
action_98 (23) = happyGoto action_47
action_98 (24) = happyGoto action_48
action_98 (25) = happyGoto action_49
action_98 (26) = happyGoto action_122
action_98 _ = happyFail (happyExpListPerState 98)

action_99 _ = happyReduce_86

action_100 _ = happyReduce_84

action_101 _ = happyReduce_85

action_102 (55) = happyShift action_121
action_102 _ = happyReduce_36

action_103 (47) = happyShift action_120
action_103 _ = happyReduce_38

action_104 (52) = happyShift action_119
action_104 _ = happyFail (happyExpListPerState 104)

action_105 _ = happyReduce_23

action_106 _ = happyReduce_21

action_107 (52) = happyShift action_118
action_107 _ = happyFail (happyExpListPerState 107)

action_108 (52) = happyShift action_117
action_108 _ = happyFail (happyExpListPerState 108)

action_109 (38) = happyShift action_56
action_109 (42) = happyShift action_57
action_109 (48) = happyShift action_58
action_109 (63) = happyShift action_60
action_109 (66) = happyShift action_62
action_109 (67) = happyShift action_63
action_109 (69) = happyShift action_65
action_109 (71) = happyShift action_66
action_109 (77) = happyShift action_2
action_109 (78) = happyShift action_68
action_109 (79) = happyShift action_69
action_109 (4) = happyGoto action_77
action_109 (5) = happyGoto action_40
action_109 (6) = happyGoto action_41
action_109 (23) = happyGoto action_47
action_109 (24) = happyGoto action_48
action_109 (25) = happyGoto action_49
action_109 (26) = happyGoto action_50
action_109 (27) = happyGoto action_51
action_109 (28) = happyGoto action_52
action_109 (29) = happyGoto action_53
action_109 (30) = happyGoto action_54
action_109 (31) = happyGoto action_116
action_109 _ = happyFail (happyExpListPerState 109)

action_110 (38) = happyShift action_56
action_110 (42) = happyShift action_57
action_110 (48) = happyShift action_58
action_110 (63) = happyShift action_60
action_110 (66) = happyShift action_62
action_110 (67) = happyShift action_63
action_110 (69) = happyShift action_65
action_110 (71) = happyShift action_66
action_110 (77) = happyShift action_2
action_110 (78) = happyShift action_68
action_110 (79) = happyShift action_69
action_110 (4) = happyGoto action_77
action_110 (5) = happyGoto action_40
action_110 (6) = happyGoto action_41
action_110 (23) = happyGoto action_47
action_110 (24) = happyGoto action_48
action_110 (25) = happyGoto action_49
action_110 (26) = happyGoto action_50
action_110 (27) = happyGoto action_51
action_110 (28) = happyGoto action_52
action_110 (29) = happyGoto action_53
action_110 (30) = happyGoto action_54
action_110 (31) = happyGoto action_114
action_110 (34) = happyGoto action_115
action_110 _ = happyReduce_79

action_111 (77) = happyShift action_2
action_111 (4) = happyGoto action_73
action_111 (15) = happyGoto action_112
action_111 (32) = happyGoto action_75
action_111 (33) = happyGoto action_113
action_111 _ = happyReduce_76

action_112 (42) = happyShift action_132
action_112 (46) = happyReduce_20
action_112 (49) = happyReduce_20
action_112 (55) = happyReduce_20
action_112 _ = happyReduce_52

action_113 _ = happyReduce_53

action_114 (47) = happyShift action_146
action_114 _ = happyReduce_80

action_115 (43) = happyShift action_145
action_115 _ = happyFail (happyExpListPerState 115)

action_116 (52) = happyShift action_144
action_116 _ = happyFail (happyExpListPerState 116)

action_117 _ = happyReduce_29

action_118 _ = happyReduce_28

action_119 _ = happyReduce_26

action_120 (77) = happyShift action_2
action_120 (4) = happyGoto action_102
action_120 (19) = happyGoto action_103
action_120 (20) = happyGoto action_143
action_120 _ = happyFail (happyExpListPerState 120)

action_121 (38) = happyShift action_56
action_121 (42) = happyShift action_57
action_121 (48) = happyShift action_58
action_121 (63) = happyShift action_60
action_121 (66) = happyShift action_62
action_121 (67) = happyShift action_63
action_121 (69) = happyShift action_65
action_121 (71) = happyShift action_66
action_121 (77) = happyShift action_2
action_121 (78) = happyShift action_68
action_121 (79) = happyShift action_69
action_121 (4) = happyGoto action_77
action_121 (5) = happyGoto action_40
action_121 (6) = happyGoto action_41
action_121 (23) = happyGoto action_47
action_121 (24) = happyGoto action_48
action_121 (25) = happyGoto action_49
action_121 (26) = happyGoto action_50
action_121 (27) = happyGoto action_51
action_121 (28) = happyGoto action_52
action_121 (29) = happyGoto action_53
action_121 (30) = happyGoto action_54
action_121 (31) = happyGoto action_142
action_121 _ = happyFail (happyExpListPerState 121)

action_122 _ = happyReduce_65

action_123 (40) = happyShift action_99
action_123 (44) = happyShift action_100
action_123 (51) = happyShift action_101
action_123 (36) = happyGoto action_98
action_123 _ = happyReduce_67

action_124 _ = happyReduce_71

action_125 (45) = happyShift action_96
action_125 (48) = happyShift action_97
action_125 (35) = happyGoto action_95
action_125 _ = happyReduce_69

action_126 _ = happyReduce_73

action_127 _ = happyReduce_49

action_128 (43) = happyShift action_141
action_128 _ = happyFail (happyExpListPerState 128)

action_129 _ = happyReduce_30

action_130 (77) = happyShift action_2
action_130 (4) = happyGoto action_73
action_130 (15) = happyGoto action_140
action_130 (32) = happyGoto action_75
action_130 (33) = happyGoto action_113
action_130 _ = happyReduce_76

action_131 (77) = happyShift action_2
action_131 (4) = happyGoto action_73
action_131 (15) = happyGoto action_74
action_131 (32) = happyGoto action_75
action_131 (33) = happyGoto action_139
action_131 _ = happyReduce_76

action_132 (38) = happyShift action_56
action_132 (42) = happyShift action_57
action_132 (48) = happyShift action_58
action_132 (63) = happyShift action_60
action_132 (66) = happyShift action_62
action_132 (67) = happyShift action_63
action_132 (69) = happyShift action_65
action_132 (71) = happyShift action_66
action_132 (77) = happyShift action_2
action_132 (78) = happyShift action_68
action_132 (79) = happyShift action_69
action_132 (4) = happyGoto action_77
action_132 (5) = happyGoto action_40
action_132 (6) = happyGoto action_41
action_132 (23) = happyGoto action_47
action_132 (24) = happyGoto action_48
action_132 (25) = happyGoto action_49
action_132 (26) = happyGoto action_50
action_132 (27) = happyGoto action_51
action_132 (28) = happyGoto action_52
action_132 (29) = happyGoto action_53
action_132 (30) = happyGoto action_54
action_132 (31) = happyGoto action_114
action_132 (34) = happyGoto action_138
action_132 _ = happyReduce_79

action_133 (77) = happyShift action_2
action_133 (4) = happyGoto action_73
action_133 (15) = happyGoto action_137
action_133 _ = happyFail (happyExpListPerState 133)

action_134 (43) = happyShift action_136
action_134 _ = happyFail (happyExpListPerState 134)

action_135 _ = happyReduce_15

action_136 (38) = happyShift action_56
action_136 (42) = happyShift action_57
action_136 (48) = happyShift action_58
action_136 (52) = happyShift action_59
action_136 (59) = happyShift action_8
action_136 (63) = happyShift action_60
action_136 (64) = happyShift action_61
action_136 (65) = happyShift action_10
action_136 (66) = happyShift action_62
action_136 (67) = happyShift action_63
action_136 (68) = happyShift action_64
action_136 (69) = happyShift action_65
action_136 (70) = happyShift action_11
action_136 (71) = happyShift action_66
action_136 (72) = happyShift action_12
action_136 (73) = happyShift action_67
action_136 (74) = happyShift action_38
action_136 (77) = happyShift action_2
action_136 (78) = happyShift action_68
action_136 (79) = happyShift action_69
action_136 (4) = happyGoto action_39
action_136 (5) = happyGoto action_40
action_136 (6) = happyGoto action_41
action_136 (15) = happyGoto action_42
action_136 (16) = happyGoto action_43
action_136 (18) = happyGoto action_150
action_136 (21) = happyGoto action_46
action_136 (23) = happyGoto action_47
action_136 (24) = happyGoto action_48
action_136 (25) = happyGoto action_49
action_136 (26) = happyGoto action_50
action_136 (27) = happyGoto action_51
action_136 (28) = happyGoto action_52
action_136 (29) = happyGoto action_53
action_136 (30) = happyGoto action_54
action_136 (31) = happyGoto action_55
action_136 _ = happyFail (happyExpListPerState 136)

action_137 _ = happyReduce_20

action_138 (43) = happyShift action_149
action_138 _ = happyFail (happyExpListPerState 138)

action_139 _ = happyReduce_78

action_140 (42) = happyShift action_132
action_140 _ = happyReduce_52

action_141 (38) = happyShift action_56
action_141 (42) = happyShift action_57
action_141 (48) = happyShift action_58
action_141 (52) = happyShift action_59
action_141 (59) = happyShift action_8
action_141 (63) = happyShift action_60
action_141 (64) = happyShift action_61
action_141 (65) = happyShift action_10
action_141 (66) = happyShift action_62
action_141 (67) = happyShift action_63
action_141 (68) = happyShift action_64
action_141 (69) = happyShift action_65
action_141 (70) = happyShift action_11
action_141 (71) = happyShift action_66
action_141 (72) = happyShift action_12
action_141 (73) = happyShift action_67
action_141 (74) = happyShift action_38
action_141 (77) = happyShift action_2
action_141 (78) = happyShift action_68
action_141 (79) = happyShift action_69
action_141 (4) = happyGoto action_39
action_141 (5) = happyGoto action_40
action_141 (6) = happyGoto action_41
action_141 (15) = happyGoto action_42
action_141 (16) = happyGoto action_43
action_141 (18) = happyGoto action_148
action_141 (21) = happyGoto action_46
action_141 (23) = happyGoto action_47
action_141 (24) = happyGoto action_48
action_141 (25) = happyGoto action_49
action_141 (26) = happyGoto action_50
action_141 (27) = happyGoto action_51
action_141 (28) = happyGoto action_52
action_141 (29) = happyGoto action_53
action_141 (30) = happyGoto action_54
action_141 (31) = happyGoto action_55
action_141 _ = happyFail (happyExpListPerState 141)

action_142 _ = happyReduce_37

action_143 _ = happyReduce_39

action_144 _ = happyReduce_27

action_145 _ = happyReduce_59

action_146 (38) = happyShift action_56
action_146 (42) = happyShift action_57
action_146 (48) = happyShift action_58
action_146 (63) = happyShift action_60
action_146 (66) = happyShift action_62
action_146 (67) = happyShift action_63
action_146 (69) = happyShift action_65
action_146 (71) = happyShift action_66
action_146 (77) = happyShift action_2
action_146 (78) = happyShift action_68
action_146 (79) = happyShift action_69
action_146 (4) = happyGoto action_77
action_146 (5) = happyGoto action_40
action_146 (6) = happyGoto action_41
action_146 (23) = happyGoto action_47
action_146 (24) = happyGoto action_48
action_146 (25) = happyGoto action_49
action_146 (26) = happyGoto action_50
action_146 (27) = happyGoto action_51
action_146 (28) = happyGoto action_52
action_146 (29) = happyGoto action_53
action_146 (30) = happyGoto action_54
action_146 (31) = happyGoto action_114
action_146 (34) = happyGoto action_147
action_146 _ = happyReduce_79

action_147 _ = happyReduce_81

action_148 (61) = happyShift action_151
action_148 _ = happyReduce_32

action_149 _ = happyReduce_75

action_150 _ = happyReduce_34

action_151 (38) = happyShift action_56
action_151 (42) = happyShift action_57
action_151 (48) = happyShift action_58
action_151 (52) = happyShift action_59
action_151 (59) = happyShift action_8
action_151 (63) = happyShift action_60
action_151 (64) = happyShift action_61
action_151 (65) = happyShift action_10
action_151 (66) = happyShift action_62
action_151 (67) = happyShift action_63
action_151 (68) = happyShift action_64
action_151 (69) = happyShift action_65
action_151 (70) = happyShift action_11
action_151 (71) = happyShift action_66
action_151 (72) = happyShift action_12
action_151 (73) = happyShift action_67
action_151 (74) = happyShift action_38
action_151 (77) = happyShift action_2
action_151 (78) = happyShift action_68
action_151 (79) = happyShift action_69
action_151 (4) = happyGoto action_39
action_151 (5) = happyGoto action_40
action_151 (6) = happyGoto action_41
action_151 (15) = happyGoto action_42
action_151 (16) = happyGoto action_43
action_151 (18) = happyGoto action_152
action_151 (21) = happyGoto action_46
action_151 (23) = happyGoto action_47
action_151 (24) = happyGoto action_48
action_151 (25) = happyGoto action_49
action_151 (26) = happyGoto action_50
action_151 (27) = happyGoto action_51
action_151 (28) = happyGoto action_52
action_151 (29) = happyGoto action_53
action_151 (30) = happyGoto action_54
action_151 (31) = happyGoto action_55
action_151 _ = happyFail (happyExpListPerState 151)

action_152 _ = happyReduce_33

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
happyReduction_5 ((HappyAbsSyn16  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyAbsSyn21  happy_var_1) `HappyStk`
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
	(HappyAbsSyn21  happy_var_1)
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
happyReduction_15 ((HappyAbsSyn16  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyAbsSyn21  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn13
		 ((fst happy_var_1, Abs.MthDef (fst happy_var_1) (snd happy_var_1) (snd happy_var_2) (snd happy_var_4) (snd happy_var_6))
	) `HappyStk` happyRest

happyReduce_16 = happySpecReduce_3  13 happyReduction_16
happyReduction_16 _
	(HappyAbsSyn4  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
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

happyReduce_19 = happySpecReduce_1  15 happyReduction_19
happyReduction_19 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn15
		 ((fst happy_var_1, Abs.SIdent (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  15 happyReduction_20
happyReduction_20 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn15
		 ((fst happy_var_1, Abs.SIdentAttr (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  16 happyReduction_21
happyReduction_21 _
	(HappyAbsSyn17  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn16
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Block (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_0  17 happyReduction_22
happyReduction_22  =  HappyAbsSyn17
		 ((Abs.BNFC'NoPosition, [])
	)

happyReduce_23 = happySpecReduce_2  17 happyReduction_23
happyReduction_23 (HappyAbsSyn17  happy_var_2)
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn17
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_2))
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  18 happyReduction_24
happyReduction_24 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn18
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Empty (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  18 happyReduction_25
happyReduction_25 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn18
		 ((fst happy_var_1, Abs.BStmt (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  18 happyReduction_26
happyReduction_26 _
	(HappyAbsSyn20  happy_var_2)
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn18
		 ((fst happy_var_1, Abs.Decl (fst happy_var_1) (snd happy_var_1) (snd happy_var_2))
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happyReduce 4 18 happyReduction_27
happyReduction_27 (_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 ((fst happy_var_1, Abs.Ass (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_28 = happySpecReduce_3  18 happyReduction_28
happyReduction_28 _
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn18
		 ((fst happy_var_1, Abs.Incr (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_3  18 happyReduction_29
happyReduction_29 _
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn18
		 ((fst happy_var_1, Abs.Decr (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_29 _ _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_3  18 happyReduction_30
happyReduction_30 _
	(HappyAbsSyn23  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn18
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Ret (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_30 _ _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_2  18 happyReduction_31
happyReduction_31 _
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn18
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.VRet (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_31 _ _  = notHappyAtAll 

happyReduce_32 = happyReduce 5 18 happyReduction_32
happyReduction_32 ((HappyAbsSyn18  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Cond (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_3) (snd happy_var_5))
	) `HappyStk` happyRest

happyReduce_33 = happyReduce 7 18 happyReduction_33
happyReduction_33 ((HappyAbsSyn18  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn18  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.CondElse (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_3) (snd happy_var_5) (snd happy_var_7))
	) `HappyStk` happyRest

happyReduce_34 = happyReduce 5 18 happyReduction_34
happyReduction_34 ((HappyAbsSyn18  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn23  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn18
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.While (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_3) (snd happy_var_5))
	) `HappyStk` happyRest

happyReduce_35 = happySpecReduce_2  18 happyReduction_35
happyReduction_35 _
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn18
		 ((fst happy_var_1, Abs.SExp (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_35 _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  19 happyReduction_36
happyReduction_36 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn19
		 ((fst happy_var_1, Abs.NoInit (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  19 happyReduction_37
happyReduction_37 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn19
		 ((fst happy_var_1, Abs.Init (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  20 happyReduction_38
happyReduction_38 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn20
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  20 happyReduction_39
happyReduction_39 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn20
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_1  21 happyReduction_40
happyReduction_40 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Int (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_1  21 happyReduction_41
happyReduction_41 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Str (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  21 happyReduction_42
happyReduction_42 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Bool (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  21 happyReduction_43
happyReduction_43 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn21
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Void (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_1  21 happyReduction_44
happyReduction_44 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn21
		 ((fst happy_var_1, Abs.Class (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_0  22 happyReduction_45
happyReduction_45  =  HappyAbsSyn22
		 ((Abs.BNFC'NoPosition, [])
	)

happyReduce_46 = happySpecReduce_1  22 happyReduction_46
happyReduction_46 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  22 happyReduction_47
happyReduction_47 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn22
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  23 happyReduction_48
happyReduction_48 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn23
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.ENull (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  23 happyReduction_49
happyReduction_49 _
	(HappyAbsSyn23  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn23
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), (snd happy_var_2))
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_2  24 happyReduction_50
happyReduction_50 (HappyAbsSyn33  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn23
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.ESelfMet (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_50 _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_2  24 happyReduction_51
happyReduction_51 (HappyAbsSyn21  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn23
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.ENew (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_51 _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  24 happyReduction_52
happyReduction_52 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, Abs.EAttr (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  24 happyReduction_53
happyReduction_53 (HappyAbsSyn33  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, Abs.EMet (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_1  24 happyReduction_54
happyReduction_54 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_54 _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_1  25 happyReduction_55
happyReduction_55 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, Abs.EVar (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_55 _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_1  25 happyReduction_56
happyReduction_56 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, Abs.ELitInt (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_1  25 happyReduction_57
happyReduction_57 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn23
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.ELitTrue (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_57 _  = notHappyAtAll 

happyReduce_58 = happySpecReduce_1  25 happyReduction_58
happyReduction_58 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn23
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.ELitFalse (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_58 _  = notHappyAtAll 

happyReduce_59 = happyReduce 4 25 happyReduction_59
happyReduction_59 (_ `HappyStk`
	(HappyAbsSyn34  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn4  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 ((fst happy_var_1, Abs.EApp (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_60 = happySpecReduce_1  25 happyReduction_60
happyReduction_60 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, Abs.EString (fst happy_var_1) (snd happy_var_1))
	)
happyReduction_60 _  = notHappyAtAll 

happyReduce_61 = happySpecReduce_1  25 happyReduction_61
happyReduction_61 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_61 _  = notHappyAtAll 

happyReduce_62 = happySpecReduce_2  26 happyReduction_62
happyReduction_62 (HappyAbsSyn23  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn23
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Neg (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_62 _ _  = notHappyAtAll 

happyReduce_63 = happySpecReduce_2  26 happyReduction_63
happyReduction_63 (HappyAbsSyn23  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn23
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Not (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)) (snd happy_var_2))
	)
happyReduction_63 _ _  = notHappyAtAll 

happyReduce_64 = happySpecReduce_1  26 happyReduction_64
happyReduction_64 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_64 _  = notHappyAtAll 

happyReduce_65 = happySpecReduce_3  27 happyReduction_65
happyReduction_65 (HappyAbsSyn23  happy_var_3)
	(HappyAbsSyn36  happy_var_2)
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, Abs.EMul (fst happy_var_1) (snd happy_var_1) (snd happy_var_2) (snd happy_var_3))
	)
happyReduction_65 _ _ _  = notHappyAtAll 

happyReduce_66 = happySpecReduce_1  27 happyReduction_66
happyReduction_66 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_66 _  = notHappyAtAll 

happyReduce_67 = happySpecReduce_3  28 happyReduction_67
happyReduction_67 (HappyAbsSyn23  happy_var_3)
	(HappyAbsSyn35  happy_var_2)
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, Abs.EAdd (fst happy_var_1) (snd happy_var_1) (snd happy_var_2) (snd happy_var_3))
	)
happyReduction_67 _ _ _  = notHappyAtAll 

happyReduce_68 = happySpecReduce_1  28 happyReduction_68
happyReduction_68 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_68 _  = notHappyAtAll 

happyReduce_69 = happySpecReduce_3  29 happyReduction_69
happyReduction_69 (HappyAbsSyn23  happy_var_3)
	(HappyAbsSyn37  happy_var_2)
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, Abs.ERel (fst happy_var_1) (snd happy_var_1) (snd happy_var_2) (snd happy_var_3))
	)
happyReduction_69 _ _ _  = notHappyAtAll 

happyReduce_70 = happySpecReduce_1  29 happyReduction_70
happyReduction_70 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_70 _  = notHappyAtAll 

happyReduce_71 = happySpecReduce_3  30 happyReduction_71
happyReduction_71 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, Abs.EAnd (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_71 _ _ _  = notHappyAtAll 

happyReduce_72 = happySpecReduce_1  30 happyReduction_72
happyReduction_72 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_72 _  = notHappyAtAll 

happyReduce_73 = happySpecReduce_3  31 happyReduction_73
happyReduction_73 (HappyAbsSyn23  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, Abs.EOr (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_73 _ _ _  = notHappyAtAll 

happyReduce_74 = happySpecReduce_1  31 happyReduction_74
happyReduction_74 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn23
		 ((fst happy_var_1, (snd happy_var_1))
	)
happyReduction_74 _  = notHappyAtAll 

happyReduce_75 = happyReduce 4 32 happyReduction_75
happyReduction_75 (_ `HappyStk`
	(HappyAbsSyn34  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn15  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn32
		 ((fst happy_var_1, Abs.EChain (fst happy_var_1) (snd happy_var_1) (snd happy_var_3))
	) `HappyStk` happyRest

happyReduce_76 = happySpecReduce_0  33 happyReduction_76
happyReduction_76  =  HappyAbsSyn33
		 ((Abs.BNFC'NoPosition, [])
	)

happyReduce_77 = happySpecReduce_1  33 happyReduction_77
happyReduction_77 (HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn33
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_77 _  = notHappyAtAll 

happyReduce_78 = happySpecReduce_3  33 happyReduction_78
happyReduction_78 (HappyAbsSyn33  happy_var_3)
	_
	(HappyAbsSyn32  happy_var_1)
	 =  HappyAbsSyn33
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_78 _ _ _  = notHappyAtAll 

happyReduce_79 = happySpecReduce_0  34 happyReduction_79
happyReduction_79  =  HappyAbsSyn34
		 ((Abs.BNFC'NoPosition, [])
	)

happyReduce_80 = happySpecReduce_1  34 happyReduction_80
happyReduction_80 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn34
		 ((fst happy_var_1, (:[]) (snd happy_var_1))
	)
happyReduction_80 _  = notHappyAtAll 

happyReduce_81 = happySpecReduce_3  34 happyReduction_81
happyReduction_81 (HappyAbsSyn34  happy_var_3)
	_
	(HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn34
		 ((fst happy_var_1, (:) (snd happy_var_1) (snd happy_var_3))
	)
happyReduction_81 _ _ _  = notHappyAtAll 

happyReduce_82 = happySpecReduce_1  35 happyReduction_82
happyReduction_82 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn35
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Plus (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_82 _  = notHappyAtAll 

happyReduce_83 = happySpecReduce_1  35 happyReduction_83
happyReduction_83 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn35
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Minus (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_83 _  = notHappyAtAll 

happyReduce_84 = happySpecReduce_1  36 happyReduction_84
happyReduction_84 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn36
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Times (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_84 _  = notHappyAtAll 

happyReduce_85 = happySpecReduce_1  36 happyReduction_85
happyReduction_85 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn36
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Div (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_85 _  = notHappyAtAll 

happyReduce_86 = happySpecReduce_1  36 happyReduction_86
happyReduction_86 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn36
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.Mod (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_86 _  = notHappyAtAll 

happyReduce_87 = happySpecReduce_1  37 happyReduction_87
happyReduction_87 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn37
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.LTH (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_87 _  = notHappyAtAll 

happyReduce_88 = happySpecReduce_1  37 happyReduction_88
happyReduction_88 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn37
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.LE (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_88 _  = notHappyAtAll 

happyReduce_89 = happySpecReduce_1  37 happyReduction_89
happyReduction_89 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn37
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.GTH (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_89 _  = notHappyAtAll 

happyReduce_90 = happySpecReduce_1  37 happyReduction_90
happyReduction_90 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn37
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.GE (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_90 _  = notHappyAtAll 

happyReduce_91 = happySpecReduce_1  37 happyReduction_91
happyReduction_91 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn37
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.EQU (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_91 _  = notHappyAtAll 

happyReduce_92 = happySpecReduce_1  37 happyReduction_92
happyReduction_92 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn37
		 ((uncurry Abs.BNFC'Position (tokenLineCol happy_var_1), Abs.NE (uncurry Abs.BNFC'Position (tokenLineCol happy_var_1)))
	)
happyReduction_92 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 80 80 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	PT _ (TS _ 1) -> cont 38;
	PT _ (TS _ 2) -> cont 39;
	PT _ (TS _ 3) -> cont 40;
	PT _ (TS _ 4) -> cont 41;
	PT _ (TS _ 5) -> cont 42;
	PT _ (TS _ 6) -> cont 43;
	PT _ (TS _ 7) -> cont 44;
	PT _ (TS _ 8) -> cont 45;
	PT _ (TS _ 9) -> cont 46;
	PT _ (TS _ 10) -> cont 47;
	PT _ (TS _ 11) -> cont 48;
	PT _ (TS _ 12) -> cont 49;
	PT _ (TS _ 13) -> cont 50;
	PT _ (TS _ 14) -> cont 51;
	PT _ (TS _ 15) -> cont 52;
	PT _ (TS _ 16) -> cont 53;
	PT _ (TS _ 17) -> cont 54;
	PT _ (TS _ 18) -> cont 55;
	PT _ (TS _ 19) -> cont 56;
	PT _ (TS _ 20) -> cont 57;
	PT _ (TS _ 21) -> cont 58;
	PT _ (TS _ 22) -> cont 59;
	PT _ (TS _ 23) -> cont 60;
	PT _ (TS _ 24) -> cont 61;
	PT _ (TS _ 25) -> cont 62;
	PT _ (TS _ 26) -> cont 63;
	PT _ (TS _ 27) -> cont 64;
	PT _ (TS _ 28) -> cont 65;
	PT _ (TS _ 29) -> cont 66;
	PT _ (TS _ 30) -> cont 67;
	PT _ (TS _ 31) -> cont 68;
	PT _ (TS _ 32) -> cont 69;
	PT _ (TS _ 33) -> cont 70;
	PT _ (TS _ 34) -> cont 71;
	PT _ (TS _ 35) -> cont 72;
	PT _ (TS _ 36) -> cont 73;
	PT _ (TS _ 37) -> cont 74;
	PT _ (TS _ 38) -> cont 75;
	PT _ (TS _ 39) -> cont 76;
	PT _ (TV _) -> cont 77;
	PT _ (TI _) -> cont 78;
	PT _ (TL _) -> cont 79;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 80 tk tks = happyError' (tks, explist)
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
