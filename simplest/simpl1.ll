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
declare void @free(i8*)
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
@.str1 = private constant [19 x i8] c"class wrap with x:\00"
@.str2 = private constant [22 x i8] c"class wrap with getx:\00"
@.Wrapsize = private constant i64 8
define i64 @Wrap.getx(i8* %selfik) {
	%var0 = alloca i8*
	store i8* null, i8** %var0
	store i8* %selfik, i8** %var0
	%var1 = load i8*, i8** %var0
	%var2 = getelementptr  i8, i8* %var1, i64 0
	%var3 = bitcast i8* %var2 to i64*
	%var4 = load i64, i64* %var3
	ret i64 %var4
}
define void @Wrap.setx(i8* %selfik, i64 %y) {
	%var0 = alloca i8*
	%var1 = alloca i64

	store i8* null, i8** %var0
	store i8* %selfik, i8** %var0
	store i64 %y, i64* %var1
	%var2 = load i8*, i8** %var0
	%var3 = getelementptr  i8, i8* %var2, i64 0
	%var4 = bitcast i8* %var3 to i64*
; old id2
	%var5 = load i64, i64* %var1
	store i64 %var5, i64* %var4
; ref map RefState {nextID = 3, refMap = fromList [(-1,(1,[])),(1,(1,[]))]}
; var map (fromList [("selfik",(0,-1,i8**)),("selfik.x",(4,-1,i64*)),("y",(1,-1,i64*))],6)
	ret void
}
define void @Wrap.print(i8* %selfik) {
	%var0 = alloca i8*

	store i8* null, i8** %var0
	store i8* %selfik, i8** %var0
	%var1 = call i8* @calloc(i64 19, i64 1)
	call void @memcpy(i8* %var1, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str1, i64 0, i64 0), i64 19)
	call void @printString(i8* %var1)
	%var3 = load i8*, i8** %var0
	%var4 = getelementptr  i8, i8* %var3, i64 0
	%var5 = bitcast i8* %var4 to i64*
	%var6 = load i64, i64* %var5
	call void @printInt(i64 %var6)
	%var8 = call i8* @calloc(i64 22, i64 1)
	call void @memcpy(i8* %var8, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str2, i64 0, i64 0), i64 22)
	call void @printString(i8* %var8)
	%var10 = load i8*, i8** %var0
	%var11 = call i64 @Wrap.getx(i8* %var10)
	call void @printInt(i64 %var11)
	ret void
}
define i8* @Wrap.id(i8* %selfik) {
	%var0 = alloca i8*

	store i8* null, i8** %var0
	store i8* %selfik, i8** %var0
	%var1 = load i8*, i8** %var0
	ret i8* %var1
}
define i64 @main() {
	%var2 = alloca i8*
	%var8 = alloca i64

	%var0= load i64, i64* @.Wrapsize
	%var1 = call i8* @calloc(i64 1, i64 %var0)
	store i8* %var1, i8** %var2
; ref map RefState {nextID = 8, refMap = fromList [(1,(1,[])),(4,(1,[])),(6,(1,[])),(7,(1,[]))]}
; var map (fromList [("w",(2,7,i8**))],3)
	%var3 = load i8*, i8** %var2
	call void @Wrap.setx(i8* %var3,i64 2)
	%var5 = load i8*, i8** %var2
	%var6 = call i64 @Wrap.getx(i8* %var5)
	store i64 %var6, i64* %var8
; ref map RefState {nextID = 9, refMap = fromList [(1,(1,[])),(4,(1,[])),(6,(1,[])),(7,(1,[])),(8,(2,[]))]}
; var map (fromList [("w",(2,7,i8**)),("x",(8,8,i64*))],9)
	%var9 = load i64, i64* %var8
	call void @printInt(i64 %var9)
	%var11 = load i8*, i8** %var2
	call void @Wrap.print(i8* %var11)
	%var13 = load i8*, i8** %var2
	%var14 = call i8* @Wrap.id(i8* %var13)
	%var16 = call i8* @Wrap.id(i8* %var14)
	%var18 = call i8* @Wrap.id(i8* %var16)
	%var20 = call i8* @Wrap.id(i8* %var18)
	%var22 = call i64 @Wrap.getx(i8* %var20)
	call void @printInt(i64 %var22)
	ret i64 0
}

