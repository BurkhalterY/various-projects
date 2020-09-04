Print "Orif/Infobs - Space Invaders - Yannis Burkhalter"
Print "Jeu Space Invaders (plusieurs types type d'ennemis)"
Print "----------------------------------------------------------------------"

nomainwin

WindowWidth=900
WindowHeight=900
UpperLeftX=Int((DisplayWidth-WindowWidth)/2)
UpperLeftY=Int((DisplayHeight-WindowHeight)/2)

open "Space Invaders" for graphics_nsb_nf as #main
#main,"trapclose [quit]"

loadbmp "bg","bg.bmp"
loadbmp "canon","canon-2.bmp"
loadbmp "ovni","ovni1.bmp"
loadbmp "ovni2","ovni2.bmp"
loadbmp "ovni3","ovni3.bmp"
loadbmp "missile","missile-2.bmp"
loadbmp "explosion","explosion-2.bmp"
loadbmp "bonus","bonus.bmp"

#main,"background bg"
#main,"addsprite missile1 missile"
#main,"addsprite missile2 missile"
#main,"addsprite canon canon explosion"
#main,"addsprite vie1 canon"
#main,"addsprite vie2 canon"
#main,"spritescale vie1 50"
#main,"spritexy vie1 5 850"
#main,"spritescale vie2 50"
#main,"spritexy vie2 30 850"

dim mortOvni(10,4)
for i=0 to 10
    #main,"addsprite ovni";i;"-0 ovni2"
    #main,"spritexy ovni";i;"-0 ";i*54;" ";54
    for j=1 to 2
        #main,"addsprite ovni";i;"-";j;" ovni"
        #main,"spritexy ovni";i;"-";j;" ";i*54;" ";j*54+54
    next j
    j=0
    for j=3 to 4
        #main,"addsprite ovni";i;"-";j;" ovni3"
        #main,"spritexy ovni";i;"-";j;" ";i*54;" ";j*54+54
    next j
    j=0
next i
i=0

#main,"addsprite bonus bonus"
#main,"spritexy bonus -48 10"

life=3
xCanon = 426
yMissile1 = -24
yMissile2 = 900
ennemisRestants=55

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
if xCanon<=0 then xCanon=0
if xCanon>=852 then xCanon=852

#main,"spritecollides missile1 listMissile$"
#main,"spritecollides canon listCanon$"
for i=0 to 10
    for j=0 to 4
        if Retour=0 then #main,"spritemovexy ovni";i;"-";j;" 1 0"
        if Retour=1 then #main,"spritemovexy ovni";i;"-";j;" -1 0"
        if Retour=2 then
            #main,"spritemovexy ovni";i;"-";j;" 0 1"
            l=l+1
            if l>=18*55 then l=0:Retour = 1
        end if
        if Retour=3 then
            #main,"spritemovexy ovni";i;"-";j;" 0 1"
            l=l+1
            if l>=18*55 then l=0:Retour = 0
        end if
        ovni$="ovni";i;"-";j
        if listMissile$=ovni$ and mortOvni(i,j)=0 then
            yMissile1=-25
            mortOvni(i,j)=1
            #main,"spritevisible ovni";i;"-";j;" off"
            ennemisRestants=ennemisRestants-1
            if ennemisRestants=0 then
                #main,"drawsprites"
                notice "GAME OVER" + chr$(13) + "Your score: ";score
                goto [quit]
            end if
            if j=0 then score = score + 10
            if j=1 or j=2 then score = score + 20
            if j=3 or j=4 then score = score + 30
        end if
        if listCanon$=ovni$ and mortOvni(i,j)=0 then
            #main,"cyclesprite canon 1 once"
            #main,"drawsprites"
            notice "GAME OVER" + chr$(13) + "Your score: ";score
            goto [quit]
        end if

        if Retour=0 and mortOvni(i,j)=0 then #main,"spritexy? ovni";i;"-";j;" droite yOvni"
        if Retour=1 and mortOvni(10-i,4-j)=0 then #main,"spritexy? ovni";10-i;"-";4-j;" gauche yOvni"
    next j
    j=0
next i
i=0

if droite>853 then Retour=2 : droite=0
if gauche<0 then Retour = 3 : gauche=853

if yMissile1>-24 then yMissile1=yMissile1-10
if yMissile1<=-24 then NouveauMissile = 1

if yMissile2<=900 then yMissile2=yMissile2+speed
if yMissile2>=900 then
    30 noOvniI=int(rnd(1)*10)
    k=4
    40
    if k=-1 then goto 30
    if mortOvni(noOvniI,k)=1 then k=k-1 : goto 40 else noOvniJ=k
    if k=0 then speed=15
    if k=1 or k=2 then speed=10
    if k=3 or k=4 then speed=5
    if mortOvni(noOvniI,noOvniJ)=1 then goto 30
    #main,"spritexy? ovni";noOvniI;"-";noOvniJ;" xOvniTir yOvniTir"
    xMissile2=xOvniTir+31
    yMissile2=yOvniTir+12
end if

if listCanon$="missile2" then
    yMissile2 = 900
    life=life - 1
    if life = 0 then
        #main,"cyclesprite canon 1 once"
        #main,"spritevisible missile2 off"
        #main,"drawsprites"
        notice "GAME OVER" + chr$(13) + "Your score: ";score
        goto [quit]
    end if
    #main,"removesprite vie";life
end if
if listMissile$="missile2" then yMissile1=-24 : yMissile2 = 900

bonusRnd = int(rnd(1)*1000)+1
if Bonus=0 and bonusRnd = 250 then Bonus=1
if Bonus=0 and bonusRnd = 750 then Bonus=2
if Bonus=1 then
    #main,"spritemovexy bonus 3 0"
    if listMissile$="bonus" then
        #main,"spritexy bonus -48 10"
        pointsBonus=int(rnd(1)*4)+1
        if pointsBonus=1 then score=score+50
        if pointsBonus=2 then score=score+100
        if pointsBonus=3 then score=score+150
        if pointsBonus=4 then score=score+300
        Bonus = 0
    end if
    #main,"spritexy? bonus bonusX bonusY"
    if bonusX>900 then Bonus = 0
end if
if Bonus=2 then
    #main,"spritemovexy bonus -3 0"
    if listMissile$="bonus" then
        #main,"spritexy bonus 900 10"
        pointsBonus=int(rnd(1)*4)+1
        if pointsBonus=1 then score=score+50
        if pointsBonus=2 then score=score+100
        if pointsBonus=3 then score=score+150
        if pointsBonus=4 then score=score+300
        Bonus = 0
    end if
    #main,"spritexy? bonus bonusX bonusY"
    if bonusX<-48 then Bonus = 0
end if

#main,"spritexy canon ";xCanon;" 822"
#main,"spritexy missile1 ";xMissile1;" ";yMissile1
#main,"spritexy missile2 ";xMissile2;" ";yMissile2
#main,"drawsprites"

wait

[missile]
if NouveauMissile = 1 then
    NouveauMissile = 0
    xMissile1=xCanon+17
    yMissile1=825
end if

wait

[quit]
unloadbmp "bg"
unloadbmp "canon"
unloadbmp "ovni"
unloadbmp "missile"
unloadbmp "ovni2"
unloadbmp "ovni3"
unloadbmp "explosion"

close #main
end
