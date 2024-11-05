#!/usr/bin/perl

print "hello perl\n";
print 'hello world';
#commantaire
print ("helle perl \n");

=pod cut
 comment first line
 comment second line
=cut

$a = 10;
$var = <<"EOF";
this is a here document, use two 
we can get the value of : a = $a
like this answer
EOF
print "$var\n";


print "\$result \n";
$limite = "2";
$res = $limite-9;
print $res."\n";


=DOC
$mytest = 123;
print $mytest;
$myseconde = 123;

@arr = (1,2,3);
print @arr[0];
=cut

# %h = ('a'=> 1, 'we' => 2);

@age = (25,30,45);
print "\$age[0] = $age[0] \n ";
print "\$age[1] = $age[1] \n ";

print "name of the file is : ". __FILE__."\n";
print "name of the line is : ". __LINE__. "\n";
print "name of the package is :". __PACKAGE__."\n";


package Person;
sub new {
	my $class = shift;
	my $self = {
		_firstName => shift,
		_lastName => shift,
		_ssn => shift,	
	};
	#input these informations of the users
	print "name is:  $self -> {_firstName}\n";
	print "the last name is : $self -> {_lastName} \n";
	print "the numberis : $self -> {ssn} \n";
	bless $self, $class;
	return $self;
}

#use Person;
#$object = new Person ()