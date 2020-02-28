#Next note higher or equal
#to the base note note n
#that is in the chord c
define :next_note do |n, c|
  n = note(n)
  #Gets distances to each note in chord,
  #Add smallest to the base note
  n + (c.map {|x| (note(x) - n) % 12}).min
end
#ENTER YOUR KEY HERE:
tune_key = [ :a3, :b3, :c3, :d3, :e3, :f3, :g3]
#Returns ring representing the chord
define :tune do |tone, name, tuning=tune_key|
  chrd = (chord tone, name)
  c = tuning.map {|n| next_note(n, chrd)}.ring
  root = note(chrd[0])
  first_root = c.take_while {|n| (n - root) % 12 != 0}.count
  if first_root > 0 and first_root < tuning.count / 2
    c = (ring :r) * first_root + c.drop(first_root)
  end
  c
end

# Input your delay between plays of chords
define :preform do |c, d=0.1|
  in_thread do
    play_pattern_timed c.drop_while{|n| [nil,:r].include? n}, d
  end
end
use_debug false
use_bpm 60

#ENTER YOUR CHORDS HERE:
define :intro do
  ring((tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M))
  #(tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M))
end
define :verse do
  ring((tune :a, :m7), (tune :g, :M), (tune :a, :m7), (tune :g, :M),
       (tune :f, :M), (tune :c, :M)) #(tune :c, :M), (tune :a, :M), (tune :gs, :M))
end
define :chorus do
  ring((tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M))
  #(tune :c, :M), (tune :a, :m), (tune :g, :M), (tune :c, :M))
end
define :instr do
  ring((tune :c, :M),(tune :a, :M), (tune :g, :M), (tune :e, :M))
  #(tune :c, :M), (tune :e, :M), (tune :a, :M), (tune :g, :M))
end
#Repeat here
j = 1
while (j < 5 || j !=5) do
    if (j = 1) then
      chords = intro
      2.times do
        intro
      end
      j += 1
    elsif (j = 2) then
      chords = verse
      1.times do
        verse
      end
      j += 1
    elsif (j = 3) then
      chords = chorus
      2.times do
        chorus
      end
      j -= 1
    elsif (j = 4) then
      chords = verse
      2.times do
        verse
      end
      #elsif (j = 5) then
      #  chords = instr
      #  2.times do
      #   instr
      #  end
      j += 1
    end
    
    
    live_loop :song do
      #MODIFY YOUR SOUND WITH WITH_FX HERE:
      #with_fx :reverb do
      #with_fx :ixi_techno, cutoff: 40, oom: 0.9, amp: 0.5 do
      #use_synth_defaults attack: 0.0625, slide: 0.0625, depth: 1.5, amp: 1.5, amp_slide: 3
      #ENTER YOUR INSTRUMENT HERE:
      with_synth :piano do
        tick
        #ENTER YOUR STRUMMING PATTERN HERE:
        "DDU.UDUD".split(//).each do |s|
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
  end
