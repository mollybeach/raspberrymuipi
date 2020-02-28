define :next_note do |n, c|
  n = note(n)
  n + (c.map {|x| (note(x) - n) % 12}).min
end
guitar_standard = [ :a3, :b3, :c3, :d3, :e3, :f3, :gs3]

define :guitar do |tonic, name, tuning=guitar_standard|
  chrd = (chord tonic, name)
  c = tuning.map {|n| next_note(n, chrd)}.ring
  root = note(chrd[0])
  first_root = c.take_while {|n| (n - root) % 12 != 0}.count
  if first_root > 0 and first_root < tuning.count / 2
    c = (ring :r) * first_root + c.drop(first_root)
  end
  c
end

# Strum a chord with a certain delay between strings
define :strum do |c, d=0.5|
  in_thread do
    play_pattern_timed c.drop_while{|n| [nil,:r].include? n}, d
  end
end
use_debug false
use_bpm 60


define :intro do
  ring((guitar :c, :M), (guitar :a, :m), (guitar :g, :M), (guitar :c, :M))
  #(guitar :c, :M), (guitar :a, :m), (guitar :g, :M), (guitar :c, :M))
end
define :verse do
  ring((guitar :a, :m7), (guitar :g, :M), (guitar :a, :'7'), (guitar :g, :M),
       (guitar :f, :M), (guitar :c, :M)) #(guitar :c, :M), (guitar :a, :M), (guitar :gs, :M))
end
define :chorus do
  ring((guitar :c, :M), (guitar :a, :m), (guitar :g, :M), (guitar :c, :M))
  #(guitar :c, :M), (guitar :a, :m), (guitar :g, :M), (guitar :c, :M))
end
define :instr do
  ring((guitar :c, :M),(guitar :a, :M), (guitar :g, :M), (guitar :e, :M))
  #(guitar :c, :M), (guitar :e, :M), (guitar :a, :M), (guitar :g, :M))
end
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
    
    
    live_loop :guit do
      #with_fx :reverb do
      #with_fx :ixi_techno, cutoff: 40, oom: 0.9, amp: 0.5 do
      #use_synth_defaults attack: 0.0625, slide: 0.0625, depth: 1.5, amp: 1.5, amp_slide: 3
      with_synth :piano do
        tick
        "DDU.UDUD".split(//).each do |s|
          if s == 'D' # Down stroke
            strum chords.look, 0.5
          elsif s == 'U' # Up stroke
            with_fx :level, amp: 0.5 do
              strum chords.look.reverse, 0.03
            end
          end
          sleep 0.5
        end
      end
      #end
      #end
    end
  end