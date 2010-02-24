#!/usr/bin/perl
use strict;
use lib '../blib/lib';
use lib '../blib/arch';
use lib './blib/lib';
use lib './blib/arch';

use sapnwrfc;
use Data::Dumper;
SAPNW::Rfc->load_config;
print "Testing SAPNW::Rfc-$SAPNW::Rfc::VERSION\n";
my $conn = SAPNW::Rfc->rfc_connect( ashost => 'gecko.local.net', user => 'developer', passwd => 'developer');
for (1..50000) {
 warn Dumper($conn->connection_attributes)."\n";
}
my $rd = $conn->function_lookup("RPY_PROGRAM_READ");
# print "Function lookup: ".Dumper($rd);
# my $rc = $rd->create_function_call;
# print "Function create: ".Dumper($rc);
$conn->disconnect;
exit(0);
