#!/usr/bin/env ruby

require 'cheep'

def build_unit
  amp = Cheep['*!']

  amp[
    Cheep.osc!(440),
    Cheep.lap!(3)[Cheep.sig![Cheep.r 'vol1']]
    ]
  amp
end

unit = build_unit

Cheep.dac![unit, unit]

File.write 'patch.pd', Cheep.to_patch
