#!/bin/sh
printf '\033c\033]0;%s\a' Masked Frustrations
base_path="$(dirname "$(realpath "$0")")"
"$base_path/boilingpoint.x86_64" "$@"
