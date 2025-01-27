import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 24;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[0]);
  grid();
  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
  off += rate;
  record();cp - 
}

void grid() {
  float s = 45;
  float w = sqrt(3)*s;
  float h = 2*s;
  for (int row = 0; row * h * 3/4 <= height; row++) {
    for (int col = 0; col * w <= width; col++) {
      float x = col * h + (row % 2) * w / 2;
      float y = row * h * 3/4;

      s = 45;

      noStroke();
      for (int i = 0; i<3; i++) {
        fill(palette[1+((i+(row*col))%(palette.length-1))]);
        if (col*row%2==0) {
          circle(x+cos(off+i)*i*s/6, y+sin(off+i)*i*s/6, s-(i*s/3));
        } else {
          circle(x+cos(-off-i)*i*s/6, y+sin(-off-i)*i*s/6, s*2-(i*s/3));
        }
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
