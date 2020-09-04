Print "Orif/Infobs - Jeu de Pong - Yannis Burkhalter"
Print "Jeu de Pong (1972)"
Print "----------------------------------------------------------------------"

nomainwin 'supprime la fenêtre habituelle

WindowWidth=649 '640 (taille de la fenêtre) + 9 (taille du bord)
WindowHeight=512 '480 (taille de la fenêtre) + 32 (taille du bord)
UpperLeftX=Int((DisplayWidth-WindowWidth)/2) 'Positionne la fenêtre au centre de l'écran sur l'axe X (taille de l'écran - taille de la fenêtre/2)
UpperLeftY=Int((DisplayHeight-WindowHeight)/2) 'Positionne la fenêtre au centre de l'écran sur l'axe Y (taille de l'écran - taille de la fenêtre/2)

'ouvre une fenêtre graphique nommé PONG qui est accessible via #main
open "PONG" for graphics_nsb_nf as #main
#main,"trapclose [quit]" 'si la croix est cliquée, alors va à la ligne [quit]

'transfère de toutes les images .bmp
loadbmp "bg","bg.bmp"
loadbmp "balle","balle.bmp"
loadbmp "barre","barre.bmp"
loadbmp "n1","1.bmp"
loadbmp "n2","2.bmp"
loadbmp "n3","3.bmp"
loadbmp "n4","4.bmp"
loadbmp "n5","5.bmp"
loadbmp "n6","6.bmp"
loadbmp "n7","7.bmp"
loadbmp "n8","8.bmp"
loadbmp "n9","9.bmp"
loadbmp "n0","0.bmp"

'création des sprites à partir des images
#main,"background bg" 'background définit le fond d'écran
#main,"addsprite left barre" 'addsprite crée une sprite "left" à partir de l'image "barre"
#main,"addsprite right barre"
#main,"addsprite balle balle"
#main,"addsprite noGauche n0 n1 n2 n3 n4 n5 n6 n7 n8 n9" 'possibilité de mettre plusieurs image pour une sprite
#main,"addsprite noDroite n0 n1 n2 n3 n4 n5 n6 n7 n8 n9"
#main,"cyclesprite noGauche 0" 'cyclesprite répète en boucle les image d'une sprite (j'ai mis 0 car je ne veux pas que le score bouge tout le temps)
#main,"cyclesprite noDroite 0"

'Simples variables qui définirons les positions des objets (leurs noms n'a pas d'importance)
leftY=215
rightY=215
balleX=315
balleY=235

'Variable de déplacement de la balle et sa vitesse
deplacementHorizontal=-1
deplacementVertical=0
speed=4

'spritexy défini la position d'un objet en fonction de deux coordonnées
#main,"spritexy noGauche 200 10"
#main,"spritexy noDroite 410 10"
#main,"drawsprites" 'drawsprites met à jour les emplacement des sprites dans la fenêtre

timer 10,[Boucle] 'Tous les 10 millisecondes, va à la ligne [Boucle]

#main,"setfocus" 'Se concentre sur les contrôles de la fenêtre #main
#main,"When mouseMove [control]" 'Chaque fois que la souris est bougée, va à la ligne [control]
wait 'Bloque le programme pour ne pas exécuter les actions suivantes

[control]
leftY = MouseY-25 'leftY est la variable qui stock la position Y de la barre de gauche. Le -25 permet que la souris soit au centre de la barre et non en haut

wait

[Boucle]
#main,"spritecollides balle cote$" 'spritecollides vérifies si "balle" touche un autre objet, si oui elle mais son nom dans la variable cote$

if cote$ = "left" then 'Si la balle touche le côté gauche alors...
    playwave "p1Snd.wav", async 'jouer un son. Si on ne met pas async, le jeu se stoppera et attendra la fin du son avant de continuer
    angle = (leftY-balleY+20)/5 'l'endroit où la balle touche la barre est stocké dans la variable angle, elle peut valoir entre -5 et 5
    deplacementHorizontal=cos(-15*acs(-1)/180*angle) 'deplacementHorizontal = cos(-15° * angle). -15*acs(-1)/180 converti les degrés en radians
    deplacementVertical=sin(-15*acs(-1)/180*angle)
    speed=4/deplacementHorizontal 'le temps que met la balle pour aller d'un bout à l'autre du jeu est toujours le même (4)
end if
if cote$ = "right" then 'Même chose que left
    playwave "p1Snd.wav", async
    angle = (rightY-balleY+20)/5
    deplacementHorizontal=cos(-15*acs(-1)/180*angle)*-1 ' -1 permet de faire allez la balle dans l'autre sens
    deplacementVertical=sin(-15*acs(-1)/180*angle)
    speed=4/deplacementHorizontal*-1 ' il faut aussi mettre un -1 ici
end if
if balleY < 0 or balleY+10 > 480 then deplacementVertical = deplacementVertical*-1:playwave "p2Snd.wav", async 'si la balle touche le haut ou le bas, elle rebondit en émettant un son

'Permet de faire que la balle se déplace
balleX = balleX+deplacementHorizontal*speed
balleY = balleY+deplacementVertical*speed

if balleX+10 < 0 then 'Si la balle passe derrière le joueur de gauche, alors...
    playwave "misSnd.wav", async ' Jouer un son
    scoreP2 = scoreP2+1 'Augmente la valeur du score du joueur de droite
    #main,"cyclesprite noDroite -9 once" 'La sprite "noDroite" recule de 9 images, le once le bloque pour éviter qu'il ne tourne à l'infini
    balleX=315 'Réinitialise les variables de la balle
    balleY=235
    deplacementHorizontal=1
    deplacementVertical=0
    speed=4
end if
if balleX > 640 then 'Même chose mais avec le joueur de droite
    playwave "winSnd.wav", async
    scoreP1 = scoreP1+1
    #main,"cyclesprite noGauche -9 once"
    balleX=315
    balleY=235
    deplacementHorizontal=-1
    deplacementVertical=0
    speed=4
end if

if scoreP1 >= 10 then notice "Player 1 Wins" : gosub [quit] 'Si le score du joueur est égal 10 alors il a gagné et le jeu se ferme
if scoreP2 >= 10 then notice "Player 2 Wins" : gosub [quit] 'Si le score l'ordi est égal 10 alors il a gagné et le jeu se ferme

#main,"spritexy balle ";balleX;" ";balleY 'Redéfini l'emplacement de la balle

if balleY+5 > rightY+25 then hautBas = 1 'Si la balle est plus haute que l'ordi alors la variable hautBas = 1
if balleY+5 < rightY+25 then hautBas = -1 'Si non elle vaut -1

if hautBas = 1 and deplacementDroite < 5 then deplacementDroite = deplacementDroite + 1 'deplacementDroite est une variable qui peux valoir entre -5 et 5, c'est la vitesse de l'ordi
if hautBas = -1 and deplacementDroite > -5 then deplacementDroite = deplacementDroite - 1
rightY = rightY + deplacementDroite 'déplacement de la barre de droite
'(Ce n'ai pas comme ça que marche l'IA du jeu officiel mais je n'ai pas retrouvé les algorithmes originaux sur Internet)


#main,"spritexy left 20 ";leftY 'Défini les emplacements des barres left et right, x ne change pas
#main,"spritexy right 610 ";rightY
#main,"drawsprites" 'drawsprites met à jour les emplacement des sprites dans la fenêtre
wait

[quit]
'unloadbmp permet de supprimer une image importée
unloadbmp "bg"
unloadbmp "balle"
unloadbmp "barre"
unloadbmp "n1"
unloadbmp "n2"
unloadbmp "n3"
unloadbmp "n4"
unloadbmp "n5"
unloadbmp "n6"
unloadbmp "n7"
unloadbmp "n8"
unloadbmp "n9"
unloadbmp "n0"
close #main 'Ferme la fenêtre #main
end 'Fin du programme

