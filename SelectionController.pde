import gab.opencv.*;

public class Selection {
  public int x, y, w, h;
  public PImage img;
  public boolean isReady = false;

  
  Selection(PImage img) {
    this.img = img;
  }
  
  Selection(PImage img, int x, int y) {
    this.img = img;
    this.x = x;
    this.y = y;
    this.w = img.width;
    this.h = img.height;
    this.isReady = true;
  }

  Selection(PGraphics g, int x1, int y1, int x2, int y2) {
    if (x1 > x2) {
      int tmp = x2;
      x2 = x1;
      x1 = tmp;
    }
    if (y1 > y2) {
      int tmp = y2;
      y2 = y1;
      y1 = tmp;
    }
    
    this.w = x2-x1;
    this.h = y2-y1;

    
    this.x = x1;
    this.y = y1;
    this.img = createImage(w,h,RGB);

    img.copy(g, x, y, w, h, 0, 0, w, h);

    this.isReady = true;
  }
  
}

public class SelectionController extends EventHandler {

  PGraphics selectionBuffer;
  PGraphics workBuffer;
  PApplet parent;
  
  int x1, y1;
  int x2, y2;
  Selection selection;
  
  String mode = "mark";
  
  
  public SelectionController (PApplet parent, PGraphics selectionBuffer, PGraphics workBuffer) {
    this.selectionBuffer = selectionBuffer;
    this.workBuffer = workBuffer;
    this.parent = parent;
  }

  public SelectionController clear() {
    selectionBuffer.beginDraw();
    selectionBuffer.background(255,0);
    selectionBuffer.endDraw();    
    return this;
  }

  public SelectionController reset() {
    clear();
    return this;
  }

  void mouseMoved() {
    clear();
    if (mode.equals("interactivePaste")) {     
      selectionBuffer.beginDraw();
      selectionBuffer.copy(selection.img, 0, 0, selection.w, selection.h, mouseX, mouseY, selection.w, selection.h);
      selectionBuffer.endDraw();      
    }
  }
  
  void mousePressed() {
    if (mode.equals("interactivePaste")) {
      pasteSelection(mouseX, mouseY);
    } else {    
      reset();
      x1 = mouseX;
      y1 = mouseY;    
    }
  }

  void mouseReleased() {
    x2 = mouseX;
    y2 = mouseY;

    if (mode.equals("mark")) {
      copySelection();
    } else if (mode.equals("blur")) {
      blur();
      reset();
    }

    
    
  }

  boolean hasSelection() {
    return this.selection != null
      && this.selection.isReady
      && this.selection.w > 0
      && this.selection.h > 0;
  }

  
  SelectionController replaceSelection(PImage replacement) {
    if (this.hasSelection()) {
      UndoableEdit undoableEdit = new UndoableEdit(workBuffer);
      println("replaceSelection");
      workBuffer.beginDraw();
      //println("sel", selection.x, selection.y, selection.w, selection.h);
      workBuffer.copy(replacement, 0, 0, selection.w, selection.h,
                      selection.x, selection.y, selection.w, selection.h);
      workBuffer.endDraw();
      undoableEdit.end();
    }
    return this;
  }

  SelectionController copySelection() {
    selection = new Selection(workBuffer, x1, y1, x2, y2);
    return this;
  }

  SelectionController cutSelection() {
    return copySelection().deleteSelection();
  }

  SelectionController deleteSelection() {
    UndoableEdit undoableEdit = new UndoableEdit(workBuffer);
    println("deleteSelection");
    workBuffer.beginDraw();
    workBuffer.fill(0);
    workBuffer.noStroke();
    workBuffer.rect(selection.x, selection.y, selection.w, selection.h);      
    workBuffer.endDraw();
    workBuffer.noFill();
    return this;
  }
  
  SelectionController moveSelection() {
    return this;  
    
  }

    
  SelectionController pasteSelection(int x, int y) {
    UndoableEdit undoableEdit = new UndoableEdit(workBuffer);
    println("pasteSelection");
    workBuffer.beginDraw();
    workBuffer.copy(selection.img, 0, 0, selection.w, selection.h, x, y, selection.w, selection.h);
    workBuffer.endDraw();
    undoableEdit.end();
    return this;    
  }
  
  SelectionController blur() {
    selection = new Selection(workBuffer, x1, y1, x2, y2);
    selection.img.filter(BLUR,3);
    replaceSelection(selection.img);
      
    return this;

  }

  SelectionController mode(String mode) {
    this.mode = mode;
    return this;
  }

  String mode() {
    return mode;
  }
}



// OpenCV opencv = new OpenCV(parent, img);
// opencv.useColor();
// opencv.blur();
// PImage blur = opencv.getOutput();
