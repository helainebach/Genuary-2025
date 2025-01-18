import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float fourPi = 4;
float off = 0;
float rate = fourPi / 600;
int day = 17;
float x = 0;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  x =  map(abs(sin(off)), 0, 1, 0, width);
  background(palette[4]);
  noFill();
  strokeWeight(1);
  stroke(palette[3]);
  dotGrid();
  line(x, 0, x, height);
  strokeWeight(3);
  push();
  translate(0, height / 2);
  stroke(palette[2]);
  wave(fourPi);
  stroke(palette[0]);
  wave(PI);
  float fourPiY = height / 6  * sin(fourPi * x / width * (fourPi*2));
  float regPiY = height / 6  * sin(PI * x / width * TWO_PI);
  ball(x, fourPiY, "4", palette[0]);
  ball(x, regPiY, "π", palette[2]);
  pop();
  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
  off += rate;
  record();
}
void dotGrid() {
  int u = 10;
  push();
  translate(u/2, u/2);
  for (int i = 0; i < width; i+=u) {
    for (int j = 0; j < height; j+=u) {
      point(i, j);
    }
  }
  pop();
}
void ball (float x, float y, String txt, color f) {
  noStroke();
  fill(f);
  circle(x, y, 25);
  textAlign(CENTER, CENTER);
  fill(palette[4]);
  text(txt, x, y);
}
void wave(float pi) {
  float amplitude = height / 6;
  float frequency = pi; // Using π = 4
  float step = 0.01;

  beginShape();
  for (float x = 0; x < width; x += step) {
    float y = amplitude * sin(frequency * x / width * (pi*2));
    vertex(x, y);
  }
  endShape();
}

void record() {
  saveFrame("../exports/" + folderName + "/###.png");
  if (x >= width) exit();
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
