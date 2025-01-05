import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 200;
int day = 4;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[1]);
  noStroke();
  fill(palette[0], 100);
  for (int i = 0; i<10; i++) {
    blob((width/4)+(i*20));
  }
  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
  off += rate;
  record();
}

void blob(float r) {
  ArrayList<PVector> points = new ArrayList<PVector>();
  push();
  translate(width/2, height/2);
  for (float a = 0; a < TWO_PI-1; a += PI / 3) {
    float n = map(noise(r*.01, a*2, off), 0, 1, -r/2, r/2);
    float x = cos(a) * r+n;
    float y = sin(a) * r+n;
    points.add(new PVector(x, y));
  }
  beginShape();
  int num = points.size()-1;
  curveVertex(points.get(num).x, points.get(num).y);
  for (int i = 0; i < points.size(); i++) {
    curveVertex(points.get(i).x, points.get(i).y);
  }
  curveVertex(points.get(0).x, points.get(0).y);
  curveVertex(points.get(1).x, points.get(1).y);
  endShape(CLOSE);
  pop();
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
