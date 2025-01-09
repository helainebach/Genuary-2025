import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 8;
//one million
int m = 1000000;
int c = 0;  // counter

void setup() {
  frameRate(10);
  size(1080, 1080);
  background(palette[1]);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  textFont(font);
}

void draw() {
  for (int i = 0; i < 10000; i++) {
    something(i);
    c++;
  }
  rectMode(CENTER);
  stroke(palette[1]);
  fill(palette[0]);
  rect(width/2, height/2, 400, 150);
  textAlign(CENTER, CENTER);
  textSize(100);
  fill(palette[1]);
  noStroke();
  text(c, width/2, height/2);
  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
  record();
}

void something(int i) {
  PVector something = new PVector(random(width), random(height), random(10, 100));
  color c1 = palette[i % palette.length];
  color c2 = palette[(i + 1) % palette.length];
  fill(c1);
  stroke(c2);
  strokeWeight(5);
  int r = (int)Math.ceil(random(1)*3);
  switch(r) {
  case 1:
    triangle(something.x, something.y, something.x + (something.z/3), something.y + (something.z/2), something.x - (something.z/3), something.y + (something.z/2));
    break;
  case 2:
    rectMode(CENTER);
    square(something.x, something.y, something.z);
    break;
  case 3:
    circle(something.x, something.y, something.z);
  }
}

void record() {
  saveFrame("../exports/" + folderName + "/###.png");
  if (c > m) exit();
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
  textAlign(RIGHT, TOP);
  textSize(20);
  fill(palette[textCol]);
  text(txt, width - 20, 20);
}
