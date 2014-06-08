#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    setupUI();
    setupAudio();

}

//--------------------------------------------------------------
void ofApp::update(){
    
    // :)

}

//--------------------------------------------------------------
void ofApp::draw(){
    /*
	float boxW = 200.0;
	float boxH = boxW * 0.75;
	
	float topY = 30;
	float leftX = 30;
    
	// draw the left:
	ofSetHexColor(0x333333);
	ofRect(leftX, topY, boxW, boxH);
	ofSetHexColor(0xFFFFFF);
	for(int i = 0; i < initialBufferSize; i++){
		float x = ofMap(i, 0, initialBufferSize, 0, boxW, true);
		ofLine(leftX + x,topY + boxH / 2,leftX + x, topY + boxH / 2 + soundBuffer[i] * boxH * 0.5);
	}
    

	char reportString[255];
	sprintf(reportString, "a volume and freq: (%f) ", a.volume);
	sprintf(reportString, "%s (%fhz)", reportString, a.frequency);
    sprintf(reportString, "\n e volume and freq: (%f) ", e.volume);
	sprintf(reportString, "%s (%fhz)", reportString, e.frequency);
    
	ofDrawBitmapString(reportString, leftX, topY + boxH + 20);
*/
}

#pragma mark - UI

//--------------------------------------------------------------
void ofApp::setupUI(){
    
    ofBackground(255, 0, 0);
    
    //ofSetOrientation(OF_ORIENTATION_DEFAULT);
    gui = new ofxUICanvas();
    gui->setDrawBack(false);
    gui->setWidth(ofGetWidth());
    gui->setHeight(ofGetHeight());
    gui->setFont("GUI/faucet.ttf");

    gui->addWidgetDown(new ofxUIToggle("A", false, 44, 44), OFX_UI_ALIGN_CENTER);
    gui->addWidgetEastOf(new ofxUISlider("A VOLUME", 0.0, 1.0, 0.2, 50,125), "A");
    
    vector<string> aSynthNames;
    aSynthNames.push_back("ASINE");
    aSynthNames.push_back("ASQUARE");
    aSynthNames.push_back("ATRIANGLE");
    aSynthNames.push_back("ASAW");
    aSynthNames.push_back("AI-SAW");
    ofxUIRadio *aSynth = gui->addRadio("ASYNTH", aSynthNames, OFX_UI_ORIENTATION_VERTICAL, 22, 22);
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
    gui->addWidgetEastOf(new ofxUISlider("E VOLUME", 0.0, 1.0, 0.2, 50,125), "E");
    
    
    vector<string> eSynthNames;
    eSynthNames.push_back("ESINE");
    eSynthNames.push_back("ESQUARE");
    eSynthNames.push_back("ETRIANGLE");
    eSynthNames.push_back("ESAW");
    eSynthNames.push_back("EI-SAW");
    ofxUIRadio *eSynth = gui->addRadio("ESYNTH", eSynthNames, OFX_UI_ORIENTATION_VERTICAL, 22, 22);
    eSynth->activateToggle("ESINE");
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
    
    
}


//--------------------------------------------------------------
void ofApp::exit(){
    
    gui->saveSettings("settings.xml");
    delete gui;
    
}

//--------------------------------------------------------------
void ofApp::guiEvent(ofxUIEventArgs &event){
    
    string name = event.widget->getName();
	int kind = event.widget->getKind();
    
    if(kind == OFX_UI_WIDGET_BUTTON)
    {
        ofxUIButton *button = (ofxUIButton *) event.widget;
        cout << name << "\t btn value: " << button->getValue() << endl;
    }
    else if(kind == OFX_UI_WIDGET_SLIDER_V){
        if(event.getName()=="A VOLUME"){
            ofxUISlider* slider = event.getSlider();
            a.volume = slider->getScaledValue();
        }
        else if(event.getName()=="E VOLUME"){
            ofxUISlider* slider = event.getSlider();
            e.volume = slider->getScaledValue();
            cout << e.volume << endl;
            
        }
        
    }
    
    else if(kind == OFX_UI_WIDGET_TOGGLE)
    {
        ofxUIToggle *toggle = (ofxUIToggle *) event.widget;
        cout << name << "\t toggle value: " << toggle->getValue() << endl;
        
        if (name=="ASINE") {
            a.type = 0;
        }else if (name=="ASQUARE"){
            a.type = 1;
        }
        else if (name=="ATRIANGLE"){
            a.type = 2;
        }
        else if (name=="ASAW"){
            a.type = 3;
        }
        else if (name=="AI-SAW"){
            a.type = 4;
        }
        else if (name=="ESINE"){
            e.type = 0;
        }
        else if (name=="ESQUARE"){
            e.type = 1;
        }
        else if (name=="ETRIANGLE"){
            e.type = 2;
        }
        else if (name=="ESAW"){
            e.type = 3;
        }
        else if (name=="EI-SAW"){
            e.type = 4;
        }
        else if (name=="A1"){
            a.setFrequency(432.0);
        }
        else if (name=="A2"){
            a.setFrequency(432.0*2);
        }
        else if (name=="A3"){
            a.setFrequency(432.0*3);
        }
        else if (name=="A4"){
            a.setFrequency(432.0*4);
        }
        else if (name=="A5"){
            a.setFrequency(432.0/2);
        }
        else if (name=="E1"){
            e.setFrequency(324.0);
        }
        else if (name=="E2"){
            e.setFrequency(324.0*2);
        }
        else if (name=="E3"){
            e.setFrequency(324.0*3);
        }
        else if (name=="E4"){
            e.setFrequency(324.0*4);
        }
        else if (name=="E5"){
            e.setFrequency(324.0/2);
        }
        else if (event.getName()=="A"){
            ofxUIToggle* toggle = event.getToggle();
            aIsToggled = toggle->getValue();
        }
        else if (event.getName()=="E"){
            ofxUIToggle* toggle = event.getToggle();
            eIsToggled = toggle->getValue();
        }
        else if(event.getName()=="A VOLUME"){
            ofxUISlider* slider = event.getSlider();
            a.volume = slider->getScaledValue();
        }
        else if(event.getName()=="E VOLUME"){
            ofxUISlider* slider = event.getSlider();
            e.volume = slider->getScaledValue();
        }
        
    }
    
}

#pragma mark - Audio
void ofApp::setupAudio(){
    // IMPORTANT!!! if your sound doesn't work in the simulator - read this post - which requires you set the output stream to 24bit
	//	http://www.cocos2d-iphone.org/forum/topic/4159
    
	// 2 output channels,
	// 0 input channels
	// 44100 samples per second
	// 512 samples per buffer
	// 4 num buffers (latency)
    
	sampleRate = 44100;
	//for some reason on the iphone simulator 256 doesn't work - it comes in as 512!
	//so we do 512 - otherwise we crash
	initialBufferSize = 512;
	
		
	// This call will allow your app's sound to mix with any others that are creating sound
	// in the background (e.g. the Music app). It should be done before the call to
	// ofSoundStreamSetup. It sets a category of "play and record" with the "mix with others"
	// option turned on. There are many other combinations of categories & options that might
	// suit your app's needs better. See Apple's guide on "Configuring Your Audio Session".
	
	// ofxiOSSoundStream::setMixWithOtherApps(true);
	
	ofSoundStreamSetup(2, 0, this, sampleRate, initialBufferSize, 4);
	ofSetFrameRate(60);
    soundBuffer = new float[512];
    
    a.setup(sampleRate);
    a.setFrequency(432.0);
    a.setVolume(0.2);
    
    e.setup(sampleRate);
    e.setFrequency(324.0);
    e.setVolume(0.2);
}

//--------------------------------------------------------------
void ofApp::audioOut(float * output, int bufferSize, int nChannels){
    
    if(aIsToggled && eIsToggled) {
        for (int i=0; i<initialBufferSize; i++){
            float sample = (a.getSample() + e.getSample())/2;
            output[i*nChannels    ] = sample;
            output[i*nChannels + 1] = sample;
            
            soundBuffer[i] = sample;
        }
    }else if(aIsToggled){
        for (int i=0; i<initialBufferSize; i++){
            float sample = a.getSample();
            output[i*nChannels    ] = sample;
            output[i*nChannels + 1] = sample;
        
            soundBuffer[i] = sample;
        }
    }else if(eIsToggled){
        for (int i=0; i<initialBufferSize; i++){
            float sample = e.getSample();
            output[i*nChannels    ] = sample;
            output[i*nChannels + 1] = sample;
            
            soundBuffer[i] = sample;
        }
    }
    
	
}

#pragma mark - Gestures

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

