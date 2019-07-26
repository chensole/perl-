#!usr/bin/perl -w
use strict;

# ---------------------  求集合运算 -------------------------------- 
# File Name: c.pl
# Author: chensole
# mail: 1278371386@qq.com
# Created Time: 2019-07-25

# ------------------------- 利用哈希特性进行集合运算 --------------------------
   my  @a=('a'..'c',1..3);
    my @b=('A'..'C',1..3);
	my %hash;
	foreach my $k (@a,@b) {
		$hash{$k}++;
	
	}

# ---- 交集
	my @k = grep {$hash{$_} > 1} keys %hash;

# ---- 差集
	my @v = grep {$hash{$_} == 1} keys %hash;
	print "@k\n";
	print "@v\n";

# ---- 并集	
	print keys %hash;

	print "\n";

## ----------------------- Array::Utils ------------------------
	
	use Array::Utils qw(:all);

# ---- 差集
	my @diff1 = array_diff(@a,@b);

# ---- 交集	
	my @isect1 = intersect(@a,@b);

# ---- 并集	
	my @unique1 = unique (@a,@b);

# ---- @a中特有的元素
	my @minus = array_minus (@a,@b);   # get items from @a that arr not in array @b 
	
	print "@diff1\n";
	print "@isect1\n";
	print "@unique1\n";
	print "@minus\n";
