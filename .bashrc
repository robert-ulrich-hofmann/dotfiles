# shellcheck disable=SC2148

# every interactive shell sources .bashrc every time at launch (of the shell)
# tumbleweed specialty: /etc/profile sources ~/.bashrc
# -> everything in .bashrc also happens once in every login shell
# todo so we don't need .profile at all?

# if .alias exists, source alias else no error
test -s ~/.alias && . ~/.alias || true

export EDITOR=/usr/bin/nano
# https://www.electronjs.org/docs/latest/api/environment-variables#electron_ozone_platform_hint-linux
export ELECTRON_OZONE_PLATFORM_HINT=auto
# https://no-color.org/
export NO_COLOR=1
# on wayland while "scaled by system" or x11
#export STEAM_FORCE_DESKTOPUI_SCALING=2.0
# run QT applications with wayland
export QT_QPA_PLATFORM=wayland
# force x11 on wayland in QT applications
#export QT_QPA_PLATFORM=xcb

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
