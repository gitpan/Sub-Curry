package Sub::Curry;

=head1 NAME

Sub::Curry - Perl module to curry functions ((� la Lisp)).

=head1 SYNOPSIS

    use Sub::Curry;
    
    sub dummy {
        return join ' ', @_;
    }
    
    *curried_func1 = curry (&dummy, 'hello', 'world');
    *curried_func2 = curry (&dummy, 'hello', Sub::Curry::Hole,    'world');
    *curried_func3 = curry (&dummy, 'hello', Sub::Curry::Hole(2), 'world');
    
    # returns ('hello world brave new')
    &curried_func1('brave', 'new');
    
    # returns ('hello brave world new')
    &curried_func2('brave', 'new');
    
    # returns ('hello brave new world')
    &curried_func3('brave', 'new');


    #### Real-life example :)   this is running somewhere in the world this very moment
    sub header {
        my ($self, $header, $value) = @_;
        $self->{headers}{$header} = $value if $value;
        return $self->{headers}{$header};
    }
    
    for (qw/cc bcc subject/) {
        no strict 'refs';
        *$_ = curry &header, Sub::Curry::Hole, $_;
    }
    
    print main->cc('some value');
    


=head1 DESCRIPTION

This module gives a simple method to curry functions as I (think I) undertand 
it. I can't really see why anyone would want to do such a thing, but then, 
there's At Least One Way To Do It, right ;)

(UPDATE: I just used this in a project! The code is the second example above!)

If you don't know what currying is then just ignore it... you'll never need it 
anyhow. Alternately consult (for example) the book at 
ftp://ftp.inria.fr/lang/caml-light/cl74tutorial.txt, which explains it in very 
(too) much detail (chapter 4.6.2).

The process is not quite as painless as in true functional languages, so you get 
a anonymous function reference instead of a real function back. However by 
assigning to a typeglob instead of a scalar, you create just that function.



It is possible to leave holes in the parameter list, by putting parameters of 
the type Sub::Curry::Hole in the argument list to curry(). It is so convenient 
that the function with the same name does just that, and several if given the 
optional numerical parameter. These holes then remain uncurried and will swallow 
arguments from the argument list given to the curried function.


Perhaps the main reason for making this package is to avoid it being included
in perl6 syntax, as per one dangerous looking RFC. That I think would be a 
pretty bad idea.

Thanks to Keli H. F. Hl��versson for making the tests and suggesting 
optimizations (as if they were needed).

Happy hacking.

=cut


use UNIVERSAL;
use strict;
use Exporter;
use vars qw(@ISA @EXPORT $VERSION);

BEGIN {
    @ISA         = qw(Exporter);
    @EXPORT      = qw(&curry);

    $VERSION = '0.07';
}


=head1 FUNCTIONS

=over 4

=item curry &function, @args

This is our engine. Takes a function and some arguments and returns a subref
to a function that calls the given function with arguments _plus_ whatever
arguements are sent to it. Also you can leave holes in the argument list with 
Sub::Curry::Hole objects.

=cut

sub curry (&;@) {
    my ($funcref, @spice) = @_;

    return sub {
               my $count = 0;
               foreach (@spice) {
                   splice @_, $count, 0, $_
                       unless UNIVERSAL::isa($_, 'Sub::Curry::Hole');
                   $count++;
               }
               goto &$funcref;
           };
}


=item Sub::Curry::Hole $number

Returns one or more Sub::Curry::Hole objects that are otherwise empty.

=cut 

sub Hole (;$){
    return map { bless [], 'Sub::Curry::Hole' } ( 1 .. ( shift || 1 ) ) if wantarray;
    return bless [], 'Sub::Curry::Hole';
}

=back


=head1 DIRECTIONS

One thing to consider is trying to comprehend subroutine prototypes. This would 
make curry much cooler.

Should Sub::Curry::Hole be exported somehow? or renamed?


=head1 COPYRIGHT

Copyright (c) 2002 by Dav�� Helgason (david@panmedia.dk). All rights 
reserved. This program is free software; you can redistribute it and/or modify 
it under the same terms as Perl itself. 

=cut


1;    # ;)
