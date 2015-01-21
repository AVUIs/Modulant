# Modulant

Modulant allows for the creation of images and their sonification.

The present implementation is built upon image-importing ~~and freehand-drawing~~[^1] modules that may be used to create arbitrary visual scenes (and eerie sounds) -- with more constrained functional and typographical modules in development.

The audio engine is inspired by a 1940’s synthesiser, the ANS, that scans across images. In this scanning, one axis is time and the other axis is frequency. Modulant thus becomes a graphical space to be explored sonically and vice-versa. The project is built with Processing for graphics and interaction, and Ruby & Puredata for sound.

[^1]: not yet

## Dependencies

- [libpd/puredatap5](https://github.com/libpd/puredatap5)
- [TimedEvent](http://multiply.org/processing/)

## Usage

For this very first / monkeypatch version , the source code itself is your interface. There is no other form of interaction.

Open [Modulant.pde](blob/master/Modulant.pde), change the parameters at the top, and run the sketch. Repeat.

## Resources

[The ANS Synthesizer: Composing on a Photoelectronic Instrument](http://www.theremin.ru/archive/ans.htm)

[Wikipedia: ANS Synthesizer](http://en.wikipedia.org/wiki/ANS_synthesizer)

[Synth-Aesthesia: Soviet Synths And The ANS](http://www.redbullmusicacademy.com/magazine/history-soviet-synth-ans)

