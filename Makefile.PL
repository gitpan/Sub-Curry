use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'    => 'Sub::Curry',
    'VERSION' => '1.05',
    'dist'    => { COMPRESS => 'gzip', SUFFIX => 'gz', },
    'AUTHOR'  => 'Davíð Helgason <david@panmedia.dk>',
);