zx-brainfuck
=========

ZX-Brainfuck is a [Brainfuck] interpreter in Z80 assembly for the ZX Spectrum.

Requirements
-----------

* [Pasmo] - Z80 Assembler, it's Open Source and Cross Platform
* [ZX Spin] - ZX Spectrum Emulator for Windows... or a real Spectrum

Build
--------------

```sh
git clone https://github.com/falsovsky/z80.git
cd z80/zx-brainfuck
pasmo -v --tapbas --err main.asm zx_brainfuck.tap
```

Demo
------
http://falsovsky.github.io/z80/zx-brainfuck.html

License
----

BSD

[Brainfuck]:http://en.wikipedia.org/wiki/Brainfuck
[tap]:http://www.worldofspectrum.org/faq/reference/formats.htm
[Pasmo]:http://pasmo.speccy.org/
[ZX Spin]:http://www.zophar.net/sinclair/zx-spin.html
