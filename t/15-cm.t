use strict;
use warnings;
use Test::More;

use RPi::HCSR04;

my $mod = 'RPi::HCSR04';

{
    my $o = $mod->new(23, 24);
    my $cm = $o->cm;
    like $cm, qr/^\d+\.\d+$/, "float is returned";
}

done_testing();
