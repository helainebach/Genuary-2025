import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 15;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[0]);
  int u = 10;
  for (int x = 0; x < width/u; x ++) {
    for (int y = 0; y < height/u; y ++) {
      noStroke();
      style1(x, y, u);
      // style2(x,y,u);
      // style3(x,y,u);
      square(x*u, y*u, u);
    }
  }
  sig(day, prompts.getString(day - 1, 0), true, 4, 1);
  off += rate;
  // record();
}

void style1(int x, int y, int u) {
  float n = noise(x, y);
  if (x%3==1 || y%4==0) {
    fill(palette[1]);
  } else if (n>0.5) {
    fill(palette[4]);
  }
}
void style2(int x, int y, int u) {
  float d1 = dist(x, y, 0, 0);
  float d2 = dist(x, y, width/u, height/u);
  if (d1 < 70 || d2 < 50) {
    fill(palette[2]);
  }
  if (d1 < 40 || d2 < 30) {
    fill(palette[0]);
  }
}
void style3(int x, int y, int u) {
  for (int i = width/u/2; i > 0; i--) {
    if (y<i || y>=height/u-i || x<i || x>=width/u-i) {
      if (y %2 ==0 && x%2==0 ) {
        fill(palette[0]);
      } else {

        fill(palette[1+(i%palette.length-1)]);
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
