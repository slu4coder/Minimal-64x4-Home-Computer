# Revision 1.4 Redux

I have designed the Redux just for fun to make it even more minimalistic: It uses 4 ICs less than the original, which I consider quite an achievement ;-)
It is *not* fully software-compatible (although the differences are slight) to the original Minimal 64x4 since it features an improved and more orthogonal instruction set with some small microcode tweaks. The OS and API have seen improvements, too, resulting in an overall 5% performance gain and a slightly snappier feel.
The serial interface now runs on 7 data bits and the serial OUT command features hardware waiting, which was a fun thing to implement.

The folder 'KiCAD9' contains the schematics and PCB layout files.
For the bill of materials (BOM) please refer to chapter 'Hardware' of the 'Minimal 64x4 Reference Manual'. Follow the link in the root readme.md of this repo.

The folder 'Support' contains the cross-platform assembler und the emulator (Win).
The folder 'Programs' contains native Minimal 64x4 Redux code.
