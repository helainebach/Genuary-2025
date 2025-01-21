import java.text.SimpleDateFormat;
import java.util.Date;


color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 19;
PShape t;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  t = loadShape("tile.svg");
  t.disableStyle();
  shapeMode(CENTER);
}

void draw() {
  int u = width/5;
  background(palette[0]);
  for (float x = 0; x<=width; x+=u) {
    for (float y = 0; y<=height; y+=u) {
      strokeCap(SQUARE);
      stroke(palette[4]);
      noFill();
      strokeWeight(3);
      push();
      translate(x+u/2, y+u/2);
      float n = noise(x, y);
      rotate(int(n*4)*HALF_PI);
      shape(t, 0, 0, u, u);
      stroke(palette[1]);
      shape(t, 6, 6, u, u);
      pop();
      strokeWeight(15);
      stroke(palette[0]);
      line(0, y, width, y);
      line(x, 0, x, height);
      strokeWeight(6);
      stroke(palette[1]);
      line(0, y, width, y);
      line(x, 0, x, height);
    }
  }

  sig(day, prompts.getString(day - 1, 0), true, 0, 4);
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
