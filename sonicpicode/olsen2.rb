define :next_note do |n, c|
  n = note(n)
  # Get distances to each note in chord, add smallest to base note
  n + (c.map {|x| (note(x) - n) % 12}).min
end
ukulele = [:g, :c, :e, :a]
guitar_standard = [:c3, :a3, :d3, :b3, :f3, :g3]

# Return ring representing the chord chrd, as played on a guitar with given tuning
define :guitar do |tonic, name, tuning=guitar_standard|
  chrd = (chord tonic, name)
  # For each string, get the next higher note that is in the chord
  c = tuning.map {|n| next_note(n, chrd)}.ring
  # We want the lowest note to be the root of the chord
  root = note(chrd[0])
  first_root = c.take_while {|n| (n - root) % 12 != 0}.count
  # Drop up to half the lowest strings to make that the case if possible
  if first_root > 0 and first_root < tuning.count / 2
    c = (ring :r) * first_root + c.drop(first_root)
  end
  # Display chord fingering
  #puts c.zip(tuning).map {|n, s| if n == :r then 'x' else (n - note(s)) end}.join, c
  c
end

# Strum a chord with a certain delay between strings
define :strum do |c, d=0.1|
  in_thread do
    play_pattern_timed c.drop_while{|n| [nil,:r].include? n}, d
  end
end

use_debug false
use_bpm 119

i = 1
while i < 100 do
    
    #Verse
    if i = 1 then
      chords = ring((guitar :d, :m7), (guitar :g, '7'), (guitar :c, :M7), (guitar :f, :M7),
                    (guitar :b, :m7), (guitar :e, '7'), (guitar :a, :m7), (ring :r, :r, 53, 57, 60, 65))
      i +=1
    elsif (i = 2) then
      chords = ring(guitar :a, :M), (guitar :a, :M), (guitar :a, :M), (guitar :a, :M)
      
    elsif (peter = 3) then
      chords = ring(guitar :a, :M), (guitar :a, :M), (guitar :a, :M), (guitar :a, :M)
    end
    
    with_fx :lpf do
      with_fx :rbpf, cutoff: 115, oom: 0.9, amp: 0.5 do
        use_synth_defaults attack: 0.0625, slide: 0.0625, depth: 1.5, amp: 1, amp_slide: 32
        with_synth :pluck do
          tick
          "DUDU.UDU".split(//).each do |s|
            if s == 'D' # Down stroke
              strum chords.look, 0.05
            elsif s == 'U' # Up stroke
              with_fx :level, amp: 0.3 do
                strum chords.look.reverse, 0.03
              end
            end
            sleep 0.5
          end
        end
      end
      
    end
    
  end
  
  