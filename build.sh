project_name=retroleague

# Assemb libraries into objects.
ca65 --cpu 65816 src/init.asm -o build/init.o
ca65 --cpu 65816 src/rom.asm -o build/rom.o

# Compile main to ASM.
cc65 --cpu 65816 -O3 src/$project_name.c -o build/$project_name.asm

# Build main object.
ca65 --cpu 65816 build/$project_name.asm -o build/$project_name.o

# Create executable (link all objects).
ld65 -C doc/lorom128.cfg -o bin/$project_name.smc build/$project_name.o build/init.o build/rom.o
