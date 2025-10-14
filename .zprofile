if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec Hyprland
fi

# eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
# export SSH_AUTH_SOCK
