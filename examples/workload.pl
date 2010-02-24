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
 my $rd = $conn->function_lookup("SWNC_GET_WORKLOAD_STATISTIC");
# print "Function lookup: ".Dumper($rd);
 my $rc = $rd->create_function_call;
 print "Function create: ".Dumper($rc);

 $rc->INSTANCE("TOTAL");
 $rc->PERIODSTRT("20090618");
 $rc->PERIODTYPE("M");
 $rc->SELECT_SYSTEM("gecko");
 $rc->SUMMARY_ONLY("X");
 $rc->SYSTEMID("N4S");
 $rc->invoke;
 print "function result: ".Dumper($rc)."\n";
 $conn->disconnect;
 exit(0);

 # BDL_SERVER_PING  DESTINATION_CHECKED = NONE , DESTINATION_OK   
   
