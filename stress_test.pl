#!/usr/bin/perl
use lib '../blib/lib';
use lib '../blib/arch';
use lib './blib/lib';
use lib './blib/arch';
use constant ITER => 50000;
use warnings;
use Carp;

use utf8;
use sapnwrfc;

$| = 1;
my $test_total = 0;

print "Testing SAPNW::Rfc-$SAPNW::Rfc::VERSION\n";
SAPNW::Rfc->load_config;
my $conn;
eval { $conn = SAPNW::Rfc->rfc_connect; };
if ($@) {
  print STDERR "RFC Failure to connect: $@\n";
	die $@;
}
print "\n";

my $cnt = 0;
eval {
  my $conn = SAPNW::Rfc->rfc_connect;
  my $fd = $conn->function_lookup("Z_TEST_DATA");
  foreach (1..ITER) {
    my $fc = $fd->create_function_call;
    $fc->CHAR("German: öäüÖÄÜß");
    $fc->INT1(123);
    $fc->INT2(1234);
    $fc->INT4(123456);
    $fc->FLOAT('123456.00');
    $fc->NUMC('12345');
    $fc->DATE('20060709');
    $fc->TIME('200607');
    $fc->BCD('200607.123');
    $fc->ISTRUCT({ 'ZCHAR' => "German: öäüÖÄÜß", 'ZINT1' => 54, 'ZINT2' => 134, 'ZIT4' => 123456, 'ZFLT' => '123456.00', 'ZNUMC' => '12345', 'ZDATE' => '20060709', 'ZTIME' => '200607', 'ZBCD' => '200607.123' });
    $fc->DATA([{ 'ZCHAR' => "German: öäüÖÄÜß", 'ZINT1' => 54, 'ZINT2' => 134, 'ZIT4' => 123456, 'ZFLT' => '123456.00', 'ZNUMC' => '12345', 'ZDATE' => '20060709', 'ZTIME' => '200607', 'ZBCD' => '200607.123' }]);
    $fc->invoke;
		my $echar = $fc->ECHAR;
		$echar =~ s/\s+$//;
    ok(scalar(@{$fc->DATA}) == 2);
	ok($fc->EINT1 == $fc->INT1);
	ok($fc->EINT2 == $fc->INT2);
	ok($fc->EINT4 == $fc->INT4);
	ok($fc->EFLOAT == $fc->FLOAT);
	ok($fc->ENUMC eq $fc->NUMC);
	ok($fc->EDATE eq $fc->DATE);
	ok($fc->ETIME eq $fc->TIME);
	ok($fc->EBCD == $fc->BCD);
	ok($echar eq $fc->CHAR);
	ok($fc->ESTRUCT->{ZINT1} == $fc->ISTRUCT->{ZINT1});
	ok($fc->ESTRUCT->{ZINT2} == $fc->ISTRUCT->{ZINT2});
	ok($fc->ESTRUCT->{ZIT4} == $fc->ISTRUCT->{ZIT4});
	ok($fc->ESTRUCT->{ZFLT} == $fc->ISTRUCT->{ZFLT});
	ok($fc->ESTRUCT->{ZBCD} == $fc->ISTRUCT->{ZBCD});
	ok($fc->ESTRUCT->{ZNUMC} eq $fc->ISTRUCT->{ZNUMC});
	ok($fc->ESTRUCT->{ZDATE} eq $fc->ISTRUCT->{ZDATE});
	ok($fc->ESTRUCT->{ZTIME} eq $fc->ISTRUCT->{ZTIME});
	$echar = $fc->ESTRUCT->{ZCHAR};
	$echar =~ s/\s+$//;
	ok($echar eq $fc->ISTRUCT->{ZCHAR});
	ok($fc->DATA->[0]->{ZINT1} == $fc->ISTRUCT->{ZINT1});
	ok($fc->DATA->[0]->{ZINT2} == $fc->ISTRUCT->{ZINT2});
	ok($fc->DATA->[0]->{ZIT4} == $fc->ISTRUCT->{ZIT4});
	ok($fc->DATA->[0]->{ZFLT} == $fc->ISTRUCT->{ZFLT});
	ok($fc->DATA->[0]->{ZBCD} == $fc->ISTRUCT->{ZBCD});
	ok($fc->DATA->[0]->{ZNUMC} eq $fc->ISTRUCT->{ZNUMC});
	ok($fc->DATA->[0]->{ZDATE} eq $fc->ISTRUCT->{ZDATE});
	ok($fc->DATA->[0]->{ZTIME} eq $fc->ISTRUCT->{ZTIME});
	$echar = $fc->DATA->[0]->{ZCHAR};
	$echar =~ s/\s+$//;
	ok($echar eq $fc->ISTRUCT->{ZCHAR});
    my $len = 0;
    map { map { $len += length("$_") } (keys %{$_}, values %{$_}) } @{$fc->DATA};
    map { map { $len += length($_) } (keys %{$_}, values %{$_}) } @{$fc->DATA};
        $cnt++;
        print "\r", "Count: ", $cnt, "\t$len";
  }
  print "\n";
  $conn->disconnect;
  print "Test total: $test_total\n";
};
if ($@) {
  print STDERR "RFC Failure in Z_TEST_DATA (set 2): $@\n";
}

sub ok {
  my $test = shift;

  carp "test failed!\n" unless $test;
  $test_total += 1;
}
