public enum OctaveDivisions {
  SEMITONES (12),
  QUARTERTONES (24),
  TET36(36),
  TET48(48),
  TET60(60),
  TET72(72);

  private int intervalsInOctave;

  OctaveDivisions(int intervalsInOctave) {
    this.intervalsInOctave = intervalsInOctave;
  }
  
  public int getIntervalsInOctave() {
    return intervalsInOctave;
  }

}

public class Config {

  // for the moment, only these are user-settable
  public int nOctaves = 10;
  public int intervalsInOctave = OctaveDivisions.QUARTERTONES.getIntervalsInOctave();
  public float lowestFrequency = 16.352;
  public int bpm = 125;
  public int lengthInSeconds = 3 * 60; // 3 minutes
  public int lengthInPixels = WIDTH; //FIXME
  public String backgroundImage = "";



  // these are computed from the above and are actually used as
  // integers, but we store these in floats and convert them to int
  // when we need to use them.
  public float lengthInBeats;
  public float pixelsPerBeat;
  public float oneBeatInMs;
  public float oneTickInMs;
  
  public Config () {
  }

  public Config (int lengthInSeconds, int bpm) {
    this.lengthInSeconds = lengthInSeconds;
    this.bpm = bpm;
    this.update();
  }


  // fluid-style setters
  public Config bpm(int bpm) {
    this.bpm = bpm;
    return this;
  }

  public Config lengthInSeconds(int lengthInSeconds) {
    this.lengthInSeconds = lengthInSeconds;
    return this;
  }

  public Config lengthInPixels(int lengthInPixels) {    
    this.lengthInPixels = lengthInPixels;
    return this;
  }

  public Config octaves(int nOctaves) {
    this.nOctaves = nOctaves;
    return this;
  }

  public Config intervalsInOctave(OctaveDivisions division) {
    this.intervalsInOctave = division.getIntervalsInOctave();
    return this;
  }

  public Config lowestFrequency(float lowestFrequency) {
    this.lowestFrequency = lowestFrequency;
    return this;
  }

  public Config backgroundImage(String backgroundImage) {
    this.backgroundImage = backgroundImage;
    return this;
  }


  public Config update() {
    lengthInBeats = (float)lengthInSeconds/60 * bpm;
    pixelsPerBeat = Math.max(1.0, lengthInPixels/lengthInBeats); //FIXME: there's a bigger problem here than ensuring pbm>=1
    oneBeatInMs = 60 * 1000 / (float)bpm;
    oneTickInMs = oneBeatInMs / pixelsPerBeat;
    return this;
  }


  //getters

  public int octaves() {    
    return this.nOctaves;
  }

  public int intervalsInOctave() {    
    return this.intervalsInOctave;
  }

  public float lowestFrequency() {    
    return this.lowestFrequency;
  }

  public int lengthInPixels() {    
    return this.lengthInPixels;
  }

  public int lengthInSeconds() {    
    return this.lengthInSeconds;
  }

  public int bpm() {    
    return this.bpm;
  }


  public int lengthInBeats() {
    return Math.round(lengthInBeats);
  }
  public int pixelsPerBeat() {
    return Math.round(pixelsPerBeat);
  }
  public int oneBeatInMs() {
    return Math.round(oneBeatInMs);
  }
  public int oneTickInMs() {
    return Math.round(oneTickInMs);
  }

  public float intervalRatio() {
    return (float) nthroot(intervalsInOctave(),2);
  }
  
  public int numberOfAllIntervals() {
    return octaves() * intervalsInOctave();
  }

  public String backgroundImage() {
    return this.backgroundImage;
  }


  public String toString() {
    return "=Modulant="
      + "\nbpm: " + bpm()
      + "\nlengthInSeconds: " + lengthInSeconds()
      + "\nlengthInPixels: " + lengthInPixels()
      + "\nlengthInBeats: " + lengthInBeats()
      + "\npixelsPerBeat: " + pixelsPerBeat()
      + "\noneBeatInMs: " + oneBeatInMs()
      + "\noneTickInMs: " + oneTickInMs()
      + "\noctaves: " + octaves()
      + "\nintervalsInOctave: " + intervalsInOctave()
      + "\nintervalRatio: " + intervalRatio()
      + "\nlowestFrequency: " + lowestFrequency()
      + "\nnumberOfAllIntervals: " + numberOfAllIntervals()
      + "\nbackgroundImage: " + backgroundImage();
  }

}
