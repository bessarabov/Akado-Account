package WWW::Provider::Akado;

use strict;
use warnings FATAL => 'all';
use DDP; # TODO bes - remove it
use Carp;
use WWW::Mechanize;
use LWP::Debug qw(+); # TODO bes - remove debug

=head1 NAME

WWW::Provider::Akado - The great new WWW::Provider::Akado!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use WWW::Provider::Akado;

    my $foo = WWW::Provider::Akado->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 new

TODO bes - pod for new()

=cut

sub new {
    my ($class, $self) = @_;

    croak 'No login specified, stopped' unless $self->{login};
    croak 'No password specified, stopped' unless $self->{password};

    $self->{site} ||= 'https://office.akado.ru/';

    bless($self, $class);
    return $self;
}

# TODO bes - pod get_data()

sub get_data {
    my ($self) = @_;

    my $mech = WWW::Mechanize->new(
        agent => "WWW::Provider::Akado/$VERSION"
    );

    $mech->get( $self->{site} . "/login.xml" );

    $mech->submit_form(
        form_number => 1,
        fields      => {
            login    => $self->{login},
            password => $self->{password},
        }
    );

    return $mech->content;

    return '';
}

=head1 AUTHOR

Ivan Bessarabov, C<< <ivan at bessarabov.ru> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-provider-akado at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Provider-Akado>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Provider::Akado


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Provider-Akado>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Provider-Akado>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Provider-Akado>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Provider-Akado/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Ivan Bessarabov.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of WWW::Provider::Akado
