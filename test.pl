use strict;
use Test;
use UNIVERSAL qw(isa);

BEGIN { 
sub Dummy {return join ' ', @_}

plan tests => 8, todo => [] }

use Sub::Curry;



my $test_1 = curry \&Dummy, 'a', 'b';
ok(isa($test_1,'CODE'));
ok($test_1->('c'),'a b c');

my $hole = Sub::Curry::Hole;
ok(isa($hole,'Sub::Curry::Hole'));

for my $n (1..3) {
    my @holes=Sub::Curry::Hole($n);
    ok($#holes,$n-1);
}

my $test_2 = curry sub { return join ' ', @_ }, 'a', Sub::Curry::Hole, 'b';
ok(isa($test_2,'CODE'));
ok($test_2->('c'),'a c b');
