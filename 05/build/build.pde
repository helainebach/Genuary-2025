import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 5;
int u = 50;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[4]);

  stroke(palette[1]);
  strokeWeight(2);
  push();
  translate(u, u);
  for (float i = 0; i < width / u; i++) {
    for (float j = 0; j < height / u; j++) {
      float x = (i - j) * u + (width / 2);
      float y = (i + j) * (u / 2);
      strokeWeight(map(i, 0, width/u, u/8, u/2));
      stroke(palette[((int)(i*j)%palette.length)], map(j, 0, height/u, 0, 255));
      cell(x, y);
      circle(x, y, 10);
    }
  }
  for (float i = 0; i < width / u; i++) {
    for (float j = 0; j < height / u; j++) {
      float x = (i - j) * u + (width / 2);
      float y = (i + j) * (u / 2);
      fill(palette[4]);
      noStroke();
      circle(x, y, map(i, 0, width/u, u*.4, u*.75));
    }
  }
  pop();

  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
  off += rate;
  // record();
}

void cell(float x, float y) {
  line(x, y, x+cos(PI/6)*u, y-sin(PI/6)*u);
  line(x, y, x, y+u);
  line(x, y, x-cos(PI/6)*u, y-sin(PI/6)*u);
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
