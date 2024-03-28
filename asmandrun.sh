#!/bin/bash
wla-65816 -o "16-Bit Hell.obj" "16-Bit Hell.asm"
wlalink "16-Bit Hell.lnk" "16-Bit Hell.sfc"
bsnes-accuracy "16-Bit Hell.sfc"
