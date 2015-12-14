# Get robots off their parachutes
right

# While not at a parachute, go right. When at a parachute, go fast right.

skip: skipNext
goto func

# Stuff to do if at parachute
goto fast
goto skip

# Stuff to do if NOT at parachute
func: right
goto skip

# Go fasssssssttttttt
fast: right
right
right
right
goto fast
