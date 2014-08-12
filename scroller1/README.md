Scroller
=========

Scroller é uma implementação um scroller de texto em Assembly no ZX Spectrum.

Requisitos
-----------

O unico realmente necessário é o Assembler, mas para ver o resultado convem tambem ter um emulador, os verdadeiros podem converter o ficheiro [tap] para audio, passar para um leitor de mp3 e ligar a um Spectrum real :-D

* [Pasmo] - Assembler de Z80, é Open Source e Cross Platform
* [ZX Spin] - Emulador de ZX Spectrum para Windows que inclui um Debugger

Instalação
--------------

```sh
git clone https://github.com/falsovsky/z80.git
cd z80/scroller1
pasmo -v --tapbas --err main.asm main.tap
```

Licença
----

BSD

[tap]:http://www.worldofspectrum.org/faq/reference/formats.htm
[Pasmo]:http://pasmo.speccy.org/
[ZX Spin]:http://www.zophar.net/sinclair/zx-spin.html
