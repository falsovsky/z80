all: starfield

starfield: starrnd.asm
		pasmo.exe -v --tap --err main.asm main.tap

starrnd.asm:
		python stargen.py

clean:
		rm -rf *.tap starrnd.asm
