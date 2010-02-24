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
my $conn = SAPNW::Rfc->rfc_connect;
my $rd = $conn->function_lookup("Z_PHARDING_NO_PARMS");
warn "Function lookup: ".Dumper($rd);

for my $i (0..50000) {
    my $rc = $rd->create_function_call;
    $rc->invoke;
    warn "function call.$i..\n";
}

$conn->disconnect;
exit(0);
