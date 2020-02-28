define :next_note do |n, c|
  n = note(n)
  # Get distances to each note in chord, add smallest to base note
  n + (c.map {|x| (note(x) - n) % 12}).min
end
ukulele = [:g, :c, :e, :a]
guitar_standard = [ :as5, :b3, :cs5, :d3, :e5, :f5, :gs5]

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
use_bpm 117


define :verse do
  ring((guitar :f, :M), (guitar :a, :M), (guitar :g, :M), (guitar :c, :M),(ring :r, :r, 53, 57, 60, 65))
end

define :chorus do
  ring((guitar :f, :M), (guitar :e, :M), (guitar :f, :M),
       (guitar :f, :M), (guitar :e, :M),(guitar :f, :M), (ring :r, :r, 53, 57, 60, 65))
end
define :bon do
  ring((guitar :c, :M), (ring :r, :r, 53, 57, 60, 65))
end
define :what do
  ring((guitar :c, :M),
       (guitar :a, :M), (guitar :g, :M),
       (guitar :c, :M), (guitar :e, :M), (ring :r, :r, 53, 57, 60, 65))
end


j = 1                    #Verse
while (j < 10) do
    if (j < 8) then
      chords = verse
      j += 1
    elsif (j = 8 || j < 12) then
      chords = bon
      j += 1
    elsif (j = 12) then
      chords = bon
      j -= 1
    end
    
    
    
    live_loop :guit do
      with_fx :reverb do
        with_fx :ixi_techno, cutoff: 90, oom: 0.9, amp: 0.5 do
          use_synth_defaults attack: 0.0625, slide: 0.0625, depth: 1.5, amp: 1, amp_slide: 32
          with_synth :pluck do
            tick
            "DDU.UDUD".split(//).each do |s|
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
    
  end