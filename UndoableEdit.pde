import javax.swing.undo.CannotUndoException;
import javax.swing.undo.CannotRedoException;
import javax.swing.undo.UndoableEditSupport;
import javax.swing.undo.AbstractUndoableEdit;


public class UndoableEdit extends AbstractUndoableEdit {
  
  ArrayList<PropagateTarget> savedTargets;
  
  ArrayList<color[]> savedTargetsPixelsForUndo = new ArrayList<color[]>();
  ArrayList<color[]> savedTargetsPixelsForRedo = new ArrayList<color[]>();


  public UndoableEdit (PropagateTarget savedTarget) {
    ArrayList<PropagateTarget> savedTargets = new ArrayList<PropagateTarget>();
    savedTargets.add(savedTarget);
    this.savedTargets = savedTargets;
    extractUndoRedoInformation(savedTargetsPixelsForUndo);

  }

  public UndoableEdit (ArrayList<PropagateTarget> savedTargets) {
    this.savedTargets = savedTargets;

    extractUndoRedoInformation(savedTargetsPixelsForUndo);
  }

  public void extractUndoRedoInformation(ArrayList<color[]>savedTargetsPixels) {
    for (PropagateTarget target : savedTargets) {
      target.buffer.loadPixels();

      color[] targetBufferPixels = new color[target.buffer.pixels.length];
      System.arraycopy(target.buffer.pixels, 0, targetBufferPixels, 0, target.buffer.pixels.length);

      savedTargetsPixels.add(targetBufferPixels);
    }
  }

  public void undo() throws CannotUndoException {
    super.undo();
    //    println("undo");
    restoreFromUndoRedoInformation(savedTargetsPixelsForUndo);
  }

  public void redo() throws CannotRedoException {
    super.redo();
    //    println("redo");
    restoreFromUndoRedoInformation(savedTargetsPixelsForRedo);
  }


  public void restoreFromUndoRedoInformation(ArrayList<color[]> savedTargetsPixels) {
    for (int i=0; i< savedTargets.size(); i++) {
      PropagateTarget target = savedTargets.get(i);
      target.buffer.loadPixels();
      color[] savedTargetPixels = savedTargetsPixels.get(i);
      System.arraycopy(savedTargetPixels, 0, target.buffer.pixels, 0, target.buffer.pixels.length);
      target.buffer.updatePixels();
    }

  }
  

  public void updateBoundingBox(int start_x, int start_y, int final_x, int final_y) {
  }
  
  public void finalize() {
    extractUndoRedoInformation(savedTargetsPixelsForRedo);
  }

  public String getPresentationName() {
    return "";
  }


}
