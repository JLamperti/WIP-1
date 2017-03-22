//Die Android App, welche die Bewegungen und die Ausrichtung des Nutzers misst und an den Server weitergibt
  
import oscP5.*;
import netP5.*;
import ketai.sensors.*;
import ketai.ui.*;
  
//Initialisieren der OSCP5 Library
OscP5 oscP5;

//Setzen der IP-Adresse des PCs
NetAddress myRemoteLocation;
String remoteIP = "192.168.2.103";

//Initialisierung der Smartphone Sensoren und der Vibrationsfunktion
KetaiSensor sensor;
CompassManager compass;
<<<<<<< HEAD
=======
KetaiVibrate vibe;
String remoteIP = "192.168.2.103";
>>>>>>> 5212cef32988e09ec9dc9adf8131c64d7924b04f
PVector accelerometer;
KetaiVibrate vibe;

//Counter für die aktuelle Aufgabe
int task = 0;

//Ausrichtung des Nutzers, Offset für das Kalibrieren (einnorden)
float direction;
float directionOffset = 0;

//Beschleunigungssensoren für alle Achsen
float accelerometerX, accelerometerY, accelerometerZ;

//calibrated gibt an ob die App kalibriert wurde und anfangen soll, Daten zu senden, 
//started gibt an, ob sie läuft oder gestoppt wurde
boolean calibrated = false;
boolean started = false;

// wird bei reset einmal auf true gesetzt
boolean reset = false;

//Array mit den Bildern der Aufgaben
PImage[] img = new PImage[3];


//initialisieren der App
void setup() {
  size(displayWidth, displayHeight, P3D);
  textAlign(TOP, LEFT);
  textSize(36);
  
  /* abhören von Port 12001 */
  oscP5 = new OscP5(this,12001);
  /* An den Server senden*/
  myRemoteLocation = new NetAddress(remoteIP,12000);
  
  //initialisieren der Sensoren
  sensor = new KetaiSensor(this);
  sensor.start();    
  sensor.list();
  accelerometer = new PVector();
  compass = new CompassManager(this);
  
  //Laden der Aufgabenbilder
  img[0] = loadImage("brandenburg.PNG");
  img[1] = loadImage("pisa.PNG");
  img[2] = loadImage("smile.png");
  
  //initialisiern der Vibrationsfunktion
  vibe = new KetaiVibrate(this);
}


//Anzeigen der Ansicht
void draw() {

  //Weißer Hintergrund
  background(0, 0, 0);
  fill(0, 0, 0);
  
  //Buttons und Texte anzeigen
  drawButtons();
  drawText();
  
  //Aufgabenbild anzeigen
  image(img[task],displayWidth/2-img[task].width/2,displayHeight/2-img[task].height/2);
            
  //Sensordaten senden
  sendAcc();
  sendDir();
  
  //Kompassnadel zeichnen
  fill(255,0,0);
  translate(width/2, height-height/8);
  scale(2);
  rotate(direction);
  beginShape();
  vertex(0, -50);
  vertex(-20, 60);
  vertex(0, 50);
  vertex(20, 60);
  endShape(CLOSE);
}


//abfragen der Nutzerinteraktion
void mousePressed() {
  //obere Bildschirmhälfte: Start/Stop Funktion
  if(mouseY < height/2){
    //Nachdem kalibriert wurde, kann gestoppt bzw. gestartet werden
    if(calibrated){
      this.started= !this.started;
      startStopWalking();
    }
  }
  //untere Bildschirmhälfte: Reset Funktion
  else{
    resetPosition();
    this.reset = true;
  }
}

 
//Erkennen von eingehenden Nachrichten vom Server
    void oscEvent(OscMessage theOscMessage) { 
      
      //Aktuelle Aufgabe wurde erfüllt: Vibrieren und starte nächste Aufgabe
      if (theOscMessage.checkAddrPattern("/nextTask")==true) {
        this.task++;
        vibe.vibrate(1000);
      }
      
      //App wurde kalibriert
      if (theOscMessage.checkAddrPattern("/calibrate")==true) {
        calibrate();
      }
    }


/*Funktion zum Kalibrieren (einnorden): Da der Norden der Karte nicht immer mit dem realen Norden bereinstimmt,
muss die App vor benutzung zunächst kalibriert werden. Dazu muss sich der Nutzer auf der Karte nach Norden ausrichten.
Nun wird zur aktuellen Ausrichtung des Nutzers ein sogenanntes Offset hinzugerechnet,
sodass für die App nun scheint, als wäre der Nutzer auch real nach Norden ausgerichtet. */
void calibrate(){
  /*der reale Norden liegt bei dem Bogenmaß-Wert Pi/2. Daher wird die Startausrichtung des Nutzers auf 2Pi gesetzt, 
  sodass es für die App scheint, als sei seine aktuelle Ausrichtung nach Norden gerichtet*/
  this.directionOffset = direction + PI/2;
  
  //nach dem ersten kalibrieren beginnt die App, Daten zu senden
  if(!calibrated){
    this.started= !this.started;
  }
  this.calibrated = true;
  //teilt dem Server mit, dass nun die Karte bewegt werden soll
  startStopWalking();
}

//Berechnung der aktuellen Ausrichtung unter Berücksichtigung des Offsets
void directionEvent(float newDirection) {
  direction = newDirection - directionOffset;
}

//Auslesen der Werte der Beschleunigungssensoren
void onAccelerometerEvent(float x, float y, float z) {
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}

//benachrichtigt den Server, wenn ein Schritt erkannt wird
void sendAcc(){
  if(this.started){
    OscMessage myMessage = new OscMessage("/accelerometerY");
    myMessage.add(accelerometerY);
    oscP5.send(myMessage, myRemoteLocation); 
    println("android acc, sending to "+myRemoteLocation);
  } 
 }
 
 //teilt dem Server die Ausrichtung des Nutzers mit
 void sendDir(){
   if(this.started){
  OscMessage myMessage = new OscMessage("/direction");
  myMessage.add(direction);
  oscP5.send(myMessage, myRemoteLocation); 
  println("android compass, sending to "+myRemoteLocation);
 }
 }
 
 //teilt dem Server mit, dass der Nutzer seine Position zurücksetzen möchte
 void resetPosition(){
   //hierbei wird auch wieder bei der ersten Aufgabe angefangen
   this.task = 0;
   OscMessage myMessage = new OscMessage("/reset");
   oscP5.send(myMessage, myRemoteLocation); 
   println("android reset, sending to "+myRemoteLocation);
 }
 
 
 //teilt dem Server mit, dass die Karte nicht weiter bewegt werden soll
 void startStopWalking(){
 OscMessage myMessage = new OscMessage("/walk");
  oscP5.send(myMessage, myRemoteLocation); 
  println("android reset, sending to "+myRemoteLocation);
 }
 
 
 //darstellen der Texte
 void drawText(){
  pushStyle();
  textAlign(CENTER);
  
  /*Der obere Text zeigt START oder STOP an, je nachdem ob die APP gestartet wurde. Wurde die APP noch nicht kalibriert, 
  wird dem Nutzer mitgeteilt, dass dies erst geschehen muss */
  if(started){
    fill(255,0,0);
    textSize(100);
    text("STOP", width/2, height/4);
  }
  else if(calibrated){
    fill(0,255,0);
    textSize(100);
     text("START", width/2, height/4  );
  }
  else{
    fill(0,255,0);
    textSize(75);
     text("CALIBRATE TO START", width/2, height/4  );
  }
  
  //Der untere text lautet immer RESET
    fill(255);
    textSize(100);
    text("RESET", width/2, (height - height/4)  );
    this.reset = false;
  
  popStyle();
  
 
  //Anzeigen der aktuellen Sensorwerte
  noStroke();
  text("Accelerometer: \n" + 
        "x: " + nfp(accelerometerX, 1, 2) + "\n" +
        "y: " + nfp(accelerometerY, 1, 2) + "\n" +
        "z: " + nfp(accelerometerZ, 1, 2) + "\n" +
        "Compass Direction: \n" +
        nfp(direction, 1, 2), 0, 0, width, height);
 }
 
 
 //anzeigen der Buttons
 void drawButtons(){
  pushStyle();
  //den oberen teil der App füllt der START/STOP Button aus. Dieser ändert ja nach Zustand seine Farbe
  if(started){
    fill(70);
    rect(0, 0, 10000, 20000);
  }
  else{
    fill(0);
    rect(0, 0, 10000, 20000);
  }
  
  //im unteren Teil befindet sich der RESET Button. Dieser blinkt bei Reset kurz auf.
  if(reset){
    fill(70);
    rect(0, (height/2), 20000, 50000);
  }
  else{
    fill(0);
    rect(0, (height/2), 20000, 50000);
  }
  popStyle();
 }