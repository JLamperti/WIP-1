    /* osc send-receive, android sketch */

    import oscP5.*;
    import netP5.*;
    import ketai.sensors.*;
      
    OscP5 oscP5;
    NetAddress myRemoteLocation;
    KetaiSensor sensor;
    PVector accelerometer, orientation;
    float accelerometerX, accelerometerY, accelerometerZ;
    float orientationX, orientationY, orientationZ;

    void setup() {
      size(640, 360);
      textAlign(CENTER, CENTER);
      textSize(36);
      
      /* start listening on port 12001, incoming messages must be sent to port 12001 */
      oscP5 = new OscP5(this,12001);

      /* send to computer address*/
      myRemoteLocation = new NetAddress("192.168.2.103",12000);
      
      sensor = new KetaiSensor(this);
      sensor.start();    
      sensor.list();
      accelerometer = new PVector();
      orientation = new PVector();
      
    }

    void draw() {
        background(78, 93, 75);
        text("Accelerometer: \n" + 
            "x: " + nfp(accelerometerX, 1, 2) + "\n" +
            "y: " + nfp(accelerometerY, 1, 2) + "\n" +
            "z: " + nfp(accelerometerZ, 1, 2) + "\n" +
            "Orientation: \n" +
            "x: " + nfp(orientationX, 1, 2) + "\n" +
            "y: " + nfp(orientationY, 1, 2) + "\n" +
            "z: " + nfp(orientationZ, 1, 2), 0, 0, width, height); 
    }

    void mousePressed() {
      /* send a message to server on mouse (touch) click */
      OscMessage myMessage = new OscMessage("/test");
      myMessage.add(123);
      oscP5.send(myMessage, myRemoteLocation); 
      println("android sketch, sending to "+myRemoteLocation);
    }

    /* incoming osc message are forwarded to the oscEvent method. */
    void oscEvent(OscMessage theOscMessage) {
      /* print the address pattern and the typetag of the received OscMessage */
      print("### received an osc message.");
      print(" addrpattern: "+theOscMessage.addrPattern());
      println(" typetag: "+theOscMessage.typetag());       
    }
    
    void onAccelerometerEvent(float x, float y, float z) {
      /* reading out the accelorometer sensors */
      accelerometerX = x;
      accelerometerY = y;
      accelerometerZ = z;
    }
    
    void onOrientaionEvent(float x, float y, float z) {
      /* reading out the orientation sensors */
      orientationX = x;
      orientationY = y;
      orientationZ = z;
    }