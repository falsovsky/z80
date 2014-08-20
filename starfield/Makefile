all: starfield

starfield: starrnd.asm
		pasmo.exe -v --tap --err main.asm main.tap

starrnd.asm:
		python randomgen.py

clean:
		rm -rf *.tap starrnd.asm
