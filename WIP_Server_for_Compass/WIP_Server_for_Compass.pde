/* Server für Kartendarstellung und Kommunikation mit Smartphone */

import oscP5.*;
import netP5.*;

//Initialisieren der OSCP5 Library
OscP5 oscP5;
NetAddress myRemoteLocation;

//Setzen der IP-Adresse des Smartphones
String remoteIP = "141.83.180.211";

//Walking = Bewegung vorerst gestoppt
boolean walking = false; 
  //        dir = false;    zur Vermeidung von "Sliding in Place"

  
  /* Gehgeschwindigkeit, Schrittzähler, Skalierung der Karte, Breite der Anzeige, Höhe der Anzeige,
 aktuelle Aufgabe */
int  
  velocity = 10, 
  steps = 0, 
  scale = 6, 
  width1=600, 
  height1=800, 
  task = 0;
 
 
/*Y-Achse des Beschleunigungssensor, Z-Achse des Beschleunigungssensor, Ausrichtung des Handys, 
 Ausrichtung in Bogenmaß, Ausrichtung in Grad, X- und Y-Position der Karte */
float   accelerometerY,
  accelerometerZ,
  direction, 
  rad, 
  degree, 
  stepsX = -(width1*(scale/2)), 
  stepsY = -(height1*(scale/2));

//Zielkoordinaten der Aufgaben
int[][] taskPos = {{-3250, -4000, -1200, -1800}, 
  {-2900, -3600, -2500, -3000}, 
  //nicht erreichbare Koordinaten, wenn Aufgaben beendet sind
  {100, 100, 100, 100}};
 
 //Definieren der benötigten Bilder:
 //Hauptmenü-Grafik, Kompassrose, Buttons des Hauptmenüs, Kalibrieren-Buttons
PImage  title, rose, btn1, btn2, btn3, btnKaliTrue, btnKaliFalse,
        //Aufgabenstart-Button, Aufgabenanzeige, Auswahl-Buttons für Steuerungsmodi
        btnEinblenden, btnAufgabeStart, Aufgabe, radiobtnOn, radiobtnOff,
        //Zurück zum Hauptmenü, weißer Hintergrund, Kalibrieren-Hinweis
        button_hauptmenue,hintergrundmenue, kaliHin;

//Definieren der Größe der Buttons
int    btn1Width = 150, 
  btn1Height = 30,
  
  //Setzen der Position der Buttons
  btnKaliX=200, 
  btn1X = 360, 
  btn1Y = 0, 
  btn2X =520, 
  btn3X = 680, 
  button_hauptmenueX=1000,
  btnAufgabeStartX = button_hauptmenueX-btn1Width-10,
  btnEinblendenX=70, 
  bildAufgabeX=50, 
  bildAufgabeY=120,
  radiobtn1X=100,
  radiobtn1Y=600,
  radiobtn2Y=650,
  
//Welche Aufgabe ist gerade aktiv
  AufgabeStarten=0,
  ersterTimer;

//Setzen eines weißes Hintergrunds
color  bckColor = color(255);

//Standardeinstellungen für Buttons
boolean btn1Over = false, 
  btn2Over = false, 
  btn3Over = false, 
  btnStartOver=false, 
  btnKaliOver=false, 
  radiobtn1Over=false,
  radiobtn2Over=false,
  btnAufgabeStartOver=false, 
  imageIsLoaded = false, 
  btnEinblendenOver=false, 
  btnHauptmenueOver=false,
  Ausblenden=false, 
  firstStart=true,
  radiobtn1=true,
  radiobtn2=false,
  kali=false;    
  //Hauptmenü=true;

void setup() {
  accelerometerY = 9.81;
  background(bckColor);
  //Bilder mit PNG-Dateien verknüpfen
  title = loadImage("title.png");
  rose =loadImage("Kompassrose-no.png");
  btn1 = loadImage("btn1.png");
  btn2 = loadImage("btn2.png");
  btn3= loadImage("btn4.png");
  btnKaliTrue=loadImage("btnKaliTrue.png");
  btnKaliFalse=loadImage("btnKaliFalse.png");
  btnAufgabeStart = loadImage("btnAufgabe.png");
  btnEinblenden=loadImage("EinblendenBtn2.png");
  Aufgabe=loadImage("Aufgabe1.png");
  radiobtnOff=loadImage("radiobtnOff.png");
  radiobtnOn=loadImage("radiobtnOn.png");
  button_hauptmenue=loadImage("button_hauptmenue.png");
  hintergrundmenue=loadImage("Hintergrund_menue.png");
  kaliHin=loadImage("Richtung_kali.png");
  //Legt Größe fest
  size(displayWidth, displayHeight, P3D);
  frameRate(60);
  textAlign(LEFT, TOP);
  textSize(18);
  fill(50);

  // start oscP5, listening for incoming messages on port 12000 */
  oscP5 = new OscP5(this, 12000);

  /* send to phone address, not needed yet */
  myRemoteLocation = new NetAddress(remoteIP, 12001);
}

void draw() {

  update (mouseX, mouseY);
  
  fill(255);
  //Lädt Buttons
  image(hintergrundmenue, stepsX, stepsY, width*scale, height*scale);
  image(btn1, btn1X, btn1Y, btn1Width, btn1Height);
  image(btn2, btn2X, btn1Y, btn1Width, btn1Height);
  image(btn3, btn3X, btn1Y, btn1Width, btn1Height);
  //image(btnEinblenden, btnEinblendenX, btn1Y, btn1Width, btn1Height);
  image(title, 0, -180, width, height);
  
  //Einrichten der Radiobuttons
  if(radiobtn1){
       textAlign(LEFT);
      image(radiobtnOn, radiobtn1X,radiobtn1Y, 50,50);
      image(radiobtnOff, radiobtn1X,radiobtn2Y, 50,50);
      textSize(20);
      fill(0);
      text("Smartphone in der Tasche", radiobtn1X+50, radiobtn1Y+20);
      textSize(20);
      fill(0);
      text("Smartphone in der Hand", radiobtn1X+50, radiobtn2Y+20);
  }
  if(radiobtn2){
      textAlign(LEFT);
      image(radiobtnOff, radiobtn1X,radiobtn1Y, 50,50);
      image(radiobtnOn, radiobtn1X,radiobtn2Y, 50,50);
       fill(0);
      text("Smartphone in der Tasche", radiobtn1X+50, radiobtn1Y+20);
      textSize(20);
      fill(0);
      text("Smartphone in der Hand", radiobtn1X+50, radiobtn2Y+20);
  }


  if (imageIsLoaded) {
    //Lädt die Karte, Kompassrose und Buttons
    image(hintergrundmenue, stepsX, stepsY, width*scale, height*scale);
    image(rose, 0, 0, 100, 100);
    
    //Buttons, die angezeigt werden, solange nicht "Ausblenden" angeklickt wird
    if (!Ausblenden) {
      image(btn1, btn1X, btn1Y, btn1Width, btn1Height);
      image(btn2, btn2X, btn1Y, btn1Width, btn1Height);
      image(btn3, btn3X, btn1Y, btn1Width, btn1Height);
      image(btnKaliFalse, btnKaliX, btn1Y, btn1Width, btn1Height);
      image(btnAufgabeStart, btnAufgabeStartX, btn1Y, btn1Width, btn1Height);
      image(button_hauptmenue, button_hauptmenueX, btn1Y, btn1Width, btn1Height);
      
      //Anzeigen des erklärenden Hinweises zur Kalibrierung des Smartphones
      if(!kali){
      image(kaliHin,width/2-400,height/2-300,800,600);
   }

    //Anzeigen der ersten Aufgabe, wenn "Aufgabe starten" geklickt
      if (AufgabeStarten==1) {
        image(Aufgabe, bildAufgabeX, bildAufgabeY, 150, 150);
      }
    //Anzeigen der zweiten Aufgabe
       if (AufgabeStarten==1 && task ==1) {
         Aufgabe=loadImage("pisa.PNG");
        image(Aufgabe, bildAufgabeX, bildAufgabeY, 150, 150);
      }
    //Anzeigen des Erfolgssmiley
       if (AufgabeStarten==1 && task ==2) {
         Aufgabe=loadImage("smile.png");
        image(Aufgabe, bildAufgabeX, bildAufgabeY, 150, 150);
      }
    }

    image(btnEinblenden, btnEinblendenX, btn1Y, btn1Width, btn1Height);

    stepper();
    checkPos();
    displayText();

    //Anzeige der Sensorendaten (für Testzwecke)
/*    text(
      "steps: " + nfp(steps, 1, 2) + "\n" +
      "velocity: " + nfp(velocity, 1, 2) + "\n" +
      "Accelerometer: " + 
      "y: " + nfp(accelerometerY, 1, 2) + "\n" +
      "Accelerometer: " + 
      "z: " + nfp(accelerometerZ, 1, 2) + "\n" +
      "Compass Direction: " +
      nfp(degree, 1, 2) + "°" + "\n" +
      "StepsX: " + nfp(stepsX, 1, 2) + "\n" +
      "steps: " + nfp(steps, 1, 2) + "\n" +
      "velocity: " + nfp(velocity, 1, 2) + "\n" +
      "StepsY: " + nfp(stepsY, 1, 2), 0, 0, width, height);
      */
  }
 
}

//Positionsabfrage für Aufgaben
void checkPos() {
  if (walking && stepsX <= taskPos[task][0] && stepsX > taskPos[task][1] 
    && stepsY <= taskPos[task][2] && stepsY > taskPos[task][3]) {
    OscMessage myMessage = new OscMessage("/nextTask");
    myMessage.add("sendingPosition");
    oscP5.send(myMessage, myRemoteLocation);
    this.task++;
  }
}

//Kalibrieren-Methode
void calibrate() {
  OscMessage myMessage = new OscMessage("/calibrate");
  myMessage.add("sendingPosition");
  oscP5.send(myMessage, myRemoteLocation);
}

void stepper() { 

  //Bogenmaß berechnen
  rad = 2*PI + direction;
  //Bogenmaß in Grad umrechnen
  degree = (360/(2*PI))*rad;

  //Begrenzung der Bewegung (nicht außerhalb der Karte) 
  if (stepsX>0) stepsX=0;
  if (stepsY>0) stepsY=0;
  if (stepsX< -width*(scale-1)) stepsX=-width*(scale-1);
  if (stepsY < -height*(scale-1)) stepsY=-height*(scale-1);

  //Bewegung in der Tasche
  if ((accelerometerY <= -11.81 || (accelerometerY >= -7.81 && accelerometerY <= 7.81) || 
    accelerometerY >= 11.81) && walking && radiobtn1) {
    stepsX = stepsX+(cos(rad)*velocity);
    stepsY = stepsY-(sin(rad)*velocity);
  }
 
  //Bewegung in der Hand
  if (accelerometerZ >= 11.81 || accelerometerZ <= 7.81 && walking &&
    radiobtn2){
      velocity = Math.abs((int) accelerometerZ);
       stepsX = stepsX+(cos(rad)*velocity);
       stepsY = stepsY-(sin(rad)*velocity);
       }
} 


void mousePressed() {
  //Button 1 wird gedrückt
  if (btn1Over) {
    hintergrundmenue=loadImage("europeMap.gif");
    imageIsLoaded = true;
      ersterTimer=millis()+3000;
  }
  
  //Button 2 wird gedrückt
  if (btn2Over) {
    hintergrundmenue=loadImage("worldMap.png");
    imageIsLoaded = true;
  }
  
  //Button 3 wird gedrückt
  if (btn3Over) {
    hintergrundmenue=loadImage("800px-BRD.png");
    imageIsLoaded = true;
  } 
  
  //Kalibrieren-Button wird gedrückt
  if (btnKaliOver) {
     if(!kali) {
       calibrate();
       btnKaliFalse=btnKaliTrue;
       kali=!kali;
       }
     else {
       btnKaliFalse=loadImage("btnKaliFalse.png");
       kali=false;
       }
  }
  
  //Ein-/Ausblenden-Button wird gedrückt
  if (btnEinblendenOver) {
    Ausblenden=!Ausblenden;
    if (Ausblenden) {
      btnEinblenden=loadImage("EinblendenBtn.png");
    } else btnEinblenden=loadImage("EinblendenBtn2.png");
  } 
  
  //Aufgabe Starten-Button wird gedrückt
  if (btnAufgabeStartOver) {
    AufgabeStarten=1;
  }
  
  //Radiobutton 1 wird gedrückt
  if (radiobtn1Over) {
    radiobtn1=true;
    radiobtn2=false;
    OscMessage myMessage = new OscMessage("/pocket");
    myMessage.add(radiobtn1);
    oscP5.send(myMessage, myRemoteLocation); 
  }
  
  //Radiobutton 2 wird gedrückt
  if (radiobtn2Over) {
    radiobtn2=true;
    radiobtn1=false;
    OscMessage myMessage = new OscMessage("/pocket");
    myMessage.add(radiobtn1);
    oscP5.send(myMessage, myRemoteLocation); 
  }
  
  //Hauptmenü-Button wird gedrückt
  if(btnHauptmenueOver){
    imageIsLoaded=false;
    hintergrundmenue=loadImage("Hintergrund_menue.png");
    walking=false;
    firstStart=true;
    Ausblenden=false;
    btnKaliFalse=loadImage("btnKaliFalse.png");
    kali=false;
  }


  /* send a message to client on mouse (touch) click */
  // OscMessage myMessage = new OscMessage("/test");
  //  myMessage.add(123);
  //  oscP5.send(myMessage, myRemoteLocation); 
  // println("standard sketch, sending to "+myRemoteLocation);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());

  /* listening to incoming sensor input */
  if (theOscMessage.checkAddrPattern("/accelerometer")==true) {
    accelerometerY = theOscMessage.get(0).floatValue();
    accelerometerZ = theOscMessage.get(1).floatValue();
    return;
  }
  
  if (theOscMessage.checkAddrPattern("/direction")==true) {
    direction = theOscMessage.get(0).floatValue();
    return;
  }
  if (theOscMessage.checkAddrPattern("/reset")==true) {
    this.stepsX = -3200; /*-(width*(scale/2));*/
    this.stepsY = -1600; /*-(height*(scale/2));*/
    this.task = 0;
    return;
  }
  if (theOscMessage.checkAddrPattern("/walk")==true) {
    this.walking = !this.walking;
    return;
  }
}
//Button1 Kontrolle
void update (int x, int y) {
  if (overBtn1(btn1X, btn1Y, btn1Width, btn1Height)) {
    btn1Over = true;
  } else {
    btn1Over = false;
  }
  //Button2 Kontrolle
  if (overBtn1(btn2X, btn1Y, btn1Width, btn1Height)) {
    btn2Over = true;
  } else {
    btn2Over = false;
  }
  //Button3 Kontrolle
  if (overBtn1(btn3X, btn1Y, btn1Width, btn1Height)) {
    btn3Over = true;
  } else {
    btn3Over = false;
  }
  /*
   if ( overBtn1(btnStartX, btn1Y, btn1Width+70, btn1Height+100)) {
   btnStartOver = true;
   } else {
   btnStartOver = false;
   }*/

  if (overBtn1(btnKaliX, btn1Y, btn1Width, btn1Height)) {
    btnKaliOver = true;
  } else {
    btnKaliOver = false;
  }
  if (overBtn1(btnEinblendenX, btn1Y, btn1Width, btn1Height)) {
    btnEinblendenOver = true;
  } else {
    btnEinblendenOver  = false;
  }
  if (overBtn1(btnAufgabeStartX, btn1Y, btn1Width, btn1Height)) {
    btnAufgabeStartOver=true;
  } else {
    btnAufgabeStartOver  = false;
  }
  if(overBtn1(button_hauptmenueX, btn1Y, btn1Width, btn1Height)) {
    btnHauptmenueOver=true;
  } else{
    btnHauptmenueOver=false;
  }
  
  if (overBtn1(radiobtn1X, radiobtn1Y, 50, 50)) {
    radiobtn1Over=true;
  } else {
    radiobtn1Over  = false;
  }
  
  if (overBtn1(radiobtn1X, radiobtn2Y, 50, 50)) {
    radiobtn2Over=true;
  } else {
    radiobtn2Over  = false;
  }
}
//Funktion zur Prüfung, ob Zeiger auf Button war
boolean overBtn1(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
// Anzeige der Himmelsrichtungen
void displayText() {
  /* textSize(40);
  fill(10);
  textAlign(CENTER, height1/10);
  text("Norden", displayWidth/2, 0);
  fill(0, 102, 153, 51);
  textAlign(CENTER, BOTTOM);
  text("Süden", displayWidth/2, displayHeight-50);
  fill(0, 102, 153, 51);
  textAlign(LEFT);
  text("Westen", 10, displayHeight/2);
  fill(0, 102, 153, 51);
  textAlign(RIGHT);
  text("Osten", displayWidth, displayHeight/2);
  textAlign(CENTER); */
}