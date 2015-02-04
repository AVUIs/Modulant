public class Marker {
  int x, y;
  String text;
  boolean isSet = false;
  
  public Marker(int x, int y, String text) {
    this.x = x;
    this.y = y;
    this.text = text;
    isSet = true;
  }

  public Marker() {}

}

public class GridController {
  
  int nCellsX;
  int nCellsY;
  float xspacing;
  float yspacing;

  color gridColour;
  PGraphics gridBuffer;

  boolean isEnabled = true;

  Marker[] markers = new Marker[4];
  
  public GridController (PGraphics gridBuffer, int nCellsX, int nCellsY, color gridColour) {
    this.gridBuffer = gridBuffer;
    this.nCellsX = nCellsX;
    this.nCellsY = nCellsY;
    this.gridColour = gridColour;

    int gWidth = gridBuffer.width;
    int gHeight = gridBuffer.height;

    xspacing = Math.max(10, (float)gWidth/nCellsX);
    yspacing = Math.max(10, (float)gHeight/nCellsY);   

    for (int i=0; i<markers.length; i++)
      markers[i] = new Marker();
    
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

    for (Marker marker : markers) {
      if (marker.isSet)
        mark(marker, gridBuffer);
    }

    
    return this;
  }

  
  public GridController mark(int index, int x, int y) {
    if (index >= markers.length)
      return this;
    markers[index] = new Marker(x,y,""+index);
    //mark(markers[index], gridBuffer);
    draw();
    return this;
  }


  public GridController mark(Marker marker, PGraphics buffer) {
    buffer.beginDraw();
    buffer.noFill();
    buffer.stroke(255);
    buffer.ellipse(marker.x, marker.y, 15, 15);
    buffer.text(marker.text,marker.x-4,marker.y+5);
    buffer.endDraw();
    return this;
  }
  
  public GridController markCell(int x, int y, PGraphics buffer) {

    int bHeight = buffer.height;
    int ymax = (int)((float)bHeight/yspacing);
    int yy = ymax - y + 1;
    int xx = x-1;
    
    buffer.beginDraw();
    buffer.noFill();
    buffer.stroke(255);
    buffer.ellipse(xx*xspacing, yy*yspacing, 10, 10);
    println(xx*xspacing, yy*yspacing, 10, 10);
    //buffer.line(xx*xspacing, yy*yspacing, xx*xspacing+5, yy*yspacing);
    buffer.endDraw();
    return this;
  }

  
}
