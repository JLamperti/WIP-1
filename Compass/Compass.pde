  import oscP5.*;
  import netP5.*;
  import ketai.sensors.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
KetaiSensor sensor;
CompassManager compass;
String remoteIP = "141.83.181.102";
PVector accelerometer;
int task = 0;
float direction;
float directionOffset = 0;
float accelerometerX, accelerometerY, accelerometerZ;
boolean started = false;
boolean reset = false;
boolean calibrated = false;
PImage[] img = new PImage[3];

void setup() {
  size(displayWidth, displayHeight, P3D);
  textAlign(TOP, LEFT);
  textSize(36);
  
  /* start listening on port 12001, incoming messages must be sent to port 12001 */
  oscP5 = new OscP5(this,12001);
  /* send to computer address*/
  myRemoteLocation = new NetAddress(remoteIP,12000);
  
  sensor = new KetaiSensor(this);
  sensor.start();    
  sensor.list();
  accelerometer = new PVector();
  compass = new CompassManager(this);
  
  img[0] = loadImage("brandenburg.PNG");
  img[1] = loadImage("pisa.PNG");
  img[2] = loadImage("smile.png");
}

void pause() {
  if (compass != null) compass.pause();
}

void resume() {
  if (compass != null) compass.resume();
}

void draw() {
 
  /*show sensor datas and compass*/
  background(0, 0, 0);
  fill(0, 0, 0);
  
  drawButtons();
  drawText();
  image(img[task],displayWidth/2-img[task].width/2,displayHeight/2-img[task].height/2);
            
  /* sending the sensor datas */
  sendAcc();
  sendDir();
  checkPos();
  
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

void mousePressed() {
  /* send a message to server on mouse (touch) click to test messaging*/
  OscMessage myMessage = new OscMessage("/test");
  myMessage.add(123);
  oscP5.send(myMessage, myRemoteLocation); 
  println("android sketch, sending to "+myRemoteLocation);
  if(mouseY < height/2){
    if(!calibrated){
      this.calibrated = true;
      this.directionOffset = direction - PI/2;
    }
    this.started= !this.started;
    startStopWalking();
  }
  else{
    resetPosition();
    this.reset = true;
  }
}

 
/* incoming osc message are forwarded to the oscEvent method. */
    void oscEvent(OscMessage theOscMessage) {
      /* print the address pattern and the typetag of the received OscMessage */
      print("### received an osc message.");
      print(" addrpattern: "+theOscMessage.addrPattern());
      println(" typetag: "+theOscMessage.typetag());  
      
      if (theOscMessage.checkAddrPattern("/nextTask")==true) {
        this.task++;
      }
    }

void directionEvent(float newDirection) {
  direction = newDirection - directionOffset;
  if(direction < 0){
     direction = direction; 
  }
}

void onAccelerometerEvent(float x, float y, float z) {
  /* reading out the accelorometer sensors */
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}

void sendAcc(){
  if(this.started){
    OscMessage myMessage = new OscMessage("/accelerometerY");
    myMessage.add(accelerometerY);
    oscP5.send(myMessage, myRemoteLocation); 
    println("android acc, sending to "+myRemoteLocation);
  } 
 }
 
 void sendDir(){
   if(this.started){
  OscMessage myMessage = new OscMessage("/direction");
  myMessage.add(direction);
  oscP5.send(myMessage, myRemoteLocation); 
  println("android compass, sending to "+myRemoteLocation);
 }
 }
 
 void resetPosition(){
   this.task = 0;
 OscMessage myMessage = new OscMessage("/reset");
  oscP5.send(myMessage, myRemoteLocation); 
  println("android reset, sending to "+myRemoteLocation);
 }
 
 void startStopWalking(){
 OscMessage myMessage = new OscMessage("/walk");
  oscP5.send(myMessage, myRemoteLocation); 
  println("android reset, sending to "+myRemoteLocation);
 }
 
 void checkPos(){
  //TODO: listen to Server 
 }
 
 void drawText(){
   pushStyle();
     textAlign(CENTER);
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
    textSize(100);
     text("START AND CALIBRATE", width/2, height/4  );
  }
    fill(255);
    textSize(100);
    text("RESET", width/2, (height - height/4)  );
    this.reset = false;
  
  popStyle();
  
 

  noStroke();
  text("Accelerometer: \n" + 
        "x: " + nfp(accelerometerX, 1, 2) + "\n" +
        "y: " + nfp(accelerometerY, 1, 2) + "\n" +
        "z: " + nfp(accelerometerZ, 1, 2) + "\n" +
        "Compass Direction: \n" +
        nfp(direction, 1, 2), 0, 0, width, height);
 }
 
 void drawButtons(){
  pushStyle();
  if(started){
    fill(70);
    rect(0, 0, 10000, 20000);
  }
  else{
    fill(0);
    rect(0, 0, 10000, 20000);
  }
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