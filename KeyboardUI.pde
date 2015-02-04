// benefits from http://forum.processing.org/two/discussion/5859/example-keyboard-navigation-with-shifted-key-combinations-and-number-pad-keys-using-keyevents
// http://docs.oracle.com/javase/6/docs/api/java/awt/event/KeyEvent.html

import java.awt.event.KeyEvent;

// FIXME: to get the toolbar and the keyboardUI operate in sync,
// we need to do the activisations via the cp5 objects.
// this sucks, as it makes cp5 more necessary than it's worth.
// cf Toolbar


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
      //toggleSoundAndMovement();
      toolbar.toggle_play();
      break;
    case KeyEvent.VK_M:
      //      pd.silenceAll();
      //toggleSound();
      toolbar.toggle_mute();
      break;
    case KeyEvent.VK_R:
      //rectangle_mode();
      toolbar.activate_mode("Rectangle");
      break;
     case KeyEvent.VK_T:
       if (isKeyPressed(KeyEvent.VK_SHIFT))
         toolbar.toggle();
       else
         //triangle_mode();
         toolbar.activate_mode("Triangle");
      break;
     case KeyEvent.VK_E:
       //ellipse_mode();
       toolbar.activate_mode("Ellipse");
      break;
    case KeyEvent.VK_F:
      //freehandBrushStandard_mode();
      toolbar.activate_mode("Freeline");
      break;
     case KeyEvent.VK_D:
       //freehandBrushDots_mode();
       toolbar.activate_mode("Dots");
      break;
     case KeyEvent.VK_P:
       //freehandBrushPaintEffect_mode();
       toolbar.activate_mode("Paintbrush");
      break;      
    case KeyEvent.VK_G:
      grid.toggle();
      break;
    case KeyEvent.VK_H:
      toggle_help();
      break;
    case KeyEvent.VK_L:
      if (isKeyPressed(KeyEvent.VK_SHIFT)) {
        clear_workbuffer();
      }
      break;
    case KeyEvent.VK_Z:
      if (isKeyPressed(KeyEvent.VK_CONTROL)) {
        undo();
      } else {
        // TODO: enable when done
        // stopAllDrawHandlers();
        // activeCursor = HAND;      
        // zoomAndPanController.start();
      }             
      break;
    case KeyEvent.VK_EQUALS:
      zoomAndPanController.zoom(-1);
      break;
    case KeyEvent.VK_MINUS:
      zoomAndPanController.zoom(1);
      break;
    case KeyEvent.VK_NUMBER_SIGN:
      zoomAndPanController.reset();
      break;
    case KeyEvent.VK_Y:
      if (isKeyPressed(KeyEvent.VK_CONTROL)) {
        redo();
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
        //selection_mode();
        toolbar.activate_mode("Select");
      }
      break;
    case KeyEvent.VK_B:
      //blur_mode();
      toolbar.activate_mode("Blur");
      break;
    case KeyEvent.VK_C:
      if (//isKeyPressed(KeyEvent.VK_CONTROL) &&
          selectionController.hasSelection()) {
        selectionController.copySelection().mode("interactivePaste");
      }
      break;
    case KeyEvent.VK_V:
      if (//isKeyPressed(KeyEvent.VK_CONTROL) &&
          selectionController.hasSelection()) {
        selectionController.mode("interactivePaste");
      }
      break;
    case KeyEvent.VK_X:
      if (//isKeyPressed(KeyEvent.VK_CONTROL) &&
          selectionController.hasSelection()) {
        selectionController.cutSelection().mode("interactivePaste");
      }
      break;

    case KeyEvent.VK_ESCAPE:
      key = 0;
      selectionController.clear().mode("mark");
      break;
      case KeyEvent.VK_Q:
        if (isKeyPressed(KeyEvent.VK_CONTROL))
          exit();        
        break;
    case KeyEvent.VK_A:
      //pd.send(113, 10.0);
      break;
    default:
      if (key >= '0' && key <= '9')
        colourManager.colourSelection(key-(int)'0', isKeyPressed(KeyEvent.VK_CONTROL));
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
