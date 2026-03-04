# shellcheck disable=SC2148

# every interactive shell sources .bashrc every time at launch (of the shell)
# tumbleweed specialty: /etc/profile sources ~/.bashrc
# -> everything in .bashrc also happens once in every login shell
# todo so we don't need .profile at all?

# if .alias exists, source alias else no error
test -s ~/.alias && . ~/.alias || true

# force 8 (="24") instead of 10 bit color depth to save bandwidth on thunderbolt dock
# check with xdpyinfo | grep "depths of root window"
export KWIN_DRM_PREFER_COLOR_DEPTH=24

# set preferred visual editor
export VISUAL=/usr/bin/kate

# set preferred line editor
export EDITOR=/usr/bin/nano

# https://no-color.org/
export NO_COLOR=1

# Wayland stuff
# https://www.electronjs.org/docs/latest/api/environment-variables#electron_ozone_platform_hint-linux
export ELECTRON_OZONE_PLATFORM_HINT=auto
# on wayland while "scaled by system" or x11
#export STEAM_FORCE_DESKTOPUI_SCALING=2.0
# run QT applications with wayland
export QT_QPA_PLATFORM=wayland
# run GTK3 applications with wayland backend
export GDK_BACKEND=wayland
# run Clutter applications with wayland backend
export CLUTTER_BACKEND=wayland

# startup "screen"
echo
if [ -x /usr/bin/fortune ]
then
    /usr/bin/fortune
    echo
else
    echo "fortune not found"
fi

# log
echo ".bashrc sourced"
