use Test::More;
use Data::Dumper;
use sapnwrfc;

plan tests => 2;
#TODO: interestingly, SAPNW::Base::RFCTYPE_INT was not defined if i use_ok, but is if i 'use'
#use_ok("sapnwrfc");

print "Testing SAPNW::Rfc-$SAPNW::Rfc::VERSION\n";
SAPNW::Rfc->load_config;
my $conn = SAPNW::Rfc->rfc_connect;

{
	my $rd = $conn->function_lookup("SWNC_COLLECTOR_GET_AGGREGATES");
	my $rc = $rd->create_function_call;
	$rc->COMPONENT("TOTAL");
	$rc->PERIODTYPE("D");

	$rc->SUMMARY_ONLY("X");
	my $factor = 10;
	use Devel::Peek;
	print  "peek at $factor (printing it makes it dualvar)\n";
	Dump($factor);
	$rc->FACTOR($factor);

	my $rc_param = $rc->parameter( uc('PERIODSTRT') );
	my $value = '20130115';
	use Devel::Peek;
	print  "peek at $value \n";
	Dump($value);
	$rc_param->value($value);


	eval {$rc->invoke;};
	ok(!$@, "RFC Error: $@\n");
}


#and now the looping conversion issue - something causes the strings to be dualvar too
{
	my $params = {
		SUMMARY_ONLY => 'X',
		COMPONENT => 'TOTAL',
		PERIODTYPE => 'D',
		FACTOR => '10', #string, as its coming in from a text file
		PERIODSTRT => '20130115'
	};

	my $rd = $conn->function_lookup("SWNC_COLLECTOR_GET_AGGREGATES");
	my $rc = $rd->create_function_call;

    foreach my $key ( qw/FACTOR COMPONENT PERIODTYPE PERIODSTRT/ ) {
        my $rc_param = $rc->parameter( uc($key) );
        if ( defined($rc_param) ) {
            my $cgi_param = $params->{$key};    #$pHash{$key};  #
            $cgi_param =~ /(.*)/;
            my $untained_cgi_param = "$1";

print "===================== rc_param $key is type:".$rc_param->type()."\n";

            if (   ( $rc_param->type() eq SAPNW::Base::RFCTYPE_INT )
                or ( $rc_param->type() eq SAPNW::Base::RFCTYPE_INT1 )
                or ( $rc_param->type() eq SAPNW::Base::RFCTYPE_INT2 ) )
            {
                #convert to integer
                my $ivalue = 0+$untained_cgi_param;

               use Devel::Peek;
   #WHATEVER YOU DO, DON'T print $ivalue, or do anything that could dual-var it.
print  '----'.$params->{_DEFAULT}.': '.uc($key)." set to string $value ";#.ref(\$value)."\n";
               Dump($ivalue);
                $rc_param->value($ivalue);
            }
            else {
                my $value = $untained_cgi_param;

#                use Devel::Peek;
print  '----'.$params->{_DEFAULT}.': '.uc($key)." set to string $value ".ref(\$value)."\n";
                Dump($value);
                $rc_param->value($value);

            }
        }
    }

	eval {$rc->invoke;};
	ok(!$@, "RFC Error: $@\n");
}