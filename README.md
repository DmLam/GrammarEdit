GrammarEdit
============

This editor is intended to work with grammar definition files. It highlights 
grammar syntax elements, parse file 'on the fly' and shows defined grammar 
elements, providing easy navigation on them.

Author: Dmitry Lamdan (lamdan@mail.ru)

How to use:
============

If you ever used a text editor for edit a program source file then nothing new
to you in using GrammarEdit. I tryed to make the editing process as similar to
Delphi IDE editor as I can. If you don't ever see Delphi, then there are a 
couple of features wich I need to say about. 

1) When you presses Ctrl and moves mouse around the text GrammarEdit highlights 
the syntax grammar elements (rules, symbols, sets) wich is defined somewhere 
in the text. Pressing left mouse button on such highlighted word moves you to 
the definition of this element in the text.

2) Doubleclick left mouse button on the tree of grammar elements moves the 
editor cursor to this element in the text.

3) You can place up to 10 bookmarks in the text using <Ctrl>+<Shift>+<0..9> 
keys and quickly return to such a bookmark using <Ctrl>+corresponding number 
key


Building
============

Built with CodeGear Delphi 2007
Uses SynEdit components from https://github.com/SynEdit/SynEdit