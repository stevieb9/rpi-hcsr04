use warnings;
use strict;

use Inline 'Noclean';
use Inline 'C';

__END__
__C__

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <wiringPi.h>

int echo;
int trig;

bool setup(int trig, int echo){
 
    int setup_mode = -1;

    if (getenv("RPI_PIN_MODE"))
        setup_mode = atoi(getenv("RPI_PIN_MODE"));

    if (setup_mode == -1){
        if (wiringPiSetupGpio() == -1)
            exit(1);
    }
    else {
        char mode_env_var[20];
        sprintf(mode_env_var, "RPI_PIN_MODE=%d", setup_mode);
        putenv(mode_env_var);
    }

    pinMode(trig, OUTPUT);
    pinMode(echo, INPUT);

    digitalWrite(trig, LOW);
    
    delay(30);
   
    return TRUE;
}
 
float fetch() {

    digitalWrite(trig, HIGH);
    delayMicroseconds(20);
    digitalWrite(trig, LOW);

    // wait for echo

    while(digitalRead(echo) == LOW);

    // wait for echo end

    long startTime = micros();
    while(digitalRead(echo) == HIGH);
    long travelTime = micros() - startTime;

    // inches

    float distance = ((float)travelTime / 2) / 74;
    return distance;
}

float inch (){
    int raw = fetch();
    return ((float)raw / 2) / 74;
}

float cm (){
    float inches  = inch();
    return inches * 2.54;
}

