#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <wiringPi.h>

bool _setup(int trig, int echo){
 
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
   
    return 1;
}
 
long _fetch(int trig, int echo) {

    long travel_time = -1;
    
    while (1){
        digitalWrite(trig, HIGH);
        delayMicroseconds(20);
        digitalWrite(trig, LOW);

        // wait for echo

        while(digitalRead(echo) == LOW);

        // wait for echo end

        long start_time = micros();
        while(digitalRead(echo) == HIGH);
        travel_time = micros() - start_time;

        if (travel_time > 0 && travel_time < 23088){
            break;
        }
    }

    return travel_time;
}

float _inch (int trig, int echo){
    int raw = _fetch(trig, echo);

    float res = ((float)raw / 2) / 74;

    return res;
}

float _cm (int trig, int echo){
    float inches = _inch(trig, echo);
    return inches * 2.54;
}

long _raw (int trig, int echo){
    return _fetch(trig, echo);
}

MODULE = RPi::HCSR04  PACKAGE = RPi::HCSR04

PROTOTYPES: DISABLE

bool
_setup(trig, echo)
    int trig
    int echo

float
_inch(trig, echo)
    int trig
    int echo

float
_cm (trig, echo)
    int trig
    int echo

int
_raw (trig, echo)
    int trig
    int echo
