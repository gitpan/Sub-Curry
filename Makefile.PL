use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Sub::Curry',
	'VERSION'	=> '0.04',
	'dist'		=> { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
