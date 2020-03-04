#how to play a song on sonic pi
#guitar, piano, etc
#base notes
key = [:a, :b, :c, :d, :e, :f, :g]
personalized_key = [:e2, :a2, :d3, :g3, :b3, :e4]
#choose a scale from below
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
tune_key = a_major.map! do |value| "#{value}#{octave}"
end
#or enter personalized key and use
#tune_key = personalized_key
#prints out scale to console
puts tune_key
#next note higher or equal
#to the base note note n
#that is in the chord c
define :next_note do |n, c|
  n = note(n)
  #gets distances to each note in chord,
  #add smallest to the base note
  n + (c.map {|x| (note(x) - n) % 12}).min
end
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
# input delay between plays of chords
define :preform do |c, d=0.1|
  in_thread do
    play_pattern_timed c.drop_while{|n| [nil,:r].include? n}, d
  end
end
use_debug false
#beats per minute
use_bpm 90
#enter your chords here
#8 chords per section/ personalize
#change original key note chords by using
#:M, :m, (:e, '7'), (:e,  m7), :a6, (:a, invert: -1), (:c, :dim)
#use play_pattern before ring to play pattern vs play through once
#change octave at different sections by redefining octave within that section
#redefine octave at particular chords using invert: 2, 3, -1 etc.
#run single note patterns with your code rings
#using either letter defintions within the preset key using (ring :b, :c, :d, :e, :fs, :g, :a, :b)
#or use note numbers (ring 65, 60, ,57, 53, 57, 60, 65)
#and/or use rings within the single note patterns (ring :r, :r, 53, 57, 60, 65)
define :intro do
  sample :tabla_ghe3
  sleep 0.5
  sample :tabla_ghe3
  sleep 0.5
  puts melody
  sleep 0.5
  melody
  puts "intro playing"
  octave = 2
  ring((tune :c, :m), (tune :g, :M), (tune :g, :M), (tune :c, :M),
       (tune :b, :m), (tune :b, :M), (tune :e, :m), (tune :d, :M))
end
define :verse do
  puts "verse playing"
  ring((tune :a, :m), (tune :c, :M), (tune :g, :M), (tune :b, :m), (tune :e, :m),
       (tune :D, :M), (tune :a, :m), (tune :c, :M), (tune :g, :M))
  sleep 0.5
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/4
  sleep 0.5
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/2
  sample :tabla_ghe3
  sleep 0.5
  sample :tabla_ghe3
  sleep 0.5
  sample :tabla_ghe3
  sleep 0.5
end
define :chorus do
  puts "chorus playing"
  ring((tune :b, :m), (tune :e, :m), (tune :d, :M), (tune :a, :m),
       (tune :c, :M), (tune :c, :m), (tune :g, :M), (tune :b, :m))
  sample :loop_tabla, rate: sample_duration(:loop_tabla)/8
  sample :perc_snap
  sleep 0.5
  sample :perc_snap
  sleep 0.5
  sample :tabla_na_s
end
define :instr do
  puts "outro playing"
  sleep 0.5
  ring((tune :g, :m), (tune :b, :m7), (tune :e, :m), (tune :d, :M),
       (tune :a, :m), (tune :c, :M), (tune :g, :m), (tune :b, :m))
 sleep 0.5
 sample :tabla_ghe8
 sleep 0.5
 sample :tabla_ke1
 sleep 0.5
 sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/2
  sleep 0.5
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/2
 sleep 0.5
end
define :verse2 do
  puts "verse2 playing"
  ring((tune :e, :m),(tune :d, :M), (tune :a, :m), (tune :c, :M),
       (tune :g, :M), (tune :b, :m), (tune :e, :m), (tune :D, :M))
  sleep 0.5
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/2
  sleep 0.5
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/2
  sleep 0.5
  sample :drum_bass_soft
  sleep 0.5
  sample :drum_cymbal_pedal
  sleep 0.5
end
define :bridge do
  #sample :elec_soft_kick
  puts "bridge playing"
  sleep 0.5
  sample :tabla_te_ne
  sleep 0.5
  ring((tune :a, :m), (tune :c, :M), (tune :g, :M), (tune :b, :m),
       (tune :e, :m), (tune :d, :M), (tune :a, :m), (tune :c, :M))
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/2
  sleep 0.5
end
define :outro do
  sample :loop_tabla, rate: sample_duration(:loop_tabla)/8
  sleep  0.5
  with_synth :dark_ambience do
  use_synth_defaults amp: 0.01
  puts "outro playing"
  ring((tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M),
       (tune :c, :M), (tune :a, :M), (tune :g, :M), (tune :c, :M))
  end
end
define :melody do
  puts "melody playing"
  octave = 5
  with_synth :fm do
    #with_fx :ixi_techno do
    use_synth_defaults attack: 0.0625, slide: 0.0625, depth: 1.5, amp: 1.1, amp_slide: 0.5,cutoff: 40, oom: 0.9, rate: 10
    #enter single note patterns here
    ring(:f, :a, :g, :b, :b, :a, :a, :g, :e, :e, :g,
         :g, :b, :b, :d, :d, :c, :c, :e,
         :e, :a, :a, :b)
    #end
  end
end
#loop a pattern throughout song
live_loop :tech do
  puts "loop playing"
  sleep 16
  with_fx :ixi_techno, phase: 32, res: 0.9, cutoff_min: 0, cutoff_max: 129, amp: 0.5 do
    64.times do
      sample :sn_dolf, amp: 0.1, start: 0.1, finish: 0.4
      sleep 0.25
    end
  end
end
#create song structure here
define :chords do
  intro
  verse
  chorus
  verse2
  instr
  bridge
  verse2
  verse2
  outro
end
#enter strumming patterns for song sections
define :strumming_str do
  intro = "DDU.U.U.D."
  verse = "U.DD.DDD"
  chorus = "DDU.UUUD"
  bridge ="UUD.UUDU"
  outro = "UDU.UDDU"
end
define :song do
  #modify your sound with with_fx here
  with_fx :pan do
    #with_fx :ixi_techno, cutoff: 40, oom: 0.9, amp: 0.5 do
    use_synth_defaults attack: 0.0625, slide: 0.0625, depth: 1.5, amp: 1.5, amp_slide: 0.5,cutoff: 40, oom: 0.9
    #enter instrument for the chords here
    #piano, pluck etc.
    with_synth :pluck do
      tick
      #define strumming pattern
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
  end
end
song
