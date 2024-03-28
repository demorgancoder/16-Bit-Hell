.define ROM_NAME "TEST"
.MEMORYMAP
 SLOTSIZE $8000
 DEFAULTSLOT 0
 SLOT 0 $8000
.ENDME

.ROMBANKSIZE $8000
.ROMBANKS 96

;.BASE $C0

.DEFINE HEADER_OFF $0000

.EMPTYFILL $FF

.SNESHEADER
 ID "SNES"
 NAME "16-Bit Hell"
 SLOWROM
 LOROM
 CARTRIDGETYPE $00
 ROMSIZE $0C
 SRAMSIZE $00
 COUNTRY $01
 LICENSEECODE $00
 VERSION $00
.ENDSNES

.BANK 0 SLOT 0

.SNESNATIVEVECTOR

COP EmptyHandler
BRK EmptyHandler
ABORT EmptyHandler
NMI NMI
UNUSED $0000
IRQ EmptyHandler

.ENDNATIVEVECTOR

.SNESEMUVECTOR 
COP EmptyHandler
ABORT EmptyHandler
NMI EmptyHandler
RESET Start
IRQBRK EmptyHandler
.ENDEMUVECTOR

.define TileDataSection $00A0
.define FirstPictureBank 01
.define MosaicDir $00A1
.define MosaicMirror $00A2
.define PaletteLength 32
.define DoingTransition $00A3
.define PalAndMapIndex $7e0100
.define PalAndMapBank $7e0102
.define LastPictureBank 86
.define PalPlusMapSize 2080

.BANK 0 SLOT 0
.ORG $0
.SECTION "Code" SEMIFREE

MAIN:
Start:

    ; SNES initialzation

    sei
    phk
    plb
    clc
    xce
    rep         #$30                    ; 16-bit A/X/Y
    lda         #$0000                  ; Direct page @ $0000
    tcd
    ldx         #$01ff                  ; Stack @ $0100-01ff
    txs
    sep         #%00100000              ; 8-bit A

    lda         #$8F                    ; forced blanking (screen off), full brightness
    sta         $2100                   ; brightness & screen enable register
    lda         #$00
    sta         $2101                   ; sprite register (size & address in VRAM)
    sta         $2102                   ; sprite registers (address of sprite memory [OAM])
    sta         $2103                   ; sprite registers (address of sprite memory [OAM])
    sta         $2105                   ; graphic mode register
    sta         $2106                   ; mosaic register
    sta         $2107                   ; plane 0 map VRAM location
    sta         $2108                   ; plane 1 map VRAM location
    sta         $2109                   ; plane 2 map VRAM location
    sta         $210A                   ; plane 3 map VRAM location
    sta         $210B                   ; plane 0 & 1 Tile data location
    sta         $210C                   ; plane 2 & 3 Tile data location
    sta         $210D                   ; plane 0 scroll x (first 8 bits)
    sta         $210D                   ; plane 0 scroll x (last 3 bits)
    sta         $210E                   ; plane 0 scroll y (first 8 bits)
    sta         $210E                   ; plane 0 scroll y (last 3 bits)
    sta         $210F                   ; plane 1 scroll x (first 8 bits)
    sta         $210F                   ; plane 1 scroll x (last 3 bits)
    sta         $2110                   ; plane 1 scroll y (first 8 bits)
    sta         $2110                   ; plane 1 scroll y (last 3 bits)
    sta         $2111                   ; plane 2 scroll x (first 8 bits)
    sta         $2111                   ; plane 2 scroll x (last 3 bits)
    sta         $2112                   ; plane 2 scroll y (first 8 bits)
    sta         $2112                   ; plane 2 scroll y (last 3 bits)
    sta         $2113                   ; plane 3 scroll x (first 8 bits)
    sta         $2113                   ; plane 3 scroll x (last 3 bits)
    sta         $2114                   ; plane 3 scroll y (first 8 bits)
    sta         $2114                   ; plane 3 scroll y (last 3 bits)
    lda         #$80                    ; increase VRAM address after writing to $2119
    sta         $2115                   ; VRAM address increment register
    lda         #$00
    sta         $2116                   ; VRAM address low
    sta         $2117                   ; VRAM address high
    sta         $211A                   ; initial mode 7 setting register
    sta         $211B                   ; mode 7 matrix parameter A register (low)
    lda         #$01
    sta         $211B                   ; mode 7 matrix parameter A register (high)
    lda         #$00
    sta         $211C                   ; mode 7 matrix parameter B register (low)
    sta         $211C                   ; mode 7 matrix parameter B register (high)
    sta         $211D                   ; mode 7 matrix parameter C register (low)
    sta         $211D                   ; mode 7 matrix parameter C register (high)
    sta         $211E                   ; mode 7 matrix parameter D register (low)
    lda         #$01
    sta         $211E                   ; mode 7 matrix parameter D register (high)
    lda         #$00
    sta         $211F                   ; mode 7 center position X register (low)
    sta         $211F                   ; mode 7 center position X register (high)
    sta         $2120                   ; mode 7 center position Y register (low)
    sta         $2120                   ; mode 7 center position Y register (high)
    sta         $2121                   ; color number register ($00-$ff)
    sta         $2123                   ; bg1 & bg2 window mask setting register
    sta         $2124                   ; bg3 & bg4 window mask setting register
    sta         $2125                   ; obj & color window mask setting register
    sta         $2126                   ; window 1 left position register
    sta         $2127                   ; window 2 left position register
    sta         $2128                   ; window 3 left position register
    sta         $2129                   ; window 4 left position register
    sta         $212A                   ; bg1, bg2, bg3, bg4 window logic register
    sta         $212B                   ; obj, color window logic register (or, and, xor, xnor)
    sta         $212C                   ; main screen designation (planes, sprites enable)
    sta         $212D                   ; sub screen designation
    sta         $212E                   ; window mask for main screen
    sta         $212F                   ; window mask for sub screen
    lda         #$30
    sta         $2130                   ; color addition & screen addition init setting
    lda         #$00
    sta         $2131                   ; add/sub sub designation for screen, sprite, color
    lda         #$E0
    sta         $2132                   ; color data for addition/subtraction
    lda         #$00
    sta         $2133                   ; screen setting (interlace x,y/enable SFX data)
    sta         $4200                   ; enable v-blank, interrupt, joypad register
    lda         #$FF
    sta         $4201                   ; programmable I/O port
    lda         #$00
    sta         $4202                   ; multiplicand A
    sta         $4203                   ; multiplier B
    sta         $4204                   ; multiplier C
    sta         $4205                   ; multiplicand C
    sta         $4206                   ; divisor B
    sta         $4207                   ; horizontal count timer
    sta         $4208                   ; horizontal count timer MSB
    sta         $4209                   ; vertical count timer
    sta         $420A                   ; vertical count timer MSB
    sta         $420B                   ; general DMA enable (bits 0-7)
    sta         $420C                   ; horizontal DMA (HDMA) enable (bits 0-7)
    sta         $420D                   ; access cycle designation (slow/fast rom)

    ; Zero-initialize VRAM via DMA

    ldx         #$0000
    stx         $2116                   ; Starting address in VRAM
    lda         #%00001001
    sta         $4300                   ; DMA properties: CPU to PPU, no increment, 2 bytes to 2 registers
    lda         #$18
    sta         $4301                   ; Set write address to $2118
    ldx.w       #zerobyte
    stx         $4302                   ; Set source address to the zero byte
    lda         #:zerobyte
    sta         $4304                   ; Set source address to the zero byte
    ldx         #$0000
    stx         $4305                   ; Writing 0 bytes??
    lda         #%00000001
    sta         $420B                   ; Enable DMA channel 0

.define FirstTileDataSection 07
    ; Set up tile map for backgrounds

    lda #$01                            ; Set the bank for the Palette and TileMap to be 1
    sta PalAndMapBank
    lda #$00                            ; Set the section 0th TileDataSection within the PalAndMapBank to 0
    sta.l PalAndMapSectionWithinBank 
    lda #FirstTileDataSection            
    sta TileDataSection
    jsr DisplayPicture                  ; Draw the picture

    cli                                 ; Enable interrupts

    lda         #$01                    ; Enable BG1
    sta         $212c

    ; Enable VBlank interrupt


    ldx	    	#$0000
    stx         $4209

    lda         #$91
    sta         $4200

    sep         #$20                    ; Set the A register to 8-bit.
    lda		    #$01
    sta		    MosaicDir
    
    lda         #$01
    sta         MosaicMirror
    sta         $2106
 
    stz         DoingTransition

    ; End force blank

    lda         #$0F
    sta         $2100
    

@Loop:
    wai
    jmp         @Loop                    ;  Wait for NMI


EmptyHandler:
    rti

.define MapSize 2048
.define PalSize 32
.define PalAndMapSectionWithinBank $7e0235
DisplayPicture:   
    php
    lda		#$80
    sta		$2100  ; Enable forced blanking
    
    lda     PalAndMapBank               ; Load which Palette and Map Bank we're on
    pha                                 ; Put it in the data bank register
    plb
    rep     #$20                        ; Change A to 16-bit
    lda     PalAndMapSectionWithinBank  ; Which picture's section within the Palette and map bank?
    and     #$00FF                      ; AND it by #$00FF for some reason
    tay                                 ; Transfer A to Y
    lda     #$0000                      ; Clear A
    sta     AddNextTime                 ; Store A in AddNextTime
    lda     #$8000                      ; We're in LoROM, so add #$8000 to all addresses
    cpy     #$0000                      ; Is this the first section we need?

    beq MapPointerLoop                  ; If so, skip calculating the address further

.define AddNextTime $7e0300
DisplayPictureLoop:

    clc
    adc #PalPlusMapSize                 ; Add size of palette and map

    dey                                 ; Decrement Y...
 
    cpy #$0000                          ; Until it's 0
    bne DisplayPictureLoop              

MapPointerLoop:
    tay
    sep #$20 
    lda         #$00                    ; Set BG1 tile map at VRAM $0000-07FF, 32x32
    sta         $2107
    lda         #$01                    ; Set BG1 CHR at $2000
    sta         $210b
    ; Copy BG1 chr to VRAM at $2000 via DMA
    ldx         #$1000
    stx         $2116
    ldx         #%0001100000000001
    stx         $4300
    ldx         #$8000
    stx         $4302                              
    lda         TileDataSection           ; Bank with palette data
 
    sta         $4304
    ldx         #$7FFF
    stx         $4305
    lda		#%00000001
    sta		$420b

    ; Copy palette to CGRAM via DMA

    lda         #$00                    ; start at palette entry #0
    sta         $2121
    ldx         #$2200
    stx         $4320
    sty         $4322                   ; Store location of palette
    lda         PalAndMapBank           ; Bank with Palette data
    sta         $4324
    ldx         #32                     ;size of palette
    stx         $4325
    lda         #%00000100
    sta         $420B

    ; Copy BG1 tilemap to VRAM at $0000 via DMA

    ldx         #$0000
    stx         $2116
    ldx         #$1801
    stx         $4310
    rep         #$30
    tya
    clc
    adc         #32
    tay
    sty         $4312                      ;  Tilemap location is in Y after 32 is added
    sep         #$20
    lda         PalAndMapBank              ;  Bank with map data
    sta         $4314
    ldx         #$07ff
    stx         $4315
    lda 	#%00000010
    sta 	$420b
    
    inc TileDataSection
     
    ; Use graphics mode 1

    lda         #$01
    sta         $2105


    lda.l PalAndMapSectionWithinBank      ; There are 15 (0 - 14) picture sections in a bank.
    cmp #14                               ; Check if we're on the last bank
    bne Not14                             ; If not, skip
    lda #$00                              ; If so, set picture section within bank to 0
    sta.l PalAndMapSectionWithinBank         
    lda PalAndMapBank                     ; Increment the bank we're on, and put it in data bank register
    inc a
    pha
    plb
    sta PalAndMapBank
    bra TileDataSectionCode                ; Skip to next section
Not14:
    inc a
    sta.l PalAndMapSectionWithinBank

TileDataSectionCode:
    lda 	TileDataSection               ; Load TileDataSection
    cmp 	#LastPictureBank             ; Is it the last picture bank?
    bcc 	+                            ; If not, skip to end.

    lda     #$00                         ; Load first picture section within bank
    sta.l     PalAndMapSectionWithinBank          
    lda 	#FirstTileDataSection         ; Load first picture
    sta 	TileDataSection
    lda     #$01                         ; Set the bank to the first Palette and Map bank
    sta     PalAndMapBank
    pha                                  ; Change the data bank to this bank.
    plb


+   lda 	#$0f
    sta		$2100                        ; Disable forced blank

    plp		

    rts                                  ; Return from subroutine 


.define SkipGraphicsChange = $00a4

NMI:
   lda          DoingTransition              ; Are we doing the transition?
   cmp          #$01
   bne          +                            ; If so, go/continue mosaic transition

   jsr 		DoTransition

+  lda		$4218                            ; Check controller for button presses
   cmp          #$00
   beq          +

   lda          #$01                         ; If there has been a button press, we're doing a transition
   sta          DoingTransition 
   
+  rti                                       ; Return to non-VBlank loop



DoTransition:
   php
   lda          MosaicDir                    ; See if mosaic direction is down
   cmp          #$00
   beq          MosaicDown                   ; If so, go to MosaicDown
MosaicUp:
   lda          #$01                         ; If we're going up, we're doing the transition
   sta          DoingTransition
   lda 		    MosaicMirror                 ; Bit wrangle to get to check if the mosaic is done
   lsr
   lsr
   lsr
   lsr
   cmp 		    #$0f                         ; Check if mosaic is done going up
   bne          IncrementMosaic

   jsr 	    	DisplayPicture               ; If done, change the picture
   stz 	    	MosaicDir                    ; Change the mosaic direction                            
   lda 	    	#$f1                         
   sta 	    	MosaicMirror
   sta 	    	$2106                        ; Store it in mosaic register
   plb
   rts                                       ; Return from subroutine

IncrementMosaic:
   inc          a                            ; Increase mosaic, and bit wrangle to get it proper
   asl
   asl
   asl
   asl
   inc          a
   sta          MosaicMirror                 ; Store mosaic byte 
   sta          $2106

   plb
   rts	                                     ; Return from interrupt

MosaicDown:
   lda          MosaicMirror                

+  lsr
   lsr
   lsr
   lsr
   cmp 	    	#$00                        ; Are we done going down?
   beq          ChangeMosaicToUp            ; If so, change MosaicDir to up and end it
      
   dec          a
   asl
   asl
   asl
   asl
   inc          a

   sta          MosaicMirror
   sta		$2106
   cmp          #$01                        ; Is it Done?
   bne          +                           ; If not, skip to end.

   stz          DoingTransition             ; Otherwise, store zero in DoingTransition
+  plb
   rts
ChangeMosaicToUp
   lda #$01                                 ; Change mosaic direction to up and leave
   sta MosaicDir
   plb
   rts

zerobyte: .byte 1

.ends
.BANK 1 SLOT 0
.ORG $0
DataBeginning:
.section "MAP0" force

titlepalette: .incbin "assets/pal/title.pal"
titlemap: .incbin "assets/map/title.map"

palette0: .incbin "assets/pal/hell-0.pal"
frame0map: .incbin "assets/map/hell-0.map"


palette1: .incbin "assets/pal/hell-1.pal"
frame1map: .incbin "assets/map/hell-1.map"


palette2: .incbin "assets/pal/hell-2.pal"
frame2map: .incbin "assets/map/hell-2.map"

;NOTE THAT hell-3 is skipped!

palette3: .incbin "assets/pal/hell-4.pal"
frame3map: .incbin "assets/map/hell-4.map"


palette4: .incbin "assets/pal/hell-5.pal"
frame4map: .incbin "assets/map/hell-5.map"


palette5: .incbin "assets/pal/hell-6.pal"
frame5map: .incbin "assets/map/hell-6.map"

palette6: .incbin "assets/pal/hell-7.pal"
frame6map: .incbin "assets/map/hell-7.map"

palette7: .incbin "assets/pal/hell-8.pal"
frame7map: .incbin "assets/map/hell-8.map"

palette8: .incbin "assets/pal/hell-9.pal"
frame8map: .incbin "assets/map/hell-9.map"

palette10: .incbin "assets/pal/hell-10.pal"
frame9map: .incbin "assets/map/hell-10.map"

palette11: .incbin "assets/pal/hell-11.pal"
frame10map: .incbin "assets/map/hell-11.map"

palette12: .incbin "assets/pal/hell-12.pal"
frame11map: .incbin "assets/map/hell-12.map"

palette13: .incbin "assets/pal/hell-13.pal"
frame12map: .incbin "assets/map/hell-13.map"

palette14: .incbin "assets/pal/hell-14.pal"
frame13map: .incbin "assets/map/hell-14.map"

.ends

.BANK 2 SLOT 0
.ORG $0
.section MAP1 force

palette15: .incbin "assets/pal/hell-15.pal"
frame14map: .incbin "assets/map/hell-15.map"

palette16: .incbin "assets/pal/hell-16.pal"
frame15map: .incbin "assets/map/hell-16.map"

palette17: .incbin "assets/pal/hell-17.pal"
frame16map: .incbin "assets/map/hell-17.map"

palette18: .incbin "assets/pal/hell-18.pal"
frame17map: .incbin "assets/map/hell-18.map"

palette19: .incbin "assets/pal/hell-19.pal"
frame18map: .incbin "assets/map/hell-19.map"

palette20: .incbin "assets/pal/hell-20.pal"
frame19map: .incbin "assets/map/hell-20.map"

palette21: .incbin "assets/pal/hell-21.pal"
frame20map: .incbin "assets/map/hell-21.map"

palette22: .incbin "assets/pal/hell-22.pal"
frame21map: .incbin "assets/map/hell-22.map"

palette23: .incbin "assets/pal/hell-23.pal"
frame22map: .incbin "assets/map/hell-23.map"

palette24: .incbin "assets/pal/hell-24.pal"
frame23map: .incbin "assets/map/hell-24.map"

palette25: .incbin "assets/pal/hell-25.pal"
frame24map: .incbin "assets/map/hell-25.map"

palette26: .incbin "assets/pal/hell-26.pal"
frame25map: .incbin "assets/map/hell-26.map"

palette27: .incbin "assets/pal/hell-27.pal"
frame26map: .incbin "assets/map/hell-27.map"

palette28: .incbin "assets/pal/hell-28.pal"
frame27map: .incbin "assets/map/hell-28.map"

palette29: .incbin "assets/pal/hell-29.pal"
frame28map: .incbin "assets/map/hell-29.map"


.ends

.BANK 3 SLOT 0
.ORG $0
.section "MAP2" force


palette30: .incbin "assets/pal/hell-30.pal"
frame29map: .incbin "assets/map/hell-30.map"

palette31: .incbin "assets/pal/hell-31.pal"
frame30map: .incbin "assets/map/hell-31.map"

palette32: .incbin "assets/pal/hell-32.pal"
frame31map: .incbin "assets/map/hell-32.map"

palette33: .incbin "assets/pal/hell-33.pal"
frame32map: .incbin "assets/map/hell-33.map"

palette34: .incbin "assets/pal/hell-34.pal"
frame33map: .incbin "assets/map/hell-34.map"

palette35: .incbin "assets/pal/hell-35.pal"
frame34map: .incbin "assets/map/hell-35.map"

palette36: .incbin "assets/pal/hell-36.pal"
frame35map: .incbin "assets/map/hell-36.map"

palette37: .incbin "assets/pal/hell-37.pal"
frame36map: .incbin "assets/map/hell-37.map"

palette38: .incbin "assets/pal/hell-38.pal"
frame37map: .incbin "assets/map/hell-38.map"

palette39: .incbin "assets/pal/hell-39.pal"
frame38map: .incbin "assets/map/hell-39.map"

palette40: .incbin "assets/pal/hell-40.pal"
frame39map: .incbin "assets/map/hell-40.map"

palette41: .incbin "assets/pal/hell-41.pal"
frame40map: .incbin "assets/map/hell-41.map"

palette42: .incbin "assets/pal/hell-42.pal"
frame41map: .incbin "assets/map/hell-42.map"

palette43: .incbin "assets/pal/hell-43.pal"
frame42map: .incbin "assets/map/hell-43.map"

palette44: .incbin "assets/pal/hell-44.pal"
frame43map: .incbin "assets/map/hell-44.map"

.ends

.BANK 4 SLOT 0
.ORG $0
.section "MAP3" force

palette45: .incbin "assets/pal/hell-45.pal"
frame44map: .incbin "assets/map/hell-45.map"

palette46: .incbin "assets/pal/hell-46.pal"
frame45map: .incbin "assets/map/hell-46.map"

palette47: .incbin "assets/pal/hell-47.pal"
frame46map: .incbin "assets/map/hell-47.map"

palette48: .incbin "assets/pal/hell-48.pal"
frame47map: .incbin "assets/map/hell-48.map"

palette49: .incbin "assets/pal/hell-49.pal"
frame48map: .incbin "assets/map/hell-49.map"

palette50: .incbin "assets/pal/hell-50.pal"
frame49map: .incbin "assets/map/hell-50.map"

palette51: .incbin "assets/pal/hell-51.pal"
frame50map: .incbin "assets/map/hell-51.map"

palette52: .incbin "assets/pal/hell-52.pal"
frame51map: .incbin "assets/map/hell-52.map"

palette53: .incbin "assets/pal/hell-53.pal"
frame52map: .incbin "assets/map/hell-53.map"

palette54: .incbin "assets/pal/hell-54.pal"
frame53map: .incbin "assets/map/hell-54.map"

palette55: .incbin "assets/pal/hell-55.pal"
frame54map: .incbin "assets/map/hell-55.map"

palette56: .incbin "assets/pal/hell-56.pal"
frame55map: .incbin "assets/map/hell-56.map"

palette57: .incbin "assets/pal/hell-57.pal"
frame56map: .incbin "assets/map/hell-57.map"

palette58: .incbin "assets/pal/hell-58.pal"
frame57map: .incbin "assets/map/hell-58.map"

palette59: .incbin "assets/pal/hell-59.pal"
frame58map: .incbin "assets/map/hell-59.map"

.ends

.BANK 5 SLOT 0
.ORG $0
.section "MAP4" force

palette60: .incbin "assets/pal/hell-60.pal"
frame59map: .incbin "assets/map/hell-60.map"

palette61: .incbin "assets/pal/hell-61.pal"
frame60map: .incbin "assets/map/hell-61.map"

palette62: .incbin "assets/pal/hell-62.pal"
frame61map: .incbin "assets/map/hell-62.map"

palette63: .incbin "assets/pal/hell-63.pal"
frame62map: .incbin "assets/map/hell-63.map"

palette64: .incbin "assets/pal/hell-64.pal"
frame63map: .incbin "assets/map/hell-64.map"

palette65: .incbin "assets/pal/hell-65.pal"
frame64map: .incbin "assets/map/hell-65.map"

palette66: .incbin "assets/pal/hell-66.pal"
frame65map: .incbin "assets/map/hell-66.map"

palette67: .incbin "assets/pal/hell-67.pal"
frame66map: .incbin "assets/map/hell-67.map"

palette68: .incbin "assets/pal/hell-68.pal"
frame67map: .incbin "assets/map/hell-68.map"

palette69: .incbin "assets/pal/hell-69.pal"
frame68map: .incbin "assets/map/hell-69.map"

palette70: .incbin "assets/pal/hell-70.pal"
frame69map: .incbin "assets/map/hell-70.map"

palette71: .incbin "assets/pal/hell-71.pal"
frame70map: .incbin "assets/map/hell-71.map"

palette72: .incbin "assets/pal/hell-72.pal"
frame71map: .incbin "assets/map/hell-72.map"

palette73: .incbin "assets/pal/hell-73.pal"
frame72map: .incbin "assets/map/hell-73.map"

palette74: .incbin "assets/pal/hell-74.pal"
frame73map: .incbin "assets/map/hell-74.map"

.ends

.BANK 6 SLOT 0
.ORG $0
.section "MAP5" force

palette75: .incbin "assets/pal/hell-75.pal"
frame74map: .incbin "assets/map/hell-75.map"

palette76: .incbin "assets/pal/hell-76.pal"
frame75map: .incbin "assets/map/hell-76.map"

palette77: .incbin "assets/pal/hell-77.pal"
frame76map: .incbin "assets/map/hell-77.map"

palette78: .incbin "assets/pal/hell-78.pal"
frame77map: .incbin "assets/map/hell-78.map"

palette79: .incbin "assets/pal/hell-79.pal"
frame78map: .incbin "assets/map/hell-79.map"

.ends


.BANK 7 SLOT 0
.ORG $0
.section "TITLE0" force
titlechr: .incbin "assets/til/title.til"
.ends

.BANK 8 SLOT 0
.ORG $0
.section "IMAGE1" force
frame1chr: .incbin "assets/til/hell-0.til"
fcl1: frame1chrlen = fcl1 - frame1chr
.ends

.BANK 9 SLOT 0
.ORG $0
.section "IMAGE2" force
frame2chr: .incbin "assets/til/hell-1.til"
fcl2: frame2chrlen = fcl2 - frame2chr
.ends


.BANK 10 SLOT 0
.ORG $0
.section "IMAGE3" force
frame3chr: .incbin "assets/til/hell-2.til"
fcl3: frame3chrlen = fcl3 - frame3chr
.ends

.BANK 11 SLOT 0
.ORG $0
.section "IMAGE4" force
frame4chr: .incbin "assets/til/hell-4.til"
fcl4: frame4chrlen = fcl4 - frame4chr
.ends

.BANK 12 SLOT 0
.ORG $0
.section "IMAGE5" force
frame5chr: .incbin "assets/til/hell-5.til"
fcl5: frame5chrlen = fcl5 - frame5chr
.ends

.BANK 13 SLOT 0
.ORG $0
.section "IMAGE6" force
frame6chr: .incbin "assets/til/hell-6.til"
fcl6: frame6chrlen = fcl6 - frame6chr
.ends

.BANK 14 SLOT 0
.ORG $0
.section "IMAGE7" force
frame7chr: .incbin "assets/til/hell-7.til"
fcl7: frame7chrlen = fcl7 - frame7chr
.ends

.BANK 15 SLOT 0
.ORG $0
.section "IMAGE8" force
frame8chr: .incbin "assets/til/hell-8.til"
fcl8: frame8chrlen = fcl8 - frame8chr
.ends

.BANK 16 SLOT 0
.ORG $0
.section "IMAGE9" force
frame9chr: .incbin "assets/til/hell-9.til"
fcl9: frame9chrlen = fcl9 - frame9chr
.ends

.BANK 17 SLOT 0
.ORG $0
.section "IMAGE10" force
frame10chr: .incbin "assets/til/hell-10.til"
fcl10: frame10chrlen = fcl10 - frame10chr
.ends

.BANK 18 SLOT 0
.ORG $0
.section "IMAGE11" force
frame11chr: .incbin "assets/til/hell-11.til"
fcl11: frame11chrlen = fcl11 - frame11chr
.ends

.BANK 19 SLOT 0
.ORG $0
.section "IMAGE12" force
frame12chr: .incbin "assets/til/hell-12.til"
fcl12: frame12chrlen = fcl12 - frame12chr
.ends

.BANK 20 SLOT 0
.ORG $0
.section "IMAGE13" force
frame13chr: .incbin "assets/til/hell-13.til"
fcl13: frame13chrlen = fcl13 - frame13chr
.ends

.BANK 21 SLOT 0
.ORG $0
.section "IMAGE14" force
frame14chr: .incbin "assets/til/hell-14.til"
fcl14: frame14chrlen = fcl14 - frame14chr
.ends

.BANK 22 SLOT 0
.ORG $0
.section "IMAGE15" force
frame15chr: .incbin "assets/til/hell-15.til"
fcl15: frame15chrlen = fcl15 - frame15chr
.ends

.BANK 23 SLOT 0
.ORG $0
.section "IMAGE16" force
frame16chr: .incbin "assets/til/hell-16.til"
fcl16: frame16chrlen = fcl16 - frame16chr
.ends

.BANK 24 SLOT 0
.ORG $0
.section "IMAGE17" force
frame17chr: .incbin "assets/til/hell-17.til"
fcl17: frame17chrlen = fcl17 - frame17chr
.ends

.BANK 25 SLOT 0
.ORG $0
.section "IMAGE18" force
frame18chr: .incbin "assets/til/hell-18.til"
fcl18: frame18chrlen = fcl18 - frame18chr
.ends

.BANK 26 SLOT 0
.ORG $0
.section "IMAGE19" force
frame19chr: .incbin "assets/til/hell-19.til"
fcl19: frame19chrlen = fcl19 - frame19chr
.ends

.BANK 27 SLOT 0
.ORG $0
.section "IMAGE20" force
frame20chr: .incbin "assets/til/hell-20.til"
fcl20: frame20chrlen = fcl20 - frame20chr
.ends

.BANK 28 SLOT 0
.ORG $0
.section "IMAGE21" force
frame21chr: .incbin "assets/til/hell-21.til"
fcl21: frame21chrlen = fcl21 - frame21chr
.ends

.BANK 29 SLOT 0
.ORG $0
.section "IMAGE22" force
frame22chr: .incbin "assets/til/hell-22.til"
fcl22: frame22chrlen = fcl22 - frame22chr
.ends

.BANK 30 SLOT 0
.ORG $0
.section "IMAGE23" force
frame23chr: .incbin "assets/til/hell-23.til"
fcl23: frame23chrlen = fcl23 - frame23chr
.ends

.BANK 31 SLOT 0
.ORG $0
.section "IMAGE24" force
frame24chr: .incbin "assets/til/hell-24.til"
fcl24: frame24chrlen = fcl24 - frame24chr
.ends

.BANK 32 SLOT 0
.ORG $0
.section "IMAGE25" force
frame25chr: .incbin "assets/til/hell-25.til"
fcl25: frame25chrlen = fcl25 - frame25chr
.ends

.BANK 33 SLOT 0
.ORG $0
.section "IMAGE26" force
frame26chr: .incbin "assets/til/hell-26.til"
fcl26: frame26chrlen = fcl26 - frame26chr
.ends

.BANK 34 SLOT 0
.ORG $0
.section "IMAGE27" force
frame27chr: .incbin "assets/til/hell-27.til"
fcl27: frame27chrlen = fcl27 - frame27chr
.ends

.BANK 35 SLOT 0
.ORG $0
.section "IMAGE28" force
frame28chr: .incbin "assets/til/hell-28.til"
fcl28: frame28chrlen = fcl28 - frame28chr
.ends

.BANK 36 SLOT 0
.ORG $0
.section "IMAGE29" force
frame29chr: .incbin "assets/til/hell-29.til"
fcl29: frame29chrlen = fcl29 - frame29chr
.ends

.BANK 37 SLOT 0
.ORG $0
.section "IMAGE30" force
frame30chr: .incbin "assets/til/hell-30.til"
fcl30: frame30chrlen = fcl30 - frame30chr
.ends

.BANK 38 SLOT 0
.ORG $0
.section "IMAGE31" force
frame31chr: .incbin "assets/til/hell-31.til"
fcl31: frame31chrlen = fcl31 - frame31chr
.ends

.BANK 39 SLOT 0
.ORG $0
.section "IMAGE32" force
frame32chr: .incbin "assets/til/hell-32.til"
fcl32: frame32chrlen = fcl32 - frame32chr
.ends

.BANK 40 SLOT 0
.ORG $0
.section "IMAGE33" force
frame33chr: .incbin "assets/til/hell-33.til"
fcl33: frame33chrlen = fcl33 - frame33chr
.ends

.BANK 41 SLOT 0
.ORG $0
.section "IMAGE34" force
frame34chr: .incbin "assets/til/hell-34.til"
fcl34: frame34chrlen = fcl34 - frame34chr
.ends

.BANK 42 SLOT 0
.ORG $0
.section "IMAGE35" force
frame35chr: .incbin "assets/til/hell-35.til"
fcl35: frame35chrlen = fcl35 - frame35chr
.ends

.BANK 43 SLOT 0
.ORG $0
.section "IMAGE36" force
frame36chr: .incbin "assets/til/hell-36.til"
fcl36: frame36chrlen = fcl36 - frame36chr
.ends

.BANK 44 SLOT 0
.ORG $0
.section "IMAGE37" force
frame37chr: .incbin "assets/til/hell-37.til"
fcl37: frame37chrlen = fcl37 - frame37chr
.ends

.BANK 45 SLOT 0
.ORG $0
.section "IMAGE38" force
frame38chr: .incbin "assets/til/hell-38.til"
fcl38: frame38chrlen = fcl38 - frame38chr
.ends

.BANK 46 SLOT 0
.ORG $0
.section "IMAGE39" force
frame39chr: .incbin "assets/til/hell-39.til"
fcl39: frame39chrlen = fcl39 - frame39chr
.ends

.BANK 47 SLOT 0
.ORG $0
.section "IMAGE40" force
frame40chr: .incbin "assets/til/hell-40.til"
fcl40: frame40chrlen = fcl40 - frame40chr
.ends

.BANK 48 SLOT 0
.ORG $0
.section "IMAGE41" force
frame41chr: .incbin "assets/til/hell-41.til"
fcl41: frame41chrlen = fcl41 - frame41chr
.ends

.BANK 49 SLOT 0
.ORG $0
.section "IMAGE42" force
frame42chr: .incbin "assets/til/hell-42.til"
fcl42: frame42chrlen = fcl42 - frame42chr
.ends

.BANK 50 SLOT 0
.ORG $0
.section "IMAGE43" force
frame43chr: .incbin "assets/til/hell-43.til"
fcl43: frame43chrlen = fcl43 - frame43chr
.ends

.BANK 51 SLOT 0
.ORG $0
.section "IMAGE44" force
frame44chr: .incbin "assets/til/hell-44.til"
fcl44: frame44chrlen = fcl44 - frame44chr
.ends

.BANK 52 SLOT 0
.ORG $0
.section "IMAGE45" force
frame45chr: .incbin "assets/til/hell-45.til"
.ends

.BANK 53 SLOT 0
.ORG $0
.section "IMAGE46" force
frame46chr: .incbin "assets/til/hell-46.til"
.ends

.BANK 54 SLOT 0
.ORG $0
.section "IMAGE47" force
frame47chr: .incbin "assets/til/hell-47.til"
.ends

.BANK 55 SLOT 0
.ORG $0
.section "IMAGE48" force
frame48chr: .incbin "assets/til/hell-48.til"
.ends

.BANK 56 SLOT 0
.ORG $0
.section "IMAGE49" force
frame49chr: .incbin "assets/til/hell-49.til"
.ends

.BANK 57 SLOT 0
.ORG $0
.section "IMAGE50" force
frame50chr: .incbin "assets/til/hell-50.til"
.ends

.BANK 58 SLOT 0
.ORG $0
.section "IMAGE51" force
frame51chr: .incbin "assets/til/hell-51.til"
.ends

.BANK 59 SLOT 0
.ORG $0
.section "IMAGE52" force
frame52chr: .incbin "assets/til/hell-52.til"
.ends

.BANK 60 SLOT 0
.ORG $0
.section "IMAGE53" force
frame53chr: .incbin "assets/til/hell-53.til"
.ends

.BANK 61 SLOT 0
.ORG $0
.section "IMAGE54" force
frame54chr: .incbin "assets/til/hell-54.til"
.ends

.BANK 62 SLOT 0
.ORG $0
.section "IMAGE55" force
frame55chr: .incbin "assets/til/hell-55.til"
.ends

.BANK 63 SLOT 0
.ORG $0
.section "IMAGE56" force
frame56chr: .incbin "assets/til/hell-56.til"
.ends

.BANK 64 SLOT 0
.ORG $0
.section "IMAGE57" force
frame57chr: .incbin "assets/til/hell-57.til"
.ends

.BANK 65 SLOT 0
.ORG $0
.section "IMAGE58" force
frame58chr: .incbin "assets/til/hell-58.til"
.ends

.BANK 66 SLOT 0
.ORG $0
.section "IMAGE59" force
frame59chr: .incbin "assets/til/hell-59.til"
.ends

.BANK 67 SLOT 0
.ORG $0
.section "IMAGE60" force
frame60chr: .incbin "assets/til/hell-60.til"
.ends

.BANK 68 SLOT 0
.ORG $0
.section "IMAGE61" force
frame61chr: .incbin "assets/til/hell-61.til"
.ends

.BANK 69 SLOT 0
.ORG $0
.section "IMAGE62" force
frame62chr: .incbin "assets/til/hell-62.til"
.ends

.BANK 70 SLOT 0
.ORG $0
.section "IMAGE63" force
frame63chr: .incbin "assets/til/hell-63.til"
.ends

.BANK 71 SLOT 0
.ORG $0
.section "IMAGE64" force
frame64chr: .incbin "assets/til/hell-64.til"
.ends

.BANK 72 SLOT 0
.ORG $0
.section "IMAGE65" force
frame65chr: .incbin "assets/til/hell-65.til"
.ends

.BANK 73 SLOT 0
.ORG $0
.section "IMAGE66" force
frame66chr: .incbin "assets/til/hell-66.til"
.ends

.BANK 74 SLOT 0
.ORG $0
.section "IMAGE67" force
frame67chr: .incbin "assets/til/hell-67.til"
.ends

.BANK 75 SLOT 0
.ORG $0
.section "IMAGE68" force
frame68chr: .incbin "assets/til/hell-68.til"
.ends

.BANK 76 SLOT 0
.ORG $0
.section "IMAGE69" force
frame69chr: .incbin "assets/til/hell-69.til"
.ends

.BANK 77 SLOT 0
.ORG $0
.section "IMAGE70" force
frame70chr: .incbin "assets/til/hell-70.til"
.ends

.BANK 78 SLOT 0
.ORG $0
.section "IMAGE71" force
frame71chr: .incbin "assets/til/hell-71.til"
.ends

.BANK 79 SLOT 0
.ORG $0
.section "IMAGE72" force
frame72chr: .incbin "assets/til/hell-72.til"
.ends

.BANK 80 SLOT 0
.ORG $0
.section "IMAGE73" force
frame73chr: .incbin "assets/til/hell-73.til"
.ends

.BANK 81 SLOT 0
.ORG $0
.section "IMAGE74" force
frame74chr: .incbin "assets/til/hell-74.til"
.ends

.BANK 82 SLOT 0
.ORG $0
.section "IMAGE75" force
frame75chr: .incbin "assets/til/hell-75.til"
.ends

.BANK 83 SLOT 0
.ORG $0
.section "IMAGE76" force
frame76chr: .incbin "assets/til/hell-76.til"
.ends

.BANK 84 SLOT 0
.ORG $0
.section "IMAGE77" force
frame77chr: .incbin "assets/til/hell-77.til"
.ends

.BANK 85 SLOT 0
.ORG $0
.section "IMAGE78" force
frame78chr: .incbin "assets/til/hell-78.til"
.ends

.BANK 87 SLOT 0
.ORG $0
.section "IMAGE79" force
frame79chr: .incbin "assets/til/hell-79.til"
.ends