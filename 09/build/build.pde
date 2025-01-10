import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 20;
int day = 9;
PImage carpet;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  carpet = loadImage("carpet.png");
  //resize image to 1080 by 1080
  carpet.resize(1080, 1080);
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  int xu = (int)map(sin(off), -1, 1, 1, 10);
  int yu = (int)map(cos(off), -1, 1, 20, 1);

  for (int x = 0; x < width; x+=xu) {
    for (int y = 0; y < height; y+=yu) {
      color target = carpet.get(x+1, y);
      fill(closestColor(target));
      noStroke();
      rect(x, y, xu, yu);
    }
  }
  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
  off += rate;
  record();
}

color closestColor(color target) {
  float minDist = 256;
  color closest = palette[0];
  for (color c : palette) {

    float d = dist(
      red(target),  green(target),  blue(target),
      red(c),       green(c),       blue(c)
      );
    if (d < minDist) {
      minDist = d;
      closest = c;
    }
  }
  return closest;
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
