@format = internal constant [4 x i8] c"%d\0A\00"
declare i64 @printf(i8*, ...)

define void @printInt(i64 %x) {
	call i64 (i8*, ...) @printf(i8* getelementptr([4 x i8], [4 x i8]* @format, i64 0, i64 0), i64 %x)
	ret void
}


define i64 @main() {
	%var1 = alloca i64
	store i64 2, i64* %var1
	store i64 4, i64* %var1
	%var2 = load i64, i64* %var1
	%var3 = add i64 2, 1
	%var4 = alloca i64
	store i64 %var3, i64* %var4
	%var5 = load i64, i64* %var1
	call void @printInt(i64 %var5)
	%var6 = load i64, i64* %var4
	call void @printInt(i64 %var6)
	ret i64 0
}

