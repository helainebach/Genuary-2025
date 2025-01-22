import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ArrayList;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 22;
PVector[] points;
PVector[] basePoints;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  points = new PVector[3];
  basePoints = new PVector[3];
  for (int i = 0; i < points.length; i++) {
    basePoints[i] = new PVector(random(width), random(height), 0);
  }
}

void draw() {
  for (int i = 0; i < points.length; i++) {
    points[i] = new PVector();
    points[i] = basePoints[i].copy();
    randomSeed(i);
    points[i].add(sin(off*random(.5, 2))*random(200, 400), cos(off*random(-2, 2))*random(200, 400), i+2);
    points[i].x = constrain(points[i].x, 0, width);
    points[i].y = constrain(points[i].y, 0, height);
  }
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float totalWeight = 0;
      float r = 0, g = 0, b = 0;
      for (int i = 0; i < points.length; i++) {
        float d = dist(x, y, points[i].x, points[i].y);
        float weight = pow(1.0 / (d + 1e-6), 6);
        totalWeight += weight;
        color c = palette[(int)points[int(i)].z];
        r += red(c) * weight;
        g += green(c) * weight;
        b += blue(c) * weight;
      }
      r /= totalWeight;
      g /= totalWeight;
      b /= totalWeight;
      color c = color(r, g, b);
      int pixelIndex = x + y * width;
      pixels[pixelIndex] = c;
    }
  }
  updatePixels();
  sig(day, prompts.getString(day - 1, 0), false, 1, 1);
  off += rate;
  // record();
}

void record() {
  saveFrame("../exports/" + folderName + "/###.png");
  if (frameCount > TWO_PI / rate) exit();
}

void keyPressed() {

  switch(key) {
  case 'p':
    String fileName = new SimpleDateFormat("yyyyMMddHHmmss'.png'").format(new Date());
    saveFrame("../exports/" + folderName + "/" + fileName);
    break;
  }
}

void sig(int d, String prompt, boolean bg, int textCol, int bgCol) {
  String txt = "#genuary" + d + " // " + prompt + " // @helainebach";
  int n = txt.length();

  if (bg) {
    fill(palette[bgCol]);
    stroke(palette[bgCol]);
    strokeWeight(10);
    rectMode(CORNER);
    rect((width - 20) - n * 10, 20, n * 10, 20);
  }
  textFont(font);
  textAlign(RIGHT, TOP);
  fill(palette[textCol]);
  text(txt, width - 20, 20);
}
