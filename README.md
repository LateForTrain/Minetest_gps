# Minetest_gps
Mod for Minetest that gives GPS and teleporting functionality, very basic.

I both like playing Minetest (https://www.minetest.net/) (with the Mineclone 2 mod) and I like programming.  I realized that I could write/create my own mod and what I needed at that point was the ability to move quickly home and also have a “GPS” in the game.

This mod uses the LUA scripting (https://www.lua.org/pil/) and the Minetest API (https://api.minetest.net/).

To install this mod create a directory called "GPS" in the mods/ directory.  Copy all the files of this repository in the newly created directory.

This mod only works in singleplayer mode and the home position does not carry over between sessions (/set_home therefore needs to be run each time a session starts).

The coordinate system of Minetest the values for X, Y and Z work like this:
- If you go up, Y increases
- If you go down, Y decreases
- If you follow the sun, X increases
- If you go to the reverse direction, X decreases
- Look to the sun's direction, then turn 90° to the right and go forwards: Z increases
- Look to the sun's direction, then turn 90° to the left and go forwards: Z decreases
- The side length of a full cube is 1

I have therefore used the coordinate systems as follow in GPS app:
- z > 0 then, latitude North
- z < 0 then, latitude South
- x > 0 then, longitude East
- x < 0 then, longitude West
- y is the altitude

The functions in this mod:
- /set_home : This function shows and sets the home position for the player
- /show_home : This function shows the home position previously set
- /go_home : This function moves the player to the pre set home position
- /move_to <lat> <long> <alt>: This function moves the player to the position set
- /gps <on|off> : This function turns the onscreen GPS on or off