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
@.str5 = private constant [2 x i8] c"6\00"
@.str6 = private constant [2 x i8] c"6\00"
@.str7 = private constant [2 x i8] c"7\00"
@.str8 = private constant [2 x i8] c"7\00"
@.str1 = private constant [2 x i8] c"4\00"
@.str2 = private constant [2 x i8] c"4\00"
@.str3 = private constant [2 x i8] c"5\00"
@.str4 = private constant [2 x i8] c"5\00"
define i64 @main() {
	%var1 = icmp sle i64 1, 1
	br i1 %var1, label %1, label %2
; <label>:1
	%var2 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var2, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str1, i64 0, i64 0), i64 2)
	call void @printString(i8* %var2)
	br label %2
; <label>:2
	%var3 = icmp sge i64 1, 1
	br i1 %var3, label %3, label %4
; <label>:3
	%var4 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str2, i64 0, i64 0), i64 2)
	call void @printString(i8* %var4)
	br label %4
; <label>:4
	%var5 = icmp sgt i64 1, 1
	br i1 %var5, label %5, label %6
; <label>:5
	%var6 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str3, i64 0, i64 0), i64 2)
	call void @printString(i8* %var6)
	br label %6
; <label>:6
	%var7 = icmp slt i64 1, 1
	br i1 %var7, label %7, label %8
; <label>:7
	%var8 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var8, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str4, i64 0, i64 0), i64 2)
	call void @printString(i8* %var8)
	br label %8
; <label>:8
	%var9 = icmp slt i64 1, 2
	br i1 %var9, label %9, label %10
; <label>:9
	%var10 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var10, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str5, i64 0, i64 0), i64 2)
	call void @printString(i8* %var10)
	br label %10
; <label>:10
	%var11 = icmp sgt i64 2, 1
	br i1 %var11, label %11, label %12
; <label>:11
	%var12 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var12, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str6, i64 0, i64 0), i64 2)
	call void @printString(i8* %var12)
	br label %12
; <label>:12
	%var13 = icmp sgt i64 1, 2
	br i1 %var13, label %13, label %14
; <label>:13
	%var14 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var14, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str7, i64 0, i64 0), i64 2)
	call void @printString(i8* %var14)
	br label %14
; <label>:14
	%var15 = icmp slt i64 2, 1
	br i1 %var15, label %15, label %16
; <label>:15
	%var16 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var16, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str8, i64 0, i64 0), i64 2)
	call void @printString(i8* %var16)
	br label %16
; <label>:16
	ret i64 0
}

