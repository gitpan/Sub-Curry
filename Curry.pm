package Sub::Curry;

=head1 NAME

Sub::Curry - Perl module to curry functions ((á la Lisp)).

=head1 SYNOPSIS

	use Sub::Curry;
	
	sub dummy {
		return @_;
	}

	$curried_func1 = curry (&dummy, "hello", "world");
	$curried_func2 = curry (&dummy, "hello", Sub::Curry::Hole,    "world");
	$curried_func3 = curry (&dummy, "hello", Sub::Curry::Hole(2), "world");
	
	# returns ("hello", "world", "brave", "new")
	&$curried_func1("brave", "new");
	
	# returns ("hello", "new", "world", "brave")
	&$curried_func2("brave", "new");
	
	# returns ("hello", "brave", "new", "world")
	&$curried_func3("brave", "new");

=cut

=head1 DESCRIPTION

This module gives a simple method to curry functions as I (think I) undertand 
it. I can't really see why anyone would want to do such a thing, but then, there's 
At Least One Way To Do It, right ;)

If you don't know what currying is then just ignore it... you'll never
need it anyhow. Altenately consult (for example) the book at 
ftp://ftp.inria.fr/lang/caml-light/cl74tutorial.txt, which explains it in very (too) 
much detail (chapter 4.6.2).

The process is not quite as painless as in true functional languages, so you get
a anonymous function reference instead of a real function back.


It is possible to leave holes in the parameter list, by putting parameters of
the type Sub::Curry::Hole in the argument list to curry(). It is so convenient that 
the function with the same name does just that, and several if given the 
optional numerical parameter. These holes then remain uncurried and will 
swallow arguments from the argument list given to the curried function.


Perhaps the main reason for making this package is to avoid it being included
in perl6 syntax, as per one dangerous looking RFC. That I think would be a 
pretty bad idea.


Happy hacking.

=cut

use strict;
use Exporter;
use vars qw(@ISA @EXPORT $VERSION);

BEGIN {
	@ISA         = qw(Exporter);
	@EXPORT      = qw(&curry);

	$VERSION = "0.10";
}

=head1 FUNCTIONS

=over 4

=item curry &function, @args

This is our engine. Takes a function and some arguments and returns a subref
to a function that calls the given function with arguments _plus_ whatever
arguements are sent to it. Also you can leave holes in the argument list with 
Sub::Curry::Hole objects.

=cut

sub curry (\&;@) {
	my ($funcref, @spice) = @_;

	return  sub {
				my @total;
				my $count = 0;
				foreach (@spice) {
					if (ref $_ eq "Sub::Curry::Hole") {
						push @total, $_[$count];
						$count++;
					} else {
						push @total, $_;
					}
				}
				push @total, @_[$count..$#_];

				if (wantarray) {
					return &$funcref(@total);
				} else {
					return scalar &$funcref(@total);
				}
			};
}


=item Sub::Curry::Hole $number

Returns one or more Sub::Curry::Hole objects that are otherwise empty.

=cut 

sub Hole (;$){
	return map {bless \my $foo, "Sub::Curry::Hole"} (1..(shift||1));
}

=back

=head1 DIRECTIONS

One thing to consider is trying to comprehend subroutine prototypes. This would make 
curry much cooler. The other thing would be to create real subroutines, instead of 
just anonymous subrefs. 

Should Sub::Curry::Hole be exported or renamed.

=head1 COPYRIGHT

Copyright (c) 2000 by Davíð Helgason (dhns@uti.is). All rights reserved. This program is 
free software; you can redistribute it and/or modify it under the same terms as Perl itself. 

=cut

1;    # ;)