use strict;
use warnings;
use Test::More;

use RPi::HCSR04;

my $mod = 'RPi::HCSR04';

{
    my $o = $mod->new(23, 24);

    my $ok = eval { $mod->new; 1; };
    is $ok, undef, "new() dies with no params";
    like $@, qr/new\(\) requires/, "...error ok";

    $ok = eval { $mod->new(23); 1; };
    is $ok, undef, "new() dies with only a single param";
    like $@, qr/new\(\) requires/, "...error ok";

}

done_testing();
