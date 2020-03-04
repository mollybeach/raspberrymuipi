#next note higher or equal
#to the base note note n
#that is in the chord c
define :next_note do |n, c|
  n = note(n)
  #gets distances to each note in chord,
  #add smallest to the base note
  n + (c.map {|x| (note(x) - n) % 12}).min
end
#enter your key here
key = [:a, :b, :c, :d, :e, :f, :g]
#major scales
c_major = key
f_major = key.map{|x| x === :b ? "#{x}b": x}
g_major = key.map{|x| x === :f ? "#{x}s": x}
d_major = g_major.map{|x| x === :c ? "#{x}s" : x}
a_major = d_major.map{|x| x === :g ? "#{x}s" : x}
e_major = a_major.map{|x| x === :d ? "#{x}s" : x}
b_major = e_major.map{|x| x === :a ? "#{x}s" : x}
#minor scales
a_minor = key
e_minor = g_major
b_minor = d_major
d_minor = f_major
g_minor = f_major.map{|x| x === :e ? "#{x}b": x}
c_minor = g_minor.map{|x| x === :a ? "#{x}b": x}
f_minor = c_minor.map{|x| x === :d ? "#{x}b": x}
#enter your octave
octave = 3
#enter your scale in tune key
tune_key = f_minor.map! do |value| "#{value}#{octave}"
end
#prints out your scale
puts tune_key
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
define :preform do |c, d=0.3|
  in_thread do
    play_pattern_timed c.drop_while{|n| [nil,:r].include? n}, d
  end
end
use_debug false
use_bpm 70

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
  sample :drum_bass_soft
  sample :drum_cymbal_pedal
  sleep 0.5
end
define :outro do
  sample :elec_soft_kick
  puts "outro playing"
  ring((tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M),
       (tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M))
end
define :melody do
  puts "melody playing"
  with_synth :fm do
    with_fx :lpf do
      #enter single note patterns here
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
