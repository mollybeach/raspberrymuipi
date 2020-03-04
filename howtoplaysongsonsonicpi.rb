#how to play a song on sonic pi
#guitar, piano, etc
#base notes
key = [:a, :b, :c, :d, :e, :f, :g]
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
tune_key = b_major.map! do |value| "#{value}#{octave}"
end
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
use_bpm 70
#enter your chords here
#change original key note chords by using
#:M, :m, :e7, :a6, (:a, invert: -1), (:c, :dim)
#use play_pattern before ring to play pattern vs play through once
#change octave at different sections by redefining octave within that section
#redefine octave at particular chords using invert: 2, 3, -1 etc.
define :intro do
  puts melody
  melody
  puts "intro playing"
  octave = 4
  play_pattern ring((tune :c, :M), (tune :a, :M), (tune :g, :M), (tune :c, :M))
  #(tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M))
end
define :verse do
  puts "verse playing"
  ring((tune :e7, :m), (tune :e, :M), (tune :e, :m7), (tune :e, :M),
            (tune :e, :M), (tune :e, :M), (tune :c, :M), (tune :a, :M), (tune :gs, :M))
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/4
  sample :guit_e_fifths, decay: 0.5, amp: 0.1, rate: -1
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/2
  sample :perc_snap
  sleep 0.5
  sample :perc_snap
end
define :chorus do
  puts "chorus playing"
  ring((tune :e, :M), (tune :e, :m), (tune :e, :M), (tune :e, :M),
            (tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M))
  sample :loop_tabla, rate: sample_duration(:loop_tabla)/8
  sample :perc_snap
end
define :bridge do
  puts "bridge playing"
  ring((tune :c, :M),(tune :a, :M), (tune :g, :M), (tune :e, :M),
  (tune :c, :M), (tune :e, :M), (tune :a, :M), (tune :g, :M))
  sample :loop_breakbeat, rate: sample_duration(:loop_breakbeat)/2
  sample :drum_bass_soft
  sample :drum_cymbal_pedal
  sleep 0.5
end
define :outro do
  sample :elec_soft_kick
  puts "outro playing"
  ring((tune :c, :M), (tune :a, invert: -1), (tune :g, :M), (tune :c, :M),
       (tune :c, :M), (tune :a, :M), (tune :g, :M), (tune :c, :M))
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
  with_fx :ixi_techno, phase: 32, res: 0.9, cutoff_min: 0, cutoff_max: 129 do
    64.times do
      sample :sn_dolf, amp: 0.2, start: 0.1, finish: 0.4
      sleep 0.25
    end
  end
end
#create song structure here
define :chords do
  intro
  verse
  chorus
  bridge
  outro
end
#enter strumming patterns for song sections
define :strumming_str do
  intro = "DDU.U.U.D."
  verse = "U.DD.DDD"
  chorus = "DDU.UUUD"
  bridge ="UUD.UUDU"
  outro = "UUU.UDUU"
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
