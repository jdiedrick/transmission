#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxUI.h"
#include "oscillator.h"

class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
        //ofxui
        ofxUICanvas* gui;
        void guiEvent(ofxUIEventArgs &e);
        void setupUI();
    
        //audio
        void setupAudio();
        void audioOut(float * output, int bufferSize, int nChannels);
        float sampleRate;
        int initialBufferSize;
        
        //A note
        bool aIsToggled;
        //E note
        bool eIsToggled;
    
        oscillator a;
        oscillator e;
        float * soundBuffer;
    
    
};


