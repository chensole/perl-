#!/usr/bin/perl -w
use strict;

# ---------------- 引用自己创建的类 ------------------------


# --增添模块查找路径
BEGIN {

	unshift @INC,"/home/zhi/perl_parctice/perl_write";

}

use cocoa;

##  使用类的构造函数创建对象

my $object = cocoa -> new();
#exit;

#   对象继承类的方法
print $object -> addem(10,20)."\n";

print $object -> data("heallo")."\n";

use class2;

# 创建另一个对象
my $object1 = class2 -> new();

print $object1 -> gettex."\n";
