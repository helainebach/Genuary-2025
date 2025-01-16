import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 16;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  int u = width/palette.length;
  int offset = u/2;
  background(palette[1]);
  for (int i = 0; i < palette.length; i++) {
    for (int j = 0; j < palette.length; j++) {
      rectMode(CENTER);
      //lighter shades of color
      color c;
      color w = color(255, 255, 255);
      color b = color(0, 0, 0);
      if (j<3) {
        c = lerpColor(w, palette[i], map(j, -1, 2, 0, 1));
      } else {
        c = lerpColor(palette[i], b, map(j, 2, 5, 0, 1));
      }
      fill(c);
      stroke(palette[0]);
      strokeWeight(3);
      if (j == 2) {
        square(i*u+offset, j*u+offset, u*.75);
      } else {
        square(i*u+offset, j*u+offset, u*.5);
      }
      fill(palette[0]);
      textAlign(CENTER, CENTER);
      //format c as hex color
      String hex = "#" + hex(c, 6);
      text(hex, i*u+offset, j*u+offset);
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
