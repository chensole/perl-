#!usr/bin/perl -w
use strict;
 
# File Name: file_handle.pl
# Author: chensole
# mail: 1278371386@qq.com
# Created Time: 2019-07-22

## 统计文件中的行数

	my $number_line = 0;
	while(<IN>) {
	
		++$number_line;
	
	}
	close IN;


	# 除了短小的文件之外，为了统计行数而逐行读取整个文件的效率是很低下的
	

# 在程序代码中存储文件
	
	# perl 有两个特殊记号 _DATA_ 和 _END_，可以用它们在代码文件中存储数据，它仅仅假设后面的内容是数据
	# 然后从隐含文件句柄 DATA中读取，就可以读取那个数据
	while (<DATA>) {
		print;
	}

	_DATA_ 

	HERE
	is
	the 
	text!



	_END_ 
	here 
	is 
	the 
	text! 


# 查找匹配的文件
	
	glob ('*');   # 显示当前目录中的文件名

	glob ('/home/zhi/');   # 显示/home/zhi/ 目录下的文件

