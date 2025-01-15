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
@.str1 = private constant [5 x i8] c"true\00"
@.str2 = private constant [6 x i8] c"false\00"
@.str3 = private constant [4 x i8] c"apa\00"
define i1 @dontCallMe(i64 %x) {
	%var1 = alloca i64
	store i64 %x, i64* %var1
	%var2 = load i64, i64* %var1
	call void @printInt(i64 %var2)
	ret i1 1
}

	

define void @printBool(i1 %b) {
	%var1 = alloca i1
	store i1 %b, i1* %var1
	br i1 %var1, label %1, label %2
; <label>:1
	%var2 = call i8* @calloc(i64 5, i64 1)
	call void @memcpy(i8* %var2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str1, i64 0, i64 0), i64 5)
	call void @printString(i8* %var2)
	br label %3
; <label>:2
	%var3 = call i8* @calloc(i64 6, i64 1)
	call void @memcpy(i8* %var3, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str2, i64 0, i64 0), i64 6)
	call void @printString(i8* %var3)
	br label %3
; <label>:3
	ret void
}

	

define i1 @implies(i1 %x, i1 %y) {
	%var1 = alloca i1
	store i1 %x, i1* %var1
	%var2 = alloca i1
	store i1 %y, i1* %var2
	%var4 = load i1, i1* %var1
	%var3 = xor i1 %var4, 1
	%var6 = load i1, i1* %var1
	%var7 = load i1, i1* %var2
	%var5 = icmp eq i1 %var6, %var7
	%var8 = or i1 %var3, %var5
	ret i1 %var8
}

	

define i64 @main() {
	%var1 = alloca i64
	store i64 4, i64* %var1
	%var3 = load i64, i64* %var1
	%var2 = icmp sle i64 3, %var3
	%var4 = icmp ne i64 4, 2
	%var5 = and i1 %var4, 1
	%var6 = and i1 %var2, %var5
	br i1 %var6, label %1, label %2
; <label>:1
	call void @printBool(i1 1)
	br label %3
; <label>:2
	%var7 = call i8* @calloc(i64 4, i64 1)
	call void @memcpy(i8* %var7, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str3, i64 0, i64 0), i64 4)
	call void @printString(i8* %var7)
	br label %3
; <label>:3
	%var8 = icmp eq i1 1, 1
%var9 = call i1 @dontCallMe(i64 1)
	%var10 = or i1 %var8, %var9
	call void @printBool(i1 %var10)
	%var11 = mul i64 5, -1
	%var12 = icmp slt i64 4, %var11
%var13 = call i1 @dontCallMe(i64 2)
	%var14 = and i1 %var12, %var13
	call void @printBool(i1 %var14)
	%var16 = load i64, i64* %var1
	%var15 = icmp eq i64 4, %var16
	%var17 = xor i1 0, 1
	%var18 = icmp eq i1 1, %var17
	%var19 = and i1 %var18, 1
	%var20 = and i1 %var15, %var19
	call void @printBool(i1 %var20)
%var21 = call i1 @implies(i1 0, i1 0)
	call void @printBool(i1 %var21)
%var22 = call i1 @implies(i1 0, i1 1)
	call void @printBool(i1 %var22)
%var23 = call i1 @implies(i1 1, i1 0)
	call void @printBool(i1 %var23)
%var24 = call i1 @implies(i1 1, i1 1)
	call void @printBool(i1 %var24)
	ret i64 0
}

	

