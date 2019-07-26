#!usr/bin/perl -w
use strict;

my @a = qw(one two three);

my @a1 = splice @a,3,1;
print "@a1";
