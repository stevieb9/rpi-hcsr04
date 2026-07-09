use strict;
use warnings;
use Test::More;

use RPi::HCSR04;

# HW-free: stub the one XS hardware call new() makes (_setup / wiringPi) so
# construction and validation run off-board, with no Pi and no sensor.
{
    no warnings 'redefine';
    *RPi::HCSR04::_setup = sub { };
}

my $mod = 'RPi::HCSR04';

# --- new() returns a real, per-instance blessed object (F11) ---
{
    my $o = $mod->new(23, 24);
    ok ref($o), 'new() returns a reference (previously the class-name string)';
    isa_ok $o, $mod;
    is $o->_trig, 23, '  trig pin stored on the instance';
    is $o->_echo, 24, '  echo pin stored on the instance';
}
{
    my $a = $mod->new(5, 6);
    my $b = $mod->new(17, 27);
    is $a->_trig, 5,  'instance A keeps its own trig pin';
    is $b->_trig, 17, 'instance B keeps its own trig pin (not shared global state)';
}

# --- new() argument validation ---
{
    my $ok = eval { $mod->new; 1 };
    is $ok, undef, 'new() dies with no params';
    like $@, qr/new\(\) requires/, '  ...error ok';

    $ok = eval { $mod->new(23); 1 };
    is $ok, undef, 'new() dies with only a single param';
    like $@, qr/new\(\) requires/, '  ...error ok';
}

# --- pin range validation (F12: the '&&' guard was dead code) ---
{
    my $o = $mod->new(23, 24);

    for my $bad (-1, 41, 100){
        my $ok = eval { $o->_trig($bad); 1 };
        is $ok, undef, "_trig($bad): out-of-range pin dies";
        like $@, qr/out of range/, '  ...error ok';
    }

    is $o->_trig(0),  0,  '_trig(0): lower bound accepted';
    is $o->_trig(40), 40, '_trig(40): upper bound accepted';
    is $o->_echo(24), 24, '_echo(24): in-range accepted';
}

done_testing();
