public class ImageManager {
  
  PApplet parent;
  PGraphics buffer;
  PImage bgImage;
  PImage bgImageOrig;

  public ImageManager (PApplet parent, PGraphics buffer) {
    this.parent = parent;
    this.buffer = buffer;
  }


  public void clear() {
    UndoableEdit undoableEdit = new UndoableEdit(new PropagateTarget(buffer));

    buffer.beginDraw();
    buffer.background(0);
    buffer.endDraw();
    
    undoableEdit.finalize();
    undoManager.addEdit(undoableEdit);

  }

  public void background(String bgImageFile) {
    bgImageOrig = loadImage(bgImageFile);

    bgImage = createImage(bgImageOrig.width, bgImageOrig.height, RGB);
    bgImage.copy(bgImageOrig, 0, 0, bgImage.width, bgImage.height, 0, 0, bgImage.width, bgImage.height);

    bgImage.resize(buffer.width, buffer.height);
    
    buffer.beginDraw();
    buffer.background(bgImage);
    buffer.endDraw();
  }

  public void openImage() {
    selectInput("Select an image file to load:", "onOpenImageFileSelected", null, this);
  }

  public void onOpenImageFileSelected(File selection) {
    if (selection != null)
      try {
        background(selection.getCanonicalPath());
      } catch (Exception e) {
        println("Something went wrong: " + e.toString());
      }
  }

  public void saveAsImage() {
    selectInput("Save your work as an image:", "onSaveImageFileSelected", null, this);
  }

  public void onSaveImageFileSelected(File selection) {
    if (selection != null)
      try {
        buffer.save(selection.getCanonicalPath());
      } catch (Exception e) {
        println("Something went wrong: " + e.toString());
      }
  }


}
