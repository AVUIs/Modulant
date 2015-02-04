void rectangle_mode() {
    stopAllDrawHandlers();
    activeCursor = ARROW;
    activeDrawer = rubberBandRectangle;
    activeDrawer.start();
}

void triangle_mode() {
  stopAllDrawHandlers();
  activeCursor = ARROW;
  activeDrawer = rubberBandTriangle;
  activeDrawer.start();
}

void ellipse_mode() {
  stopAllDrawHandlers();
  activeCursor = ARROW;
  activeDrawer = rubberBandEllipse;
  activeDrawer.start();
}

void freehandBrushStandard_mode() {
  stopAllDrawHandlers();
  activeCursor = ARROW;
  activeDrawer = freehandBrushStandard;
  activeDrawer.start();
}

void freehandBrushDots_mode() {
  stopAllDrawHandlers();
  activeCursor = ARROW;
  activeDrawer = freehandBrushDots;
  activeDrawer.start();
}

void freehandBrushPaintEffect_mode() {
  stopAllDrawHandlers();
  activeCursor = ARROW;
  activeDrawer = freehandBrushPaintEffect;
  activeDrawer.start();
}

void selection_mode() {
  stopAllDrawHandlers();
  activeCursor = CROSS;
  activeDrawer = rubberBandSelection;
  activeDrawer.start();
  selectionController.mode("mark").start();
}

void blur_mode() {
  stopAllDrawHandlers();
  activeCursor = ARROW;
  activeDrawer = rubberBandSelection;
  activeDrawer.start();
  selectionController.mode("blur").start();
}


//TODO doesn't work
void interactiveCopyPaste_mode() {
  selection_mode();
  selectionController.mode("interactivePaste").start();
}


void undo() {
  try { undoManager.undo(); } catch(Exception e) {};
}

void redo() {
  try { undoManager.redo(); } catch(Exception e) {};
}


void toggleSoundAndMovement() {
  scanningController.toggleSound();
  scanningController.toggleMovement();
}


void toggleSound() {
  scanningController.toggleSound();
}


void clear_workbuffer() {
  imageManager.clear();
}

void toggle_help() {
  onscreenHelp.toggle();
}

