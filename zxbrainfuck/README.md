zxBrainfuck
=========

zxBrainfuck is a [Brainfuck] interpreter in Z80 assembly for the ZX Spectrum.

Requirements
-----------

* [Pasmo] - Z80 Assembler, it's Open Source and Cross Platform

Build
--------------

```sh
git clone https://github.com/falsovsky/z80.git
cd z80/zxbrainfuck
pasmo -v --tapbas --err main.asm zxbrainfuck.tap
```

Demo
------
http://falsovsky.github.io/z80/zx-brainfuck.html

Running the [Fibonacci program] by [Daniel B Cristofani].

License
----

BSD

[Brainfuck]:http://en.wikipedia.org/wiki/Brainfuck
[Pasmo]:http://pasmo.speccy.org/
[Fibonacci program]:http://www.hevanet.com/cristofd/brainfuck/fib.b
[Daniel B Cristofani]:http://www.hevanet.com/cristofd/brainfuck/
