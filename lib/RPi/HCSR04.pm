package RPi::HCSR04;

use strict;
use warnings;

require XSLoader;
XSLoader::load('RPi::HCSR04', $VERSION);

our $VERSION = '0.01';

BEGIN {
    my @subs = qw(trig echo);

    for (@subs){
        my ($self, $p) = @_;

        if (defined $p){
            if ($p < 0 && $p > 40){
                die "$_ pin number '$p' is out of range\n";
            }
            $self->{$_} = $p;
        }
        return $self->{$_};
    }
}

sub new {
    # trig, echo pins
    my ($self, $t, $e) = @_;

    if (! defined $t || ! defined $e){
        die "new() requires both a trig and echo pin number sent in\n";
    }

    $self->trig($t);
    $self->echo($t);
}

sub inch {
    return inch_c();
}
sub cm {
    return cm_c();
}
sub raw {
    return raw_c();
}

1;
__END__

=head1 NAME

RPi::HCSR04 - Interface to the HC-SR04 ultrasonic distance measurement sensor
on the Raspberry Pi

=head1 SYNOPSIS

    use RPi::HCSR04;

    my $trig_pin = 23;
    my $echo_pin = 24;

    my $sensor = RPi::HCSR04->new($trig_pin, $echo_pin);

    my $inches = $sensor->inch;
    my $cm     = $sensor->cm;
    my $raw    = $sensor->raw;

    ...

=head1 DESCRIPTION

Easy to use interface to retrieve distance measurements from the HC-SR04
ultrasonic distance measurement sensor.    

Requires L<wiringPi|http://wiringpi.com> to be installed.

=head1 METHODS

=head2 new

Instantiates and returns a new L<RPi::HCSR04> object.

Parameters:

    $trig

Mandatory: Integer, the GPIO pin number of the Raspberry Pi that the C<TRIG>
pin is connected to.

    $echo

Mandatory: Integer, the GPIO pin number of the Raspberry Pi that the C<ECHO>
pin is connected to.

=head2 inch

Returns a floating point number containing the distance in inches. Takes no
parameters.

=head2 cm

Returns a floating point number containing the distance in centemetres. Takes
no parameters.

=head2 raw

Returns an integer representing the return from the sensor in raw original
form. Takes no parameters.

=head1 AUTHOR

Steve Bertrand, C<< <steveb at cpan.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2017 Steve Bertrand.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.
