#!/usr/bin/perl
use strict;
use lib '../blib/lib';
use lib '../blib/arch';
use lib './blib/lib';
use lib './blib/arch';

use sapnwrfc;
use Data::Dumper;
SAPNW::Rfc->load_config;
my $conn = SAPNW::Rfc->rfc_connect;
my $rd = $conn->function_lookup("RFC_READ_TABLE");
my $rc = $rd->create_function_call;
$rc->QUERY_TABLE("TBTCO");
$rc->FIELDS([{'FIELDNAME' => 'JOBNAME'},{'FIELDNAME' => 'JOBCOUNT'},{'FIELDNAME' => 'STRTDATE'}]);
$rc->ROWCOUNT(10);
$rc->invoke;
warn "function result: ".Dumper($rc->DATA)."\n";
$conn->disconnect;
exit(0);
