#!usr/bin/perl -w

# 函数与运算符

	# perl的规则是：如果它看起来像函数，这意味着参数表被包括在圆括号之中。

	# 如 print 表运算符

	print 1 + 2;   # 打印 3 ， 不使用圆括号，此时作为一个运算符
	print "\n";
	print (1 + 2) + 3;  # 打印 3 ，使用括号时，perl作为一个函数，只作用于括号内的参数
	print "\n";


	# 括号前使用 + 号，可以告诉perl 不执行函数调用，这里只是表运算符

	print +( 2 + 3) * 4;
	print "\n";     # 20


# -> 运算符

	# 如果右侧不使用 [] 或 {},则箭头运算符左侧不是对数组或哈希表的引用，其左侧要么是对象，要么是类名


# ++ 和 --

	# 如果出现在变量之前，则先增加或减少该变量的值，然后才返回它的值
		
		my $a = 1;
		print ++$a;

	# 如果出现在变量之后，则先返回这个值，在增加或减少变量的值

		print "\n";
		print $a++;   # 2, 先打印后自增
		print "\n";
		print $a."\n";
		


		print 2**1024;


# 取模运算符

	print 16 % 3;



# 表运算符拥有比其左侧项目高很多的优先级
	
	print 1,2,3,sort 6,5,4;






## 循环和控制


	# exit 语句结束程序

	# 在出了问题想要在结束时显示错误信息用 die




## 数据处理

	# lcfirst ---- 第一个字符转换为小写
	# ucfirst ---- 第一个字符转换为大写
	# rand 创建随机数

		# 默认创建从 0到1之间的数字
		# 也可指定一个数n , 返回0到n之间的随机数
		# rand(b-a) + a 指定a到b范围内的数字

	# 设置随机种子

		# 使产生的随机数结果得以重现，使用rand之前，调用srand

			srand;
			my $randonm = rand(100);
			print $randonm;
			print "\n";
			# 对于5.004后面的版本，会自动调用srand


	# 得到字串
		
		# substr EXPR,OFFSET,LEN,REPLACEMENT

		# 返回子串的第一个字符位于 OFFSET处，如果OFFSET为负值，则substr从字符串的末尾开始，向后移动
		# 可以使用REPLACEMENT替换指定的字符串
		my $string = "AAAAAATTTTTTTTTAAAAAAAAAAAATTTTTTTTTTTTTCCCCCCCC";
		substr ($string,6,10,"GGGGGGGGGG");  # 不需要进行赋值，直接替换

		my $A = $string =~ tr/A/A/;
		print $A,"\n";
		print $string."\n";


	# 时间
		# time 返回1970年1月1日以来的秒数
		print time."\n";
		
		# localtime
		
		print localtime."\n";

		
