@intFormat = internal constant [6 x i8] c"%lld\0A\00"
@strFormat = private unnamed_addr constant [14 x i8] c"runtime error\00", align 1
@endl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i64 @printf(i8*, ...)
declare i64 @scanf(i8*, ...)
declare i8* @malloc(i64)
declare i8* @realloc(i8*, i64)
declare i8* @calloc(i64, i64)
declare void @memcpy(i8*, i8*, i64)

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

define void @error() {
    %msg = getelementptr inbounds [14 x i8], [14 x i8]* @strFormat, i64 0, i64 0
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
@.str3 = private constant [3 x i8] c"&&\00"
@.str4 = private constant [3 x i8] c"||\00"
@.str5 = private constant [2 x i8] c"!\00"
@.str1 = private constant [6 x i8] c"false\00"
@.str2 = private constant [5 x i8] c"true\00"
define void @printBool(i1 %b) {
	%var1 = alloca i1
	store i1 %b, i1* %var1
	%var3 = load i1, i1* %var1
	%var2 = xor i1 %var3, 1
	br i1 %var2, label %1, label %2
; <label>:1
	%var4 = call i8* @calloc(i64 6, i64 1)
	call void @memcpy(i8* %var4, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str1, i64 0, i64 0), i64 6)
	call void @printString(i8* %var4)
	br label %3
; <label>:2
	%var5 = call i8* @calloc(i64 5, i64 1)
	call void @memcpy(i8* %var5, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str2, i64 0, i64 0), i64 5)
	call void @printString(i8* %var5)
	br label %3
; <label>:3
	ret void
}

	

define i1 @test(i64 %i) {
	%var1 = alloca i64
	store i64 %i, i64* %var1
	%var2 = load i64, i64* %var1
	call void @printInt(i64 %var2)
	%var4 = load i64, i64* %var1
	%var3 = icmp sgt i64 %var4, 0
	ret i1 %var3
}

	

define i64 @main() {
	%var1 = call i8* @calloc(i64 3, i64 1)
	call void @memcpy(i8* %var1, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str3, i64 0, i64 0), i64 3)
	call void @printString(i8* %var1)
	%var2 = mul i64 1, -1
%var3 = call i1 @test(i64 %var2)
	br i1 %var3, label %2, label %1
; <label>:1
	br label %3
; <label>:2
%var5 = call i1 @test(i64 0)
	br label %3
; <label>:3
	%var4 = phi i1 [ %var5, %2], [0, %1]
	call void @printBool(i1 %var4)
	%var6 = mul i64 2, -1
%var7 = call i1 @test(i64 %var6)
	br i1 %var7, label %5, label %4
; <label>:4
	br label %6
; <label>:5
%var9 = call i1 @test(i64 1)
	br label %6
; <label>:6
	%var8 = phi i1 [ %var9, %5], [0, %4]
	call void @printBool(i1 %var8)
%var10 = call i1 @test(i64 3)
	br i1 %var10, label %8, label %7
; <label>:7
	br label %9
; <label>:8
	%var12 = mul i64 5, -1
%var13 = call i1 @test(i64 %var12)
	br label %9
; <label>:9
	%var11 = phi i1 [ %var13, %8], [0, %7]
	call void @printBool(i1 %var11)
%var14 = call i1 @test(i64 234234)
	br i1 %var14, label %11, label %10
; <label>:10
	br label %12
; <label>:11
%var16 = call i1 @test(i64 21321)
	br label %12
; <label>:12
	%var15 = phi i1 [ %var16, %11], [0, %10]
	call void @printBool(i1 %var15)
	%var17 = call i8* @calloc(i64 3, i64 1)
	call void @memcpy(i8* %var17, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str4, i64 0, i64 0), i64 3)
	call void @printString(i8* %var17)
	%var18 = mul i64 1, -1
%var19 = call i1 @test(i64 %var18)
	br i1 %var19, label %13, label %14
; <label>:13
	br label %15
; <label>:14
%var21 = call i1 @test(i64 0)
	br label %15
; <label>:15
	%var20 = phi i1 [ %var21, %14], [1, %13]
	call void @printBool(i1 %var20)
	%var22 = mul i64 2, -1
%var23 = call i1 @test(i64 %var22)
	br i1 %var23, label %16, label %17
; <label>:16
	br label %18
; <label>:17
%var25 = call i1 @test(i64 1)
	br label %18
; <label>:18
	%var24 = phi i1 [ %var25, %17], [1, %16]
	call void @printBool(i1 %var24)
%var26 = call i1 @test(i64 3)
	br i1 %var26, label %19, label %20
; <label>:19
	br label %21
; <label>:20
	%var28 = mul i64 5, -1
%var29 = call i1 @test(i64 %var28)
	br label %21
; <label>:21
	%var27 = phi i1 [ %var29, %20], [1, %19]
	call void @printBool(i1 %var27)
%var30 = call i1 @test(i64 234234)
	br i1 %var30, label %22, label %23
; <label>:22
	br label %24
; <label>:23
%var32 = call i1 @test(i64 21321)
	br label %24
; <label>:24
	%var31 = phi i1 [ %var32, %23], [1, %22]
	call void @printBool(i1 %var31)
	%var33 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var33, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str5, i64 0, i64 0), i64 2)
	call void @printString(i8* %var33)
	call void @printBool(i1 1)
	call void @printBool(i1 0)
	ret i64 0
}

	

