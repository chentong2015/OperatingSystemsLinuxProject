#!/usr/bin/perl

open(DATA, "<input.txt") or die "can't open the file !";
open(DATA2, ">>output.txt") or die "can't open the file !";
@line = <DATA>;
print @line;

while(<DATA>){
	#print DATA2 "$_";
	print DATA2 "test";
}

close(DATA);
close(DATA2);
print "\n";

open(DATA, "<sa_b.tei") or die "sa_b.tei open failed !";
@lines = <DATA>;
print "K" . @lines[1];
close(DATA);


# sysopen(DATA, "sa_b.tei", O_RDWR);
print "The website is : \n";
# $name = <STDIN>;  #input from the console
# print "the website is : $name \n";


#definition beforing usging 
format MYFILE = # 与文件变量同名 
=================================
   This is a test for testing 
=================================
.

if (open(MYFILE, ">>output.txt")) {
	$~ = "MYFORMAT";
	write MYFILE; 
	close MYFILE;
}

$dir = "../tmp/*";
my @files = glob($dir); #get all the files in the directory
foreach (@files){
	print $_ . "\n";
}

#get all the file in this directory
opendir (DIR, '.') or die "can't open this dir";
while ($file = readdir DIR){
	print "$file \n";
}
closedir DIR;

#当前循环的字符串会放在 $_ 中, 然后 通过 print 输出, 默认情况下使用的也是 $_。
foreach ('Google', 'Runoob', 'Baidu'){
	#在没有给出其他变量时是 "foreach" 循环的默认迭代变量。
	print;
	print "\n";
}

$string = 'welconme to runoob site';
$string =~ tr/a-z/A-Z/;
print "$string\n";