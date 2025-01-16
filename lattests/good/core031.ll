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
define i64 @f(i64 %a, i64 %b) {
	%var1 = alloca i64
	store i64 %a, i64* %var1
	%var2 = alloca i64
	store i64 %b, i64* %var2
	%var4 = load i64, i64* %var1
	%var3 = icmp sgt i64 %var4, 0
	br i1 %var3, label %2, label %1
; <label>:1
	br label %3
; <label>:2
	%var7 = load i64, i64* %var2
	%var6 = icmp sgt i64 %var7, 0
	br label %3
; <label>:3
	%var5 = phi i1 [ %var7, %2], [0, %1]
	br i1 %var5, label %4, label %5
; <label>:4
	br label %9
; <label>:5
	%var10 = load i64, i64* %var1
	%var9 = icmp slt i64 %var10, 0
	br i1 %var9, label %7, label %6
; <label>:6
	br label %8
; <label>:7
	%var13 = load i64, i64* %var2
	%var12 = icmp slt i64 %var13, 0
	br label %8
; <label>:8
	%var11 = phi i1 [ %var13, %7], [0, %6]
	br label %9
; <label>:9
	%var8 = phi i1 [ %var13, %5], [1, %4]
	br i1 %var8, label %10, label %11
; <label>:10
	ret i64 7
; <label>:11
	ret i64 42
; <label>:12
}

	

define i64 @main() {
	%var1 = mul i64 1, -1
%var2 = call i64 @f(i64 1, i64 %var1)
	call void @printInt(i64 %var2)
	ret i64 0
}

	

