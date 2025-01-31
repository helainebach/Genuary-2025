import java.text.SimpleDateFormat;
import java.util.Date;

float [][] field;
int u = 40;
int cols, rows;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 30;

void setup() {
  size(1080, 1080);
  cols = width / u;
  rows = height / u;
  field = new float[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      field[i][j] = floor(random(2));
    }
  }
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[0]);
  push();
  translate(u/2, u/2);
  for (int x = 0; x < cols; x ++) {
    for (int y = 0; y < rows; y ++) {
      stroke(field[x][y] == 1 ? palette[4] : palette[2]);
      strokeWeight(u);
      point(x*u, y*u);
    }
  }
  strokeWeight(u/4);
  stroke(palette[3]);
  for (int i = 0; i < cols-1; i++) {
    for (int j = 0; j < rows-1; j++) {
      float x = i * u;
      float y = j * u;
      PVector a = new PVector(x+u/2, y);
      PVector b = new PVector(x+u, y+u/2);
      PVector c = new PVector(x+u/2, y+u);
      PVector d = new PVector(x, y+u/2);
      int state = getState(int(field[i][j]), int(field[i+1][j]), int(field[i+1][j+1]), int(field[i][j+1]));
      switch (state) {
      case 1:
        drawLine(c, d);
        break;
      case 2:
        drawLine(b, c);
        break;
      case 3:
        drawLine(b, d);
        break;
      case 4:
        drawLine(a, b);
        break;
      case 5:
        drawLine(a, d);
        drawLine(b, c);
        break;
      case 6:
        drawLine(a, c);
        break;
      case 7:
        drawLine(a, d);
        break;
      case 8:
        drawLine(a, d);
        break;
      case 9:
        drawLine(a, c);
        break;
      case 10:
        drawLine(a, b);
        drawLine(c, d);
        break;
      case 11:
        drawLine(a, b);
        break;
      case 12:
        drawLine(b, d);
        break;
      case 13:
        drawLine(b, c);
        break;
      case 14:
        drawLine(c, d);
        break;
      }
    }
  }
  pop();
  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
  off += rate;
  // record();
}
void drawLine(PVector a, PVector b) {
  line(a.x, a.y, b.x, b.y);
}

int getState(int a, int b, int c, int d) {
  return a * 8 + b * 4 + c * 2 + d;
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
