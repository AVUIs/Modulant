#!/usr/bin/env ruby

require 'cheep'

def tet72_freq(note)
  bottom_freq = 16.352
  tet72_step_ratio = 2**(1.0 / 72)

  (tet72_step_ratio**note) + bottom_freq
end

units = (0..719).map do |note|
  amp = Cheep['*!']

  osc = Cheep.osc!(tet72_freq note)
  vol = Cheep.lap!(3)[Cheep.sig![Cheep.r "vol#{note}"]]

  amp[osc, vol]
  amp
end

Cheep.dac![units, units]
File.write 'patch.pd', Cheep.to_patch
