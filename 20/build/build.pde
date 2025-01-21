import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 20;
int skyline = 900;
ArrayList<Building> buildings1 = new ArrayList<Building>();
ArrayList<Building> buildings2 = new ArrayList<Building>();
ArrayList<Building> buildings3 = new ArrayList<Building>();
int gridSize = 50; // Define the grid unit size

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  for (int i = 0; i < 10; i++) {
    float x = snapToGrid(i * width / 10 - 100 + random(-50, 50));
    float w = snapToGrid(random(200, 400));
    float h = snapToGrid(random(200, 600));
    buildings1.add(new Building(x, snapToGrid(700), w, h, 20));
    buildings2.add(new Building(x, snapToGrid(900), w, h, 20));
    buildings3.add(new Building(x, snapToGrid(1080), w, h, 20));
  }
}

void draw() {
  background(palette[0]);
  for (Building b : buildings1) {
    b.buildingFace();
    b.windows();
  }

  for (Building b : buildings2) {
    b.buildingFace();
    b.windows();
  }
  for (Building b : buildings3) {
    b.buildingFace();
    b.windows();
  }

  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
  off += rate;
  // record();
}

class Building {
  float x; // building x
  float w; //building width
  float h; // building height
  float s; // window size
  float skyline;
  int c1;
  int c2;
  Building (float _x, float _skyline, float _w, float _h, float _s) {
    x = _x;
    w = _w;
    h = _h;
    s = _s;
    skyline = _skyline;
    c1 = int(random(2, 5));
    c2 = int(random(2, 5));
    while (c2==c1) {
      c2 = int(random(2, 5));
    }
  }
  void buildingFace() {
    stroke(palette[0]);
    strokeWeight(3);
    fill(palette[c1]);
    rectMode(CORNER);
    rect(x, skyline-h, w, h);
  }
  void windows() {
    float c = w/s;
    float r = h/s;
    push();
    translate(x, skyline-h);
    for (int i = 1; i<c-1; i++) {
      for (int j = 0; j<r-1; j++) {
        noStroke();
        fill(palette[c2]);
        rectMode(CENTER);
        if (j%2==1)square(i*s+s/2, j*s+s/2, s*.75);
      }
    }
    pop();
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

float snapToGrid(float value) {
  return round(value / gridSize) * gridSize;
}
