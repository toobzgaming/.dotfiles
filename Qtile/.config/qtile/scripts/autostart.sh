#!/bin/bash

function run {
	if ! pgrep -x "$(basename "$1" | head -c 15)" 1>/dev/null; then
		"$@" &
	fi
}

#Set your native resolution IF it does not exist in xrandr
#More info in the script
#run $HOME/.config/qtile/scripts/set-screen-resolution-in-virtualbox.sh

#Find out your monitor name with xrandr or arandr (save and you get this line)
#xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal
#xrandr --output DP2 --primary --mode 1920x1080 --rate 60.00 --output LVDS1 --off &
#xrandr --output LVDS1 --mode 1366x768 --output DP3 --mode 1920x1080 --right-of LVDS1
#xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
#autorandr horizontal

#change your keyboard if you need it
#setxkbmap -layout be

# keybLayout=$(setxkbmap -v | awk -F "+" '/symbols/ {print $2}')

# if [ $keybLayout = "be" ]; then
#   cp $HOME/.config/qtile/config-azerty.py $HOME/.config/qtile/config.py
# fi

#autostart ArcoLinux Welcome App
#run dex $HOME/.config/autostart/arcolinux-welcome-app.desktop

#Some ways to set your wallpaper besides variety or nitrogen
feh --bg-fill ../wallpapers/linux.png &
#feh --bg-fill /usr/share/backgrounds/arcolinux/arco-wallpaper.jpg &
#wallpaper for other Arch based systems
#feh --bg-fill /usr/share/archlinux-tweak-tool/data/wallpaper/wallpaper.png &
#start the conky to learn the shortcuts
run conky -c "$HOME"/.config/qtile/scripts/system-overview
run conky -c "$HOME"/.config/qtile/scripts/system-hotkeys

#start sxhkd to replace Qtile native key-bindings

run "$HOME"/Applications/hotkeys.sh
run emacs --daemon

#starting utility applications at boot time
run variety
run nm-applet
run pamac-tray
run powerdevil
#run numlockx on
run blueberry-tray
if [ "$WAYLAND_DISPLAY" = "" ]; then
	run picom --config "$HOME"/.config/qtile/scripts/picom.conf
fi
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
#run /usr/lib/polkit-kde-authentication-agent-1
run /usr/bin/dunst

#starting user applications at boot time
run volumeicon
run yakuake
#run discord
#run nitrogen --restore
#run caffeine -a
#run vivaldi-stable
#run firefox
#run thunar
#run dropbox
#run insync start
#run spotify
#run atom
#run telegram-desktop
