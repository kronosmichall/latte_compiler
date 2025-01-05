@format = internal constant [4 x i8] c"%d\0A\00"
declare i64 @printf(i8*, ...)

define void @printInt(i64 %x) {
	call i64 (i8*, ...) @printf(i8* getelementptr([4 x i8], [4 x i8]* @format, i64 0, i64 0), i64 %x)
	ret void
}


define i64 @two() {
ret i64 2
}
define i64 @three() {
%ref1 = alloca i64
store i64 2, i64* %ref1
%tmp1 = load i64, i64* %ref1
%tmp2 = add i64 1, 0
%tmp3 = add i64 %tmp1, %tmp2
ret i64 %tmp3
}
define i64 @four() {
%ref2 = alloca i64
store i64 4, i64* %ref2
%tmp4 = load i64, i64* %ref2
ret i64 %tmp4
}
define i64 @five() {
%ref3 = alloca i64
store i64 2, i64* %ref3
%tmp5 = load i64, i64* %ref3
%tmp6 = add i64 3, 0
%tmp7 = add i64 %tmp5, %tmp6
store i64 %tmp7, i64* %ref3
%tmp8 = load i64, i64* %ref3
ret i64 %tmp8
}
