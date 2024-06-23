#!/bin/sh
echo -ne '\033c\033]0;Frog\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Frog.x86_64" "$@"
