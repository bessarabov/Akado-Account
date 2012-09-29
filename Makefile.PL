use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Akado::Account',
    AUTHOR              => q{Ivan Bessarabov <ivan@bessarabov.ru>},
    VERSION_FROM        => 'lib/Akado/Account.pm',
    ABSTRACT_FROM       => 'lib/Akado/Account.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'lib::abs' => 0,
        'File::Slurp' => 9999.17,
        'LWP' => 0,
        'XML::Simple' => 0,
        'Digest::MD5' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Akado-Account-*' },
);
