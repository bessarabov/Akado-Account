use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WWW::Provider::Akado',
    AUTHOR              => q{Ivan Bessarabov <ivan@bessarabov.ru>},
    VERSION_FROM        => 'lib/WWW/Provider/Akado.pm',
    ABSTRACT_FROM       => 'lib/WWW/Provider/Akado.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'lib::abs' => 0,
        'File::Slurp' => 9999.17,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WWW-Provider-Akado-*' },
);
