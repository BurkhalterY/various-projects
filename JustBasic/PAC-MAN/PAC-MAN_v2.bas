nomainwin

WindowWidth=501
WindowHeight=668
UpperLeftX=Int((DisplayWidth-WindowWidth)/2)
UpperLeftY=Int((DisplayHeight-WindowHeight)/2)

open "PAC-MAN" for graphics_nsb_nf as #main
#main,"trapclose [quit]"

loadbmp "bg","bg.bmp"

loadbmp "pacgomme","pacgomme.bmp"
for i=0 to 15
    loadbmp "tile";i,"tile";i;".bmp"
next i
i=0

for i=1 to 4
    loadbmp "pacman";i,"pacman";i;".bmp"
    #main,"addsprite pacgomme";i;" pacgomme"
next i
i=0

#main,"spritexy pacgomme1 12 60"
#main,"spritexy pacgomme2 444 60"
#main,"spritexy pacgomme3 12 468"
#main,"spritexy pacgomme4 444 468"

dim level(40,52)
open "level.dat" for input as #file

#main,"background bg"
for i=0 to 52
    input #file, ligne$
    for j=0 to 40
        tile = val(mid$(ligne$, j*3+1, 2))
        #main,"addsprite tile";j;"-";i;" tile";tile
        #main,"spritexy tile";j;"-";i;" ";j*12;" ";i*12
        level(j,i)=tile
        if tile=15 then pacgomme=pacgomme+1
    next j
    j=0
next i
i=0
close #file

#main,"addsprite pacmanH pacman1 pacman2"
#main,"addsprite pacmanV pacman3 pacman4"
#main,"spritevisible pacmanV off"

PacManX = 19
PacManY = 39

#main,"Setfocus"
#main,"When characterInput 20"

timer 75, 10

wait
20
key$ = Inkey$

wait
10

if PacManX=38 then PacManX=1
if PacManX=0 then PacManX=37

if asc(right$(key$, 1)) = _VK_LEFT then
    tile=level(PacManX-1,PacManY):tile1=level(PacManX-1,PacManY+1):tile2=level(PacManX-1,PacManY+2)
    if tile=0 or tile=15 then
        if tile1=0 or tile1=15 then
            if tile2=0 or tile2=15 then
                horizontal=-1 : vertical=0 : #main,"spritevisible pacmanH on; spritevisible pacmanV off; spriteorient pacmanH mirror";
            end if
        end if
    end if
end if
if asc(right$(key$, 1)) = _VK_RIGHT then
    tile=level(PacManX+3,PacManY):tile1=level(PacManX+3,PacManY+1):tile2=level(PacManX+3,PacManY+2)
    if tile=0 or tile=15 then
        if tile1=0 or tile1=15 then
            if tile2=0 or tile2=15 then
                horizontal=1 : vertical=0 : #main,"spritevisible pacmanH on; spritevisible pacmanV off; spriteorient pacmanH normal";
            end if
        end if
    end if
end if
if asc(right$(key$, 1)) = _VK_UP then
    tile=level(PacManX,PacManY-1):tile1=level(PacManX+1,PacManY-1):tile2=level(PacManX+2,PacManY-1)
    if tile=0 or tile=15 then
        if tile1=0 or tile1=15 then
            if tile2=0 or tile2=15 then
                vertical=-1 : horizontal=0 : #main,"spritevisible pacmanV on; spritevisible pacmanH off; spriteorient pacmanV normal";
            end if
        end if
    end if
end if
if asc(right$(key$, 1)) = _VK_DOWN then
    tile=level(PacManX,PacManY+3):tile1=level(PacManX+1,PacManY+3):tile2=level(PacManX+2,PacManY+3)
    if tile=0 or tile=15 then
        if tile1=0 or tile1=15 then
            if tile2=0 or tile2=15 then
                vertical=1: horizontal=0 : #main,"spritevisible pacmanV on; spritevisible pacmanH off; spriteorient pacmanV flip";
            end if
        end if
    end if
end if


if horizontal>0 then tile=level(PacManX+3,PacManY):tile1=level(PacManX+3,PacManY+1):tile2=level(PacManX+3,PacManY+2)
if horizontal<0 then tile=level(PacManX-1,PacManY):tile1=level(PacManX-1,PacManY+1):tile2=level(PacManX-1,PacManY+2)
if vertical>0 then tile=level(PacManX,PacManY+3):tile1=level(PacManX+1,PacManY+3):tile2=level(PacManX+2,PacManY+3)
if vertical<0 then tile=level(PacManX,PacManY-1):tile1=level(PacManX+1,PacManY-1):tile2=level(PacManX+2,PacManY-1)

if tile=0 or tile=15 then
    if tile1=0 or tile1=15 then
        if tile2=0 or tile2=15 then
            if tile1 = 15 then
                if horizontal>0 then level(PacManX+3,PacManY+1)=0
                if horizontal<0 then level(PacManX-1,PacManY+1)=0
                if vertical>0 then level(PacManX+1,PacManY+3)=0
                if vertical<0 then level(PacManX+1,PacManY-1)=0
                pacgomme=pacgomme-1
            end if
            PacManX=PacManX+horizontal
            PacManY=PacManY+vertical
        end if
    end if
end if

#main,"spritevisible tile";PacManX+1;"-";PacManY+1;" off"

if PacManX=1 and PacManY=5 then
    #main,"spritevisible pacgomme1 off"
end if
if PacManX=37 and PacManY=5 then
    #main,"spritevisible pacgomme2 off"
end if
if PacManX=1 and PacManY=39 then
    #main,"spritevisible pacgomme3 off"
end if
if PacManX=37 and PacManY=39 then
    #main,"spritevisible pacgomme4 off"
end if

#main,"spritexy pacmanH ";PacManX*12;" ";PacManY*12
#main,"spritexy pacmanV ";PacManX*12;" ";PacManY*12
#main,"cyclesprite pacmanH 1"
#main,"cyclesprite pacmanV 1"

#main,"drawsprites"

if pacgomme=0 then goto [quit]

wait

[quit]
for i=0 to 6
    unloadbmp "tile";i
next i
close #main
end
