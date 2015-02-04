public class ColourManager  {

  color activeColour = #ffffff;

  public color[] solarizedBase 
    = new color[] { #000000, #002b36, #073642, #586e75, #657b83, #839496, #93a1a1, #eee8d5, #fdf6e3, #ffffff };
  public color[] solarizedAccent 
    = new color[] { #b58900, #cb4b16, #dc322f, #d33682, #6c71c4, #268bd2, #2aa198, #859900 };

  
  public ColourManager () {
  }

  public ColourManager colourSelection(int index, boolean fromAccentRange) {
    color c;
    
    try {
      if (fromAccentRange)
        c = solarizedAccent[index];
      else
        c = solarizedBase[index];
      
      activeColour(c);
    } catch (Exception e) {
      println(e);
    }

    return this;    
  }
  
  public ColourManager activeColour(color c) {
    activeColour = c;
    return this;
  }

  public color activeColour() {
    return activeColour;
  }

}
