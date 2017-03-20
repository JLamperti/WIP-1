/* Server für Kartendarstellung und Kommunikation mit Smartphone */

import oscP5.*;
import netP5.*;

//Initialisieren der OSCP5 Library
OscP5 oscP5;
//Setzen der IP-Adresse des Smartphones
NetAddress myRemoteLocation;
String remoteIP = "141.83.181.62";

//Walking = Bewegung vorerst gestoppt
boolean walking = false;
//        dir = false;    zur Vermeidung von "Sliding in Place"

/*Y-Achse des Beschleunigungssensor, Ausrichtung des Handys, 
Ausrichtung in Bogenmaß, Ausrichtung in Grad, X- und Y-Position der Karte */
float   accelerometerY, 
  direction, 
  rad, 
  degree, 
  stepsX = 0, 
  stepsY = 0;

/* Gehgeschwindigkeit, Schrittzähler, Skalierung der Karte, Breite der Anzeige, Höhe der Anzeige,
aktuelle Aufgabe */
int  velocity = 10,
  steps = 0,
  scale = 6, 
  width1=600, 
  height1=800, 
  task = 0;

//Zielkoordinaten der Aufgaben
int[][] taskPos = {{-3250, -4000, -1200, -1800}, 
  {-2900, -3600, -2500, -3000}, 
  //nicht erreichbare Koordinaten, wenn Aufgaben beendet sind
  {100, 100, 100, 100}};

PImage  img, title, rose, btn1, btn2, btn3,start,btnKaliTrue,btnKaliFalse,btnEinblenden;

int      btnKaliX=200,
  btn1X = 360, 
  btn1Y = 0, 
  btn2X =520, 
  btn3X = 680,
  //btnStartX = 640,
 
  btnEinblendenX=70;
int     btn1Width = 150, 
  btn1Height = 30;
color   btn1Color = color (255), 
  btn1Highlight = color (200), 
  bckColor = color(0);
boolean btn1Over = false, 
  btn2Over = false, 
  btn3Over = false, 
  btnStartOver=false,
  btnKaliOver=false,
  imageIsLoaded = false,
  btnEinblendenOver=false,
  Ausblenden=false;

void setup() {
  accelerometerY = 9.81;
  background(bckColor);
  title = loadImage("title.png");
  rose =loadImage("Kompassrose-no.png");
  btn1 = loadImage("btn1.png");
  btn2 = loadImage("btn2.png");
  btn3= loadImage("btn4.png");
  btnKaliTrue=loadImage("btnKaliTrue.png");
  btnKaliFalse=loadImage("btnKaliFalse.png");
 //start = loadImage("startBtn.png");
  btnEinblenden=loadImage("EinblendenBtn2.png");
  //Legt Größe fest
  size(displayWidth, displayHeight, P3D);
  frameRate(60);
  textAlign(LEFT, TOP);
  textSize(18);
  fill(50);

  /* start oscP5, listening for incoming messages on port 12000 */
  oscP5 = new OscP5(this, 12000);

  /* send to phone address, not needed yet */
  myRemoteLocation = new NetAddress(remoteIP, 12001);
}

void draw() {

  update (mouseX, mouseY);
  fill(255);
  //Lädt Buttons
  image(btn1, btn1X, btn1Y, btn1Width, btn1Height);
  image(btn2, btn2X, btn1Y, btn1Width, btn1Height);
  image(btn3, btn3X, btn1Y, btn1Width, btn1Height);
 // image(btnEinblenden, btnEinblendenX, btn1Y, btn1Width, btn1Height);
  image(title, 0, -180, width, height);



  if (imageIsLoaded) {
    /*map position on screen*/
    //Lädt die Karte, Kompassrose und Buttons
   
    image(img, stepsX, stepsY, width*scale, height*scale);
    image(rose, 0, 0, 100, 100);
    if(!Ausblenden){
    image(btn1, btn1X, btn1Y, btn1Width, btn1Height);
    image(btn2, btn2X, btn1Y, btn1Width, btn1Height);
    image(btn3, btn3X, btn1Y, btn1Width, btn1Height);
    image(btnKaliFalse,btnKaliX,btn1Y, btn1Width, btn1Height);
    }

    image(btnEinblenden, btnEinblendenX, btn1Y, btn1Width, btn1Height);
   //  image(start,btnStartX, btn1Y, btn1Width, btn1Height); //Btn Start
  
    stepper();
    checkPos();
    displayText();

    /*displays sensor data on screen*/
    text(
      "steps: " + nfp(steps, 1, 2) + "\n" +
      "velocity: " + nfp(velocity, 1, 2) + "\n" +
      "Accelerometer: " + 
      "y: " + nfp(accelerometerY, 1, 2) + "\n" +
      "Compass Direction: " +
      nfp(degree, 1, 2) + "°" + "\n" +
      "StepsX: " + nfp(stepsX, 1, 2) + "\n" +
      "steps: " + nfp(steps, 1, 2) + "\n" +
      "velocity: " + nfp(velocity, 1, 2) + "\n" +
      "StepsY: " + nfp(stepsY, 1, 2), 0, 0, width, height);
  }
}

void checkPos() {
  if (walking && stepsX <= taskPos[task][0] && stepsX > taskPos[task][1] 
    && stepsY <= taskPos[task][2] && stepsY > taskPos[task][3]) {
    OscMessage myMessage = new OscMessage("/nextTask");
    myMessage.add("sendingPosition");
    oscP5.send(myMessage, myRemoteLocation);
    this.task++;
  }
}

void calibrate() {
  OscMessage myMessage = new OscMessage("/calibrate");
    myMessage.add("sendingPosition");
    oscP5.send(myMessage, myRemoteLocation);
}

void stepper() { 

  /* radiant (Bogenmass) calculation */
  rad = 2*PI + direction;
  /*translate radiant to degree */
  degree = (360/(2*PI))*rad;

  distVert = 10;
  distDiag = 10;

  //Boundaries
  if (stepsX>0) stepsX=0;
  if (stepsY>0) stepsY=0;
  if (stepsX< -width*(scale-1)) stepsX=-width*(scale-1);
  if (stepsY < -height*(scale-1)) stepsY=-height*(scale-1);


/* beschleunigung x achse
  if (accelerometerZ >= -0.5 && steps < 15 && steps >= -15 && walking) {
    steps++;
    if(dir){
     steps = 0;
     dir = false;
    } 
    //velocity = 10*Math.abs((int) (accelerometerZ + 1.25));
    velocity = 10;
    stepsX = stepsX+(cos(rad)*velocity);
    stepsY = stepsY-(sin(rad)*velocity);
  }
  
  if (accelerometerZ <= -2.5 && steps <= 15 && steps > -15 && walking) {
    steps = steps - 1;
    if(!dir){
     steps = 0;
     dir = true;
    } 
    //velocity = 10*Math.abs((int) (accelerometerZ + 1.25));
    velocity = 10;
    stepsX = stepsX+(cos(rad)*velocity);
    stepsY = stepsY-(sin(rad)*velocity);
  }
*/
  
  if ((accelerometerY <= -11.81 || (accelerometerY >= -7.81 && accelerometerY <= 7.81) || 
        accelerometerY >= 11.81) && walking){
       stepsX = stepsX+(cos(rad)*velocity);
       stepsY = stepsY-(sin(rad)*velocity);
       }

} 


void mousePressed() {
  //Button 1 wird gedrückt
  if (btn1Over) {
    img=loadImage("europeMap.gif");
    imageIsLoaded = true;
  }
  //Button 2 wird gedrückt
  if (btn2Over) {
    img=loadImage("worldMap.png");
    imageIsLoaded = true;
  }
  //Button 3 wird gedrückt
  if (btn3Over) {
    img=loadImage("800px-BRD.png");
    imageIsLoaded = true;
  } 
    if (btnKaliOver) {
   calibrate();
      btnKaliFalse=btnKaliTrue;
  }
    if (btnEinblendenOver) {
   Ausblenden=!Ausblenden;
if(Ausblenden){
  btnEinblenden=loadImage("EinblendenBtn.png");
}else btnEinblenden=loadImage("EinblendenBtn2.png");
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
  if (theOscMessage.checkAddrPattern("/accelerometerY")==true) {
    accelerometerY = theOscMessage.get(0).floatValue();
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
}
//Funktion zur Prüfung ob Zeiger auf Button war
boolean overBtn1(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
// Sensordaten Anzeige 
void displayText() {
  textSize(40);
  fill(0, 102, 153, 51);
  textAlign(CENTER, TOP);
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
}