#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    setupUI();
    setupAudio();

}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){
	
}

//--------------------------------------------------------------
void ofApp::exit(){
    
    gui->saveSettings("settings.xml");
    delete gui;

}

//--------------------------------------------------------------
void ofApp::guiEvent(ofxUIEventArgs &e){

    if(e.getName()=="BACKGROUND"){
        ofxUISlider* slider = e.getSlider();
        ofBackground(slider->getScaledValue());
    }
    else if (e.getName()=="A"){
            ofxUIToggle* toggle = e.getToggle();
            aIsToggled = toggle->getValue();
        }
    else if (e.getName()=="E"){
                ofxUIToggle* toggle = e.getToggle();
                eIsToggled = toggle->getValue();
            }
    
}

//--------------------------------------------------------------
void ofApp::setupUI(){
    
    gui = new ofxUICanvas();
    gui->setFont("GUI/faucet.ttf");
    //setup background color slider
    gui->addSlider("BACKGROUND", 0.0, 255.0, 100.0);
    gui->addToggle("A", false, 44, 44);
    gui->addToggle("E", false, 44, 44);
    
    //gui->autoSizeToFitWidgets();
    ofAddListener(gui->newGUIEvent, this, &ofApp::guiEvent);
    
    gui->loadSettings("settings.xml");
    
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

#pragma mark - Audio
void ofApp::setupAudio(){
    // IMPORTANT!!! if your sound doesn't work in the simulator - read this post - which requires you set the output stream to 24bit
	//	http://www.cocos2d-iphone.org/forum/topic/4159
    
	ofSetOrientation(OF_ORIENTATION_90_RIGHT);//Set iOS to Orientation Landscape Right
    
	ofBackground(255, 255, 255);
    
	// 2 output channels,
	// 0 input channels
	// 44100 samples per second
	// 512 samples per buffer
	// 4 num buffers (latency)
    
	sampleRate = 44100;
	phase = 0;
	phaseAdder = 0.0f;
	aPhaseAdderTarget = 0.0;
    ePhaseAdderTarget = 0.0;
	volume = 0.15f;
	pan = 0.5;
	bNoise = false;
	
	//for some reason on the iphone simulator 256 doesn't work - it comes in as 512!
	//so we do 512 - otherwise we crash
	initialBufferSize = 512;
	
	lAudio = new float[initialBufferSize];
	rAudio = new float[initialBufferSize];
	
	memset(lAudio, 0, initialBufferSize * sizeof(float));
	memset(rAudio, 0, initialBufferSize * sizeof(float));
	
	//we do this because we don't have a mouse move function to work with:
	aFrequency = 432.0;
    eFrequency = 324.0;
	aPhaseAdderTarget = (aFrequency / (float)sampleRate) * TWO_PI;
    ePhaseAdderTarget = (eFrequency / (float)sampleRate) * TWO_PI;
	
	// This call will allow your app's sound to mix with any others that are creating sound
	// in the background (e.g. the Music app). It should be done before the call to
	// ofSoundStreamSetup. It sets a category of "play and record" with the "mix with others"
	// option turned on. There are many other combinations of categories & options that might
	// suit your app's needs better. See Apple's guide on "Configuring Your Audio Session".
	
	// ofxiOSSoundStream::setMixWithOtherApps(true);
	
	ofSoundStreamSetup(2, 0, this, sampleRate, initialBufferSize, 4);
	ofSetFrameRate(60);
}

//--------------------------------------------------------------
void ofApp::audioOut(float * output, int bufferSize, int nChannels){
    
	if( initialBufferSize < bufferSize ){
		ofLog(OF_LOG_ERROR, "your buffer size was set to %i - but the stream needs a buffer size of %i", initialBufferSize, bufferSize);
		return;
	}
    
	float leftScale = 1 - pan;
	float rightScale = pan;
    
	// sin (n) seems to have trouble when n is very large, so we
	// keep phase in the range of 0-TWO_PI like this:
	while(phase > TWO_PI){
		phase -= TWO_PI;
	}
    
	if(aIsToggled == true){

		phaseAdder = 0.95f * phaseAdder + 0.05f * aPhaseAdderTarget;
		for(int i = 0; i < bufferSize; i++){
			phase += phaseAdder;
            float sample = sin(phase); // sine wave
            //float sample = sin(phase)>0?1:-1; // square wave
            //float sample = fmod(phase,TWO_PI); // saw wave..maybe?
			lAudio[i] = output[i * nChannels] = sample * volume * leftScale;
			rAudio[i] = output[i * nChannels + 1] = sample * volume * rightScale;
		}
	}
    else if(eIsToggled == true){
        
		phaseAdder = 0.95f * phaseAdder + 0.05f * ePhaseAdderTarget;
		for(int i = 0; i < bufferSize; i++){
			phase += phaseAdder;
            float sample = sin(phase); // sine wave
            //float sample = sin(phase)>0?1:-1; // square wave
            //float sample = fmod(phase,TWO_PI); // saw wave..maybe?
			lAudio[i] = output[i * nChannels ] = sample * volume * leftScale;
			rAudio[i] = output[i * nChannels + 1] = sample * volume * rightScale;
		}
	}
    
	
}

