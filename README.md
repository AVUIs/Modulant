# Modulant

Modulant allows for the creation of images and their sonification.

The present implementation is built upon image-importing and freehand-drawing modules that may be used to create arbitrary visual scenes (and eerie sounds), with more constrained functional and typographical modules in development.

The audio engine is inspired by a 1940’s synthesizer, the ANS, that scans across images. In this scanning, one axis is time and the other axis is frequency. Modulant thus becomes a graphical space to be explored sonically and vice-versa. The project is built with Processing for graphics and interaction, and Ruby & Puredata for sound.



## Usage

The early Modulant has a very plain and minimalist interface, geared toward fast switching between its modes.

The application responds to keyboard shortcuts which select various drawing modes or execute commands. The pointer/mouse is only used for drawing.

Here is the current list of keybindings:

### Bindings for Drawing
    r       rectangle mode 
    t       triangle mode 
    e       ellipse mode 
    f       freehand mode 
    d       freehand w/ dots 
    Shift-c clear all 
    Ctrl-z  undo 
    Ctrl-y  redo 

### Sonification Control
    Space                  resume/pause scanning 
    Left/Right             step 1px 
    Ctrl-Left/Right        step 10px 
    Shift-Ctrl-Left/Right  step 50px 
    m                      mute/unmute sound 
    g                      toggle grid;

### File Operations 
    Ctrl-o  load background image 
    Ctrl-s  save work buffer as image 
 
### Colours 
    0         black (eraser) 
    1:8       Solarized base colours 
    Ctrl-1:8  Solarized accents 
    9         white

### Help
    h  toggle help (this text)




## Dependencies

Install (unpack) into your `sketchbook/libraries` folder:

- [libpd/puredatap5](https://github.com/libpd/puredatap5)  ([pdp5.zip](https://github.com/libpd/puredatap5/blob/master/pdp5.zip))
- [TimedEvent](http://multiply.org/processing/)  ([TimedEvents.zip](http://multiply.org/processing/TimedEvents.zip))

See this [short guide on installing libraries](http://www.learningprocessing.com/tutorials/libraries/) for the where and how if you are not sure.

## Tips

- Images that you load to sonify should have light features on dark backgrounds. The brightness of each pixel determines the volume of the associated oscillator -- if the majority of your image is bright, then all you're going to hear is a loud and harsh noise.

- Also, when drawing, it's better to avoid bright and long vertical lines/regions -- these will turn on a lot of oscillators in one go, which may sound unpleasant (unless you know what you're doing).

## Example images for sonification


Included in the [data](data) directory:

- klee-lines-dots-drawing-bw.jpg : a drawing by Paul Klee (downloaded from [here](http://artbusnyc.blogspot.co.uk/2011/01/artbus-lines-dots-and-circles-inspired.html))
- sc02-1n.jpg : an image used with the actual ANS synthesizer (downloaded from [here](http://www.theremin.ru/archive/ans.htm))
- Coil-ANS-C-grey.png : A "composition" by the experimental music group *Coil*
- Coil-ANS-D-grey.png : Another one by *Coil* (note that these are a bit noisy due to lack of image cleaning)
- graph2d-1.png : parametric graph 1
- graph2d-2.png : parametric graph 2
- graph2d-3.png : parametric graph 3


## Resources

[The ANS Synthesizer: Composing on a Photoelectronic Instrument](http://www.theremin.ru/archive/ans.htm)

[Wikipedia: ANS Synthesizer](http://en.wikipedia.org/wiki/ANS_synthesizer)

[Synth-Aesthesia: Soviet Synths And The ANS](http://www.redbullmusicacademy.com/magazine/history-soviet-synth-ans)

[Virtual ANS Spectral Synthesizer](http://warmplace.ru/soft/ans/)

## Project members

* [berkan](github.com/berkan)
* [lpil](github.com/lpil)
* [zipporobotics](github.com/zipporobotics)

## License

	Modulant - A sonification and audiovisual performance interface experiment
	Copyright 2015 Berkan Eskikaya, Louis Pilfold
	
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
	file, You can obtain one at http://mozilla.org/MPL/2.0/.
