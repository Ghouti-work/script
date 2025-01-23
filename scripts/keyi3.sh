#!/bin/bash

# Function to display a formatted list of keybindings
function display_keybindings {
    echo "Basic Navigation and Window Management:"
    echo "  Modkey + j/k/l/semicolon: Move focus left/down/up/right"
    echo "  Modkey + Shift + j/k/l/semicolon: Move the focused window left/down/up/right"
    echo "  Modkey + Return: 		Enter resize mode"
    echo "  Modkey + a: 			Focus the parent container"
    echo "  Modkey + d:	 			Focus the child container"
    echo "  Modkey + Shift + f: 	Toggle focus between tiling and floating windows"
    echo ""
    echo "Workspace Management:"
    echo "  Modkey + 1-10: 			Switch to workspace number 1-10"
    echo "  Modkey + Shift + 1-10: 	Move the focused container to workspace number 1-10"
    echo ""
    echo "Application Launching and Closing:"
    echo "  Modkey + Space: 		Run dmenu for quick application launching"
    echo "  Modkey + t: 			Launch Alacritty terminal"
    echo "  Modkey + b: 			Launch FireFox browser"
    echo "  Modkey + q: 			Kill focused window"
    echo ""
    echo "Other Functions:"
    echo "  Modkey + Escape: 		Execute a power menu script"
    echo "  Modkey + xss-lock: 		Lock the screen"
    echo "  Modkey + nm-applet: 	Open the network manager applet"
    echo "  Modkey + pactl: 		Adjust volume and mute settings"
    echo "  Modkey + Shift + c: 	Reload the i3 config file"
    echo "  Modkey + Shift + r: 	Restart i3"
    echo "  Modkey + Shift + e: 	Exit i3"
    echo "  Modkey + n 				create note using rofi and noter is command line"
    echo "  Modkey + print 			full screenshot "
    echo "  Modkey + F12   			window screenshot "
    echo "  Modkey + p     		   	passmenu "
    echo "  Modkey + I     		   	rofi emoji menu"
    echo "  Modkey + Shift + u     	rize the brightness up "
    echo "  Modkey + Shift + d     	down the brightness down"
    echo "  Modkey + Shift + b     	show batry notif"
    echo "  Modkey + Shift + s     	switch window using rofi" 
    echo "  Modkey + c 				rofi short cut to open configuration"
}

# Call the function to display the keybindings
display_keybindings
