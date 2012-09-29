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
use Akado::Account;

# global vars

# subs

# main
sub main {

    my $file = lib::abs::path('./akado_login_password');
    my ($login, $password) = read_file($file, chomp => 1);

    my $aa = Akado::Account->new({
        login => $login,
        password => $password,
    });

    p $aa->get_balance();
    p $aa->get_next_month_payment();

    say '#END';
}

main();
__END__
