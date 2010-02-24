#!/usr/bin/perl
use strict;
use lib '../blib/lib';
use lib '../blib/arch';
use lib './blib/lib';
use lib './blib/arch';
use utf8;
use sapnwrfc;
use Data::Dumper;
my $Username = "SCHRÖDER";
#my $Username = "developer";
SAPNW::Rfc->load_config;
print "Testing SAPNW::Rfc-$SAPNW::Rfc::VERSION\n";
my $conn = SAPNW::Rfc->rfc_connect();
my $Rcb = $conn->function_lookup( "BAPI_USER_GET_DETAIL" );
my $Iface = $Rcb->create_function_call;
$Iface->USERNAME( $Username );
$Iface->invoke;
warn Dumper($Iface);
