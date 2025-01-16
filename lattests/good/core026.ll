@intFormat = internal constant [6 x i8] c"%lld\0A\00"
@errorFormat = private unnamed_addr constant [14 x i8] c"runtime error\00", align 1
@strFormat = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@endl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i64 @printf(i8*, ...)
declare i64 @scanf(i8*, ...)
declare i8* @malloc(i64)
declare i8* @realloc(i8*, i64)
declare i8* @calloc(i64, i64)
declare void @memcpy(i8*, i8*, i64)
declare i8 @getchar()

declare void @exit()

define void @printInt(i64 %x) {
    call i64 (i8*, ...) @printf(i8* getelementptr([6 x i8], [6 x i8]* @intFormat, i64 0, i64 0), i64 %x)
    ret void
}
define void @printString(i8* %x) {
    %str = call i8* @concat_strings(i8* %x, i8* getelementptr([2 x i8], [2 x i8]* @endl, i64 0, i64 0))
    call i64 (i8*, ...) @printf(i8* %str)
    ret void
}

define i64 @readInt() {
  %res = alloca i64
  %scan_res = call i64 (i8*, ...) @scanf(i8* getelementptr([6 x i8], [6 x i8]* @intFormat, i64 0, i64 0), i64* %res)
  %res2 = load i64, i64* %res
  ret i64 %res2
}

define i8* @readString() {
  %res= call i8* @calloc(i64 256, i64 1)
  %scan_res = call i64 (i8*, ...) @scanf(i8* getelementptr([3 x i8], [3 x i8]* @strFormat, i64 0, i64 0), i8* %res)
  ret i8* %res
}

define void @error() {
    %msg = getelementptr inbounds [14 x i8], [14 x i8]* @errorFormat, i64 0, i64 0
    call void @printString(i8* %msg)
    call void @exit()
    ret void
}

define i8* @concat_strings(i8* %str1, i8* %str2) {
  %len1 = call i64 @strlen(i8* %str1)
  %len2 = call i64 @strlen(i8* %str2)
  %len = add i64 %len1, %len2
  %lenfull = add i64 %len, 1
  %str = call i8* @calloc(i64 %lenfull, i64 1)
  call void @memcpy(i8* %str, i8* %str1, i64 %len1)
  %strptr2 = getelementptr i8, i8* %str, i64 %len1
  call void @memcpy(i8* %strptr2, i8* %str2, i64 %len2)
  %strptr3 = getelementptr i8, i8* %str, i64 %len
  store i8 0, i8* %strptr3
  ret i8* %str
  
}

define i64 @strlen(i8* %str) {
  %counter = alloca i64, align 8
  store i64 0, i64* %counter

  br label %1

; <label>:1
  %index = load i64, i64* %counter
  %char_ptr = getelementptr i8, i8* %str, i64 %index
  %char = load i8, i8* %char_ptr
  %is_null = icmp eq i8 %char, 0

  br i1 %is_null, label %3, label %2

; <label>2:
  %index2 = add i64 %index, 1
  store i64 %index2, i64* %counter
  br label %1
; <label>:3
  %final_index = load i64, i64* %counter
  ret i64 %final_index
}
define i64 @d() {
	ret i64 0
}

	

define i64 @s(i64 %x) {
	%var1 = alloca i64
	store i64 %x, i64* %var1
	%var3 = load i64, i64* %var1
	%var2 = add i64 %var3, 1
	ret i64 %var2
}

	

define i64 @main() {
%var1 = call i64 @d()
%var2 = call i64 @s(i64 %var1)
%var3 = call i64 @s(i64 %var2)
%var4 = call i64 @s(i64 %var3)
%var5 = call i64 @s(i64 %var4)
%var6 = call i64 @s(i64 %var5)
%var7 = call i64 @s(i64 %var6)
%var8 = call i64 @s(i64 %var7)
%var9 = call i64 @s(i64 %var8)
%var10 = call i64 @s(i64 %var9)
%var11 = call i64 @s(i64 %var10)
%var12 = call i64 @s(i64 %var11)
%var13 = call i64 @s(i64 %var12)
%var14 = call i64 @s(i64 %var13)
%var15 = call i64 @s(i64 %var14)
%var16 = call i64 @s(i64 %var15)
%var17 = call i64 @s(i64 %var16)
%var18 = call i64 @s(i64 %var17)
%var19 = call i64 @s(i64 %var18)
%var20 = call i64 @s(i64 %var19)
%var21 = call i64 @s(i64 %var20)
%var22 = call i64 @s(i64 %var21)
%var23 = call i64 @s(i64 %var22)
%var24 = call i64 @s(i64 %var23)
%var25 = call i64 @s(i64 %var24)
%var26 = call i64 @s(i64 %var25)
%var27 = call i64 @s(i64 %var26)
%var28 = call i64 @s(i64 %var27)
%var29 = call i64 @s(i64 %var28)
%var30 = call i64 @s(i64 %var29)
%var31 = call i64 @s(i64 %var30)
%var32 = call i64 @s(i64 %var31)
%var33 = call i64 @s(i64 %var32)
%var34 = call i64 @s(i64 %var33)
%var35 = call i64 @s(i64 %var34)
%var36 = call i64 @s(i64 %var35)
%var37 = call i64 @s(i64 %var36)
%var38 = call i64 @s(i64 %var37)
%var39 = call i64 @s(i64 %var38)
%var40 = call i64 @s(i64 %var39)
%var41 = call i64 @s(i64 %var40)
%var42 = call i64 @s(i64 %var41)
%var43 = call i64 @s(i64 %var42)
%var44 = call i64 @s(i64 %var43)
%var45 = call i64 @s(i64 %var44)
%var46 = call i64 @s(i64 %var45)
%var47 = call i64 @s(i64 %var46)
%var48 = call i64 @s(i64 %var47)
%var49 = call i64 @s(i64 %var48)
%var50 = call i64 @s(i64 %var49)
%var51 = call i64 @s(i64 %var50)
%var52 = call i64 @s(i64 %var51)
%var53 = call i64 @s(i64 %var52)
%var54 = call i64 @s(i64 %var53)
%var55 = call i64 @s(i64 %var54)
%var56 = call i64 @s(i64 %var55)
%var57 = call i64 @s(i64 %var56)
%var58 = call i64 @s(i64 %var57)
%var59 = call i64 @s(i64 %var58)
%var60 = call i64 @s(i64 %var59)
%var61 = call i64 @s(i64 %var60)
%var62 = call i64 @s(i64 %var61)
%var63 = call i64 @s(i64 %var62)
%var64 = call i64 @s(i64 %var63)
%var65 = call i64 @s(i64 %var64)
%var66 = call i64 @s(i64 %var65)
%var67 = call i64 @s(i64 %var66)
%var68 = call i64 @s(i64 %var67)
%var69 = call i64 @s(i64 %var68)
%var70 = call i64 @s(i64 %var69)
%var71 = call i64 @s(i64 %var70)
%var72 = call i64 @s(i64 %var71)
%var73 = call i64 @s(i64 %var72)
%var74 = call i64 @s(i64 %var73)
%var75 = call i64 @s(i64 %var74)
%var76 = call i64 @s(i64 %var75)
%var77 = call i64 @s(i64 %var76)
%var78 = call i64 @s(i64 %var77)
%var79 = call i64 @s(i64 %var78)
%var80 = call i64 @s(i64 %var79)
%var81 = call i64 @s(i64 %var80)
	call void @printInt(i64 %var81)
	ret i64 0
}

	

