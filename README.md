# Modulant

Modulant allows for the creation of images and their sonification.

The present implementation is built upon image-importing ~~and freehand-drawing~~<sup>not yet</sup> modules that may be used to create arbitrary visual scenes (and eerie sounds), with more constrained functional and typographical modules in development.

The audio engine is inspired by a 1940’s synthesizer, the ANS, that scans across images. In this scanning, one axis is time and the other axis is frequency. Modulant thus becomes a graphical space to be explored sonically and vice-versa. The project is built with Processing for graphics and interaction, and Ruby & Puredata for sound.



## Usage

For this very first / monkeypatch version , the source code itself is your interface. There is no other form of interaction.

Open [Modulant.pde](blob/master/Modulant.pde), change the parameters at the top, and run the sketch. Repeat.


## Dependencies

Install (unpack) into your `sketchbook/libraries` folder:

- [libpd/puredatap5](https://github.com/libpd/puredatap5)
- [TimedEvent](http://multiply.org/processing/)


## Example images for sonification


Included in the [data](blob/master/data) directory:

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
