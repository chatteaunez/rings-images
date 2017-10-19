class Ring {
  int innerRad;
  int outerRad;
  float r = 0;
  float s;

  PGraphics mask;
  PGraphics img;

  Ring(int i, int o, float _r) {
    innerRad = i;
    outerRad = o;
    r =  _r;
  }

  void create() {
    int sz = int(outerRad*radDivSz)*2;
    float thickness = radDivSz+1;
    float filter = (nbRings - innerRad) * filterFactor;
    if(altFilterDirection)filter = innerRad * filterFactor;

    img = createGraphics(sz, sz);
    img.beginDraw();
    img.imageMode(CENTER);
    img.image(baseImg, sz/2, sz/2);
    img.endDraw();

    mask = createGraphics(sz, sz);
    mask.beginDraw();
    if (innerRad==0) {
      mask.noStroke();
      mask.fill(0);
      mask.ellipse(sz/2, sz/2, sz, sz);
    } else {
      mask.stroke(0);
      mask.strokeWeight(thickness);
      mask.noFill();
      mask.ellipse(sz/2, sz/2, sz-thickness, sz-thickness);
    }

    mask.endDraw();

    mask.loadPixels();
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      color c = img.pixels[i];
      color m = mask.pixels[i];
      img.pixels[i] = color(
        constrain(red(c)+filter, 0, 255), 
        constrain(green(c)+filter, 0, 255), 
        constrain(blue(c)+filter, 0, 255), 
        alpha(m)
        );
    }
    img.updatePixels();
  }

  void update() {
    r+=s;
  }

  void render(PGraphics a) {
    a.pushMatrix();
    a.translate(o.x, o.y);
    a.rotate(r);
    a.image(img, 0, 0);
    a.popMatrix();
  }
}