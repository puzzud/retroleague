#!/bin/bash

graphics=../graphics

declare -a targets=("c64" "nes")

for target in "${targets[@]}"

do
  perl ./merge_chr.pl -t=$target -m=$graphics/text.map $graphics/trl_logo.map -c=$graphics/$target/text.chr $graphics/$target/trl_logo.chr --mo=$graphics/text.map $graphics/trl_logo_merged.map --co=$graphics/$target/chr0.chr
done

exit 0
