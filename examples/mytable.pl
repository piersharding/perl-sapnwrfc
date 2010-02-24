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
 my $rd = $conn->function_lookup("Z_MY_RFC_HARD");
 warn "Function lookup: ".Dumper($rd);
 my $rc = $rd->create_function_call;
 warn "Function create: ".Dumper($rc);

$rc->IMPORT_ELEMENT( { 'OTYPE' => "AA", 'FIRST' => "The first desc", 'CAPABILITIES' => 
				        [ 
								  { 'OBJID' => "1", 'TEXT' => "The short text1" },
									{ 'OBJID' => "2", 'TEXT' => "The short text2" },
									{ 'OBJID' => "3", 'TEXT' => "The short text3" }
									] } );

 warn "function call...\n";
 $rc->invoke;
 warn "function result: ".Dumper($rc->EXPORT_ELEMENT)."\n";
 $conn->disconnect;
 exit(0);
