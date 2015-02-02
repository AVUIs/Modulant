import org.puredata.processing.PureData;
import org.multiply.processing.TimedEventGenerator;
import javax.swing.undo.UndoManager;

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

int WIDTH = 800;
int HEIGHT = 600;


PGraphics workBuffer;
PGraphics effectsBuffer;
PGraphics gridBuffer;

PureDataMiddleware pd;

DragAction rubberBandSelection;
DragAction rubberBandRectangle;
DragAction rubberBandTriangle;
DragAction rubberBandEllipse;
DragAction freehandBrushStandard;
DragAction freehandBrushDots;

KeyboardUI keyboardUI;

ColourManager colourManager;

IDrawer activeDrawer = null;

ScanningController scanningController;
void onTimerEvent() { scanningController.onTimerEvent(); }

GridController grid;

OnscreenHelp onscreenHelp;

UndoManager undoManager;

ImageManager imageManager;




void setup() {

  /* Configuration */

  config = new Config()
    .lengthInSeconds(30)
    .bpm(125)
    .octaves(10)
    .intervalsInOctave(OctaveDivisions.TET24)
    .backgroundImage("data/klee-lines-dots-drawing-bw.jpg")
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


  /* Buffers (Layers) */

  workBuffer = createGraphics(WIDTH,HEIGHT);
  effectsBuffer = createGraphics(WIDTH, HEIGHT);
  gridBuffer = createGraphics(WIDTH, HEIGHT);
  gridBuffer.background(255,0);


  /* Controllers and Managers */

  imageManager = new ImageManager(this, workBuffer);
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
  undoManager.setLimit(10);


  /* Drawing modes */

  rubberBandSelection
    = new DragAction(this.g, 
                     new IDragStep() { 
                       public void action(PGraphics g, int start_x, int start_y, int current_x, int current_y) {
                         g.beginDraw();
                         g.rect(start_x, start_y, current_x-start_x,current_y-start_y);  
                         g.endDraw();
                       } 
                     }, color(255,204,0,127))
    .propagateTo(effectsBuffer);


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


  freehandBrushStandard
    = new DragAction(this.g, 
                     new IDragStep() { 
                       public void action(PGraphics g, int start_x, int start_y, int current_x, int current_y) {
                         g.beginDraw();
                         g.ellipse(current_x, current_y, 10, 10);  
                         g.endDraw();
                       } 
                     })
    .propagateTo(workBuffer, true);


  freehandBrushDots
    = new DragAction(this.g, 
                     new IDragStep() { 
                       public void action(PGraphics g, int start_x, int start_y, int current_x, int current_y) {
                         int nDots = 10;
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

}

void draw() {

  background(0);

  //grid.mark(5,5);
  
  image(workBuffer,0,0);
  image(gridBuffer,0,0);
  image(effectsBuffer,0,0);
  if (activeDrawer != null)
    activeDrawer.draw();
  image(onscreenHelp.getBuffer(),0,0);
}
