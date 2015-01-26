public class GridController {
  
  int nCellsX = 10;
  int nCellsY = 10;
  color gridColour;
  PGraphics gridBuffer;

  boolean isEnabled = true;
  
  public GridController (PGraphics gridBuffer, int nCellsX, int nCellsY, color gridColour) {
    this.gridBuffer = gridBuffer;
    this.nCellsX = nCellsX;
    this.nCellsY = nCellsY;
    this.gridColour = gridColour;
    
    draw();
  }

  public void enabled(boolean isItEnabled) {
    this.isEnabled = isItEnabled;
  }

  public void toggle() {
    this.isEnabled = !this.isEnabled;
    draw();
  }

  public GridController draw() {
    if (!isEnabled) {
      gridBuffer.beginDraw();
      gridBuffer.background(255,0);
      gridBuffer.endDraw();
      return this;
    }
     
    int gWidth = gridBuffer.width;
    int gHeight = gridBuffer.height;

    
    float xspacing = Math.max(10, (float)gWidth/nCellsX);
    float yspacing = Math.max(10, (float)gHeight/nCellsY);

    gridBuffer.beginDraw();

    gridBuffer.background(255,0);    
    gridBuffer.stroke(gridColour);

    for (int i = 0, j=0; i < gWidth; i+=xspacing, j++) {
      gridBuffer.line (i, 0, i, gHeight);
      if (j%4 == 0) gridBuffer.text(j, i, 0+10); //FIXME: this %4 is very arbitrary
    }
    for (int i = 0, j=0; i < gHeight; i+=yspacing, j++) {
      gridBuffer.line (0, i, gWidth, i);
      gridBuffer.text(nCellsY+1-j, 0, i); //BE stupid hack +1!
    }

    gridBuffer.endDraw();

    return this;
  }
}
