public class OnscreenHelp {
   
  String helptext1 = 
    "Bindings for Drawing \n\n" +
    "r \t\t rectangle mode\n" +
    "t \t\t triangle mode\n" +
    "e \t\t ellipse mode\n" +
    "f \t\t freehand mode\n" +
    "d \t\t freehand w/ dots\n" +
    "Ctrl-z \t\t undo\n" +
    "Ctrl-y \t\t redo\n" +
    "Shift-c \t\t clear all\n" +
    "\n" +
    "Sonification Control \n\n" +
    "Space \t\t toggle scanning\n" +
    "Left/Right \t\t step 1px\n" +
    "Ctrl-Left/Right \t\t step 10px\n" +
    "Shift-Ctrl-Left/Right \t\t step 50px\n" +
    "m \t\t toggle sound\n" +
    "g \t\t toggle grid\n";

  String helptext2 = 
    "File Operations\n\n" +
    "Ctrl-o \t\t load background image\n" +
    "Ctrl-s \t\t save work buffer as image\n" +
    "\n" +
    "Colours\n\n" +
    "0 \t\t black (eraser)\n" +
    "1:8 \t\t Solarized base colours\n" +
    "Ctrl-1:8 \t\t Solarized accents\n" +
    "9 \t\t white\n" +
    "\n" +
    "Help\n\n" +
    "h \t\t toggle help (this text)"
    
    
  
  PGraphics helpBuffer;

  boolean isEnabled = false; 

  public OnscreenHelp () {
    helpBuffer = createGraphics(WIDTH,HEIGHT);
  }

  public void enabled(boolean isItEnabled) {
    this.isEnabled = isItEnabled;
  }

  public void toggle() {
    this.isEnabled = !this.isEnabled;
    draw();
  }

  public PGraphics getBuffer() {
    return helpBuffer;
  }

  public OnscreenHelp draw() {
    if (!isEnabled) {
      helpBuffer.beginDraw();
      helpBuffer.background(255,0);
      helpBuffer.endDraw();
      return this;
    }

    helpBuffer.beginDraw();
    helpBuffer.background(255,200);    
    helpBuffer.textAlign(LEFT);
    helpBuffer.textSize(16);
    //helpBuffer.fill(color(147, 161, 247, 127));
    helpBuffer.fill(color(0, 0));
    helpBuffer.textLeading(24);
    helpBuffer.text(helptext1, 30, 40);
    helpBuffer.text(helptext2, 230, 40);
    helpBuffer.endDraw();

    return this;
  }
  

}
