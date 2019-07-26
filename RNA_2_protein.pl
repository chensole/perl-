#!usr/bin/perl -w
use strict;
 
# File Name: RNA_2_protein.pl
# Author: chensole
# mail: 1278371386@qq.com
# Created Time: 2019-07-24

## ------------------------------------------ Main program ----------------------------------------------


## -------------------------------------------------  Code Hash table -----------------------------------------------------------

my %code = qw(	
TCA	S
TCC	S
TCG	S
TCT	S
TTC	F  
TTT	F  
TTA	L
TTG	L
TAC	Y
TAT	Y
TAA	_
TAG	_
TGC	C
TGT	C
TGA	_
TGG	W
CTA	L
CTC	L
CTG	L
CTT	L
CCA	P
CCC	P
CCG	P
CCT	P
CAC	H
CAT	H
CAA	Q
CAG	Q
CGA	R
CGC	R
CGG	R
CGT	R
ATA	I
ATC	I
ATT	I
ATG	M
ACA	T
ACC	T
ACG	T
ACT	T
AAC	N
AAT	N
AAA	K
AAG	K
AGC	S
AGT	S
AGA	R
AGG	R
GTA	V
GTC	V
GTG	V
GTT	V
GCA	A
GCC	A
GCG	A
GCT	A
GAC	D  
GAT	D  
GAA	E  
GAG	E  
GGA	G 
GGC	G 
GGG	G 
GGT	G
);

my $file = shift;
my $singlefile = "singlefile.fasta";


print ">>>>>>>>>>>>>>>>>>>> First check the file format >>>>>>>>>>>>>>>>>>>>>>>>\n";
my $linetype = test_file($file);
#print "$linetype\n";

## ------- 多行sequence转换为单行sequence

# 实现思路：每次读入一行，当读到ID行，保存ID，当非ID行时，连接所有序列行，当读到下一个ID时，打印上一个ID所对应的序列。如此往复。读到最后一个ID时，要注意输出其对应的序列

# 思想很重要,这种思想很重要

if (!$linetype) {

	open I,$file or die "$!";
	open O,">$singlefile" or die "$!";
	my $seq = "";
	while (my $line = <I>) {
		chomp $line;

		if ($line =~ /^>/) {
			if ($seq ne "") {
				
				print O "$seq\n";     
			}
			$seq = "";
			print O "$line\n";
		}
		
		if ($line =~ /^[ATCG]/i) {
			$seq .= $line;
			
		}
	
		
	}
	print O "$seq\n";     # 打印最后一个ID所对应的序列行

	close O;
	close I;
	
	$file = $singlefile;

}


#print "$file\n";
#
my ($test1,$test2,$test3) = checkformat($file);

if ($test1) {

		print STDERR "Input file format is not like Fasta,please check\n";
		exit;
}

if ($test2) {

		print STDERR "The sequence have a invaild alphabet\n";
		exit;
}
#print "$test3\n";
print "Now, I can translation the sequence to protein\n";
my %results;



if ($test3) {
	
	print STDERR "the sequence is the RNA sequence\nTransformed RNA to DNA\n";
	open I, $file or die "$!";

	while (my $line = <I>) {
		chomp $line;
		my $id = $line;
		my $seq = <I>;
		$seq = RNA_DNA($seq);
		my $inputseq = find_code_seq($seq);
		my $protein = translation($inputseq);

		$results{$id} = $protein;

	}	

}else {

     open I, $file or die "$!";
 
     while (my $line = <I>) {
         chomp $line;
         my $id = $line;
         my $seq = <I>;
		 #print "$seq\n";
		 #print "$seq\n";
         my $inputseq = find_code_seq($seq);
		 #print $inputseq."\n";
         my $protein = translation($inputseq);
 
         $results{$id} = $protein;
 
     }   

}
#
#
print "The work is finished ! Now print the outputs......\n";

map {if (defined($results{$_})) {print "$_\n$results{$_}\n"}} keys %results;


## ---------------------------------------  Subroutine -----------------------------------------------------------

## ----- test the sequence whther belong to singleline 

sub test_file {

	my $file = shift;
	open I ,$file or die "$!";
	my $singleline = 0;
	my $count1 = 0;
	my $count2 = 0;
	while (my $line = <I>) {
		chomp $line;
		if ($line =~ /^>/) {
		
				$count1 += 1;
		
		}else {
		
				$count2 += 1;
		
		}
	
	}
	close I;
	
	if ($count1 == $count2) {
	
		$singleline = 1;    # ID 和 sequence 各占一行
	}else {
	
		$singleline = 0;    # sequence 为多行
	}

	return $singleline;

}

# -------- RNA 转换为 DNA 
sub RNA_DNA {

	my $seq = shift;
	$seq =~ tr/Uu/TT/;
	return $seq;
}


# ----------- 检查输入文件格式 (若序列为多行首先要将序列转换为单行) --------- 便于代码的实现

# 1.序列中是否有 N
# 2.序列是 DNA 还是 RNA
# 3.是否为正确的fasta格式，即序列ID是否以 > 开头

sub checkformat {

	my $file = shift;
	open I, $file or die "$!";
	my ($echo1,$echo2,$echo3) = (0,0,0);
	while (my $line = <I>) {
		if ($. % 2 == 1) {
			
				if ($line !~ /^>\w+/) {
				
				
					$echo1 = 1;   # 首行是否为ID行
			}
		}
		if ($. % 2 == 0) {
		
			
				if ($line =~ /N/i) {
				
				
					$echo2 = 1;	   # 序列中是否有 N
			}else {
			
				if ($line =~ /U/i) {
					
						$echo3 = 1;  #序列是否含有 U
					
				}
			
			}	
			
		}	
		
	}

	return ($echo1,$echo2,$echo3);	
}


# ---------- 确定序列中是否具有编码区

#1. 先对原序列利用正则表达式，开头ATG，结尾以 TAA 或 TAG 或 TGA，这样的情况属于编码区
#2. 若第一步没有找到编码区，可以尝试对原序列进行变换得到反向互补链，然后对反向互补序列再次进行匹配
#3. 若上述两个步骤都未找到编码区，那么输出未找到的信息

sub find_code_seq {
	my $seq = shift;
	my $input;
	if ($seq =~ /(ATG)((?:\w{3})+)((?:TAA)|(?:TAG)|(?:TGA))$/) {
			
			$input = $1.$2.$3; 
		
	}else {
		
			$seq = revcom($seq);
		
			if ($seq =~ /(ATG)((?:\w{3})+)((?:TAA)|(?:TAG)|(?:TGA))$/) {
					$input = $1.$2.$3;
			
			}else {
					print "I don't find CDS region\n";
					
			}
			
	}
	return $input;
}




# ---------- 得到序列的反向互补序列

sub revcom {

	my $seq = shift;
	$seq = reverse($seq);
	$seq =~ tr/ATCG/TAGC/;
	return $seq;
}





# ----------- 密码子翻译

# 利用密码子哈希表对序列进行翻译
sub translation {
	
	my $seq = shift;
	my @tmp = $seq =~ /(\w{3})/g if ($seq);
	my $protein;
	
	for (my $i = 0; $i < $#tmp; $i++) {
		if (exists $code{$tmp[$i]}) {
			$protein .= $code{$tmp[$i]};
		}
		
	}
	return $protein;

}









