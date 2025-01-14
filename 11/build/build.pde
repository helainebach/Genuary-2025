import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 11;
int u = 100;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  background(palette[1]);
  frameRate(10);
}

void draw() {
  //Penrose Triangle with cubes
  stroke(palette[1]);
  strokeCap(ROUND);
  strokeWeight(u/10);
  int numCells = 15; // Parameterize the number of cells
  Cell[] h = new Cell[numCells];
  h[0] = new Cell(width / 2-u, height / 3, u);

  for (int i = 1; i < numCells; i++) {
    int vertexIndex;
    if (i < numCells / 3) {
      vertexIndex = 3; // First third
    } else if (i < 2 * numCells / 3) {
      vertexIndex = 5; // Second third
    } else {
      vertexIndex = 1; // Last third
    }
    h[i] = new Cell(h[i - 1].v[vertexIndex].x, h[i - 1].v[vertexIndex].y, u);
  }
  h[frameCount % numCells].display();


  sig(day, prompts.getString(day - 1, 0), true, 0, 1);
  off += rate;
  record();
}

class Cell {
  PVector[] v;
  float x, y, u;

  Cell(float x, float y, float u) {
    this.x = x;
    this.y = y;
    this.u = u;
    this.v = new PVector[7];
    this.v[0] = new PVector(x, y);
    for (int i = 0; i < 6; i++) {
      float angle = TWO_PI * (i - 1) / 6 - PI / 6;
      this.v[i + 1] = new PVector(x + cos(angle) * u, y + sin(angle) * u);
    }
  }
  void display() {
    drawFace(v[0], v[6], v[1], v[2], palette[2]); // Top face
    drawFace(v[0], v[2], v[3], v[4], palette[4]); // Left face
    drawFace(v[0], v[4], v[5], v[6], palette[3]); // Right face
  }
  void drawFace(PVector v1, PVector v2, PVector v3, PVector v4, color c) {
    fill(c);
    quad(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y, v4.x, v4.y);
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
