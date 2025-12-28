#!/usr/bin/perl

$integer = 200;
$negative = -300;
$floating = 200.35;
$bigfloat = -1.2E-15;
$octal = 0377;
$hexa = 0xff;

print "integer = $integer\n";
print "negative = $negative\n";
print "floating = $floating\n";
print "bigfloat = $bigfloat\n";
print "octal = $octal\n";
print "hexa = $hexa\n";

$str = "hello";
$num = 5 * 10;
$mix = $str . $num;
print "$mix \n"; 

@array = (1, 2, 'hello');
@arry = qw/ this is a arrayTest /;
$size = @array;
$max_index = $#array;

print "size of the array : $size\n";
print "max Index : $max_index\n";

@array2 = @array[1,2];
print "@array2 \n";


#parcourir tous les values dans une list 
foreach $a (@array){
	print "a is : $a\n";
}


@var_10 = (1..10);
print "@var_10";

#d�finir les donn�e HASH
%data = ('google'=>'goole.com', 'runnob'=>'runnob.com','taobao'=>'taobao.com');
$data{'facebook'} = "facebook.com";
delete $data{'facebook'};
if(exists($data{'facebook'})){
	print " facebook is : $data{'facebook'} \n";
}else{
	print "there is not the facebook in the data \n";
}

$a = 60;
$b = 13;
print "$a&$b \n";
$c = $a & $b;
print "$c";

$t = qx{date};
#print "qt{date} = $t \n";

$datestring = localtime();
print "the date is : $datestring";

#create une fonction using Sub
sub PrintHASH {
	my (%hash) = @_;
	foreach $item (%hash){
		print "the item is  : $item \n";
	}
}

%hashtest = ('name'=>'chen', 'last name'=>'tong');

$scref = \&PrintHASH;
&$scref(%hashtest);