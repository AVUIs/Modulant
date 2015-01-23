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

int WIDTH = 800;
int HEIGHT = 600;

PImage bgImage;

// Adding zooming and panning support

int imgW;
int imgH;
int centerX;
int centerY;

//Define the zoom vars
int scale = 1;
int maxScale = 10;
float zoomFactor = 0.4;

//Define the pan vars
int panFromX;
int panFromY;
int panToX;
int panToY;
int xShift = 0;
int yShift = 0;


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
  //size(bgImage.width, bgImage.height);

  imgW = bgImage.width;
  imgH = bgImage.height;
  centerX = WIDTH / 2;
  centerY = HEIGHT / 2;

  size(WIDTH, HEIGHT);


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
  background(0);
  imageMode(CENTER);
  image(bgImage, centerX, centerY, imgW, imgH);
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
    //pd.sendFloat("unit"+(ALL_STEPS-y), brightness/30);

    // draw the scan-line
    pixels[thisPixelIndex] = color(0,126,255);

  }
  
  updatePixels();
  
}


void keyPressed() {
  if (key == 'r') {
    scale = 1;
    imgW = bgImage.width;
    imgH = bgImage.height;
    centerX = WIDTH / 2;
    centerY = HEIGHT / 2;
  }
}


//Pan function
void mousePressed(){
  if(mouseButton == LEFT){
    panFromX = mouseX;
    panFromY = mouseY;
  }
}


//Pan function continued..
void mouseDragged(){
  if(mouseButton == LEFT){
    panToX = mouseX;
    panToY = mouseY;
    
    xShift = panToX - panFromX; 
    yShift = panToY - panFromY;
    
    centerX = centerX + xShift;
    centerY = centerY + yShift;
    
    panFromX = panToX;
    panFromY = panToY;
  }
}


//Zoom function
void mouseWheel(MouseEvent event) {
  float e = event.getAmount();
  
  //Zoom in
  if(e == -1){
    if(scale < maxScale){
      scale++;
      imgW = int(imgW * (1+zoomFactor));
      imgH = int(imgH * (1+zoomFactor));
      
      int oldCenterX = centerX;
      int oldCenterY = centerY;  
      
      centerX = centerX - int(zoomFactor * (mouseX - centerX));
      centerY = centerY - int(zoomFactor * (mouseY - centerY));
    }
  }
  
  //Zoom out
  if(e == 1){
    // if(scale < 1){
    //   scale = 1;
    //   imgW = bgImage.width;
    //   imgH = bgImage.height;
    // }
    
    if(scale > 1){
      scale--;
      imgH = int(imgH/(1+zoomFactor));
      imgW = int(imgW/(1+zoomFactor));
      
      int oldCenterX = centerX;
      int oldCenterY = centerY;  
      
      centerX = centerX + int((mouseX - centerX) 
                              * (zoomFactor/(zoomFactor + 1))); 
      centerY = centerY + int((mouseY - centerY) 
                              * (zoomFactor/(zoomFactor + 1)));
      
    }
  }
}
