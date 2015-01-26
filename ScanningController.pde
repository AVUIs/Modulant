public class ScanningController {

  TimedEventGenerator ticks;
  //HighResolutionTimer ticks;
  int lastMillis = 0;

  int currentScanLine = -1;
  PGraphics workBuffer;
  PGraphics effectsBuffer;
  PApplet parent;
  Config appConfig;

  int workBufferWidth;
  int workBufferHeight;

  boolean isMuted = true;
      
  public ScanningController (PApplet parent, Config appConfig, PGraphics workBuffer, PGraphics effectsBuffer) {
    this.parent = parent;
    this.appConfig = appConfig;
    this.workBuffer = workBuffer;
    this.effectsBuffer = effectsBuffer;

    ticks = new TimedEventGenerator(parent);
    ticks.setEnabled(false);
    ticks.setIntervalMs(appConfig.oneTickInMs());

    // takes up unnecessarily high CPU
    //ticks = new HighResolutionTimer(parent, appConfig.oneTickInMs());
    //ticks.start();
  }

  void start() {
    ticks.setEnabled(true);
  }

  void stop() {
    ticks.setEnabled(false);
  }

  void toggleMovement() {
    ticks.setEnabled(!ticks.isEnabled());        
  }

  void toggleSound() {
    this.isMuted = !this.isMuted;
    if (this.isMuted) 
      pd.silenceAll();
    else
      sonifyScanline();
  }
  
  void isMuted(boolean isItMuted) {
    this.isMuted = isItMuted;
  }


  int getCurrentScanline() {
    return currentScanLine;
  }


  void moveScanline(int steps) {
    boolean isEnabled = ticks.isEnabled();
    if (isEnabled)      
      ticks.setEnabled(false);

    currentScanLine = (currentScanLine+steps) % workBuffer.width;
    drawScanline();
    sonifyScanline();
    
    if (isEnabled)
      ticks.setEnabled(isEnabled);
  }

  void setCurrentScanLine(int pos) {  
    boolean isEnabled = ticks.isEnabled();
    if (isEnabled)      
      ticks.setEnabled(false);
    currentScanLine = pos;
    drawScanline();
    if (isEnabled)
      ticks.setEnabled(isEnabled);
  }



  void onTimerEvent() {
    int millisDiff = millis() - lastMillis;
    lastMillis = millisDiff + lastMillis;  
    // System.out.println("diff " + millisDiff + " now:" + lastMillis);

    if (currentScanLine == 0)
      println("TOCK: " + millis());

    // scan the next line
    currentScanLine = (currentScanLine+1) % workBuffer.width;
    drawScanline();
    sonifyScanline();

    //  System.out.println("spent: " + (millis()-lastMillis));
  }


  void drawScanline() {
    // draw the line 
    effectsBuffer.beginDraw();
    effectsBuffer.background(255,0);
    effectsBuffer.stroke(0,126,255);
    effectsBuffer.line(currentScanLine,0,currentScanLine,effectsBuffer.height);
    effectsBuffer.endDraw();
  }

  void sonifyScanline() {
    if (this.isMuted)
      return;

    int numberOfAllIntervals = appConfig.numberOfAllIntervals();

    workBuffer.loadPixels();
    color[] wPixels = workBuffer.pixels;
    workBufferWidth = workBuffer.width;
    workBufferHeight = workBuffer.height;
    

    float wHeightStep = (float)workBufferHeight/numberOfAllIntervals;

    // read pixels every wHeightStep
    int unitNo=numberOfAllIntervals;
    for (float y=0; y<workBufferHeight; y += wHeightStep) {

      int thisPixelIndex = Math.round(y)*workBufferWidth + currentScanLine;
      int safePixelIndex = Math.max(0,Math.min(thisPixelIndex, wPixels.length-1));      
      color c = wPixels[safePixelIndex];

      float brightness = brightness(c) / 255;    
      pd.send(unitNo, brightness);
      unitNo--;
    }

  }


  void sonifyScanlineAveragingPixels() {
    if (this.isMuted)
      return;

    int numberOfAllIntervals = config.numberOfAllIntervals();

    workBuffer.loadPixels();
    color[] wPixels = workBuffer.pixels;
    workBufferWidth = workBuffer.width;
    workBufferHeight = workBuffer.height;

    float verticalStep = (float)workBufferHeight/numberOfAllIntervals;

    // read every pixel, average the brightness every workBufferHeightStep
 
    int interval=0;
    int y=0;

    while (y < workBufferHeight) {
      int nextStop = Math.round((interval+1)*verticalStep);
      float avgBrightness = 0;
      int numPixels = 0;

      while (y<nextStop) {
        numPixels++;
        int thisPixelIndex = y*workBufferWidth + currentScanLine;
        color c = wPixels[thisPixelIndex];
        avgBrightness += brightness(c) / 255;
        y++;
      }
  
      avgBrightness /= numPixels;
      int unitNo = numberOfAllIntervals - interval;
      pd.send(unitNo, avgBrightness);
  
      interval++;
    }
  }

}
