#!/bin/bash

PACKAGE_ICON='󰏔 '
#PACKAGE_ICON=''
#PACKAGE_ICON='󰏔'

# Check official repositories
if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

# Check AUR repositories (uncomment if using yay or paru)
# if ! updates_aur=$(yay -Qum 2> /dev/null | wc -l); then
# if ! updates_aur=$(paru -Qum 2> /dev/null | wc -l); then
#     updates_aur=0
# fi

# Total updates
updates=$((updates_arch + updates_aur))

# Output the result for Polybar
if [ "$updates" -gt 0 ]; then
    echo " %{F#E06B74}$PACKAGE_ICON%{F-} $updates "
else
    echo " %{F#98C379}$PACKAGE_ICON%{F-} 0 "
fi
