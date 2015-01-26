public class ColourManager  {


  private color[] solarizedBase 
    = new color[] { #000000, #002b36, #073642, #586e75, #657b83, #839496, #93a1a1, #eee8d5, #fdf6e3, #ffffff };
  private color[] solarizedAccent 
    = new color[] { #b58900, #cb4b16, #dc322f, #d33682, #6c71c4, #268bd2, #2aa198, #859900 };

  
  public ColourManager () {
  }

  public ColourManager colourSelection(int index, boolean fromAccentRange) {
    color c;
    
    //println(index - (int)'0');

    try {
      if (fromAccentRange)
        c = solarizedAccent[index - (int)'0'];
      else
        c = solarizedBase[index - (int)'0'];
    
      activeColour(c);
    } catch (Exception e) {
      println(e);
    }

    return this;    
  }
  
  public ColourManager activeColour(color c) {
    activeColor = c;
    return this;
  }

  public color activeColour() {
    return activeColor;
  }

}
