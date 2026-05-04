#!/usr/bin/with-contenv bash

set -eu
set -o pipefail

s6-setuidgid devbox mkdir -p "$HOME/.config"
s6-setuidgid devbox mv /misc/kscreenlockerrc "$HOME/.config/kscreenlockerrc"
