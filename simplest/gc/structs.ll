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
@.str2 = private constant [6 x i8] c"other\00"
@.str1 = private constant [12 x i8] c"some string\00"
@.wrapsize = private constant i64 8
define i64 @main() {
	%var0= load i64, i64* @.wrapsize
	%var1 = call i8* @calloc(i64 1, i64 %var0)
	%var2 = alloca i8*
	store i8* %var1, i8** %var2
; ref map (2,fromList [(1,1)])
; var map (fromList [("w",(2,1,i8**))],3)
	%var3 = load i8*, i8** %var2
	%var4 = getelementptr  i8, i8* %var3, i64 0
	%var5 = bitcast i8* %var4 to i8**
	%var6 = call i8* @calloc(i64 12, i64 1)
	call void @memcpy(i8* %var6, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str1, i64 0, i64 0), i64 12)
; old id2
	store i8* %var6, i8** %var5
; ref map (4,fromList [(1,1),(2,0),(3,1)])
; var map (fromList [("w",(2,1,i8**)),("w.s",(5,3,i8**))],7)
	%var7 = load i8*, i8** %var2
	%var8 = getelementptr  i8, i8* %var7, i64 0
	%var9 = bitcast i8* %var8 to i8**
	%var10 = call i8* @calloc(i64 6, i64 1)
	call void @memcpy(i8* %var10, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str2, i64 0, i64 0), i64 6)
; old id3
	%var11 = load i8*, i8** %var5
	call void @free (i8* %var11)
	store i8* %var10, i8** %var9
; ref map (5,fromList [(1,1),(2,0),(3,0),(4,1)])
; var map (fromList [("w",(2,1,i8**)),("w.s",(9,4,i8**))],12)
	%var12 = load i8*, i8** %var2
	%var13 = load i8*, i8** %var9
	call void @free (i8* %var12)
	call void @free (i8* %var13)
; ref map (5,fromList [])
; var map (fromList [],12)
	ret i64 0
}

