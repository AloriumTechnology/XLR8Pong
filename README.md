Menlo Fork:

Bring out the latent audio functionality.

Better document and comment the Verilog.

Include Eagle designs for an Arduino shield with Grove connectors for the paddles and RCA jacks for audio and video.

Include volume control and any required RC network for audio.

Include an Eagle design for a paddle/switch PCB.

# XLR8Pong
## A FPGA implementation of the Pong Game using Alorium Technology's OpenXLR8 design methodology

The XLR8 block is used to create the NTSC A/V signals needed to connected to a television or monitor that has NTSC (Game) A/V inputs for displaying the Pong game. 
Ball & Paddle movement along with scoring is handled by XLR8 block.

The XLR8's AVR core is used to just read the Players game controller's button and potentiometer
values and update the Pong's Memory Map Registers (which are used for starting, resetting, paddle position)
A sketch is included in the examples directory

To use the XLR8Pong XLR8 block follow the directions that are explained in the following webpage.
https://github.com/AloriumTechnology/XLR8BuildTemplate

A few components will need to be assembled and attached to the XLR8 board.

## Video cable:
<pre>
                             1K Ohm 
Video Sync:  JTag pin9  ----vvvvvvv--------+
                                           |
Video out:   JTag pin7  ----vvvvvvv--------+------------ RCA connector (center pin)
                             470 Ohm                    
                                                       
GND:         JTag pin2  -------------------------------- RCA GND (outside)
</pre>

## Paddle Controller:  
  2 controllers are needed using the following parts.  
  two 10k ohm or 1k ohm potentiometers and two momentary switches (normally open)
<pre>
XLR8 5v:  ------+
                |
                < 
  10K ohm  pot. <------------  (Player 0: XLR8 pin A0,   Player 1: XLR8 pin A1)
                <
                <
                |
XLR8 GND:  -----+
                |
                |
         switch  \
                |
                +------------  (Player 0: XLR8 pin D7,  Player 1: XLR8 pin D6)

</pre>

