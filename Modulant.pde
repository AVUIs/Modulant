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


Config config;


// now calculate some more parameters

float STEP_RATIO = (float) nthroot(STEPS,2); //1.0594 for SEMITONES
int ALL_STEPS = OCTAVES * STEPS;
int BEAT_INTERVAL_MS = 1000*60/BPM;
String patchfile = "modulant-"+OCTAVES+"x"+STEPS+".pd";



// MAIN - here we go

int WIDTH = 800;
int HEIGHT = 600;

PImage bgImage;
PGraphics workBuffer;
PGraphics effectsBuffer;

PureDataMiddleware pd;
TimedEventGenerator beats;
int lastMillis = 0;

int currentScanLine = -1;
color scannedPixelColour[] = null;
int scannedPixelIndex[] = null;


void setup() {

  config = new Config()
    .lengthInSeconds(30)
    .bpm(125)
    .octaves(10)
    .intervalsInOctave(OctaveDivisions.QUARTERTONES)
    .update();

  println(config);

  size(WIDTH, HEIGHT);
  frameRate(30);



  // load the image, resize it in proportion to the number of pitches
  // we have, then set the size of the window
  bgImage = loadImage(bgImageFile);

  bgImage.resize(0,config.numberOfAllIntervals());
  workBuffer = createGraphics(bgImage.width, bgImage.height);
  workBuffer.background(bgImage);
  //  workBuffer.resize(0,config.numberOfAllIntervals());
  
  //size(bgImage.width, bgImage.height);

  imgW = bgImage.width;
  imgH = bgImage.height;
  centerX = WIDTH / 2;
  centerY = HEIGHT / 2;

  


  // start Puredata 
  pd = new PureDataMiddleware(this,config);
  pd.start();

  // set up the beat tick
  beats = new TimedEventGenerator(this);
  beats.setIntervalMs(config.oneTickInMs());

  currentScanLine = -1;
  scannedPixelColour = new color[height];
  scannedPixelIndex = new int[height];

}


void draw() {
  //  background(0);
  //imageMode(CENTER);
  //image(bgImage, centerX, centerY, imgW, imgH);

  //  stroke(0,126,255);
  //line(currentScanLine,0,currentScanLine,height);
}




void onTimerEvent() {
  int millisDiff = millis() - lastMillis;
  lastMillis = millisDiff + lastMillis;  
  //System.out.println("tick " + millisDiff + " " + lastMillis);

  int numberOfAllIntervals = config.numberOfAllIntervals();

  workBuffer.loadPixels();
  color[] wpixels = workBuffer.pixels;
  int wwidth = workBuffer.width;
  int wheight = workBuffer.height;

  // scan the next line
  currentScanLine = (currentScanLine+1) % wwidth;


  background(0);
  imageMode(CENTER);
  image(bgImage, centerX, centerY, imgW, imgH);

  stroke(0,126,255);
  line(currentScanLine,0,currentScanLine,height);


  for (int y=0, i=0; y<wheight; y += wheight/numberOfAllIntervals, i++) {

    int thisPixelIndex = y*wwidth + currentScanLine;
    color c = wpixels[thisPixelIndex];

    scannedPixelColour[i] = c;

    float brightness = brightness(c) / 255;    
    int unitNo = numberOfAllIntervals-y;
    pd.sendFloat("unit"+unitNo, brightness/30);

    // draw the scan-line
    //pixels[thisPixelIndex] = color(0,126,255);
  }
  
  //updatePixels();

  
}




