use strict;
use warnings;
use Test::More;

use RPi::HCSR04;

my $mod = 'RPi::HCSR04';

{
    my $o = $mod->new(23, 24);

    my $r = $o->raw;
    like $r, qr/^\d+$/, "integer is returned";
}

done_testing();
