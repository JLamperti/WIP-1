    /* osc send-recieve,processing sketch */
    
    import oscP5.*;
    import netP5.*;
      
    OscP5 oscP5;
    NetAddress myRemoteLocation;
    float zA,zR;
    
    void setup() {
      size(640,360);
      frameRate(25);
      textAlign(CENTER, CENTER);
      textSize(36);
      
      /* start oscP5, listening for incoming messages on port 12000 */
      oscP5 = new OscP5(this,12000);
      
      /* send to phone address */
      myRemoteLocation = new NetAddress("127.0.0.1",12001); 
    }

    void draw() {
      background(78, 93, 75);
      fill(255);
      zR = map(zR,-10,10,0,TWO_PI);
      translate(width/2,height/2);
      rotate(zR);     
      
      rect(20,20,20,20);
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
      if (theOscMessage.checkAddrPattern("/zA")==true) {
        zA = theOscMessage.get(0).floatValue();
        //println(" med : "+ med);
        return;
      }
      if (theOscMessage.checkAddrPattern("/zR")==true) {
        zR = theOscMessage.get(0).floatValue();
        //println(" med : "+ med);
        return;
      }
    }