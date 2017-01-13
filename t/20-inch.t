use strict;
use warnings;
use Test::More;

use RPi::HCSR04;

my $mod = 'RPi::HCSR04';

{
    my $o = $mod->new(23, 24);
    my $i = $o->inch;
    like $i, qr/^\d+\.\d+$/, "float is returned";
}

done_testing();
