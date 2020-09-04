Print "Orif/Infobs - Space Invaders - Yannis Burkhalter"
Print "Jeu Space Invaders (plusieurs lignes d'ennemis)"
Print "----------------------------------------------------------------------"

nomainwin

WindowWidth=600
WindowHeight=900
UpperLeftX=Int((DisplayWidth-WindowWidth)/2)
UpperLeftY=Int((DisplayHeight-WindowHeight)/2)

open "Space Invaders" for graphics_nsb_nf as #main
#main,"trapclose [quit]"

loadbmp "bg","bg.bmp"
loadbmp "canon","canon.bmp"
loadbmp "ovni","ovni.bmp"
loadbmp "missile","missile.bmp"
loadbmp "explosion","explosion.bmp"

#main,"background bg"
#main,"addsprite missile1 missile"
#main,"addsprite missile2 missile"
#main,"addsprite canon canon explosion"

dim mortOvni(6,3)
for i=0 to 6
    for j=0 to 3
        #main,"addsprite ovni";i;"-";j;" ovni"
        #main,"spritexy ovni";i;"-";j;" ";i*72;" ";j*54+50
    next j
    j=0
next i
i=0

xCanon = 256
yMissile1 = -24
yMissile2 = 900

#main,"Setfocus"
#main,"When characterInput 20"

timer 10, 10

wait

20
key$ = Inkey$
if asc(right$(key$, 1)) = _VK_LEFT then xCanon=xCanon-10
if asc(right$(key$, 1)) = _VK_RIGHT then xCanon=xCanon+10
if asc(right$(key$, 1)) = _VK_SPACE then goto [missile]

wait

10
if xCanon<0 then xCanon=0
if xCanon>513 then xCanon=513

#main,"spritecollides missile1 list$"
for i=0 to 6
    for j=0 to 3
        if Retour=0 then #main,"spritemovexy ovni";i;"-";j;" 1 0"
        if Retour=1 then #main,"spritemovexy ovni";i;"-";j;" -1 0"
        ovni$="ovni";i;"-";j
        if list$=ovni$ and mortOvni(i,j)=0 then
            yMissile1=-25
            mortOvni(i,j)=1
            #main,"spritevisible ovni";i;"-";j;" off"
            for k=0 to 6
                for l=0 to 3
                    if mortOvni(k,l)=1 then ovnisTues=ovnisTues+1
                next l
                l=0
            next k
            k=0
            if ovnisTues=28 then
                #main,"drawsprites"
                notice "GAME OVER"
                goto [quit]
            end if
            ovnisTues=0
        end if

        if Retour=0 and mortOvni(i,j)=0 then #main,"spritexy? ovni";i;"-";j;" droite yOvni"
        if Retour=1 and mortOvni(6-i,3-j)=0 then #main,"spritexy? ovni";6-i;"-";3-j;" gauche yOvni"
    next j
    j=0
next i
i=0

if droite>=525 then Retour=1 : droite=0
if gauche<=0 then Retour = 0 : gauche=525

if yMissile1>-24 then yMissile1=yMissile1-10
if yMissile1<=-24 then NouveauMissile = 1

if yMissile2<=900 then yMissile2=yMissile2+10
if yMissile2>900 then
    30 noOvniI=int(rnd(1)*7)
    k=3
    40
    if k=-1 then goto 30
    if mortOvni(noOvniI,k)=1 then k=k-1 : goto 40 else noOvniJ=k
    k=0
    if mortOvni(noOvniI,noOvniJ)=1 then goto 30
    #main,"spritexy? ovni";noOvniI;"-";noOvniJ;" xOvniTir yOvniTir"
    xMissile2=xOvniTir+31
    yMissile2=yOvniTir+12
end if

#main,"spritecollides missile2 list$"
if list$="canon" then
    #main,"spritevisible missile2 off"
    #main,"cyclesprite canon 1 once"
    #main,"drawsprites"
    notice "GAME OVER"
    goto [quit]
end if
if list$="missile1" then yMissile1=-24 : yMissile2 = 900

#main,"spritexy canon ";xCanon;" 822"
#main,"spritexy missile1 ";xMissile1;" ";yMissile1
#main,"spritexy missile2 ";xMissile2;" ";yMissile2
#main,"drawsprites"

wait

[missile]
if NouveauMissile = 1 then
    NouveauMissile = 0
    xMissile1=xCanon+37
    yMissile1=900
end if

wait

[quit]
unloadbmp "bg"
unloadbmp "canon"
unloadbmp "ovni"
unloadbmp "missile"
unloadbmp "explosion"
close #main
end

