// Adding zooming and panning support

boolean panEnabled = false;
boolean zoomEnabled = false;

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
