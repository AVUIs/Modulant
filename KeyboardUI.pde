// benefits from http://forum.processing.org/two/discussion/5859/example-keyboard-navigation-with-shifted-key-combinations-and-number-pad-keys-using-keyevents
// http://docs.oracle.com/javase/6/docs/api/java/awt/event/KeyEvent.html

import java.awt.event.KeyEvent;

public class KeyboardUI extends EventHandler {
  
  //
  // keep a map of the pressed keys for detecting shifted combinations
  //
  boolean[] keys = new boolean[526];

  public KeyboardUI () {
  }

  
  void keyPressed() {
    keys[keyCode] = true;

    switch(keyCode) {
    case KeyEvent.VK_LEFT:
      //pd.silenceAll();
      if (isKeyPressed(KeyEvent.VK_SHIFT))
        if (isKeyPressed(KeyEvent.VK_CONTROL))
          scanningController.moveScanline(-50);
        else
          scanningController.moveScanline(-10);
      else
        scanningController.moveScanline(-1);
      break;
    case KeyEvent.VK_RIGHT:
      //pd.silenceAll();
      if (isKeyPressed(KeyEvent.VK_SHIFT))
        if (isKeyPressed(KeyEvent.VK_CONTROL))
          scanningController.moveScanline(50);
        else
          scanningController.moveScanline(10);
      else
        scanningController.moveScanline(1);
      break;
    case KeyEvent.VK_SPACE:
      scanningController.toggleSound();
      scanningController.toggleMovement();
      break;
    case KeyEvent.VK_M:
      //      pd.silenceAll();
      scanningController.toggleSound();
      break;
    case KeyEvent.VK_R:
      stopAllDragActionHandlers();
      activeDrawer = rubberBandRectangle;
      activeDrawer.start();
      break;
     case KeyEvent.VK_T:
      stopAllDragActionHandlers();
      activeDrawer = rubberBandTriangle;
      activeDrawer.start();
      break;
     case KeyEvent.VK_E:
      stopAllDragActionHandlers();
      activeDrawer = rubberBandEllipse;
      activeDrawer.start();
      break;
     case KeyEvent.VK_F:
      stopAllDragActionHandlers();
      activeDrawer = freehandBrushStandard;
      activeDrawer.start();
      break;
     case KeyEvent.VK_D:
      stopAllDragActionHandlers();
      activeDrawer = freehandBrushDots;
      activeDrawer.start();
      break;
    case KeyEvent.VK_G:
      grid.toggle();
      break;
    case KeyEvent.VK_H:
      onscreenHelp.toggle();
      break;
    case KeyEvent.VK_C:
      if (isKeyPressed(KeyEvent.VK_SHIFT)) {
        imageManager.clear();        
      }
    case KeyEvent.VK_Z:
      if (isKeyPressed(KeyEvent.VK_CONTROL)) {
        try { undoManager.undo(); } catch(Exception e) {};
      }
      break;
    case KeyEvent.VK_Y:
      if (isKeyPressed(KeyEvent.VK_CONTROL)) {
        try { undoManager.redo(); } catch(Exception e) {};
      }
      break;
    case KeyEvent.VK_O:
      if (isKeyPressed(KeyEvent.VK_CONTROL)) {
        imageManager.openImage();
      }
      break;
    case KeyEvent.VK_S:
      if (isKeyPressed(KeyEvent.VK_CONTROL)) {
        imageManager.saveAsImage();
      } else {
        stopAllDragActionHandlers();
        activeDrawer = rubberBandSelection;
        activeDrawer.start();
      }
      break;
    default:
      if (key >= '0' && key <= '9')
        colourManager.colourSelection(key, isKeyPressed(KeyEvent.VK_CONTROL));
    }    
  }


  void keyReleased() {    
    keys[keyCode] = false;
  }
 

  //
  // simple approach to dealing with shifted keys
  //
  boolean isKeyPressed(int k) {
    if (keys.length >= k) {
      return keys[k];
    }
    return false;
  }
  
  //
  // compose key description prefix of shifted keys
  //
  String keyPrefix() {
    String prefix;
    boolean prefixPresent;
    prefix = "";
    prefixPresent = false;
 
    if (isKeyPressed(KeyEvent.VK_SHIFT)) {
      prefix += "SHIFT";
      prefixPresent = true;
    }
    if (isKeyPressed(KeyEvent.VK_CONTROL)) {
      prefix += (prefixPresent == true ? "-" : "") +"CTRL";
      prefixPresent = true;
    }
    if (isKeyPressed(KeyEvent.VK_ALT)) {
      prefix += (prefixPresent == true ? "-" : "") +"ALT"; 
      prefixPresent = true;
    }
    prefix += (prefixPresent == true ? " " : "");
    return prefix;
  }

}
