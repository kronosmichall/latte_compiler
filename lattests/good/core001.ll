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
@.str2 = private constant [2 x i8] c"=\00"
@.str3 = private constant [9 x i8] c"hello */\00"
@.str4 = private constant [9 x i8] c"/* world\00"
@.str1 = private constant [1 x i8] c"\00"
	define i64 @fac(i64 %fac) {
	%var0 = alloca i64
	store i64 %a, i64* %var0
	%var1 = alloca i64
	%var2 = alloca i64
	store i64 1, i64* %var1
	%var3 = load i64, i64* %var0
	store i64 %var3, i64* %var2
	br label %Just (28,9)while
	; <label>:Just (28,9)while
	%var5 = load i64, i64* %var2
	%var4 = icmp sgt i64 %var5, 0
	br i1 %var4, label %4true, label %4false
	; <label>:4true
	%var7 = load i64, i64* %var1
	%var8 = load i64, i64* %var2
	%var6 = mul i64 %var7, %var8
	store i64 %var6, i64* %var1
	%var10 = load i64, i64* %var2
	%var9 = sub i64 %var10, 1
	store i64 %var9, i64* %var2
	br label %Just (28,9)while
	; <label>:4false
	%var11 = load i64, i64* %var1
	ret i64 %var11
	}
	

	define i64 @rfac(i64 %rfac) {
	%var0 = alloca i64
	store i64 %n, i64* %var0
	%var2 = load i64, i64* %var0
	%var1 = icmp eq i64 %var2, 0
	br i1 %var1, label %1true, label %1false
	; <label>:1true
	ret i64 1
	; <label>:1false
	%var4 = load i64, i64* %var0
	%var3 = sub i64 %var4, 1
	%var5 = call i64 @rfac(i64 %var3)
	%var7 = load i64, i64* %var0
	%var6 = mul i64 %var7, %var5
	ret i64 %var6
	}
	

	define i64 @mfac(i64 %mfac) {
	%var0 = alloca i64
	store i64 %n, i64* %var0
	%var2 = load i64, i64* %var0
	%var1 = icmp eq i64 %var2, 0
	br i1 %var1, label %1true, label %1false
	; <label>:1true
	ret i64 1
	; <label>:1false
	%var4 = load i64, i64* %var0
	%var3 = sub i64 %var4, 1
	%var5 = call i64 @nfac(i64 %var3)
	%var7 = load i64, i64* %var0
	%var6 = mul i64 %var7, %var5
	ret i64 %var6
	}
	

	define i64 @nfac(i64 %nfac) {
	%var0 = alloca i64
	store i64 %n, i64* %var0
	%var2 = load i64, i64* %var0
	%var1 = icmp ne i64 %var2, 0
	br i1 %var1, label %1true, label %1false
	; <label>:1true
	%var4 = load i64, i64* %var0
	%var3 = sub i64 %var4, 1
	%var5 = call i64 @mfac(i64 %var3)
	%var7 = load i64, i64* %var0
	%var6 = mul i64 %var5, %var7
	ret i64 %var6
	; <label>:1false
	ret i64 1
	}
	

	define i64 @ifac(i64 %ifac) {
	%var0 = alloca i64
	store i64 %n, i64* %var0
	%var1 = load i64, i64* %var0
	%var2 = call i64 @ifac2f(i64 1, i64 %var1)
	ret i64 %var2
	}
	

	define i64 @ifac2f(i64 %ifac2f, i64 %ifac2f) {
	%var0 = alloca i64
	store i64 %l, i64* %var0
	%var1 = alloca i64
	store i64 %h, i64* %var1
	%var3 = load i64, i64* %var0
	%var4 = load i64, i64* %var1
	%var2 = icmp eq i64 %var3, %var4
	br i1 %var2, label %2true, label %2false
	; <label>:2true
	%var5 = load i64, i64* %var0
	ret i64 %var5
	; <label>:2false
	%var7 = load i64, i64* %var0
	%var8 = load i64, i64* %var1
	%var6 = icmp sgt i64 %var7, %var8
	br i1 %var6, label %6true, label %6false
	; <label>:6true
	ret i64 1
	; <label>:6false
	%var9 = alloca i64
	%var11 = load i64, i64* %var0
	%var12 = load i64, i64* %var1
	%var10 = add i64 %var11, %var12
	%var13 = sdiv i64 %var10, 2
	store i64 %var13, i64* %var9
	%var14 = load i64, i64* %var0
	%var15 = load i64, i64* %var9
	%var16 = call i64 @ifac2f(i64 %var14, i64 %var15)
	%var18 = load i64, i64* %var9
	%var17 = add i64 %var18, 1
	%var19 = load i64, i64* %var1
	%var20 = call i64 @ifac2f(i64 %var17, i64 %var19)
	%var21 = mul i64 %var16, %var20
	ret i64 %var21
	}
	

	define i8* @repStr(i8* %repStr, i8* %repStr) {
	%var0 = alloca i8*
	store i8* %s, i8** %var0
	%var1 = alloca i64
	store i64 %n, i64* %var1
	%var2 = call i8* @calloc(i64 1, i64 1)
	call void @memcpy(i8* %var2, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str1, i64 0, i64 0), i64 1)
	%var3 = alloca i8*
	store i8* %var2, i8** %var3
	%var4 = alloca i64
	store i64 0, i64* %var4
	br label %Just (71,3)while
	; <label>:Just (71,3)while
	%var6 = load i64, i64* %var4
	%var7 = load i64, i64* %var1
	%var5 = icmp slt i64 %var6, %var7
	br i1 %var5, label %5true, label %5false
	; <label>:5true
	%var8 = load i8*, i8** %var3
	%var9 = load i8*, i8** %var0
	%var10 = call i8* @concat_strings(i8* %var8, i8* %var9)
	store i8* %var10, i8** %var3
	%var12 = load i64, i64* %var4
	%var11 = add i64 %var12, 1
	store i64 %var11, i64* %var4
	br label %Just (71,3)while
	; <label>:5false
	%var13 = load i8*, i8** %var3
	ret i8* %var13
	}
	

	define i64 @main() {
	%var0 = call i64 @fac(i64 10)
	call void @printInt(i64 %var0)
	%var1 = call i64 @rfac(i64 10)
	call void @printInt(i64 %var1)
	%var2 = call i64 @mfac(i64 10)
	call void @printInt(i64 %var2)
	%var3 = call i64 @ifac(i64 10)
	call void @printInt(i64 %var3)
	%var4 = alloca i8*
	%var5 = alloca i64
	store i64 10, i64* %var5
	%var6 = alloca i64
	store i64 1, i64* %var6
	br label %Just (10,11)while
	; <label>:Just (10,11)while
	%var8 = load i64, i64* %var5
	%var7 = icmp sgt i64 %var8, 0
	br i1 %var7, label %7true, label %7false
	; <label>:7true
	%var10 = load i64, i64* %var6
	%var11 = load i64, i64* %var5
	%var9 = mul i64 %var10, %var11
	store i64 %var9, i64* %var6
	%var13 = load i64, i64* %var5
	%var12 = sub i64 %var13, 1
	store i64 %var12, i64* %var5
	br label %Just (10,11)while
	; <label>:7false
	%var14 = load i64, i64* %var6
	call void @printInt(i64 %var14)
	%var15 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var15, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str2, i64 0, i64 0), i64 2)
	%var16 = call i8* @repStr(i8* %var15, i64 60)
	call void @printString(i8* %var16)
	%var17 = call i8* @calloc(i64 9, i64 1)
	call void @memcpy(i8* %var17, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str3, i64 0, i64 0), i64 9)
	call void @printString(i8* %var17)
	%var18 = call i8* @calloc(i64 9, i64 1)
	call void @memcpy(i8* %var18, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str4, i64 0, i64 0), i64 9)
	call void @printString(i8* %var18)
	ret i64 0
	}
	

