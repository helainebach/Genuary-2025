import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 13;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  background(palette[0]);
  frameRate(3);
  blendMode(REPLACE);
}

void draw() {
  PVector p = new PVector(random(width), random(height));
  noStroke();
  int u = (int)width/6;
  int n = 0;
  while (n<width) {
    int c = (int)(n/u);
    float r = random(1);
    if (r<.25) {


      fill(palette[c%palette.length]);
      triangle(p.x, p.y, n, 0, n+u, 0);
      c++;
      fill(palette[c%palette.length]);
      triangle(p.x, p.y, n, height, n+u, height);
      c++;
      fill(palette[c%palette.length]);
      triangle(p.x, p.y, 0, n, 0, n+u);
      c++;
      fill(palette[c%palette.length]);
      triangle(p.x, p.y, height, n, height, n+u);
    }
    n+=u;
  }

  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
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
  case 'b':
    background(palette[0]);
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
