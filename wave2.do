vlib work
vlog -timescale 1ns/1ns Morse.v
vsim Morse

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# 50 MHz clock on signal slowclk (0 at 0ns, 1 at 10ns, repeat at 20)
force {CLOCK_50} 0 0ns, 1 10ns -r 20ns

# First test case
# Set input values using the force command, signal names need to be in {} brackets.
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {KEY[0]} 0
force {KEY[1]} 1
# Run simulation for a few ns.
run 20ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {KEY[0]} 0
force {KEY[1]} 1
run 20ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {KEY[0]} 1
force {KEY[1]} 0
run 20ns

force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {KEY[0]} 1
force {KEY[1]} 1
run 20ns

# Second test case: change input values and run for another 10ns.
# SW[0] should control LED[0]
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {KEY[0]} 1
force {KEY[1]} 1
run 2000000000ns