import controlP5.*;
ControlP5 cp5;
Range range;

PImage baseImg;
PVector o; //origin point, center of the screen

PGraphics finalRender;



ArrayList<Ring> rings = new ArrayList<Ring>();
float radDivSz;

String imagePath = "assets/image2.jpg";
float maxRot = QUARTER_PI;
int nbRings = 6;
int radDivs = 14;
float filterFactor;
boolean altFilterDirection;


boolean autorender;



void setup() {

  fullScreen(P2D);
  imageMode(CENTER);
  o = new PVector(width/2, height/2); // calculate origin point

  cp5 = new ControlP5(this);

  Group g = cp5.addGroup("Controls")
    .setPosition(20, 20)
    .setWidth(300)
    .setBackgroundColor(color(0, 64))
    .setBackgroundHeight(220)
    ;

  cp5.addTextfield("imagePath")
    .setPosition(10, 10)
    .setAutoClear(false)
    .moveTo(g)
    .setValue(imagePath)
    ;
  cp5.addSlider("maxRot")
    .setPosition(10, 60)
    .setRange(-PI, PI)
    .setWidth(200)
    .moveTo(g)
    ;
  range = cp5.addRange("rings/Divisions")
    .setBroadcast(false) 
    .setPosition(10, 80)
    .setRange(0, 50)
    .setWidth(200)
    .setRangeValues(6, 14)
    .setBroadcast(true)
    .moveTo(g)
    ;
    
  cp5.addSlider("filterFactor")
    .setPosition(10, 100)
    .setRange(-30, 30)
    .setWidth(200)
    .moveTo(g)
    ;
    
    cp5.addToggle("altFilterDirection")
     .setPosition(10, 120)
     .moveTo(g)
     ;
     cp5.addToggle("autorender")
     .setPosition(220, 180)
     .moveTo(g)
     ;
  cp5.addButton("renderAll")
    .setPosition(10, 180)
    .setSize(200, 19)
    .moveTo(g)
    ;


  renderAll();
}

void draw() {
  image(finalRender, o.x, o.y);
  imagePath = cp5.get(Textfield.class, "imagePath").getText();
}

public void renderAll() {
  rings.clear();
  finalRender = createGraphics(width, height);

  baseImg = loadImage(imagePath);

  float rot = maxRot;
  for (int i=0; i<nbRings; i++) {
    rings.add(new Ring(i, i+1, rot));
    rot -= maxRot/nbRings;
  }

  radDivSz = (min(baseImg.width, baseImg.height)/2)/radDivs;

  finalRender.beginDraw();
  finalRender.imageMode(CENTER);
  finalRender.background(255);   
  finalRender.image(baseImg, o.x, o.y);

  for (int i=rings.size()-1; i>=0; i--) {
    Ring ring = rings.get(i);
    ring.create();
    ring.render(finalRender);
  }
  finalRender.endDraw();
}

public void bang() {
  renderAll();
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("rings/Divisions")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue().
    // min is at index 0, max is at index 1.
    nbRings = int(theControlEvent.getController().getArrayValue(0));
    radDivs = int(theControlEvent.getController().getArrayValue(1));
  }
  if(autorender && !theControlEvent.isFrom("imagePath"))renderAll();
}