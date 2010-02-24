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
 my $fdl = $conn->function_lookup("BAPI_XMI_LOGON");
 my $fcl = $fdl->create_function_call;
 $fcl->EXTCOMPANY("SERCOM");
 $fcl->EXTPRODUCT("BIGBROTHER");
 $fcl->INTERFACE("XAL");
 $fcl->parameter("VERSION")->value("1.0");

 my $rd = $conn->function_lookup("BAPI_SYSTEM_MTE_GETPERFCURVAL");
 my $rc = $rd->create_function_call;
 $rc->EXTERNAL_USER_NAME("BIGBROTHER");
 $rc->invoke;
 print "CURRENT_VALUE: ".Dumper($rc->CURRENT_VALUE);
 $conn->disconnect;
 exit(0);
