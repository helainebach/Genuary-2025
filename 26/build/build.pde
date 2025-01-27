import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 26;
int u = 1080/50;
ArrayList<Persimmon> persimmons = new ArrayList<Persimmon>();


void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  int h = 17;
  int x = 0;
  int y = 0;
  while (h>=1) {
    for (int i = 0; i<4; i++) {
      int newH = constrain(h-(i*4), 1, h);
      persimmons.add(new Persimmon(h, x, y));
      persimmons.add(new Persimmon(newH, x, y));
      persimmons.add(new Persimmon(h, x, -y));
      persimmons.add(new Persimmon(newH, x, -y));
      persimmons.add(new Persimmon(h, -x, -y));
      persimmons.add(new Persimmon(newH, -x, -y));
      persimmons.add(new Persimmon(h, -x, y));
      persimmons.add(new Persimmon(newH, -x, y));
    }
    x+=u*h/2;
    y+=u*h/2;
    h=h-4;
  }
}

void draw() {
  background(palette[3]);
  strokeWeight(1);
  push();
  translate(snap(width/2), snap(height/2));
  for (Persimmon p : persimmons) {
    strokeWeight(3);
    stroke(palette[4]);
    noFill();
    p.draw();
  }
  pop();
  sig(day, prompts.getString(day - 1, 0), true, 4, 3);
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
