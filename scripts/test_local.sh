#!/bin/bash

target_dir="/mnt/d/games/World of Warcraft/_classic_era_/Interface/AddOns"
addon_name="EquipmentManagerClassic"
current_dir=$(pwd)
this_dir=$(dirname $0)
files=("EquipmentManagerClassic.toc" "embeds.xml")
included_dirs=("GUI" "libs" "core")

mkdir -p "$target_dir/$addon_name"
for file in "${files[@]}"; do cp -v "$current_dir/$file" "$target_dir/$addon_name/."; done

for dir in "${included_dirs[@]}"; do
    if [ -d "$current_dir/$dir" ]; then
        mkdir -p "$target_dir/$addon_name/$dir"
        cp -rv "$current_dir/$dir/." "$target_dir/$addon_name/$dir/."
    fi
done
