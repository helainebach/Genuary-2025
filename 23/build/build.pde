import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 23;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  // noLoop();
  frameRate(3);
}

void draw() {
  background(palette[4]);
  float s = 0;
  float p = 0;
  float w;
  float d;
  push();
  translate(width/2, height*.75);
  rotate(PI);
  while (s<PI) {
    p = random(1, 2)*PI/8;
    w = random(.85, 1.25)*width/4;
    d = random(.95, 1.25)*width/2;
    noFill();
    stroke(palette[3]);
    strokeWeight(w);
    strokeCap(SQUARE);
    arc(0, 0, d, d, s, s+p-PI/64, OPEN);
    s+=p;
  }
  pop();
  fill(palette[0]);
  rect(0, height*.75, width, height*.75);

  sig(day, prompts.getString(day - 1, 0), false, 3, 0);
  off += rate;
  record();
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
