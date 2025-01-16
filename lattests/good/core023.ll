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
define i64 @foo(i64 %a, i64 %b, i64 %c, i64 %d, i64 %e, i64 %f, i64 %g, i64 %h, i64 %i, i64 %j, i64 %k, i64 %l, i64 %m, i64 %n) {
	%var1 = alloca i64
	store i64 %a, i64* %var1
	%var2 = alloca i64
	store i64 %b, i64* %var2
	%var3 = alloca i64
	store i64 %c, i64* %var3
	%var4 = alloca i64
	store i64 %d, i64* %var4
	%var5 = alloca i64
	store i64 %e, i64* %var5
	%var6 = alloca i64
	store i64 %f, i64* %var6
	%var7 = alloca i64
	store i64 %g, i64* %var7
	%var8 = alloca i64
	store i64 %h, i64* %var8
	%var9 = alloca i64
	store i64 %i, i64* %var9
	%var10 = alloca i64
	store i64 %j, i64* %var10
	%var11 = alloca i64
	store i64 %k, i64* %var11
	%var12 = alloca i64
	store i64 %l, i64* %var12
	%var13 = alloca i64
	store i64 %m, i64* %var13
	%var14 = alloca i64
	store i64 %n, i64* %var14
	%var16 = load i64, i64* %var1
	%var15 = mul i64 2, %var16
	%var18 = load i64, i64* %var2
	%var17 = sdiv i64 %var18, 2
	%var19 = add i64 %var15, %var17
	%var21 = load i64, i64* %var3
	%var20 = add i64 %var19, %var21
	%var23 = load i64, i64* %var4
	%var22 = add i64 %var20, %var23
	%var25 = load i64, i64* %var5
	%var24 = add i64 %var22, %var25
	%var27 = load i64, i64* %var6
	%var26 = add i64 %var24, %var27
	%var29 = load i64, i64* %var7
	%var28 = add i64 %var26, %var29
	%var31 = load i64, i64* %var8
	%var30 = add i64 %var28, %var31
	%var33 = load i64, i64* %var9
	%var32 = add i64 %var30, %var33
	%var35 = load i64, i64* %var10
	%var34 = sdiv i64 %var35, 2
	%var36 = add i64 %var32, %var34
	%var38 = load i64, i64* %var11
	%var37 = add i64 %var36, %var38
	%var40 = load i64, i64* %var12
	%var39 = add i64 %var37, %var40
	%var42 = load i64, i64* %var13
	%var41 = add i64 %var39, %var42
	%var44 = load i64, i64* %var14
	%var43 = add i64 %var41, %var44
	%var45 = srem i64 %var43, 10
	%var46 = alloca i64
	store i64 %var45, i64* %var46
	%var47 = load i64, i64* %var46
	call void @printInt(i64 %var47)
	%var48 = load i64, i64* %var46
	ret i64 %var48
}

	

define i64 @main() {
	%var1 = alloca i64
	store i64 1, i64* %var1
	%var2 = alloca i64
	store i64 2, i64* %var2
	%var3 = alloca i64
	store i64 1, i64* %var3
	%var4 = alloca i64
	store i64 2, i64* %var4
	%var5 = alloca i64
	store i64 1, i64* %var5
	%var6 = alloca i64
	store i64 2, i64* %var6
	%var7 = alloca i64
	store i64 1, i64* %var7
	%var8 = alloca i64
	store i64 2, i64* %var8
	%var9 = alloca i64
	store i64 1, i64* %var9
	%var10 = alloca i64
	store i64 2, i64* %var10
	%var11 = alloca i64
	store i64 1, i64* %var11
	%var12 = alloca i64
	store i64 2, i64* %var12
	%var13 = alloca i64
	store i64 1, i64* %var13
	%var14 = alloca i64
	store i64 2, i64* %var14
	%var15 = load i64, i64* %var1
	%var16 = load i64, i64* %var2
	%var17 = load i64, i64* %var3
	%var18 = load i64, i64* %var4
	%var19 = load i64, i64* %var5
	%var20 = load i64, i64* %var6
	%var21 = load i64, i64* %var7
	%var22 = load i64, i64* %var8
	%var23 = load i64, i64* %var9
	%var24 = load i64, i64* %var10
	%var25 = load i64, i64* %var11
	%var26 = load i64, i64* %var12
	%var27 = load i64, i64* %var13
	%var28 = load i64, i64* %var14
%var29 = call i64 @foo(i64 %var15, i64 %var16, i64 %var17, i64 %var18, i64 %var19, i64 %var20, i64 %var21, i64 %var22, i64 %var23, i64 %var24, i64 %var25, i64 %var26, i64 %var27, i64 %var28)
	ret i64 %var29
}

	

