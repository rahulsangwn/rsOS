all:
	nasm src/hello.asm -f bin -o build/boot.bin 

run:
	qemu-system-x86_64 build/boot.bin

clean:
	rm -rf build/*