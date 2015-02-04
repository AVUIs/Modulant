import java.util.Arrays;

// FIXME This is the most horrible hack ever
// controlP5 is not nice; and this became in one afternoon one big hardcoded mess.

public class Toolbar extends EventHandler {

  static final int ACTIVE_TOOLBAR_HEIGHT = 20;

  PGraphics buffer;
  PApplet parent;

  boolean isVisible = true;
  
  PFont largeFont, smallFont;

  RadioButton modes;
  Toggle play, mute;
  
  String[] modeButtonText = {
    "Paintbrush",
    "Freeline",
    "Dots",
    "Rectangle",
    "Triangle",
    "Ellipse",
    "Blur",
    "Select"
  };

  
  public Toolbar (PApplet parent, PGraphics buffer) {
    this.parent = parent;
    this.buffer = buffer;
    
    // largeFont = loadFont("BonvenoCF-Light-18.vlw");
    // smallFont = loadFont("BonvenoCF-Light-10.vlw"); 

    cp5 = new ControlP5(parent);
    cp5.setAutoDraw(false);
  }


  public Toolbar setup() {
    int originX = 0;
    int originY = HEIGHT - ACTIVE_TOOLBAR_HEIGHT;

    int buttonX = originX;
    int buttonY = originY;

    int buttonGapX = 2;
    //int buttonW = (WIDTH/1) / modeButtonText.length - buttonGapX;
    int minButtonW = 50;
    int buttonH = ACTIVE_TOOLBAR_HEIGHT;
   

    // Attempt1: manual background
    // buffer.beginDraw();
    // buffer.fill(color(120, 120));
    // buffer.rect(originX, originY, WIDTH, ACTIVE_TOOLBAR_HEIGHT);
    // buffer.smooth();
    // buffer.textAlign(LEFT,BOTTOM);
    // buffer.textFont(smallFont);
    // //buffer.textSize(16);
    // buffer.noFill();
    // buffer.endDraw();

    modes = cp5.addRadioButton("mode")
      .setPosition(originX,originY)
      .setSize(minButtonW,ACTIVE_TOOLBAR_HEIGHT)
      .setColorForeground(color(120,120))
      .setColorActive(color(255))
      .setColorLabel(color(0))
      .setItemsPerRow(15)
      .setSpacingColumn(buttonGapX);

    for (int i = 0; i<modeButtonText.length; i++){
      String text = modeButtonText[i];
      modes.addItem(text,i);
    }

    modes.activate(0);
    
    // THIS IS HORRIBLE HORRIBLE HORRIBLE!!!! IN THIS DAY AND AGE, STILL HAVE TO MOVE MARGINS&PADDINGS????
    
    for(Toggle t: modes.getItems()) {
       t.captionLabel().setColorBackground(color(255,80));
       t.captionLabel().style().moveMargin(-7,0,0,-52);
       t.captionLabel().style().movePadding(7,0,0,1);
       t.captionLabel().style().backgroundWidth = 48;
       t.captionLabel().style().backgroundHeight = 13;
     }


    play = cp5.addToggle("play")
      .setPosition(600,originY);
    play.captionLabel().style().moveMargin(-17,0,0,4);

    mute = cp5.addToggle("mute")
      .setPosition(640,originY);
    mute.captionLabel().style().moveMargin(-17,0,0,4);

    Button clear
      = cp5.addButton("clear_button")
            .setCaptionLabel("clear")
      .setSize(40,ACTIVE_TOOLBAR_HEIGHT)
      .setPosition(680,originY);
    clear.captionLabel().style().moveMargin(0,0,0,4);

    
    Button undo
      = cp5.addButton("undo_button")
      .setCaptionLabel("undo")
      .setPosition(720,originY)
      .setSize(40,ACTIVE_TOOLBAR_HEIGHT);
    undo.captionLabel().style().moveMargin(0,0,0,4);

  
    Button redo
      = cp5.addButton("redo_button")
      .setCaptionLabel("redo")
      .setSize(40,ACTIVE_TOOLBAR_HEIGHT)
      .setPosition(760,originY);
    redo.captionLabel().style().moveMargin(0,0,0,4);
    

    Button load_button
      = cp5.addButton("load_button")
      .setCaptionLabel("load")
      .setSize(40,ACTIVE_TOOLBAR_HEIGHT)
      .setPosition(800,originY);
    load_button.captionLabel().style().moveMargin(0,0,0,4);


    Button save_button
      = cp5.addButton("save_button")
      .setCaptionLabel("save")
      .setSize(40,ACTIVE_TOOLBAR_HEIGHT)
      .setPosition(840,originY);
    save_button.captionLabel().style().moveMargin(0,0,0,4);
    
    Toggle help
      = cp5.addToggle("help")
      .setCaptionLabel(" ? ")
      .setSize(40,ACTIVE_TOOLBAR_HEIGHT)
      .setPosition(880,originY);
    help.captionLabel().style().moveMargin(-17,0,0,4);


    
    RadioButton colours
      = cp5.addRadioButton("colour")
      .setPosition(415, originY)
      .setSize(10,ACTIVE_TOOLBAR_HEIGHT)  
      .setColorForeground(color(255,120))
      .setColorBackground(color(255,120))
      .setColorActive(color(255))
      .setItemsPerRow(20)
      .setSpacingColumn(0);

    int nBaseColours = colourManager.solarizedBase.length;
    
    for (int i = 0; i<nBaseColours; i++){
      colours.addItem(""+i,i);
    }
    
    for (int i = 0; i<colourManager.solarizedAccent.length; i++){
      colours.addItem("i"+i,nBaseColours+i);
    }


    for (int i=0; i<nBaseColours; i++) {
      Toggle t = colours.getItem(i);
      t.setLabel("");
      
      t.captionLabel().setVisible(true);
      t.captionLabel().style().backgroundWidth = 10;
      t.captionLabel().style().backgroundHeight = 20;
      t.captionLabel().style().moveMargin(-7,0,0,-13);
      t.captionLabel().style().movePadding(0,0,0,0);
      t.captionLabel().setColor(colourManager.solarizedBase[i]);
      t.captionLabel().setColorBackground(colourManager.solarizedBase[i]);      
      t.valueLabel().setVisible(false);
      
    }

    for (int i=0; i<colourManager.solarizedAccent.length; i++) {
      Toggle t = colours.getItem(nBaseColours+i);
      t.setLabel("");
      t.captionLabel().setVisible(true);
      t.captionLabel().style().backgroundWidth = 10;
      t.captionLabel().style().backgroundHeight = 20;
      t.captionLabel().style().moveMargin(-7,0,0,-13);
      t.captionLabel().style().movePadding(0,0,0,0);
      t.captionLabel().setColor(colourManager.solarizedAccent[i]);
      t.captionLabel().setColorBackground(colourManager.solarizedAccent[i]);
 
      t.valueLabel().setVisible(false);      
    }
    
    colours.activate(9); // #ffffff

    
    // Attempt1: manual buttons (or with cp5)
    // for (int i=0; i<modeButtonText.length; i++) {
    //   String text = modeButtonText[i];
      
    //   // buffer.beginDraw();
    //   // buffer.fill(0);
    //   // buffer.text(text, buttonX, buttonY+20);//, buttonW, buttonH);
    //   // buffer.endDraw();

    //   //buttonX += Math.max(minButtonW, text.length()*8) + buttonGapX;
      
    //   cp5.addToggle(text)
    //      .setPosition(buttonX, buttonY)
    //      .setSize(minButtonW, buttonH)
    //     .setValue(i);

    //   buttonX += minButtonW + buttonGapX;
    // }
    
    return this;
  }
  

  void onControlEvent(ControlEvent e) {

    String trigger = e.getName();
    
    if ("mode".equals(trigger)) {
    
      int value = (int)e.getValue();
    
      switch(value) {
      case(0):
        freehandBrushPaintEffect_mode();
        break;
      case(1):
        freehandBrushStandard_mode();
        break;
      case(2):
        freehandBrushDots_mode();
        break;
      case(3):
        rectangle_mode();
        break;
      case(4):
        triangle_mode();
        break;
      case(5):
        ellipse_mode();
        break;
      case(6):
        blur_mode();
        break;
      case(7):
        selection_mode();      
        break;     
      }
    }
    else if ("colour".equals(trigger)) {
      int value = (int)e.getValue();
      if (value == -1) // don't do anything when the active colour is ticked off
        return;

      int nBaseColours = colourManager.solarizedBase.length;
      if (value < nBaseColours)
        colourManager.colourSelection(value, false);
      else
        colourManager.colourSelection(value - nBaseColours, true);
    }   
    // FIXME: these seem to trigger undo/redo twice???
    else if ("undo_button".equals(trigger)) {
      undo();
    }
    else if ("redo_button".equals(trigger)) {
      redo();
    }
    else if ("play".equals(trigger)) {
      toggleSoundAndMovement();
    }
    else if ("mute".equals(trigger)) {
      toggleSound();
    }
    else if ("clear_button".equals(trigger)) {
      clear_workbuffer();
    }
    else if ("load_button".equals(trigger)) {
      imageManager.openImage();
    }
    else if ("save_button".equals(trigger)) {
      imageManager.saveAsImage();
    }
    else if ("help".equals(trigger)) {
      toggle_help();
    }

  }



  // FIXME: to get the toolbar and the keyboardUI operate in sync,
  // we need to do the activisations via the cp5 objects.
  // this sucks, as it makes cp5 more necessary than it's worth.
  // cf KeyboardUI
  void activate_mode(String mode) {
    int index = Arrays.asList(modeButtonText).indexOf(mode);
    if (index > -1)
      modes.activate(index);    
  }

  void toggle() {
    this.isVisible = !this.isVisible;
  }

  void toggle_play() {
    play.toggle();
  }

  void toggle_mute() {
    mute.toggle();
  }


  boolean pointIsInside (int x, int y) {
    return this.isVisible && (y > HEIGHT - ACTIVE_TOOLBAR_HEIGHT);
  }
  
}
