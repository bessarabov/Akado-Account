#!/usr/bin/perl

=encoding UTF-8
=cut

=head1 DESCRIPTION

=cut

# common modules
use strict;
use warnings FATAL => 'all';
use 5.010;
use DDP; # TODO bes - remove it
use Carp;
use File::Slurp;

# project modules
use lib::abs qw(../lib);
use WWW::Provider::Akado;

# global vars

# subs

# main
sub main {

    my $file = lib::abs::path('./akado_login_password');
    my ($login, $password) = read_file($file, chomp => 1);

    my $wpa = WWW::Provider::Akado->new({
        login => $login,
        password => $password,
    });

    p $wpa->get_balance();

    # start here
    say '#END';
}

main();
__END__
