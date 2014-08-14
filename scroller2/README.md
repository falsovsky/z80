Scroller2
=========

Scroller2 é a minha segunda implementação um [scroller] em Z80 Assembly para o ZX Spectrum.

É um scroller que scrolla o texto guardado em memoria pixel a pixel da direita para a esquerda, tipo os da [demoscene].

Requisitos
-----------

* [Pasmo] - Assembler de Z80, é Open Source e Cross Platform
* [ZX Spin] - Emulador de ZX Spectrum para Windows que inclui um Debugger, ou um Spectrum de verdade :-)

Assemblar
--------------

```sh
git clone https://github.com/falsovsky/z80.git
cd z80/scroller2
pasmo -v --tapbas --err main.asm scroller2.tap
```

Demo
------
http://falsovsky.github.io/z80/scroller2.html

Licença
----

BSD

[scroller]:http://en.wikipedia.org/wiki/Scrolling#Demos
[Pasmo]:http://pasmo.speccy.org/
[ZX Spin]:http://www.zophar.net/sinclair/zx-spin.html
[demoscene]:http://en.wikipedia.org/wiki/Demoscene