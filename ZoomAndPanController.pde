// Adding zooming and panning support

public class ZoomAndPanController extends EventHandler {

  boolean panEnabled = true;
  boolean zoomEnabled = true;

  int sketchW;
  int sketchH;
  int centerX;
  int centerY;

  //Define the zoom vars
  int scale = 1;
  int maxScale = 10;
  float zoomFactor = 0.2;

  //Define the pan vars
  int panFromX;
  int panFromY;
  int panToX;
  int panToY;
  int xShift = 0;
  int yShift = 0;

   
  public ZoomAndPanController (int centerX, int centerY, int sketchW, int sketchH) {
    this.centerX = centerX;
    this.centerY = centerY;
    this.sketchW = sketchW;
    this.sketchH = sketchH;   
  }

  public ZoomAndPanController () {
    this(WIDTH/2, HEIGHT/2, WIDTH, HEIGHT);
  }
  
  public int centerX() { return centerX; }
  public int centerY() { return centerY; }
  public int sketchW() { return sketchW; }
  public int sketchH() { return sketchH; }
  

  public ZoomAndPanController disable() {
    zoomEnabled = false;
    panEnabled = false;
    return this;
  }

  public ZoomAndPanController enable() {
    zoomEnabled = true;
    panEnabled = true;
    return this;
  }

  
  //Pan function
  void mousePressed(){
    if (!panEnabled) return;
    if(mouseButton == LEFT){
      panFromX = mouseX;
      panFromY = mouseY;
    }
  }


  //Pan function continued..
  void mouseDragged(){
    if (!panEnabled) return;
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
    if (!zoomEnabled) return;

    float e = event.getAmount();

    zoom(e);

  }

  ZoomAndPanController zoom(float direction) {
    if (!zoomEnabled) return this;
    
    //Zoom in
    if(direction == -1){
      if(scale < maxScale){
        scale++;
        sketchW = int(sketchW * (1+zoomFactor));
        sketchH = int(sketchH * (1+zoomFactor));
      
        int oldCenterX = centerX;
        int oldCenterY = centerY;  
      
        centerX = centerX - int(zoomFactor * (mouseX - centerX));
        centerY = centerY - int(zoomFactor * (mouseY - centerY));
      }
    }
  
    //Zoom out
    if(direction == 1){
      // if(scale < 1){
      //   scale = 1;
      //   sketchW = bgImage.width;
      //   sketchH = bgImage.height;
      // }
    
      if(scale > 1){
        scale--;
        sketchH = int(sketchH/(1+zoomFactor));
        sketchW = int(sketchW/(1+zoomFactor));
      
        int oldCenterX = centerX;
        int oldCenterY = centerY;  
      
        centerX = centerX + int((mouseX - centerX) 
                                * (zoomFactor/(zoomFactor + 1))); 
        centerY = centerY + int((mouseY - centerY) 
                                * (zoomFactor/(zoomFactor + 1)));
      
      }
    }

    return this;
  }

  ZoomAndPanController reset() {
      scale = 1;
      sketchW = WIDTH;
      sketchH = HEIGHT;
      centerX = WIDTH / 2;
      centerY = HEIGHT / 2;

      return this;
  }
  
  // reset function
  // void keyPressed() {
  //   if (key == '@') {
  //     reset();
  //   }
  // }
}




// sketchW = bgImage.width;
// sketchH = bgImage.height;
// centerX = WIDTH / 2;
// centerY = HEIGHT / 2;
/*  */

