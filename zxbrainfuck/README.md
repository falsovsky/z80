zxBrainfuck
=========

zxBrainfuck is a [Brainfuck](http://en.wikipedia.org/wiki/Brainfuck) interpreter in Z80 assembly for the ZX Spectrum.

* Supports all the Brainfuck instructions.
* User defined Brainfuck memory size in the **memory_size** variable. The default is 5000.
* The memory wraps at the beginning and end.
* Clears all the memory cells before use.
* Correctly counts the number of **]** equivalent to **[**, for example, it does not run the **.** in this code:
```
[[].]
```
* Uses a nice lookup table to run the instruction.

Requirements
-----------

* [Pasmo](http://pasmo.speccy.org/) - Z80 Assembler, it's Open Source and Cross Platform
* [bas2tap](ftp://ftp.worldofspectrum.org/pub/sinclair/tools/generic/bas2tap26-generic.zip) - Convert Spectrum Basic to TAP

Build
--------------

```sh
git clone https://github.com/falsovsky/z80.git
cd z80/zxbrainfuck
```

To convert a brainfuck source file to Spectrum DATA
```sh
make brainfuck SOURCE="helloworld.bf"
```
And finally
```sh
make
```

Demos
------

* [Hello World](http://falsovsky.github.io/z80/bf-hello.html)
* [Bad Hello World](http://falsovsky.github.io/z80/bf-bad_hello.html) from [esolang](http://esolangs.org/) wiki article about [Brainfuck](http://esolangs.org/wiki/Brainfuck)
* [Arvorezinha](http://falsovsky.github.io/z80/bf-arvorezinha.html)
* [Arvorezinha with loops](http://falsovsky.github.io/z80/bf-arvorezinha_loops.html)
* [Input/Output test](http://falsovsky.github.io/z80/bf-io.html)
* [Fibonacci](http://falsovsky.github.io/z80/bf-fibonacci.html) from [Daniel B Cristofani] - [source](http://www.hevanet.com/cristofd/brainfuck/fib.b)
* [Number Warper](http://falsovsky.github.io/z80/bf-numwarp.html) also by [Daniel B Cristofani] - [source](http://www.hevanet.com/cristofd/brainfuck/numwarp.b)

License
----

BSD

[Daniel B Cristofani]:http://www.hevanet.com/cristofd/brainfuck/
