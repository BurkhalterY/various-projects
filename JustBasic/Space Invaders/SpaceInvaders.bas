Print "Orif/Infobs - Space Invaders - Yannis Burkhalter"
Print "Jeu Space Invaders"
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
#main,"addsprite missile missile"
#main,"addsprite canon canon"
#main,"addsprite ovni ovni"
#main,"addsprite explosion explosion"
#main,"spritevisible explosion off"

xCanon = 256
yMissile = -24

#main,"Setfocus"
#main,"When characterInput 20"

timer 10, 10

wait

20
key$ = Inkey$
if asc(right$(key$, 1)) = _VK_LEFT then deplacementHorizontal=-3
if asc(right$(key$, 1)) = _VK_RIGHT then deplacementHorizontal=3
if asc(right$(key$, 1)) = _VK_SPACE then goto [missile]
if asc(right$(key$, 1)) <> _VK_LEFT and asc(right$(key$, 1)) <> _VK_RIGHT then deplacementHorizontal=0

wait

10
if xCanon<0 then xCanon=0
if xCanon>513 then xCanon=513
xCanon=xCanon+deplacementHorizontal

if xOvni>525 then Retour=1
if xOvni<=0 then Retour = 0

if Retour=0 then xOvni=xOvni+1
if Retour=1 then xOvni=xOvni-1

if yMissile>-24 then yMissile=yMissile-10
if yMissile<=-24 then NouveauMissile = 1

#main,"spritecollides missile list$"
if list$="ovni" and finDuJeu = 0 then
    yMissile=-25
    #main,"spritexy explosion ";xOvni-6;" 50"
    #main,"spritevisible explosion on"
    #main,"spritevisible ovni off"
    finDuJeu = 1
end if

#main,"spritexy ovni ";xOvni;" 50"
#main,"spritexy canon ";xCanon;" 822"
#main,"spritexy missile ";xMissile;" ";yMissile
#main,"drawsprites"

wait

[missile]
if NouveauMissile = 1 then
    NouveauMissile = 0
    xMissile=xCanon+37
    yMissile=900
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

