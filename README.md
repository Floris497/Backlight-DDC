# Backlight DDC

### be warned this software is quite buggy on some hardware combinations
Not every manufacturer has made DDC-CI functionality as described in the standarts.. this causes some monitors to flikker when changing settings or even crash.
Your mac might crash (I only experienced this with macbooks due to the internal monitor not supporting DDC-CI I assume)

This application implements some (altered) functions/code from: https://github.com/kfix/ddcctl

This application can change brightness and contrast on your DDC-CI enabled monitor.

Requesting current values from the monitor seems to work much better on a AMD GPU than on an NVIDIA or INTEL GPU.

### support for multi monitor setup

Tested on DELL U2410 (1920x1200) with:
- MacMini 2011 + INTEL HD3000 (DP/HDMI) (Works okay)
- MacMini 2011 + GTX 670 (DP/DVI/HDMI) (Works okay)
- MacMini 2011 + Radeon HD6870 (DP/DVI/HDMI) (Works Better)

KNOWN ISSUES:
- CRASHES MACBOOKS
- NVIDIA and INTEL GPU don't do data requiests good
- some monitors try to smooth the transitions wich makes the screen flash a bit (partial fix with 'continuous effects' checkbox)

TODO:
- proper reading of current values
- volume slider/mute
- sleep
- many other things


