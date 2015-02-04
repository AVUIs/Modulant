import org.puredata.processing.PureData;
import org.multiply.processing.TimedEventGenerator;
import javax.swing.undo.UndoManager;
import controlP5.*;


/* Modulant - A sonification and audiovisual performance interface experiment.
   Copyright 2015 Berkan Eskikaya, Louis Pilfold
 */


//String bgImageFile = "data/klee-lines-dots-drawing-bw.jpg";
//String bgImageFile = "data/Coil-ANS-C-grey.png";
//String bgImageFile = "data/Coil-ANS-D-grey.png";
//String bgImageFile = "data/sc02-1n.jpg";
//String bgImageFile = "data/graph2d-1.png";
//String bgImageFile = "data/graph2d-2.png";
//String bgImageFile = "data/graph2d-3.png";


Config config;

int WIDTH = 900;
int HEIGHT = 600;


PGraphics workBuffer;
PGraphics effectsBuffer;
PGraphics gridBuffer;
PGraphics selectionBuffer;

PureDataMiddleware pd;

DragAction rubberBandSelection;
DragAction rubberBandRectangle;
DragAction rubberBandTriangle;
DragAction rubberBandEllipse;
DragAction freehandBrushStandard;
DragAction freehandBrushDots;
DragAction freehandBrushPaintEffect;


KeyboardUI keyboardUI;

ColourManager colourManager;

IDrawer activeDrawer = null;

ScanningController scanningController;
void onTimerEvent() { scanningController.onTimerEvent(); }

GridController grid;

Toolbar toolbar;
void controlEvent(ControlEvent theEvent) { toolbar.onControlEvent(theEvent); } // for controlP5

OnscreenHelp onscreenHelp;

UndoManager undoManager;

ImageManager imageManager;

SelectionController selectionController;

int activeCursor = ARROW;

ZoomAndPanController zoomAndPanController;


void setup() {

  /* Configuration */

  config = new Config()
    .lengthInSeconds(30)
    .bpm(125)
    .octaves(10)
    .intervalsInOctave(OctaveDivisions.TET12)
    //.backgroundImage("data/klee-lines-dots-drawing-bw.jpg")
    .update();

  // config = new Config()
  //   .lengthInSeconds(30)
  //   .bpm(125)
  //   .octaves(5)
  //   .lowestFrequency(60)
  //   .intervalsInOctave(OctaveDivisions.TET48)
  //   .backgroundImage("data/klee-lines-dots-drawing-bw.jpg")
  //   .update();


  // config = new Config()
  //   .lengthInSeconds(30)
  //   .bpm(125)
  //   .octaves(4)
  //   .intervalsInOctave(OctaveDivisions.TET72)
  //   .backgroundImage("data/klee-lines-dots-drawing-bw.jpg")
  //   .update();

  println(config);


  size(WIDTH, HEIGHT);
  frameRate(30);
  smooth();
  
  if (frame != null) {
    frame.setResizable(true);
  }

  /* Buffers (Layers) */

  workBuffer = createGraphics(WIDTH,HEIGHT);
  effectsBuffer = createGraphics(WIDTH, HEIGHT);
  selectionBuffer = createGraphics(WIDTH, HEIGHT);
  gridBuffer = createGraphics(WIDTH, HEIGHT);
  gridBuffer.background(255,0);


  /* Controllers and Managers */

  imageManager = new ImageManager(this, workBuffer);
  if (!"".equals(config.backgroundImage()))
    imageManager.background(config.backgroundImage());


  grid = new GridController(gridBuffer, config.lengthInBeats(), config.octaves(), color(50,50,50,127));

  onscreenHelp = new OnscreenHelp();

  keyboardUI = new KeyboardUI();
  keyboardUI.start();

  colourManager = new ColourManager();

  pd = new PureDataMiddleware(this,config);
  pd.start();

  scanningController = new ScanningController(this, config, workBuffer, effectsBuffer);
  scanningController.start();

  undoManager = new UndoManager();
  undoManager.setLimit(5);

  selectionController = new SelectionController(this, selectionBuffer, workBuffer);
  //  selectionController.start();
  

  /* Drawing modes */

  rubberBandSelection
    = new DragAction(this.g, 
                     new IDragStep() { 
                       public void action(PGraphics g, int start_x, int start_y, int current_x, int current_y) {
                         g.beginDraw();
                         g.rect(start_x, start_y, current_x-start_x,current_y-start_y);  
                         g.endDraw();
                       } 
                     }, color(152,251,152,127))
    //                     color(255,204,0,127))
    .propagateTo(selectionBuffer);


  rubberBandRectangle
    = new DragAction(this.g, 
                     new IDragStep() { 
                       public void action(PGraphics g, int start_x, int start_y, int current_x, int current_y) {
                         g.beginDraw();
                         g.rect(start_x, start_y, current_x-start_x,current_y-start_y);  
                         g.endDraw();
                       } 
                     })
    .propagateTo(workBuffer);
  

  rubberBandTriangle
    = new DragAction(this.g, 
                     new IDragStep() { 
                       public void action(PGraphics g, int start_x, int start_y, int current_x, int current_y) {
                         g.beginDraw();
                         g.triangle(start_x, start_y, current_x,current_y, current_x,start_y-(current_y-start_y));  
                         g.endDraw();
                       } 
                     })
    .propagateTo(workBuffer);


  rubberBandEllipse
    = new DragAction(this.g, 
                     new IDragStep() { 
                       public void action(PGraphics g, int start_x, int start_y, int current_x, int current_y) {
                         g.beginDraw();
                         g.ellipse(start_x,start_y, current_x-start_x,start_y-current_y);  
                         g.endDraw();
                       } 
                     })
    .propagateTo(workBuffer);
    
  
  freehandBrushPaintEffect
    = new DragAction(this.g, 
                     new IDragStep() { 
                       public void action(PGraphics g, int start_x, int start_y, int current_x, int current_y) {
                         g.beginDraw();
                         //g.ellipse(current_x, current_y, 10, 10);
                         g.stroke(colourManager.activeColour());
                         for ( int i=0;i<10;i++) {
                           g.line(mouseX+random(5), mouseY+random(5), pmouseX+random(5), pmouseY+random(5));
                           //g.line(start_x+random(10), start_y+random(10), current_x+random(10), current_y+random(10));
                           g.strokeWeight(1);
                         }
                         g.endDraw();
                       } 
                     })
    .propagateTo(workBuffer, true);


  freehandBrushStandard
    = new DragAction(this.g,
                     new IDragStep() {
                       public void action(PGraphics g, int start_x, int start_y, int current_x, int current_y) {
                         float thickness = 1f;
                         float maxThickness = 10f;
                         g.beginDraw();
                         g.stroke(colourManager.activeColour());
                         g.strokeWeight(thickness);
                         g.line(mouseX, mouseY, pmouseX, pmouseY);                        
                         g.endDraw();
                         thickness = Math.min(thickness+0.25, maxThickness);
                       }
                     })
    .propagateTo(workBuffer, true);
  
  
  freehandBrushDots
    = new DragAction(this.g, 
                     new IDragStep() { 
                       public void action(PGraphics g, int start_x, int start_y, int current_x, int current_y) {
                         int nDots = 3;
                         int radius = 15;
                         int maxdotsize = 2;
                         g.beginDraw();
                         for (int n=0; n<nDots; n++) {
                           float dotsize = random(1.0)*maxdotsize;
                           float r = noise((float)current_x, (float)current_y, (float)n) * radius;
                           float theata = noise((float)current_x, (float)current_y, (float)n) * 360;
                           float x = r * cos(theata);
                           float y = r * sin(theata);
                           //println(r + " " + theata + " " + x + " " + y);
                           g.ellipse(current_x+x, current_y+y, dotsize, dotsize);  
                         }                         
                         g.endDraw();
                       } 
                     })
    .propagateTo(workBuffer, true);

  activeDrawer = freehandBrushPaintEffect;
  activeDrawer.start();

  // need to set this up after activeDrawer is set (because it calls a function to activate it)
  toolbar = new Toolbar(this, gridBuffer);
  toolbar.setup();
  

  zoomAndPanController = new ZoomAndPanController(WIDTH/2,HEIGHT/2,WIDTH,HEIGHT);
  // TODO: it works, but disabling for the moment, because the drawing
  // tools don't know how to translate from the zoomed/panned coordinates
  // to the underlying buffer coordinates
  zoomAndPanController.disable(); 
  
}

ControlP5 cp5;

void draw() {

  background(0);

  //grid.mark(5,5);

  imageMode(CENTER);
  
  if (mouseY < ScanningController.ACTIVE_TOPBAR_HEIGHT
      || mouseY > HEIGHT - Toolbar.ACTIVE_TOOLBAR_HEIGHT) {
    cursor(HAND);
  } else {
    cursor(activeCursor);
  }

  int centerX = zoomAndPanController.centerX();
  int centerY = zoomAndPanController.centerY();
  int sketchW = zoomAndPanController.sketchW();
  int sketchH = zoomAndPanController.sketchH();

  image(workBuffer, centerX, centerY, sketchW, sketchH);
  image(gridBuffer, centerX, centerY, sketchW, sketchH);
  image(effectsBuffer, centerX, centerY, sketchW, sketchH);
  image(selectionBuffer, centerX, centerY, sketchW, sketchH);
  if (activeDrawer != null)
    activeDrawer.draw();
  image(onscreenHelp.getBuffer(), centerX, centerY, sketchW, sketchH);


  if (toolbar.isVisible)
    cp5.draw();
  
  // image(workBuffer,0,0);
  // image(gridBuffer,0,0);
  // image(effectsBuffer,0,0);
  // image(selectionBuffer,0,0);
  // if (activeDrawer != null)
  //   activeDrawer.draw();
  // image(onscreenHelp.getBuffer(),0,0);
}
