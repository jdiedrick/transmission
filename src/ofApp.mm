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
	float boxW = 200.0;
	float boxH = boxW * 0.75;
	
	float topY = 30;
	float leftX = 30;
	float rightX = leftX + boxW + 20;
    
	// draw the left:
	ofSetHexColor(0x333333);
	ofRect(leftX, topY, boxW, boxH);
	ofSetHexColor(0xFFFFFF);
	for(int i = 0; i < initialBufferSize; i++){
		float x = ofMap(i, 0, initialBufferSize, 0, boxW, true);
		ofLine(leftX + x,topY + boxH / 2,leftX + x, topY + boxH / 2 + lAudio[i] * boxH * 0.5);
	}
    
	// draw the right:
	ofSetHexColor(0x333333);
	ofRect(rightX, topY, boxW, boxH);
	ofSetHexColor(0xFFFFFF);
	for(int i = 0; i < initialBufferSize; i++){
		float x = ofMap(i, 0, initialBufferSize, 0, boxW, true);
		ofLine(rightX + x, topY + boxH / 2, rightX + x, topY + boxH / 2 + rAudio[i] * boxH * 0.5);
	}
    
	ofSetHexColor(0x333333);
	char reportString[255];
	sprintf(reportString, "volume: (%f) \npan: (%f)\nsynthesis: %s", aVolume, pan, bNoise ? "noise" : "sine wave");
	sprintf(reportString, "%s (%fhz)", reportString, aFrequency);
    
	ofDrawBitmapString(reportString, leftX, topY + boxH + 20);

}

//--------------------------------------------------------------
void ofApp::exit(){
    
    gui->saveSettings("settings.xml");
    delete gui;

}

//--------------------------------------------------------------
void ofApp::guiEvent(ofxUIEventArgs &e){
    
    string name = e.widget->getName();
	int kind = e.widget->getKind();
    
    if(kind == OFX_UI_WIDGET_BUTTON)
    {
        ofxUIButton *button = (ofxUIButton *) e.widget;
        cout << name << "\t btn value: " << button->getValue() << endl;
    }
    else if(kind == OFX_UI_WIDGET_SLIDER_V){
        if(e.getName()=="A VOLUME"){
            ofxUISlider* slider = e.getSlider();
            aVolume = slider->getScaledValue();
        }
        else if(e.getName()=="E VOLUME"){
            ofxUISlider* slider = e.getSlider();
            eVolume = slider->getScaledValue();
            cout << eVolume << endl;
            
        }

    }
    
    else if(kind == OFX_UI_WIDGET_TOGGLE)
    {
        ofxUIToggle *toggle = (ofxUIToggle *) e.widget;
        cout << name << "\t toggle value: " << toggle->getValue() << endl;
        
        if (name=="ASINE") {
            aSynthMode = 1;
            cout << aSynthMode << endl;
        }else if (name=="ASQUARE"){
            aSynthMode = 2;
            cout << aSynthMode << endl;
        }
        
        else if (name=="ATRIANGLE"){
            aSynthMode = 3;
            cout << aSynthMode << endl;
        }
        
        else if (name=="ATRIANGLE"){
            aSynthMode = 3;
            cout << aSynthMode << endl;
        }
        
        else if (name=="ASAW"){
            aSynthMode = 4;
            cout << aSynthMode << endl;
        }
        
        else if (name=="AI-SAW"){
            aSynthMode = 5;
            cout << aSynthMode << endl;
        }
        
        else if (e.getName()=="A"){
            aPhase = 0;
            ofxUIToggle* toggle = e.getToggle();
            aIsToggled = toggle->getValue();
        }
        else if (e.getName()=="E"){
            ePhase = 0;
            ofxUIToggle* toggle = e.getToggle();
            eIsToggled = toggle->getValue();
        }
        else if(e.getName()=="A VOLUME"){
            ofxUISlider* slider = e.getSlider();
            aVolume = slider->getScaledValue();
        }
        else if(e.getName()=="E VOLUME"){
            ofxUISlider* slider = e.getSlider();
            eVolume = slider->getScaledValue();
            cout << eVolume << endl;
            
        }

    }
    
//    else if (e.getName()=="A"){
//            aPhase = 0;
//            ofxUIToggle* toggle = e.getToggle();
//            aIsToggled = toggle->getValue();
//        }
//    else if (e.getName()=="E"){
//            ePhase = 0;
//                ofxUIToggle* toggle = e.getToggle();
//                eIsToggled = toggle->getValue();
//            }
//    else if(e.getName()=="A VOLUME"){
//        ofxUISlider* slider = e.getSlider();
//        aVolume = slider->getScaledValue();
//    }
//    else if(e.getName()=="E VOLUME"){
//        ofxUISlider* slider = e.getSlider();
//        eVolume = slider->getScaledValue();
//        cout << eVolume << endl;
//
//    }
    
}

//--------------------------------------------------------------
void ofApp::setupUI(){
    
    //ofSetOrientation(OF_ORIENTATION_DEFAULT);
    gui = new ofxUICanvas();
    gui->setWidth(ofGetWidth());
    gui->setHeight(ofGetHeight());
    gui->setFont("GUI/faucet.ttf");

    gui->addWidgetDown(new ofxUIToggle("A", false, 44, 44), OFX_UI_ALIGN_CENTER);
    gui->addWidgetEastOf(new ofxUISlider("A VOLUME", 0.0, 1.0, 1.0, 17,64), "A");
    
    vector<string> aSynthNames;
    aSynthNames.push_back("ASINE");
    aSynthNames.push_back("ASQUARE");
    aSynthNames.push_back("ATRIANGLE");
    aSynthNames.push_back("ASAW");
    aSynthNames.push_back("AI-SAW");
    ofxUIRadio *aSynth = gui->addRadio("ASYNTH", aSynthNames, OFX_UI_ORIENTATION_VERTICAL, 44, 44);
    aSynth->activateToggle("ASINE");
    gui->addWidgetWestOf(aSynth, "A");
    
    vector<string> aFreqNames;
    aFreqNames.push_back("A1");
    aFreqNames.push_back("A2");
    aFreqNames.push_back("A3");
    aFreqNames.push_back("A4");
    aFreqNames.push_back("A5");
    ofxUIRadio *aFreq = gui->addRadio("AFREQ", aFreqNames, OFX_UI_ORIENTATION_HORIZONTAL, 22, 22);
    aFreq->activateToggle("A1");
    
    gui->addSpacer();
    
    gui->addWidgetDown(new ofxUIToggle("E", false, 44, 44), OFX_UI_ALIGN_CENTER);
    gui->addWidgetEastOf(new ofxUISlider("E VOLUME", 0.0, 1.0, 1.0, 17,64), "E");
    
    
    vector<string> eSynthNames;
    eSynthNames.push_back("ESINE");
    eSynthNames.push_back("ESQUARE");
    eSynthNames.push_back("ESAW");
    eSynthNames.push_back("ETRIANGLE");
    eSynthNames.push_back("EI-SAW");
    ofxUIRadio *eSynth = gui->addRadio("ESYNTH", eSynthNames, OFX_UI_ORIENTATION_VERTICAL, 44, 44);
    aSynth->activateToggle("ESINE");
    gui->addWidgetWestOf(eSynth, "E");
    
    vector<string> eFreqNames;
    eFreqNames.push_back("E1");
    eFreqNames.push_back("E2");
    eFreqNames.push_back("E3");
    eFreqNames.push_back("E4");
    eFreqNames.push_back("E5");
    ofxUIRadio *eFreq = gui->addRadio("EFREQ", eFreqNames, OFX_UI_ORIENTATION_HORIZONTAL, 22, 22);
    eFreq->activateToggle("E1");
    
    ofAddListener(gui->newGUIEvent, this, &ofApp::guiEvent);
    
    gui->loadSettings("settings.xml");
    
    aSynthMode = 1;
    
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
    
	//ofSetOrientation(OF_ORIENTATION_90_RIGHT);//Set iOS to Orientation Landscape Right
    
	ofBackground(255, 255, 255);
    
	// 2 output channels,
	// 0 input channels
	// 44100 samples per second
	// 512 samples per buffer
	// 4 num buffers (latency)
    
	sampleRate = 44100;
    aPhase = 0;
    ePhase = 0;
	aPhaseAdder = 0.0f;
    ePhaseAdder = 0.0f;
	aPhaseAdderTarget = 0.0;
    ePhaseAdderTarget = 0.0;
	aVolume = 1.0f;
    eVolume = 1.0f;
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
    
	//float leftScale = 1 - pan;
	//float rightScale = pan;
    
	// sin (n) seems to have trouble when n is very large, so we
	// keep phase in the range of 0-TWO_PI like this:
	while(aPhase > TWO_PI){
		aPhase -= TWO_PI;
	}
    
    while(ePhase > TWO_PI){
		ePhase -= TWO_PI;
	}
    
    
	if(aIsToggled == true && eIsToggled){
        float aSample, eSample;

		aPhaseAdder = 0.95f * aPhaseAdder + 0.05f * aPhaseAdderTarget;
        ePhaseAdder = 0.95f * ePhaseAdder + 0.05f * ePhaseAdderTarget;
        
		for(int i = 0; i < bufferSize; i++){
			aPhase += aPhaseAdder;
            ePhase += ePhaseAdder;
            if(aSynthMode==1) aSample = sin(aPhase); // sine wave
            if(aSynthMode==2) aSample = sin(aPhase)>0?1:-1; // square wave

            
            eSample = sin(ePhase);
            //float sample = sin(phase)>0?1:-1; // square wave
            //float sample = fmod(phase,TWO_PI); // saw wave..maybe?
			lAudio[i] = output[i * nChannels] = ((aSample * aVolume) + (eSample * eVolume)/2) ;
			rAudio[i] = output[i * nChannels + 1] = ((aSample * aVolume) + (eSample * eVolume)/2);
		}
        
    }
    
	else if(aIsToggled == true){
        
        float aSample;

		//aPhaseAdder = 0.95f * aPhaseAdder + 0.05f * aPhaseAdderTarget;
        
        //aPhaseAdder = (float)(aFrequency * TWO_PI) / (float)sampleRate;
		
        for(int i = 0; i < bufferSize; i++){
			aPhase += aPhaseAdder;
            
            if(aSynthMode==1) aSample = sin(aPhase); // sine wave
            
            if(aSynthMode==2) aSample = sin(aPhase)>0?1:-1; // square wave
            
            if(aSynthMode==3) {
                float pct = aPhase / TWO_PI;
                aSample = ( pct < 0.5 ? ofMap(pct, 0, 0.5, -1, 1) : ofMap(pct, 0.5, 1.0, 1, -1));
            } // saw tooth wave
            
            if(aSynthMode==4){
                float pct = aPhase / TWO_PI;
                aSample =  ofMap(pct, 0, 1, -1, 1);
            } // triangle wave
            
            if(aSynthMode==5) {
                float pct = aPhase / TWO_PI;
                aSample =  ofMap(pct, 0, 1, 1, -1);
            } // inverse saw tooth
            
			lAudio[i] = output[i * nChannels] = aSample * aVolume ;
			rAudio[i] = output[i * nChannels + 1] = aSample * aVolume;
		}
	}
    
    else if(eIsToggled == true){
        
		ePhaseAdder = 0.95f * ePhaseAdder + 0.05f * ePhaseAdderTarget;
		for(int i = 0; i < bufferSize; i++){
			ePhase += ePhaseAdder;
            float eSample = sin(ePhase); // sine wave
            //float sample = sin(phase)>0?1:-1; // square wave
            //float sample = fmod(phase,TWO_PI); // saw wave..maybe?
			lAudio[i] = output[i * nChannels ] = eSample * eVolume;
			rAudio[i] = output[i * nChannels + 1] = eSample * eVolume;
		}
	}
    
    
	
}

