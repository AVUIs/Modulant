// Based on https://processing.org/discourse/beta/num_1253804974.html


interface IDragStep {
  void action(PGraphics g, int start_x, int start_y, int current_x, int current_y);
}


public class PropagateTarget {
  PGraphics buffer;
  boolean isUpdatedAtEveryStep;
  public PropagateTarget(PGraphics buffer, boolean isUpdatedAtEveryStep) {
    this.buffer = buffer;
    this.isUpdatedAtEveryStep = isUpdatedAtEveryStep;
  }
  public PropagateTarget(PGraphics buffer) {
    this(buffer, false);
  }
}


public class DragAction extends EventHandler implements IDrawer {

  protected int start_x; // catch the start dragging point x
  protected int start_y; // catch the start dragging point y
  protected int current_x; // record moving mouseX
  protected int current_y; // record moving mouseY

  protected color DEFAULT_FINAL_COLOR = color(255, 204, 0, 255); // full-opaque
  protected color DEFAULT_TRANS_COLOR = color(255, 204, 0, 127); // half-transparent
  protected color transcolor = -1; //HACK
  protected color finalcolor = -1; //HACK


  IDragStep dragStep;


  PGraphics screen;
  ArrayList<PropagateTarget> propagateTargets = new ArrayList<PropagateTarget>();
  

  private UndoableEdit undoableEdit;


  public DragAction (PGraphics screen, IDragStep dragStep, color finalcolor) {
    this.screen = screen;
    this.dragStep = dragStep;
    this.finalcolor = finalcolor;
  }

  public DragAction (PGraphics screen, IDragStep dragStep) {
    this(screen, dragStep, -1);
  }

  
  public DragAction propagateTo(PGraphics buffer, boolean isUpdatedAtEveryStep) {
    this.propagateTargets.add(new PropagateTarget(buffer, isUpdatedAtEveryStep));
    return this;
  }

  public DragAction propagateTo(PGraphics buffer) {
    return propagateTo(buffer, false);
  }


  void draw() {

    int sizex = current_x - start_x;
    int sizey = current_y - start_y;

    if (sizex == 0 && sizey == 0)
      return;

    fill(transcolor());
    dragStep.action(screen, start_x, start_y, current_x, current_y);

    for (PropagateTarget target : propagateTargets) { 
      if (target.isUpdatedAtEveryStep)
        dragStep.action(target.buffer, start_x, start_y, current_x, current_y); 
    }
  }

  void mousePressed() {
    start_x = mouseX;
    start_y = mouseY;
    mouseDragged(); // Reset vars

    ArrayList<PropagateTarget> savedTargets = new ArrayList<PropagateTarget>(propagateTargets);
    savedTargets.add(new PropagateTarget(screen, false));

    undoableEdit = new UndoableEdit(savedTargets);
  }

  void mouseDragged() {
    current_x = mouseX;
    current_y = mouseY;
    stroke(255,255,255);
    fill(transcolor());
  }

  void mouseReleased() {

    //undoableEdit.updateBoundingBox(start_x, start_y, current_x, current_y);

    fill(finalcolor());
    dragStep.action(screen, start_x, start_y, current_x, current_y);

    for (PropagateTarget target : propagateTargets) {
      target.buffer.beginDraw();
      target.buffer.noStroke();
      target.buffer.fill(finalcolor());
      target.buffer.endDraw();
      dragStep.action(target.buffer, start_x, start_y, current_x, current_y);
    }

    undoableEdit.finalize();
    
    undoManager.addEdit(undoableEdit);

    reset();    
  }

  protected DragAction reset() {
    start_x = start_y = current_x = current_y = 0;
    return this; 
  }

  
  protected color finalcolor() {
    if (this.finalcolor != -1) //HACK
      return this.finalcolor;
    else 
      return colourManager.activeColour();
  }

  protected color transcolor() {
    if (this.transcolor != -1) //HACK
      return this.transcolor;
    else 
      return color(colourManager.activeColour(), 127);

  }

}


public static void stopAllDragActionHandlers() {
  for (Object handler : EVENT_LISTENERS) {
    if (handler instanceof DragAction) {
      ((DragAction)handler).stop();
    }
  }    
}
