use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'WebFramework',
    VERSION_FROM      => 'lib/WebFramework.pm',
    PREREQ_PM         => {
        'Config'                => '0'    , # the Config module doesn't have $VERSION
        'File::Spec::Functions' => '3.251', # version in Debian Lenny
        'Exporter'              => '5.58' ,
        'FCGI'                  => '0.67' , # version in Debian Lenny
        'Template'              => '2.19' , # version in Debian Lenny
        'JSON'                  => '2.07' , # version in Debian Lenny
        'Test::Perl::Critic'    => '1.01' , # version in Debian Lenny
        'Carp'                  => '1.04' ,
        'HTTP::Status'          => '1.28' , # found in "libwww-perl" CPAN and Debian packages
        'CGI::Cookie'           => '1.26' ,
        'CGI::Util'             => '1.5'  ,
        'MIME::Types'           => '1.24' , # version in Debian Lenny
        'Test::Exception'       => '0.27' ,
        'Test::More'            => '0.94' ,
        'HTTP::Body'            => '1.06' , # really need at least '1.06' for auto cleanup of tmp files
    },
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
        (ABSTRACT_FROM  => 'lib/WebFramework.pm', # retrieve abstract from module
         AUTHOR         => 'Peter Michaux <petermichaux@gmail.com>') : ()),
);
