public class ScanningController extends EventHandler {

  TimedEventGenerator timer;
  //HighResolutionTimer timer;
  int lastMillis = 0;

  int currentScanLine = 0;
  PGraphics workBuffer;
  PGraphics effectsBuffer;
  PApplet parent;
  Config appConfig;

  int workBufferWidth;
  int workBufferHeight;

  boolean isMuted = true;

  float[] lastVol;
  float[] currVol;

  int ACTIVE_TOP_BAR_HEIGHT = 10;
  boolean mouseMovingTheScanline = false;
  
  public ScanningController (PApplet parent, Config appConfig, PGraphics workBuffer, PGraphics effectsBuffer) {
    this.parent = parent;
    this.appConfig = appConfig;
    this.workBuffer = workBuffer;
    this.effectsBuffer = effectsBuffer;

    timer = new TimedEventGenerator(parent);
    timer.setEnabled(false);
    timer.setIntervalMs(appConfig.oneTickInMs());

    // takes up unnecessarily high CPU
    //timer = new HighResolutionTimer(parent, appConfig.oneTickInMs());
    //timer.start();

    lastVol = new float[appConfig.numberOfAllIntervals()];    
    currVol = new float[appConfig.numberOfAllIntervals()];

    for (int i=0; i<appConfig.numberOfAllIntervals(); i++)
      lastVol[0] = 0.0;
    
  }

  void start() {
    super.start();
    //timer.setEnabled(true);
  }

  void stop() {
    super.stop();
    //timer.setEnabled(false);
  }

  void toggleMovement() {
    timer.setEnabled(!timer.isEnabled());        
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
    boolean isEnabled = timer.isEnabled();
    if (isEnabled)      
      timer.setEnabled(false);

    currentScanLine = (workBuffer.width + currentScanLine+steps) % workBuffer.width;
    drawScanline();
    sonifyScanline();
    
    if (isEnabled)
      timer.setEnabled(isEnabled);
  }

  void setCurrentScanLine(int pos) {  
    boolean isEnabled = timer.isEnabled();
    if (isEnabled)      
      timer.setEnabled(false);
    
    currentScanLine = pos;
    drawScanline();
    
    if (isEnabled)
      timer.setEnabled(isEnabled);
  }



  void onTimerEvent() {
    int millisDiff = millis() - lastMillis;
    lastMillis = millisDiff + lastMillis;  
    // System.out.println("diff " + millisDiff + " now:" + lastMillis);

    if (currentScanLine == 0)
      println("TOCK: " + millis());

    // scan the current line
    drawScanline();
    sonifyScanline();

    currentScanLine = (currentScanLine+1) % workBuffer.width;

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

    int nChanged = 0;

    // read pixels every wHeightStep
    for (int interval=0; interval < numberOfAllIntervals; interval++) {
      
      int unitNo = (numberOfAllIntervals-1) - interval;
      
      int thisPixelIndex = Math.round(interval*wHeightStep)*workBufferWidth + currentScanLine;
      int safePixelIndex = Math.max(0,Math.min(thisPixelIndex, wPixels.length-1));
      color c = wPixels[safePixelIndex];
      
      float volume = brightness(c) / 255;

      // if (volume >= 1.0)
      //   println(volume + " @ " + currentScanLine+","+interval*wHeightStep + "(" + unitNo +")");
      
      try {
        currVol[unitNo] = volume;
      } catch (Exception e) {
        println("unitNo:"+ unitNo + " wHeightStep:"+wHeightStep + " workBufferHeight:"+workBufferHeight + " numberOfAllIntervals:"+numberOfAllIntervals); 
      }
      
      // if (Math.abs(volume - lastVol[unitNo]) > 0.0001) { // FIXME some arbitrary threshold for now
      //   nChanged++;        
      //   pd.send(unitNo, volume);
      // }
      
      unitNo--;
    }

    //println(Math.round((float)nChanged/numberOfAllIntervals*100.0) + "% -- " + nChanged + " / " + numberOfAllIntervals);

    pd.send(currVol);
    
    System.arraycopy(currVol, 0, lastVol, 0, numberOfAllIntervals);    
  }


 
  
   void sonifyScanlinePixelIteration() {
    // void sonifyScanline() {
    if (this.isMuted)
      return;

    int numberOfAllIntervals = appConfig.numberOfAllIntervals();

    workBuffer.loadPixels();
    color[] wPixels = workBuffer.pixels;
    workBufferWidth = workBuffer.width;
    workBufferHeight = workBuffer.height;
    

    float wHeightStep = (float)workBufferHeight/numberOfAllIntervals;

    int nChanged = 0;
    
    // read pixels every wHeightStep
    int unitNo=numberOfAllIntervals-1;
    for (float y=0; y<workBufferHeight; y += wHeightStep) {

      int thisPixelIndex = Math.round(y)*workBufferWidth + currentScanLine;
      int safePixelIndex = Math.max(0,Math.min(thisPixelIndex, wPixels.length-1));      
      color c = wPixels[safePixelIndex];

      float volume = brightness(c) / 255;
      try {
        currVol[unitNo] = volume;
      } catch (Exception e) {
        println("y:"+ y + " wHeightStep:"+wHeightStep + " workBufferHeight:"+workBufferHeight + " numberOfAllIntervals:"+numberOfAllIntervals); 
      }
      
      if (Math.abs(volume - lastVol[unitNo]) > 0.001) { // FIXME some arbitrary threshold for now
        nChanged++;        
        pd.send(unitNo, volume);
      }
      
      unitNo--;
    }

    //    println((float)nChanged/numberOfAllIntervals*100 + "% -- " + nChanged + " / " + numberOfAllIntervals);

    System.arraycopy(currVol, 0, lastVol, 0, numberOfAllIntervals);    
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


  void mousePressed() {
    if (mouseY < ACTIVE_TOP_BAR_HEIGHT) {
      mouseMovingTheScanline = true;
      setCurrentScanLine(mouseX);
    }
  }

  void mouseDragged() {
    if (mouseMovingTheScanline)
      setCurrentScanLine(mouseX);
  }


  void mouseReleased() {
    mouseMovingTheScanline = false;
  }
}
