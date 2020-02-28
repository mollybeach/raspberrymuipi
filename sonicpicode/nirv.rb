# Welcome to Sonic Pi v3.1
peter = 78
while (peter < 78)
  #Verse        #Verse
  chords = ring((guitar :g, :M), (guitar :e, :m), (ring :r, :r, 53, 57, 60, 65),
                (guitar :g, :M), (guitar :e, :M), (ring :r, :r, 53, 57, 60, 65),
                (guitar :c, :M), (guitar :d, :M), (ring :r, :r, 53, 57, 60, 65),
                (guitar :c, :M), (guitar :d, :M), (ring :r, :r, 53, 57, 60, 65),
                
                (guitar :g, :M), (guitar :e, :m), (ring :r, :r, 53, 57, 60, 65),
                (guitar :g, :M), (guitar :e, :m), (ring :r, :r, 53, 57, 60, 65),
                (guitar :c, :M), (guitar :d, :M), (ring :r, :r, 53, 57, 60, 65),
                (guitar :c, :M), (guitar :d, :M))
  peter += 1
end


if (j = 1) then
      chords = ring((guitar :e, :M), (guitar :a, :M), (guitar :g, :M), (guitar :c, :M),
                    (guitar :g, :M), (guitar :e, :M), (guitar :g, :M), (guitar :c, :M), (ring :r, :r, 53, 57, 60, 65))
      j += 1
      elsif (j = 2) then
       chords = ring((guitar :e, :M), (guitar :a, :M), (guitar :g, :M),
       (guitar :c, :M), (guitar :e, :M),
      (guitar :a, :M), (guitar :g, :m7),
      (guitar :c, :M), (guitar :e, :M),
      (guitar :a, :M), (guitar :g, :m7),
      (guitar :c, :M), (guitar :e, :M),
      (guitar :a, :M), (guitar :g, :M), (guitar :c, :M), (guitar :e, :M),
      # (guitar :e, :M), (guitar :a, :M), (guitar :g, :m),(guitar :c, :M), (ring :r, :r, 53, 57, 60, 65))
        j += 1
      elsif (j = 3) then
      #Chorus
      chords = ring((guitar :e, :M),
      (guitar :a, :M), (guitar :g, :M),
      (guitar :c, :M), (guitar :e, :M),
      (guitar :a, :M), (guitar :g, :M),
      (guitar :c, :M), (guitar :e, :M),
      (guitar :a, :M), (guitar :g, :M),
      (guitar :c, :M), (guitar :e, :M),
      (guitar :a, :M), (guitar :g, :M),
      (guitar :c, :M), (guitar :e, :M),
      (guitar :a, :M),
      (guitar :a, :M), (guitar :g, :M),
      (guitar :c, :M), (guitar :e, :M),
      (guitar :a, :M),
      (guitar :a, :M), (guitar :g, :M),
      (guitar :c, :M), (guitar :e, :M),
      (guitar :c, :M), (ring :r, :r, 53, 57, 60, 65))
      j += 1
    end