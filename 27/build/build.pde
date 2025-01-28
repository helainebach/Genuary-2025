import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 27;
int u = 20;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[0]);
  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      if (x % u == 0 && y % u == 0) {
        noStroke();
        if (y/u%4<=2) {
          fill(palette[2]);
          if (x/u%6>=4) {
            fill(palette[4]);
          }
        } else {
          fill(palette[3]);
        }
        if (((y/u)+(x/u))%2==0) {
          fill(palette[0]);
          square(x, y, u);
        } else {
          circle(x, y, u);
        }
        ellipseMode(CORNER);
      }
    }
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
