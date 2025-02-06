# Cheatsheet

## temporarily add current directory to executable path

PATH="$(pwd):$PATH"

## temporarily change editor for commands

EDITOR=nano crontab -e

## FIREFOX

Add `media.cubeb.backend` with value `alsa` to avoid jumping volume on application streams with pulseaudio on pipewire.
