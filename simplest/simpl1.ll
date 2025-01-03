@format = internal constant [4 x i8] c"%d\0A\00"
declare i64 @printf(i8*, ...)

define void @printInt(i64 %x) {
	call i64 (i8*, ...) @printf(i8* getelementptr([4 x i8], [4 x i8]* @format, i64 0, i64 0), i64 %x)
	ret void
}

define i64 @main(i64 %argc, i8** %argv) {

%1= alloca i64
store i64 10, i64* %1
%2= alloca i64
%tmp1 = load i64, i64* %1
%tmp2 = add i64 9, 0
%tmp3 = sub i64 0, %tmp2
%tmp4 = add i64 %tmp1, %tmp3
store i64 %tmp4, i64* %2
%tmp5 = load i64, i64* %1
call void @printInt(i64 %tmp5)
%tmp6 = load i64, i64* %2
call void @printInt(i64 %tmp6)
	ret i64 0
}

