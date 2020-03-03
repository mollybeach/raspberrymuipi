#next note higher or equal
#to the base note note n
#that is in the chord c
define :next_note do |n, c|
  n = note(n)
  #gets distances to each note in chord,
  #add smallest to the base note
  n + (c.map {|x| (note(x) - n) % 12}).min
end
#enter your key here:
tune_key = [ :a4, :b4, :c4, :d4, :e4, :fs5, :g4]
#returns ring representing the chord
define :tune do |tune, name, tuning=tune_key|
  chrd = (chord tune, name)
  puts chrd
  c = tuning.map {|n| next_note(n, chrd)}.ring
  root = note(chrd[0])
  first_root = c.take_while {|n| (n - root) % 12 != 0}.count
  if first_root > 0 and first_root < tuning.count / 2
    c = (ring :r) * first_root + c.drop(first_root)
  end
  c
end
# input your delay between plays of chords
define :preform do |c, d=0.1|
  in_thread do
    play_pattern_timed c.drop_while{|n| [nil,:r].include? n}, d
  end
end
use_debug false
use_bpm 60

#enter your chords here:
define :intro do
  puts melody
  melody
  puts "intro playing"
  play_pattern ring((tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M))
  #(tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M))

end
define :verse do
  puts "verse playing"
  play ring((tune :e, :m7), (tune :e, :M), (tune :e, :m7), (tune :e, :M),
            (tune :e, :M), (tune :e, :M), (tune :c, :M), (tune :a, :M), (tune :gs, :M))
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/4
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/2

end
define :chorus do
  play ring((tune :e, :M), (tune :e, :m), (tune :e, :M), (tune :e, :M),
            (tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M))
  sample :loop_tabla, rate: sample_duration(:loop_tabla)/8
  puts "chorus playing"
end
define :bridge do
  puts "bridge playing"
  play ring((tune :c, :M),(tune :a, :M), (tune :g, :M), (tune :e, :M),
  (tune :c, :M), (tune :e, :M), (tune :a, :M), (tune :g, :M))
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/2
  sleep 0.5
  sample :drum_bass_soft
  sleep 0.5
  sample :drum_cymbal_pedal
end
define :outro do
  puts "outro playing"
  ring((tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M),
       (tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M))
end
#enter single note patterns here
define :melody do
  puts "melody playing"
  with_synth :fm do
    with_fx :lpf do
      ring(:f, :a, :g, :b, :b, :a, :a, :g, :e, :e, :g,
           :g, :b, :b, :d, :d, :c, :c, :e,
           :e, :a, :a, :b)
    end
  end
end
#create song structure here
define :chords do
  intro
  verse
  chorus
  bridge
  chorus
  outro
end
define :strumming_str do
  intro = "DDU.U.D.UU.DD."
  verse = "DDU.U.DD.DUU.DD."
  chorus = "DDU.U.DD.DUU.DD."
  bridge ="UUUUUUUUUUUU."
  outro = "UUU.U.DD.UUD."
end

define :song do
  #modify your sound with with_fx here
  #with_fx :reverb do
  #with_fx :ixi_techno, cutoff: 40, oom: 0.9, amp: 0.5 do
  #use_synth_defaults attack: 0.0625, slide: 0.0625, depth: 1.5, amp: 1.5, amp_slide: 3
  #enter your instrument here:
  with_synth :pluck do
    tick
    strumming_str.split(//).each do |s|
      if s == 'D' # Down stroke
        preform chords.look, 0.5
      elsif s == 'U' # Up stroke
        with_fx :level, amp: 0.5 do
          preform chords.look.reverse, 0.03
        end
      end
      sleep 0.5
    end
  end
  #end
  #end
end
song
