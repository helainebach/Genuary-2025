import java.text.SimpleDateFormat;
import java.util.Date;
import processing.svg.*;

String fileName;
PShape t;

void setup() {
  frameRate(3);
  size(300, 800);
  t = loadShape("tile.svg");
  // noLoop();
}

void draw() {
  fileName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  beginRecord(SVG, "./exports/"+fileName+".svg");
  int u = width/5;
  background(255);
  for (float x = 0; x<=width; x+=u) {
    for (float y = 0; y<=height; y+=u) {
      shapeMode(CENTER);
      t.disableStyle();
      noFill();
      push();
      translate(x+u/2, y+u/2);
      float n = noise(x, y, frameCount);
      // float n = random(0, 1);
      rotate(int(n*4)*HALF_PI);
      shape(t, 0, 0, u, u);
      pop();
    }
  }
  endRecord();
}
