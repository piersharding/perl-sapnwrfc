#!/usr/bin/perl
use strict;
#use utf8;

use lib '../blib/lib';
use lib '../blib/arch';
use lib './blib/lib';
use lib './blib/arch';

use sapnwrfc;
use Data::Dumper;
SAPNW::Rfc->load_config;
print "Testing SAPNW::Rfc-$SAPNW::Rfc::VERSION\n";
 my $server = SAPNW::Rfc->rfc_register(
                           tpname   => 'wibble.rfcexec',
                           gwhost   => 'gecko.local.net',
                           gwserv   => '3301',
                           trace    => '1',
#                           );
                           debug => 1 );
 # $p = SAPNW::RFC::Import->new(name => $name, type => $type, len => $len, ulen => $ulen, decimals => $decimals) 
  my $func = new SAPNW::RFC::FunctionDescriptor("MY_TEST");
  $func->addParameter(new SAPNW::RFC::Export(name => "COMMAND", 
                                             len => 10,
                                             type => RFCTYPE_CHAR));
  $func->addParameter(new SAPNW::RFC::Import(name => "HELLO", 
                                             len => 10,
                                             ulen => 20,
                                             decimals => 0,
                                             type => RFCTYPE_CHAR));
  $func->callback(\&do_test);
  $server->installFunction($func);
  $server->accept(5, \&do_global_callback); 
  $server->disconnect();

  sub do_test {
    my $func = shift;
    my $ls = $func->COMMAND;
    $func->HELLO('Test');
    warn "in do_test: $ls \n";
    return 1;
  }

  sub do_global_callback {
    warn "Running global callback ...\n";
    return 1;
  }
