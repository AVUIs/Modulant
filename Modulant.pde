import org.puredata.processing.PureData;
import org.multiply.processing.TimedEventGenerator;

/* Modulant - A sonification and audiovisual performance interface experiment.
   Copyright 2015 Berkan Eskikaya, Louis Pilfold

   For this very first / monkeypatch version , the source code itself
   is your interface. There is no other form of interaction.

   Change the parameters below, run the sketch. Repeat.
 */


// CONSTANTS - in an octave, there are...
int SEMITONES = 12; 
int QUARTERTONES = 24;


// PARAMETERS: We set these as we like:

// 1. how many octaves do we want
int OCTAVES = 10;

// 2. are we going to use semitones or quartertones
//int STEPS = SEMITONES;
int STEPS = QUARTERTONES;

// 3. what's the lowest freqency
float FREQ0 = 16.352;

// 4. what's the BPM
int BPM = 600;

// 5. which image to sonify
String bgImageFile = "data/klee-lines-dots-drawing-bw.jpg";
//String bgImageFile = "data/Coil-ANS-C-grey.png";
//String bgImageFile = "data/Coil-ANS-D-grey.png";
//String bgImageFile = "data/sc02-1n.jpg";
//String bgImageFile = "data/graph2d-1.png";
//String bgImageFile = "data/graph2d-2.png";
//String bgImageFile = "data/graph2d-3.png";



// now calculate some more parameters

float STEP_RATIO = (float) nthroot(STEPS,2); //1.0594 for SEMITONES
int ALL_STEPS = OCTAVES * STEPS;
int BEAT_INTERVAL_MS = 1000*60/BPM;
String patchfile = "modulant-"+OCTAVES+"x"+STEPS+".pd";



// MAIN - here we go

PImage bgImage;
PureData pd;
TimedEventGenerator beats;
int lastMillis = 0;

int currentScanLine = -1;
color scannedPixelColour[] = null;
int scannedPixelIndex[] = null;


void setup() {

  // load the image, resize it in proportion to the number of pitches
  // we have, then set the size of the window
  bgImage = loadImage(bgImageFile);
  bgImage.resize(0,ALL_STEPS);  
  size(bgImage.width, bgImage.height);

  // display the image
  background(0);
  image(bgImage, 0, 0);

  // start Puredata 
  generatePatch(patchfile);
  startPuredata(patchfile);

  // set up the beat tick
  beats = new TimedEventGenerator(this);
  beats.setIntervalMs(BEAT_INTERVAL_MS);

  currentScanLine = -1;
  scannedPixelColour = new color[height];
  scannedPixelIndex = new int[height];

}


void draw() {
}




void onTimerEvent() {
  int millisDiff = millis() - lastMillis;
  lastMillis = millisDiff + lastMillis;  
  //System.out.println("tick " + millisDiff + " " + lastMillis);


  //image(bgImage, 0, 0);

  loadPixels();

  // if we have already scanned a line, restore that area first
  if (currentScanLine >= 0){
    for (int i=0; i<scannedPixelIndex.length; i++) {
      pixels[scannedPixelIndex[i]] = scannedPixelColour[i];
    }
  }


  // scan the next line
  currentScanLine = (currentScanLine+1) % width;

  for (int y=0, i=0; y<height; y += height/ALL_STEPS, i++) {

    int thisPixelIndex = y*width + currentScanLine;
    color c = pixels[thisPixelIndex];

    scannedPixelColour[i] = c;
    scannedPixelIndex[i] = thisPixelIndex;

    float brightness = brightness(c) / 255;    
    pd.sendFloat("unit"+(ALL_STEPS-y), brightness/30);

    // draw the scan-line
    pixels[thisPixelIndex] = color(0,126,255);

  }
  
  updatePixels();
  
}

