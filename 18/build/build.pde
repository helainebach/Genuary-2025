import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 100;
int day = 18;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  int u = 30;
  background(palette[2]);
  PVector a = new PVector();
  PVector b = new PVector();
  a.set(sin(off)*width/2, cos(off)*width/2);
  for (float x = 0; x<width; x+=u) {
    for (float y = 0; y <height; y+=u) {
      strokeWeight(u/2);
      strokeCap(SQUARE);
      push();
      translate(u/2, u/2);
      b.set(u, 0); // Set the vector to have a magnitude of u along the x-axis
      b.rotate(map(dist(x, y, a.x, a.y), 0, width, 0, PI)); // Rotate the vector by 45 degrees
      stroke(palette[0]);
      b.add(x, y);
      line(x, y, b.x, b.y); // Draw the line from (x, y) to the new coordinates
      translate(u/4, u/4);
      stroke(palette[2]);
      line(x, y, b.x, b.y); // Draw the line from (x, y) to the new coordinates
      pop();
    }
  }
  sig(day, prompts.getString(day - 1, 0), true, 2, 0);
  off += rate;
  record();
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
