public class PureDataMiddleware {

  PApplet parent;
  PureData pd; 
  String patchfilename = "";
  float lowestFrequency;
  int nOctaves;
  int intervalsInOctave;
  float intervalRatio;

  public PureDataMiddleware (PApplet parent, float lowestFrequency, int nOctaves, int intervalsInOctave) {
    this.parent = parent;
    this.lowestFrequency = lowestFrequency;
    this.nOctaves = nOctaves;
    this.intervalsInOctave = intervalsInOctave;
    this.intervalRatio = (float) nthroot(intervalsInOctave, 2);    
  }

    
  public PureDataMiddleware (PApplet parent, Config config) {
    this(parent, config.lowestFrequency(), config.octaves(), config.intervalsInOctave());
  }


  public PureDataMiddleware patchfilename(String patchfilename) {
    this.patchfilename = patchfilename;
    return this;
  }

  private String generatePatchfilename() {
    return "modulant-"+nOctaves+"x"+intervalsInOctave+".pd";
  }

  public PureDataMiddleware start() {
    if ("".equals(patchfilename))
      patchfilename = generatePatchfilename();

    generatePatch();
    startPureData();
    return this;
  }

  PureDataMiddleware startPureData() {
    //initialize pd with audio rate of 44100, no inputs, and two 
    //outputs, load the patch and start the object
    pd = new PureData(parent, 44100, 0, 2);

    pd.openPatch(patchfilename);
    pd.start();
    return this;
  }

  PureDataMiddleware generatePatch() {
    if (createAndAssertDir("data")) {
      generatePatchfile("data/"+patchfilename, lowestFrequency, nOctaves*intervalsInOctave, intervalRatio);
    }
    else {
      System.out.println("Couldn't create data directory");
      exit();
    }
    return this;
  }


  void generatePatchfile(String patchfileName, float freq0, int nUnits, float intervalRatio) {

    float amplitudeScaleDown = 1.0 / nUnits; 

    PrintWriter patch = createWriter(patchfileName);

    patch.println("#N canvas 1000 70 762 624 10;");  
    patch.println("#X obj 78 116 dac~;"); // 0

    float freq = freq0;
    for (int unit = 0; unit < nUnits; unit++) {
      freq = freq * intervalRatio;

      patch.println("#X obj 121 -86 r unit" + unit + ";"); // 1
      patch.println("#X obj 23 -27 osc~ "   + freq + ";"); // 2
      patch.println("#X obj 78 63 *~;"); // 3

      patch.println("#X obj 100 100 sig~;");     // 4
      patch.println("#X obj 200 200 lop~ 3;");   // 5
      patch.println("#X obj 300 300 *~ " + amplitudeScaleDown + ";");   // 6
    }

    int elem = 0;
    for (int unit=0; unit < nUnits; unit++) {
      elem = unit*6;  //patch.println("elem: " + elem);

      patch.println("#X connect " + (elem+1) + " 0 " + (elem+4) + " 0;");
      patch.println("#X connect " + (elem+4) + " 0 " + (elem+5) + " 0;");
      patch.println("#X connect " + (elem+5) + " 0 " + (elem+3) + " 1;");

      // TODO: this connection was made by accident - but it doesn't seem to effect
      // things negatively either. keeping it to investigate later.
      //    patch.println("#X connect " + (elem+1) + " 0 " + (elem+3) + " 1;");

      patch.println("#X connect " + (elem+2) + " 0 " + (elem+3) + " 0;");
      patch.println("#X connect " + (elem+3) + " 0 " + (elem+6) + " 0;");

      patch.println("#X connect " + (elem+6) + " 0 " + " 0 "    + " 0;");
      patch.println("#X connect " + (elem+6) + " 0 " + " 0 "    + " 1;");

    }

    patch.flush();
    patch.close();
  }

  public void sendFloat(String receiver, float message) {
    pd.sendFloat(receiver, message);
  }
  
  public void send(int unitNo, float message) {
    pd.sendFloat("unit"+unitNo, message);
  }

  public void send(float[] message) {
    for (int unitNo = 0; unitNo<message.length; unitNo++){
      pd.sendFloat("unit"+unitNo, message[unitNo]);
    }
  }

  public void silenceAll() {
    int nAllUnits = nOctaves*intervalsInOctave;

    for (int unit=0; unit<nAllUnits; unit++) {
      send(unit, 0.0);
    }
  }

}
