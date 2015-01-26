// based on the discussion here: https://processing.org/discourse/beta/num_1213599231.html 
// and some code snippets from [TimedEvent](http://multiply.org/processing/)

//BE if you have the android library for processing installed (and its 32/64bit-ness doesn't match PureData's libpd), 
//BE this import statement will cause a clash! (because the android library also includes java.lang.*)
//BE check it with   println(System.getProperty("java.library.path"));
import java.lang.reflect.Method;

class HighResolutionTimer extends Thread {

  private static final String defaultEventName = "onTimerEvent";
  private PApplet parent;
  private String timerEventName;
  private Method timerEvent;
  
  long previousTime;
  boolean isActive = true;
  int intervalInMs;

  HighResolutionTimer(PApplet parent, int intervalInMs, String timerEventName) {
    this.parent = parent;
    this.intervalInMs = intervalInMs;
    this.timerEventName = timerEventName;

    try {
      timerEvent = parent.getClass().getMethod(timerEventName, (Class<?>[]) null);
    } catch (Exception e) {
      this.isActive = false;
      throw new RuntimeException("Your sketch is using the HighResolutionTimer without defining " +
         "the target method " + timerEventName + "()!");
    }

    previousTime=System.nanoTime();

  }

  HighResolutionTimer(PApplet parent, int intervalInMs) {
    this(parent, intervalInMs, defaultEventName);
  }

  
  public void start() {
    this.isActive = true;
    super.start();
  }
  
  public void quit() {
    interrupt();
  }

  void run() {
    try {
      while(isActive) {
        // calculate time difference since last tick & wait if necessary
        double timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        while(timePassed<intervalInMs) {
          timePassed=(System.nanoTime()-previousTime)*1.0e-6;
        }

        try {
          timerEvent.invoke(parent);
        } catch (Exception e) {
          System.err.println("Disabling " + timerEventName + "() for HighResolutionTimer " +
                             "because of an error.");
          e.printStackTrace();
          this.isActive = false;
        }
        // insert your midi event sending code here
        
        // calculate real time until next tick    
        //BE this gives negative delays!
        long delay=(long)(intervalInMs-(System.nanoTime()-previousTime)*1.0e-6); 
        if (delay < 0) delay = 0;
        //long delay = (long)intervalInMs;
        previousTime=System.nanoTime();
 
        //        println("hires-tick: "+timePassed+"ms " + "delay: " + delay);

        Thread.sleep(delay);
      }
    } 
    catch(InterruptedException e) {
      println("force quit...");
    }
  }
} 
