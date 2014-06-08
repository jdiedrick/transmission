//class referenced from ofZach's week two course at avsys 2012
//https://github.com/ofZach/avsys2012/tree/master/week2_oscillatorTypes

#pragma once

#include "ofMain.h"


class oscillator{
    
    public:
    
    enum{
        sineWave, squareWave, triangleWave, sawWave, inverseSawWave
    } waveType;
    
    int type;
    
    int sampleRate;
    float frequency;
    float volume;
    float phase;
    float phaseAdder;
    
    void setup (int sampRate);
    void setFrequency (float freq);
    void setVolume (float vol);
    
    float getSample();
    
};