package WWW::Provider::Akado;

=head1 NAME

WWW::Provider::Akado - get account info from internet provider Akado

=cut

our $VERSION = '0.01';

use strict;
use warnings FATAL => 'all';
use 5.010; # TODO bes - remove it
use DDP; # TODO bes - remove it
use utf8;
use Carp;
use LWP;
use HTTP::Request::Common;
use Digest::MD5 qw(md5_hex);
use XML::Simple;

=head1 SYNOPSIS

=head1 METHODS

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

=head2 get_balance

TODO bes - pod get_data()

=cut

sub get_balance {
    my ($self) = @_;

    my $data = $self->_get_cached_parsed_data();
    return $data->{balance};
}

sub get_next_month_payment {
    my ($self) = @_;

    my $data = $self->_get_cached_parsed_data();
    return $data->{next_month_payment};
}

sub _get_cached_parsed_data {
    my ($self) = @_;

    if (not defined $self->{_parsed_data}) {
        my $xml = $self->_get_full_account_info_xml();
        $self->{_parsed_data} = $self->_parse_xml($xml);
    }

    return $self->{_parsed_data};
}

sub _get_full_account_info_xml {
    my ($self) = @_;

    my $ua = LWP::UserAgent->new;
    $ua->agent("WWW::Provider::Akado/$VERSION");
    $ua->cookie_jar( {} );

    my $auth_response = $self->_get_auth_response($ua);
    my $data_response = $self->_get_data_response($ua);

    my $xml = $data_response->decoded_content;

    return $xml;
}

sub _parse_xml {
    my ($self, $xml) = @_;

    my $account_info = XMLin($xml);

    my $parsed_account_info;

    $parsed_account_info->{date} = $account_info->{date};

    if ($account_info->{status}->[3]->{description} eq "Остаток на счете") {
        $parsed_account_info->{balance} = $account_info->{status}->[3]->{amount};
    } else {
        croak "Got incorrect data structure.";
    }

    if ($account_info->{status}->[4]->{status}->[1]->{description}
        eq "Стоимость услуг в следующем месяце") {
        $parsed_account_info->{next_month_payment}
            = $account_info->{status}->[4]->{status}->[1]->{amount};
    } else {
        croak "Got incorrect data structure.";
    }

    return $parsed_account_info;
}

sub _get_auth_response {
    my ($self, $browser) = @_;

    my $url = $self->{site} . "/login.xml/login";
    my $md5 = uc(md5_hex($self->{password}));

    my $request = POST($url,
        Accept => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        Content => [
            login    => $self->{login},
            password => $md5,
        ]
    );

    my $response = $browser->request($request);
    $self->_check_response($response);

    return $response;
}

sub _get_data_response {
    my ($self, $browser) = @_;


    my $domain;

    $browser->{cookie_jar}->scan(
        sub {
            $domain = $_[4];
        }
    );

    $browser->{cookie_jar}->set_cookie(
        0,        # version, $key, $val,
        'render', # key
        'xml',    # value
        '/',      # $path
        $domain,
    );

    my $url = $self->{site} . "/account.xml";

    my $request = HTTP::Request->new(
        'GET',
        $url,
    );

    my $response = $browser->request($request);
    $self->_check_response($response);

    return $response;
}

sub _check_response {
    my ($self, $response) = @_;

    my $url = scalar $response->request->uri->canonical;
    if ($response->is_error) {
        croak "Can't get url '$url'. Got error "
            . $response->status_line;
    }

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
