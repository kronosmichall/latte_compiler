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
@.str3 = private constant [7 x i8] c"string\00"
@.str2 = private constant [6 x i8] c"false\00"
@.str4 = private constant [2 x i8] c" \00"
@.str5 = private constant [14 x i8] c"concatenation\00"
define void @printBool(i1 %b) {
	%var1 = alloca i1
	store i1 %b, i1* %var1
	br i1 %var1, label %1, label %2
; <label>:1
	%var2 = call i8* @calloc(i64 5, i64 1)
	call void @memcpy(i8* %var2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str1, i64 0, i64 0), i64 5)
	call void @printString(i8* %var2)
	ret void
; <label>:2
	%var3 = call i8* @calloc(i64 6, i64 1)
	call void @memcpy(i8* %var3, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str2, i64 0, i64 0), i64 6)
	call void @printString(i8* %var3)
	ret void
; <label>:3
}

	

define i64 @main() {
	%var1 = alloca i64
	store i64 56, i64* %var1
	%var2 = mul i64 23, -1
	%var3 = alloca i64
	store i64 %var2, i64* %var3
	%var5 = load i64, i64* %var1
	%var6 = load i64, i64* %var3
	%var4 = add i64 %var5, %var6
	call void @printInt(i64 %var4)
	%var8 = load i64, i64* %var1
	%var9 = load i64, i64* %var3
	%var7 = sub i64 %var8, %var9
	call void @printInt(i64 %var7)
	%var11 = load i64, i64* %var1
	%var12 = load i64, i64* %var3
	%var10 = mul i64 %var11, %var12
	call void @printInt(i64 %var10)
	%var13 = sdiv i64 45, 2
	call void @printInt(i64 %var13)
	%var14 = srem i64 78, 3
	call void @printInt(i64 %var14)
	%var16 = load i64, i64* %var1
	%var17 = load i64, i64* %var3
	%var15 = sub i64 %var16, %var17
	%var19 = load i64, i64* %var1
	%var20 = load i64, i64* %var3
	%var18 = add i64 %var19, %var20
	%var21 = icmp sgt i64 %var15, %var18
	call void @printBool(i1 %var21)
	%var23 = load i64, i64* %var1
	%var24 = load i64, i64* %var3
	%var22 = sdiv i64 %var23, %var24
	%var26 = load i64, i64* %var1
	%var27 = load i64, i64* %var3
	%var25 = mul i64 %var26, %var27
	%var28 = icmp sle i64 %var22, %var25
	call void @printBool(i1 %var28)
	%var29 = call i8* @calloc(i64 7, i64 1)
	call void @memcpy(i8* %var29, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str3, i64 0, i64 0), i64 7)
	%var30 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var30, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str4, i64 0, i64 0), i64 2)
	%var31 = call i8* @concat_strings(i8* %var29, i8* %var30)
	%var32 = call i8* @calloc(i64 14, i64 1)
	call void @memcpy(i8* %var32, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str5, i64 0, i64 0), i64 14)
	%var33 = call i8* @concat_strings(i8* %var31, i8* %var32)
	call void @printString(i8* %var33)
	ret i64 0
}

	

