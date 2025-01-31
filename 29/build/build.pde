import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI/16;
int day = 29;
int u = 20;


void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  background(palette[0]);
  grid();
}

void draw() {
  float n = noise(off)*width/2; 
  PVector p = new PVector(width/2 + cos(off) * n, height/2 + sin(off) * n);    
  noStroke();
  fill(palette[4]);
  square(snap(p.x), snap(p.y), u);
  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
  off += rate;
  record();
}

int snap(float n) {
  return int(n / u) * u;
}

void grid() {
  for (int x = 0; x < width; x += u) {
    for (int y = 0; y < height; y += u) {
      stroke(palette[4]);
      strokeWeight(1);
      line(x, 0, x, height);
      line(0, y, width, y);
    }
  }
}

void record() {
  saveFrame("../exports/" + folderName + "/###.png");
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
