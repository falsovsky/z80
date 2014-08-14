Scroller1
=========

Scroller1 é a minha primeira implementação um [scroller] em Z80 Assembly para o ZX Spectrum.

Apenas scrolla o que já está actualmente no ecrã, pixel a pixel, da esquerda para a direita e da direita para a esquerda.

Requisitos
-----------

* [Pasmo] - Assembler de Z80, é Open Source e Cross Platform
* [ZX Spin] - Emulador de ZX Spectrum para Windows que inclui um Debugger, ou um Spectrum de verdade :-)

Assemblar
--------------

```sh
git clone https://github.com/falsovsky/z80.git
cd z80/scroller1
pasmo -v --tapbas --err main.asm scroller1.tap
```

Demo
------
http://falsovsky.github.io/z80/scroller1.html

Licença
----

BSD

[scroller]:http://en.wikipedia.org/wiki/Scrolling#Demos
[Pasmo]:http://pasmo.speccy.org/
[ZX Spin]:http://www.zophar.net/sinclair/zx-spin.html
