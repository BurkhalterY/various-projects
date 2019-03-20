//  Yannis Burkhalter
//  20.12.2017
//  http://www.esat.ch/
//-----------------------------

#include <Servo.h>
#include <Wire.h>
#include <Adafruit_TCS34725.h>

#define intServoHaut 7 //Servo du haut sur la pin 7
#define intServoBas 8 //Servo du bas sur la pin 8

int Couleur = 0; //Variable contenant le numéro de la couleur

int PosServo = 0; //Variable contenant la position du servo

//LED rouge vert et bleu sur ports 3, 5 et 6
#define redpin 3
#define greenpin 5
#define bluepin 6


#define commonAnode true
byte gammatable[256];

Servo ServoHaut; //Création des objets servo
Servo ServoBas;

//Création de l'objet capteur
Adafruit_TCS34725 tcs = Adafruit_TCS34725(TCS34725_INTEGRATIONTIME_50MS, TCS34725_GAIN_4X);

void setup() {
  Serial.begin(9600); //Ouverture du port avec l'arduino

  //Emplacement des leds
  pinMode(redpin, OUTPUT);
  pinMode(greenpin, OUTPUT);
  pinMode(bluepin, OUTPUT);

  //Emplacement des servos
  ServoHaut.attach(intServoHaut);
  ServoBas.attach(intServoBas);
  
  if (tcs.begin()) {  //Si le capteur répond
    Serial.println("Found sensor");
  } else {            //Si le capteur ne répond pas
    Serial.println("No TCS34725 found ... check your connections");
    while (1);
  }

  for (int i=0; i<256; i++) {
    float x = i;
    x /= 255;
    x = pow(x, 2.5);
    x *= 255;
      
    if (commonAnode) {
      gammatable[i] = 255 - x;
    } else {
      gammatable[i] = x;      
    }
    //Serial.println(gammatable[i]);
  }
}


//Boucle infini
void loop() {
  start: //Définition du point 'start'
  Couleur = 0; //Reset de la variable couleur
  
  ServoHaut.write(95); // Aller chercher la bille
  delay(300);
  
  ServoHaut.write(40); // Amener la bille au capteur
  delay(250);

  //Scanne la couleur
  uint16_t clear, red, green, blue;

  tcs.setInterrupt(false);      // turn on LED

  delay(60);  // takes 50ms to read 
  
  tcs.getRawData(&red, &green, &blue, &clear);

  tcs.setInterrupt(true);  // turn off LED

  //Affiche la couleur sur l'ordinateur
  Serial.print("C:\t"); Serial.print(clear);
  Serial.print("\tR:\t"); Serial.print(red);
  Serial.print("\tG:\t"); Serial.print(green);
  Serial.print("\tB:\t"); Serial.println(blue);

  //Test de la couleur (Noir, Rouge, Blanc)
  if (clear < 5000){
    Couleur = 1; //Noir
  } else if (clear > 6000 && clear < 12000){
    Couleur = 2; //Rouge
  } else if (clear > 18000){
    Couleur = 3; //Blanc
  } else {
    Couleur = 0;
  }

  //Si la bille est noire
  if (Couleur == 1){
    Serial.println("Noir");
    ServoBas.write(180); //Tourne le servo du bas vers le bon gobelet
    if (PosServo != 180){ //Si le servo du bas n'est pas déjà sur la bonne couleur alors...
      PosServo = 180; // ...redéfinir la variable
      delay(500); // ...attendre que le servo soit positionné sur le bon gobelet
    }
  } //idem pour rouge
  else if (Couleur == 2){
    Serial.println("Rouge");
    ServoBas.write(135);
    if (PosServo != 135){
      PosServo = 135;
      delay(500);
    } 
  } //idem pour blanc
  else if (Couleur == 3){
    Serial.println("Blanc");
    ServoBas.write(90);
    if (PosServo != 90){
      PosServo = 90;
      delay(500);
    }
  }
  else { //Si aucune des trois couleurs n'est détectée, recommencer jusqu'à ce que ça correspond
    Serial.println("Inconnu");
    goto start;
  }

  //Conversion des couleurs pour la led
  uint32_t sum = clear;
  float r, g, b;
  r = red; r /= sum;
  g = green; g /= sum;
  b = blue; b /= sum;
  r *= 256; g *= 256; b *= 256;

  //Allume la led de la bonne couleur
  analogWrite(redpin, gammatable[(int)r]);
  analogWrite(greenpin, gammatable[(int)g]);
  analogWrite(bluepin, gammatable[(int)b]);
 
  // - - - - - - - - - - -
  
  ServoHaut.write(4); // Amener la bille dans le trou
  delay(200);
}

