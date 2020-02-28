
#next note higher or equal to the base note note n that is in the chord c
define :next_note do |n, c|
    n = note(n)
    #Gets distances to each note in chord,
    #Add smallest to the base note
    n + (c.map {|x| (note(x) - n) % 12}).min
end
#enter your key here:
tune_key = [ :a4, :b4, :c4, :d4, :e4, :fs5, :g4]
#returns ring representing the chord
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
        strumming_str = "DDU.U.D.UU.DD."
        chords = intro
        j += 1
        elsif (j = 2) then
        strumming_str = "DDU.U.UU.DD."
        chords = verse
        j += 1
        elsif (j = 3) then
        strumming_str = "DDU.U.DD.DUU.DD."
        chords = chorus
        j -= 1
        elsif (j = 4) then
        strumming_str = "DDU.U.DD.UUD."
        chords = verse
        #elsif (j = 5) then
        #  chords = instr
        j += 1
    end
    
    
    live_loop :song do
        #modify your sound with with_fx here:
        #with_fx :reverb do
        #with_fx :ixi_techno, cutoff: 40, oom: 0.9, amp: 0.5 do
        #use_synth_defaults attack: 0.0625, slide: 0.0625, depth: 1.5, amp: 1.5, amp_slide: 3
        #ENTER YOUR INSTRUMENT HERE:
        with_synth :piano do
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
end
#repeat here
1.times do
    #Enter single note patterns here
    play_pattern_timed [:f, :a, :g, :b, :b, :a, :a, :g, :e, :e, :g,
    :g, :b, :b, :d, :d, :c, :c, :e,
    :e, :a, :a, :b], [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    sleep 0.5
end
1.times do
    intro
end
1.times do
    verse
end
sleep 0.5
2.times do
    chorus
    sleep 0.5
    play :a4, amp: 0.1
    sleep 0.5
end
sleep 0.5
2.times do
    verse
end
#  2.times do
#   instr
#  end
    
