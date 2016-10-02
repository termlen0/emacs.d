emacs.d
=======

My emacs config

My rebuilt emacs settings.
I'm starting from scratch to remove old cruft and make it more modular.

Based on Technomancy's [Better Defaults](https://github.com/technomancy/better-defaults)
With many ideas from: 
    [BBatsov's prelude](https://github.com/bbatsov/prelude),
    [flyingmachine's settings](https://github.com/flyingmachine/emacs.d),
    [Emacs Live](https://github.com/overtone/emacs-live),

Now porting to use-package

Including instructions on how to compile and install emacs on in local directories on Fedora Linux [install-fedora.md](./doc/install-fedora.md)

A handy key binding reference: [key-bind.org](./doc/key-bind.org) acsessible with the C-h C-d key combo.

*Directories*

```custom```      contains customization files for various modules and custom lisp code

```vendor```      contains lisp modules not in any of the ```elpa``` repositories

```melpa```       contains ```elpa``` installed elisp modules.

```doc```         contains various usefull (hmm, to me) files.


This software is under the GPL3 license.
