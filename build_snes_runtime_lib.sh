# Dirty script to build snes.lib from cc65/libsrc/runtime assembly source.
# cc65 is set up to generate assembly code which relies on these runtime sources' exports.

CC65_HOME=$(cygpath -u $(where ca65)/../..)

if [ ! -d "$CC65_HOME" ];
then
  echo "Error: Could not find cc65 checkout root."
  exit 1
fi

CC65_LIBSRC=$CC65_HOME/libsrc

if [ ! -d "$CC65_LIBSRC" ];
then
  echo "Error: Could not find cc65/libsrc."
  exit 1
fi

CC65_LIBSRC_RUNTIME=$CC65_LIBSRC/runtime

for f in $(ls $CC65_LIBSRC_RUNTIME)
do
  f_wo_ext="${f%.*}"

  echo "$CC65_LIBSRC_RUNTIME/$f"
  ca65 --cpu 65816 "$CC65_LIBSRC_RUNTIME/$f" -o lib/$f_wo_ext.o
  
  ar65 a lib/snes.lib lib/$f_wo_ext.o
done

exit 0
