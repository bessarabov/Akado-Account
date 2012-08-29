#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'WWW::Provider::Akado' ) || print "Bail out!
";
}

diag( "Testing WWW::Provider::Akado $WWW::Provider::Akado::VERSION, Perl $], $^X" );
