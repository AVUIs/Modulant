import java.util.concurrent.CopyOnWriteArrayList;

public static CopyOnWriteArrayList<EventHandler> EVENT_LISTENERS = new CopyOnWriteArrayList<EventHandler>();

interface IEventHandler {
  void mousePressed();
  void mouseMoved();
  void mouseDragged();
  void mouseReleased();
  void mouseWheel(MouseEvent e);
  void keyPressed();
  void keyReleased();
  void keyTyped();
  void start();
  void stop();
}


public class EventHandler implements IEventHandler {
  public EventHandler() {
    //EVENT_LISTENERS.add(this);
  }
  void mousePressed() {
  }
  void mouseMoved() {
  }
  void mouseDragged() {
  }
  void mouseReleased() {
  }
  void mouseWheel(MouseEvent e) {
  }
  void keyPressed() {
  }
  void keyReleased() {
  }
  void keyTyped() {
  }

  void start() {
    EVENT_LISTENERS.add(this);
  }
  void stop() {
    EVENT_LISTENERS.remove(this);
  }

}

// instead of handling input globally, we let
// the event handling obejct(s) take care of it

void mousePressed() {
  for(EventHandler handler: EVENT_LISTENERS) {
   handler.mousePressed();
  }
}
void mouseMoved() {
  for(EventHandler handler: EVENT_LISTENERS) {
   handler.mouseMoved();
  }
}
void mouseDragged() {
  for(EventHandler handler: EVENT_LISTENERS) {
   handler.mouseDragged();
  }
}
void mouseReleased() {
  for(EventHandler handler: EVENT_LISTENERS) {
   handler.mouseReleased();
  }
}
void mouseWheel(MouseEvent e) {
  for (EventHandler handler: EVENT_LISTENERS) {
    handler.mouseWheel(e);
  }
}
void keyPressed() {
  for(EventHandler handler: EVENT_LISTENERS) {
   handler.keyPressed();
  }
}
void keyReleased() {
  for(EventHandler handler: EVENT_LISTENERS) {
   handler.keyReleased();
  }
}
void keyTyped() {
  for(EventHandler handler: EVENT_LISTENERS) {
   handler.keyTyped();
  }
}
