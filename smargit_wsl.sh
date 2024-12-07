#!/bin/bash

#https://docs.syntevo.com/SmartGit/Latest/HowTos/Running-on-WSLg
mkdir ~/.config/dconf
sudo apt install libgtk-3-0
sudo apt install xdg-util
sudo apt install adwaita-icon-theme-full
export GTK_THEME=Adwaita
export SWT_GTK3=0
export $(dbus-launch)
