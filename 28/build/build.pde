import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 28;
ArrayList<Persimmon> persimmons = new ArrayList<Persimmon>();
float u = 1080/50;
int h=3;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[0]);
  if (frameCount%2==0) {
    setPersimmons(1);
  } else {
    setPersimmons(3);
  }
  frameRate(6);
  push();
  translate(snap(width/2), snap(height/2));
  sortPersimmons();
  for (int i = 0; i < persimmons.size(); i++) {
    Persimmon p = persimmons.get(i);
    fill(palette[(i+frameCount)%palette.length]); 
    noStroke(); 
    p.draw();
  }
  pop();
  sig(day, prompts.getString(day - 1, 0), true, 0, 1);
  off += rate;
  record();
}

void setPersimmons(int h) {
  persimmons.clear();
  while (h < width/u*2) {
    persimmons.add(new Persimmon(h, 0, 0));
    h+=4;
  }
}

void sortPersimmons() {
  for (int i = 0; i < persimmons.size(); i++) {
    for (int j = 0; j < persimmons.size() - 1; j++) {
      if (persimmons.get(j).h < persimmons.get(j + 1).h) {
        Persimmon temp = persimmons.get(j);
        persimmons.set(j, persimmons.get(j + 1));
        persimmons.set(j + 1, temp);
      }
    }
  }
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

int snap(float v) {
  float halfU = u / 2.0;
  int snapped = int(round((v - halfU) / u) * u + halfU);
  if (snapped % u == 0) {
    snapped += halfU;
  }
  return snapped;
}

class Persimmon {
  int h;
  int x;
  int y;

  Persimmon(int h, int x, int y) {
    this.h = h;
    this.x = x;
    this.y = y;
  }

  void draw() {
    push();
    translate(x, y);
    translate(-h / 2 * u, 0);
    translate(-u / 2, -u / 2);
    beginShape();
    int tempX = 0;
    int tempY = 0;
    for (int i = 0; i < 4 * h; i++) {
      int quadrant = i / h;
      if (i % 2 == 0) {
        tempY += (quadrant == 0 || quadrant == 3) ? u : -u;
      } else {
        tempX += (quadrant == 0 || quadrant == 1) ? u : -u;
      }
      vertex(tempX, tempY);
    }
    endShape(CLOSE);
    pop();
  }
}
