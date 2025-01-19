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
@.str3 = private constant [3 x i8] c"&&\00"
@.str4 = private constant [3 x i8] c"||\00"
@.str1 = private constant [6 x i8] c"false\00"
@.str5 = private constant [2 x i8] c"!\00"
@.str2 = private constant [5 x i8] c"true\00"
	define void @printBool(void %printBool) {
	%var0 = alloca i1
	store i1 %b, i1* %var0
	%var2 = load i1, i1* %var0
	%var1 = xor i1 %var2, 1
	br i1 %var1, label %1true, label %1false
	; <label>:1true
	%var3 = call i8* @calloc(i64 6, i64 1)
	call void @memcpy(i8* %var3, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str1, i64 0, i64 0), i64 6)
	call void @printString(i8* %var3)
	br label %1end
	; <label>:1false
	%var4 = call i8* @calloc(i64 5, i64 1)
	call void @memcpy(i8* %var4, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str2, i64 0, i64 0), i64 5)
	call void @printString(i8* %var4)
	br label %1end
	; <label>:1end
	ret void
	}
	

	define i1 @test(i1 %test) {
	%var0 = alloca i64
	store i64 %i, i64* %var0
	%var1 = load i64, i64* %var0
	call void @printInt(i64 %var1)
	%var3 = load i64, i64* %var0
	%var2 = icmp sgt i64 %var3, 0
	ret i1 %var2
	}
	

	define i64 @main() {
	%var0 = call i8* @calloc(i64 3, i64 1)
	call void @memcpy(i8* %var0, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str3, i64 0, i64 0), i64 3)
	call void @printString(i8* %var0)
	%var1 = mul i64 1, -1
	%var2 = call i1 @test(i64 %var1)
	br i1 %var2, label %2true, label %2false
	; <label>:2false
	br label %2end
	; <label>:2true
	%var4 = call i1 @test(i64 0)
	%lbvar4 = add i1 0, %var4
	br label %2end
	; <label>:2end
	%var3 = phi i1 [ %lbvar4, %2true], [0, %2false]
	call void @printBool(i1 %var3)
	%var5 = mul i64 2, -1
	%var6 = call i1 @test(i64 %var5)
	br i1 %var6, label %6true, label %6false
	; <label>:6false
	br label %6end
	; <label>:6true
	%var8 = call i1 @test(i64 1)
	%lbvar8 = add i1 0, %var8
	br label %6end
	; <label>:6end
	%var7 = phi i1 [ %lbvar8, %6true], [0, %6false]
	call void @printBool(i1 %var7)
	%var9 = call i1 @test(i64 3)
	br i1 %var9, label %9true, label %9false
	; <label>:9false
	br label %9end
	; <label>:9true
	%var11 = mul i64 5, -1
	%var12 = call i1 @test(i64 %var11)
	%lbvar12 = add i1 0, %var12
	br label %9end
	; <label>:9end
	%var10 = phi i1 [ %lbvar12, %9true], [0, %9false]
	call void @printBool(i1 %var10)
	%var13 = call i1 @test(i64 234234)
	br i1 %var13, label %13true, label %13false
	; <label>:13false
	br label %13end
	; <label>:13true
	%var15 = call i1 @test(i64 21321)
	%lbvar15 = add i1 0, %var15
	br label %13end
	; <label>:13end
	%var14 = phi i1 [ %lbvar15, %13true], [0, %13false]
	call void @printBool(i1 %var14)
	%var16 = call i8* @calloc(i64 3, i64 1)
	call void @memcpy(i8* %var16, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str4, i64 0, i64 0), i64 3)
	call void @printString(i8* %var16)
	%var17 = mul i64 1, -1
	%var18 = call i1 @test(i64 %var17)
	br i1 %var18, label %18true, label %18false
	; <label>:18true
	br label %18end
	; <label>:18false
	%var20 = call i1 @test(i64 0)
	%lbvar20 = add i1 0, %var20
	br label %18end
	; <label>:18end
	%var19 = phi i1 [ %lbvar20, %18false], [1, %18true]
	call void @printBool(i1 %var19)
	%var21 = mul i64 2, -1
	%var22 = call i1 @test(i64 %var21)
	br i1 %var22, label %22true, label %22false
	; <label>:22true
	br label %22end
	; <label>:22false
	%var24 = call i1 @test(i64 1)
	%lbvar24 = add i1 0, %var24
	br label %22end
	; <label>:22end
	%var23 = phi i1 [ %lbvar24, %22false], [1, %22true]
	call void @printBool(i1 %var23)
	%var25 = call i1 @test(i64 3)
	br i1 %var25, label %25true, label %25false
	; <label>:25true
	br label %25end
	; <label>:25false
	%var27 = mul i64 5, -1
	%var28 = call i1 @test(i64 %var27)
	%lbvar28 = add i1 0, %var28
	br label %25end
	; <label>:25end
	%var26 = phi i1 [ %lbvar28, %25false], [1, %25true]
	call void @printBool(i1 %var26)
	%var29 = call i1 @test(i64 234234)
	br i1 %var29, label %29true, label %29false
	; <label>:29true
	br label %29end
	; <label>:29false
	%var31 = call i1 @test(i64 21321)
	%lbvar31 = add i1 0, %var31
	br label %29end
	; <label>:29end
	%var30 = phi i1 [ %lbvar31, %29false], [1, %29true]
	call void @printBool(i1 %var30)
	%var32 = call i8* @calloc(i64 2, i64 1)
	call void @memcpy(i8* %var32, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str5, i64 0, i64 0), i64 2)
	call void @printString(i8* %var32)
	call void @printBool(i1 1)
	call void @printBool(i1 0)
	ret i64 0
	}
	

