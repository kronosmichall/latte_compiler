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
@.str2 = private constant [2 x i8] c"=\00"
@.str3 = private constant [9 x i8] c"hello */\00"
@.str4 = private constant [9 x i8] c"/* world\00"
@.str1 = private constant [1 x i8] c"\00"
define i64 @fac(i64 %a) {
	%var1 = alloca i64
	store i64 %a, i64* %var1
	%var2 = alloca i64
	%var3 = alloca i64
	store i64 1, i64* %var2
	%var4 = load i64, i64* %var1
	store i64 %var4, i64* %var3
	br label %1
; <label>:1
	%var6 = load i64, i64* %var3
	%var5 = icmp sgt i64 %var6, 0
	br i1 %var5, label %2, label %3
; <label>:2
	%var8 = load i64, i64* %var2
	%var9 = load i64, i64* %var3
	%var7 = mul i64 %var8, %var9
	store i64 %var7, i64* %var2
	%var11 = load i64, i64* %var3
	%var10 = sub i64 %var11, 1
	store i64 %var10, i64* %var3
	br label %1
; <label>:3
	%var12 = load i64, i64* %var2
	ret i64 %var12
}

	

define i64 @rfac(i64 %n) {
	%var1 = alloca i64
	store i64 %n, i64* %var1
	%var3 = load i64, i64* %var1
	%var2 = icmp eq i64 %var3, 0
	br i1 %var2, label %1, label %2
; <label>:1
	ret i64 1
; <label>:2
	%var5 = load i64, i64* %var1
	%var4 = sub i64 %var5, 1
%var6 = call i64 @rfac(i64 %var4)
	%var8 = load i64, i64* %var1
	%var7 = mul i64 %var8, %var6
	ret i64 %var7
}

	

define i64 @mfac(i64 %n) {
	%var1 = alloca i64
	store i64 %n, i64* %var1
	%var3 = load i64, i64* %var1
	%var2 = icmp eq i64 %var3, 0
	br i1 %var2, label %1, label %2
; <label>:1
	ret i64 1
; <label>:2
	%var5 = load i64, i64* %var1
	%var4 = sub i64 %var5, 1
%var6 = call i64 @nfac(i64 %var4)
	%var8 = load i64, i64* %var1
	%var7 = mul i64 %var8, %var6
	ret i64 %var7
}

	

define i64 @nfac(i64 %n) {
	%var1 = alloca i64
	store i64 %n, i64* %var1
	%var3 = load i64, i64* %var1
	%var2 = icmp ne i64 %var3, 0
	br i1 %var2, label %1, label %2
; <label>:1
	%var5 = load i64, i64* %var1
	%var4 = sub i64 %var5, 1
%var6 = call i64 @mfac(i64 %var4)
	%var8 = load i64, i64* %var1
	%var7 = mul i64 %var6, %var8
	ret i64 %var7
; <label>:2
	ret i64 1
}

	

define i64 @ifac(i64 %n) {
	%var1 = alloca i64
	store i64 %n, i64* %var1
	%var2 = load i64, i64* %var1
%var3 = call i64 @ifac2f(i64 1, i64 %var2)
	ret i64 %var3
}

	

define i64 @ifac2f(i64 %l, i64 %h) {
	%var1 = alloca i64
	store i64 %l, i64* %var1
	%var2 = alloca i64
	store i64 %h, i64* %var2
	%var4 = load i64, i64* %var1
	%var5 = load i64, i64* %var2
	%var3 = icmp eq i64 %var4, %var5
	br i1 %var3, label %1, label %2
; <label>:1
	%var6 = load i64, i64* %var1
	ret i64 %var6
; <label>:2
	%var8 = load i64, i64* %var1
	%var9 = load i64, i64* %var2
	%var7 = icmp sgt i64 %var8, %var9
	br i1 %var7, label %3, label %4
; <label>:3
	ret i64 1
; <label>:4
	%var10 = alloca i64
	%var12 = load i64, i64* %var1
	%var13 = load i64, i64* %var2
	%var11 = add i64 %var12, %var13
	%var14 = sdiv i64 %var11, 2
	store i64 %var14, i64* %var10
	%var15 = load i64, i64* %var1
	%var16 = load i64, i64* %var10
%var17 = call i64 @ifac2f(i64 %var15, i64 %var16)
	%var19 = load i64, i64* %var10
	%var18 = add i64 %var19, 1
	%var20 = load i64, i64* %var2
%var21 = call i64 @ifac2f(i64 %var18, i64 %var20)
	%var22 = mul i64 %var17, %var21
	ret i64 %var22
}

	

define i8* @repStr(i8* %s, i64 %n) {
	%var1 = alloca i8*
	store i8* %s, i8** %var1
	%var2 = alloca i64
	store i64 %n, i64* %var2
	%var3 = call i8* @calloc(i64 1, i64 1)
	call void @memcpy(i8* %var3, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str1, i64 0, i64 0), i64 1)
	%var4 = alloca i8*
	store i8* %var3, i8** %var4
	%var5 = alloca i64
	store i64 0, i64* %var5
	br label %1
; <label>:1
	%var7 = load i64, i64* %var5
	%var8 = load i64, i64* %var2
	%var6 = icmp slt i64 %var7, %var8
	br i1 %var6, label %2, label %3
; <label>:2
	%var9 = load i8*, i8** %var4
	%var10 = load i8*, i8** %var1
	%var11 = call i8* @concat_strings(i8* %var9, i8* %var10)
	store i8* %var11, i8** %var4
	%var13 = load i64, i64* %var5
	%var12 = add i64 %var13, 1
	store i64 %var12, i64* %var5
	br label %1
; <label>:3
	%var14 = load i8*, i8** %var4
	ret i8* %var14
}

	

define i64 @main() {
%var1 = call i64 @fac(i64 10)
	call void @printInt(i64 %var1)
%var2 = call i64 @rfac(i64 10)
	call void @printInt(i64 %var2)
%var3 = call i64 @mfac(i64 10)
	call void @printInt(i64 %var3)
%var4 = call i64 @ifac(i64 10)
	call void @printInt(i64 %var4)
	%var5 = alloca i8*
	%var6 = alloca i64
	store i64 10, i64* %var6
	%var7 = alloca i64
	store i64 1, i64* %var7
	br label %1
; <label>:1
	%var9 = load i64, i64* %var6
	%var8 = icmp sgt i64 %var9, 0
	br i1 %var8, label %2, label %3
; <label>:2
	%var11 = load i64, i64* %var7
	%var12 = load i64, i64* %var6
	%var10 = mul i64 %var11, %var12
	store i64 %var10, i64* %var7
	%var14 = load i64, i64* %var6
	%var13 = sub i64 %var14, 1
	store i64 %var13, i64* %var6
	br label %1
; <label>:3
	%var15 = load i64, i64* %var7
	call void @printInt(i64 %var15)
	%var16 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str2, i64 0, i64 0), i64 2)
%var17 = call i8* @repStr(i8* %var16, i64 60)
	call void @printString(i8* %var17)
	%var18 = call i8* @calloc(i64 9, i64 1)
	call void @memcpy(i8* %var18, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str3, i64 0, i64 0), i64 9)
	call void @printString(i8* %var18)
	%var19 = call i8* @calloc(i64 9, i64 1)
	call void @memcpy(i8* %var19, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str4, i64 0, i64 0), i64 9)
	call void @printString(i8* %var19)
	ret i64 0
}

	

