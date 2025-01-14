import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 12;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  background(palette[0]);
  noLoop(); // We only need to draw once
}

void draw() {
  background(palette[4]);
  drawSierpinski(width / 2, height / 2, width*.8, 5); // Adjust the depth as needed

  sig(day, prompts.getString(day - 1, 0), false, 1, 0);
  off += rate;
  // record();
}

void drawSierpinski(float x, float y, float size, int depth) {
  noStroke();
  if (depth == 0) {
    drawTriangle(x, y, size);
  } else {
    float newSize = size / 2;
    float h = newSize * sqrt(3) / 2;
    fill(palette[1]);
    drawSierpinski(x, y - h / 2, newSize, depth - 1); // Top triangle
    drawSierpinski(x - newSize / 2, y + h / 2, newSize, depth - 1); // Bottom-left triangle
    drawSierpinski(x + newSize / 2, y + h / 2, newSize, depth - 1); // Bottom-right triangle
  }
}

void drawTriangle(float x, float y, float size) {
  float h = size * sqrt(3) / 2;
  beginShape();
  vertex(x, y - h / 2); // Top vertex
  vertex(x - size / 2, y + h / 2); // Bottom-left vertex
  vertex(x + size / 2, y + h / 2); // Bottom-right vertex
  endShape(CLOSE);
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
