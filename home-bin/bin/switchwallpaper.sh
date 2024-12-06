#!/bin/bash

export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

WALLPAPER=$HOME/Images/wallpapers/monogatari-minimal/"$(ls $HOME/Images/wallpapers/monogatari-minimal | shuf -n1)"
echo $WALLPAPER
gsettings set org.gnome.desktop.background picture-uri-dark "file://$WALLPAPER"
