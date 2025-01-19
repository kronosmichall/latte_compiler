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
@.str1 = private constant [5 x i8] c"true\00"
@.str2 = private constant [6 x i8] c"false\00"
@.str3 = private constant [4 x i8] c"apa\00"
	define i1 @dontCallMe(i1 %dontCallMe) {
	%var0 = alloca i64
	store i64 %x, i64* %var0
	%var1 = load i64, i64* %var0
	call void @printInt(i64 %var1)
	ret i1 1
	}
	

	define void @printBool(void %printBool) {
	%var0 = alloca i1
	store i1 %b, i1* %var0
	%var1 = load i1, i1* %var0
	br i1 %var1, label %1true, label %1false
	; <label>:1true
	%var2 = call i8* @calloc(i64 5, i64 1)
	call void @memcpy(i8* %var2, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str1, i64 0, i64 0), i64 5)
	call void @printString(i8* %var2)
	br label %1end
	; <label>:1false
	%var3 = call i8* @calloc(i64 6, i64 1)
	call void @memcpy(i8* %var3, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str2, i64 0, i64 0), i64 6)
	call void @printString(i8* %var3)
	br label %1end
	; <label>:1end
	ret void
	}
	

	define i1 @implies(i1 %implies, i1 %implies) {
	%var0 = alloca i1
	store i1 %x, i1* %var0
	%var1 = alloca i1
	store i1 %y, i1* %var1
	%var3 = load i1, i1* %var0
	%var2 = xor i1 %var3, 1
	br i1 %var2, label %2true, label %2false
	; <label>:2true
	br label %2end
	; <label>:2false
	%var6 = load i1, i1* %var0
	%var7 = load i1, i1* %var1
	%var5 = icmp eq i1 %var6, %var7
	%lbvar5 = add i1 0, %var5
	br label %2end
	; <label>:2end
	%var4 = phi i1 [ %lbvar5, %2false], [1, %2true]
	ret i1 %var4
	}
	

	define i64 @main() {
	%var0 = alloca i64
	store i64 4, i64* %var0
	%var2 = load i64, i64* %var0
	%var1 = icmp sle i64 3, %var2
	br i1 %var1, label %1true, label %1false
	; <label>:1false
	br label %1end
	; <label>:1true
	%var4 = icmp ne i64 4, 2
	br i1 %var4, label %4true, label %4false
	; <label>:4false
	br label %4end
	; <label>:4true
	%lbvar6 = add i1 0, 1
	br label %4end
	; <label>:4end
	%var5 = phi i1 [ %lbvar6, %4true], [0, %4false]
	%lbvar5 = add i1 0, %var5
	br label %1end
	; <label>:1end
	%var3 = phi i1 [ %lbvar5, %4end], [0, %1false]
	br i1 %var3, label %3true, label %3false
	; <label>:3true
	call void @printBool(i1 1)
	br label %3end
	; <label>:3false
	%var7 = call i8* @calloc(i64 4, i64 1)
	call void @memcpy(i8* %var7, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str3, i64 0, i64 0), i64 4)
	call void @printString(i8* %var7)
	br label %3end
	; <label>:3end
	%var8 = icmp eq i1 1, 1
	br i1 %var8, label %8true, label %8false
	; <label>:8true
	br label %8end
	; <label>:8false
	%var10 = call i1 @dontCallMe(i64 1)
	%lbvar10 = add i1 0, %var10
	br label %8end
	; <label>:8end
	%var9 = phi i1 [ %lbvar10, %8false], [1, %8true]
	call void @printBool(i1 %var9)
	%var11 = mul i64 5, -1
	%var12 = icmp slt i64 4, %var11
	br i1 %var12, label %12true, label %12false
	; <label>:12false
	br label %12end
	; <label>:12true
	%var14 = call i1 @dontCallMe(i64 2)
	%lbvar14 = add i1 0, %var14
	br label %12end
	; <label>:12end
	%var13 = phi i1 [ %lbvar14, %12true], [0, %12false]
	call void @printBool(i1 %var13)
	%var16 = load i64, i64* %var0
	%var15 = icmp eq i64 4, %var16
	br i1 %var15, label %15true, label %15false
	; <label>:15false
	br label %15end
	; <label>:15true
	%var18 = xor i1 0, 1
	%var19 = icmp eq i1 1, %var18
	br i1 %var19, label %19true, label %19false
	; <label>:19false
	br label %19end
	; <label>:19true
	%lbvar21 = add i1 0, 1
	br label %19end
	; <label>:19end
	%var20 = phi i1 [ %lbvar21, %19true], [0, %19false]
	%lbvar20 = add i1 0, %var20
	br label %15end
	; <label>:15end
	%var17 = phi i1 [ %lbvar20, %19end], [0, %15false]
	call void @printBool(i1 %var17)
	%var22 = call i1 @implies(i1 0, i1 0)
	call void @printBool(i1 %var22)
	%var23 = call i1 @implies(i1 0, i1 1)
	call void @printBool(i1 %var23)
	%var24 = call i1 @implies(i1 1, i1 0)
	call void @printBool(i1 %var24)
	%var25 = call i1 @implies(i1 1, i1 1)
	call void @printBool(i1 %var25)
	ret i64 0
	}
	

