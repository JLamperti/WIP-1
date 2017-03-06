    /* osc send-recieve,processing sketch */
    
    import oscP5.*;
    import netP5.*;
      
    OscP5 oscP5;
    NetAddress myRemoteLocation;
    float   accelerometerZ,
            direction,
            rad,
            degree,
            stepsX = 0, 
            stepsY = 0;
    int     distVert,
            distDiag,
            scale = 6;
    PImage  img;
    
    void setup() {
      accelerometerZ = 9;
      size(displayWidth, displayHeight, P3D);
      frameRate(60);
      textAlign(LEFT, TOP);
      textSize(18);
      fill(50);
      img=loadImage("europeMap.gif");
      
      /* start oscP5, listening for incoming messages on port 12000 */
      oscP5 = new OscP5(this,12000);
      
      /* send to phone address, not needed yet */
      myRemoteLocation = new NetAddress("127.0.0.1",12001); 
    }

    void draw() {
      stepper(); 
      background(78, 93, 75);
    
      /*map position on screen*/
      image(img, stepsX, stepsY, width*scale, height*scale);
      
      /*displays sensor data on screen*/
      text("Accelerometer: " + 
            "z: " + nfp(accelerometerZ, 1, 2) + "\n" +
            "Compass Direction: " +
            nfp(degree, 1, 2) + "°" + "\n" +
            "StepsX: " + nfp(stepsX, 1, 2) + "\n" +
            "StepsY: " + nfp(stepsY, 1, 2), 0, 0, width, height);       
    }
    
    /************************************************
    *   /TODO:                                      *
    *  here is the function to manipulate the map   *
    *                                               *
    ************************************************/
    
    void stepper(){ 
      
      /* radiant (Bogenmass) calculation */
      rad = 2*PI + direction;
      /*translate radiant to degree */
      degree = (360/(2*PI))*rad;
      
      distVert = 10;
      distDiag = 10;
    
    if ((accelerometerZ >= 11.81 || accelerometerZ <= 7.81) && (degree >= 337.7 || degree <22.5)){
       stepsY = stepsY+distVert;
       }
       else if ((accelerometerZ >= 11.81 || accelerometerZ <= 7.81) && (degree >= 22.5 && degree <67.5)){
       stepsX = stepsX + distDiag;
       stepsY = stepsY + distDiag;
       }
       else if ((accelerometerZ >= 11.81 || accelerometerZ <= 7.81) && (degree >= 67.5 && degree <112.5)){
       stepsX = stepsX + distVert;
       }
       else if ((accelerometerZ >= 11.81 || accelerometerZ <= 7.81) && (degree >= 112.5 && degree <157.5)){
       stepsX = stepsX + distDiag;
       stepsY = stepsY - distDiag;
       }
       else if ((accelerometerZ >= 11.81 || accelerometerZ <= 7.81) && (degree >= 157.5 && degree <205.5)){
       stepsY = stepsY - distVert;
       }
       else if ((accelerometerZ >= 11.81 || accelerometerZ <= 7.81) && (degree >= 205.5 && degree <247.5)){
       stepsX = stepsX - distDiag;
       stepsY = stepsY - distDiag;
       }
       else if ((accelerometerZ >= 11.81 || accelerometerZ <= 7.81) && (degree >= 247.5 && degree <292.5)){
       stepsX = stepsX - distVert;
       }
       else if ((accelerometerZ >= 11.81 || accelerometerZ <= 7.81) && (degree >= 292.5 && degree <337.5)){
       stepsX = stepsX - distDiag;
       stepsY = stepsY + distDiag;
       }
       if(stepsX>0) stepsX=0;
        if(stepsY>0) stepsY=0;
        if(stepsX< -width*(scale-1)) stepsX=-width*(scale-1);
        if(stepsY < -height*(scale-1)) stepsY=-height*(scale-1);
      /* if accelerometer detects a step, calculate new x- and y-position for the map */
      /*
     if (accelerometerZ >= 11.81 || accelerometerZ <= 7.81){
       stepsX = stepsX+(cos(degree)*5);
       stepsY = stepsY+(sin(degree)*5);
       }
       else {
       }     */
    }         
   
    void mousePressed() {
      /* send a message to client on mouse (touch) click */
      OscMessage myMessage = new OscMessage("/test");
      myMessage.add(123);
      oscP5.send(myMessage, myRemoteLocation); 
      println("standard sketch, sending to "+myRemoteLocation);
    }

    /* incoming osc message are forwarded to the oscEvent method. */
    void oscEvent(OscMessage theOscMessage) {
      /* print the address pattern and the typetag of the received OscMessage */
      print("### received an osc message.");
      print(" addrpattern: "+theOscMessage.addrPattern());
      println(" typetag: "+theOscMessage.typetag());
      
      /* listening to incoming sensor input */
      if (theOscMessage.checkAddrPattern("/accelerometerZ")==true) {
        accelerometerZ = theOscMessage.get(0).floatValue();
        return;
      }
      if (theOscMessage.checkAddrPattern("/direction")==true) {
        direction = theOscMessage.get(0).floatValue();
        return; 
      }
      if (theOscMessage.checkAddrPattern("/reset")==true) {
        this.stepsX = -3200; /*-(width*(scale/2));*/
        this.stepsY = -1600; /*-(height*(scale/2));*/
        return;
      }
    }