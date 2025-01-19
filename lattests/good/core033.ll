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
	define i64 @funkcja_ifbooltrudny(i64 %funkcja_ifbooltrudny, i64 %funkcja_ifbooltrudny) {
	%var0 = alloca i1
	store i1 %f, i1* %var0
	%var1 = alloca i1
	store i1 %t, i1* %var1
	%var3 = load i1, i1* %var0
	%var2 = xor i1 %var3, 1
	br i1 %var2, label %2true, label %2false
	; <label>:2false
	br label %2end
	; <label>:2true
	%var5 = load i1, i1* %var0
	%lbvar5 = add i1 0, %var5
	br label %2end
	; <label>:2end
	%var4 = phi i1 [ %lbvar5, %2true], [0, %2false]
	br i1 %var4, label %4true, label %4false
	; <label>:4true
	br label %4end
	; <label>:4false
	%var7 = load i1, i1* %var0
	br i1 %var7, label %7true, label %7false
	; <label>:7true
	br label %7end
	; <label>:7false
	%var10 = load i1, i1* %var1
	%var9 = xor i1 %var10, 1
	%lbvar9 = add i1 0, %var9
	br label %7end
	; <label>:7end
	%var8 = phi i1 [ %lbvar9, %7false], [1, %7true]
	%var11 = xor i1 %var8, 1
	%lbvar11 = add i1 0, %var11
	br label %4end
	; <label>:4end
	%var6 = phi i1 [ %lbvar11, %7end], [1, %4true]
	br i1 %var6, label %6true, label %6false
	; <label>:6true
	call void @printInt(i64 1042)
	br label %6end
	; <label>:6false
	call void @printInt(i64 2042)
	br label %6end
	; <label>:6end
	ret i64 0
	}
	

	define i64 @main() {
	%var0 = call i64 @funkcja_ifbooltrudny(i1 0, i1 1)
	ret i64 0
	}
	

