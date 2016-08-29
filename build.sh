project_name=retroleague

# Assemb libraries into objects.
ca65 --cpu 65816 -I include src/init.asm -o build/init.o
ca65 --cpu 65816 -I include src/rom.asm -o build/rom.o

# Compile main to ASM.
cc65 --cpu 65816 -I include -O3 src/$project_name.c -o build/$project_name.asm

# Build main object.
ca65 --cpu 65816 -I include build/$project_name.asm -o build/$project_name.o

# Create executable (link all objects).
if [ ! -e "lib/snes.lib" ];
then
  echo "Error: lib/snes.lib is not present."
  exit 1
fi

ld65 -C doc/lorom128.cfg -L lib -o bin/$project_name.smc build/$project_name.o build/init.o build/rom.o --lib snes.lib

exit 0
