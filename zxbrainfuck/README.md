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

Demos
------

* [Hello World](http://falsovsky.github.io/z80/bf-hello.html)
* [Bad Hello World](http://falsovsky.github.io/z80/bf-bad_hello.html) from [esolang](http://esolangs.org/)'s article about [Brainfuck](http://esolangs.org/wiki/Brainfuck)
* [Arvorezinha](http://falsovsky.github.io/z80/bf-arvorezinha.html)
* [Arvorezinha with loops](http://falsovsky.github.io/z80/bf-arvorezinha_loops.html)
* [Input/Output test](http://falsovsky.github.io/z80/bf-io.html)
* [Fibonacci](http://falsovsky.github.io/z80/bf-fibonacci.html) from [Daniel B Cristofani] - [source](http://www.hevanet.com/cristofd/brainfuck/fib.b)
* [Number Warper](http://falsovsky.github.io/z80/bf-numwarp.html) also by [Daniel B Cristofani] - [source](http://www.hevanet.com/cristofd/brainfuck/numwarp.b)

License
----

BSD

[Brainfuck]:http://en.wikipedia.org/wiki/Brainfuck
[Pasmo]:http://pasmo.speccy.org/
[Daniel B Cristofani]:http://www.hevanet.com/cristofd/brainfuck/
