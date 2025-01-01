@format = internal constant [4 x i8] c"%d\0A\00"
declare i64 @printf(i8*, ...)

define void @printInt(i64 %x) {
	call i64 (i8*, ...) @printf(i8* getelementptr([4 x i8], [4 x i8]* @format, i64 0, i64 0), i64 %x)
	ret void
}

define i64 @main(i64 %argc, i8** %argv) {

%1= alloca i64
%2= alloca i8*
%3= alloca i1
	ret i64 0
}

