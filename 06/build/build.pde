import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ArrayList;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = -1;
float rate = PI / 100;
int day = 6;
//
int horizon = 400;
int sunSize = 500;
PVector sun = new PVector();
ArrayList<Tree> trees = new ArrayList<Tree>();
ArrayList<PVector> stars = new ArrayList<PVector>();

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  //
  for (int i = 0; i<200; i++) {
    stars.add(new PVector(random(width), random(height-horizon), random(1, 3)));
  }
  int u = 100;
  for (float x = u/2; x < width; x += u/2) {
    for (float y = height - horizon+u/2; y < height-(u/2); y += u/2) {
      float n = map(noise(x/2, y), 0, 1, -u/2, u);
      trees.add(new Tree(x+n, y+n, random(u/4, u/2), u+n));
    }
  }
}

void draw() {
  noStroke();
  sun.x = width/2 + map(cos(off), -1, 1, -sunSize/2, sunSize/2);
  sun.y = map(sin(off), -1, 1, -sunSize/2, height+sunSize/2);
  sun.z = sunSize;
  //sky
  fill(colorChange(palette[4], palette[0]));
  rect(0, 0, width, height-horizon);

  //stars
  fill(palette[3]);
  for (PVector s : stars) {
    fill(palette[4]);
    circle(s.x, s.y, s.z);
  }

  // sun
  fill(colorChange(palette[3], palette[1]));
  if (cos(off) > 0)  circle(sun.x, sun.y, sun.z);

  // ground
  fill(colorChange(palette[2], palette[4]));
  rect(0, height-horizon, width, horizon);

  //shadow
  for (Tree t : trees) {
    t.displayShadow();
  }

  if (cos(off)<0) {
    //sky
    fill(colorChange(palette[4], palette[0]));
    rect(0, 0, width, height-horizon);

    //stars
    fill(palette[3]);
    for (PVector s : stars) {
      fill(palette[4]);
      circle(s.x, s.y, s.z);
    }
  }

  // trees
  for (Tree t : trees) {
    t.displayTree();
  }
  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
  off += rate;
  // record();
}

class Tree {
  float x, y, w, h;
  Tree(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void displayTree() {
    fill(colorChange(lerpColor(palette[2], palette[0], .25), palette[0]));
    triangle(x - w / 2, y, x, y - h, x + w / 2, y);
  }
  void displayShadow() {
    PVector shadowPoint = new PVector();
    if (sun.x > x) {
      shadowPoint.x = x - map(sun.x - x, 0, width, 0, h);
    } else {
      shadowPoint.x = x + map(x - sun.x, 0, width, 0, h);
    }
    if (cos(off) < 0) {
      shadowPoint.y = y-map(sin(off), -1, 1, 0, h);
    } else {
      shadowPoint.y = y+map(sin(off), -1, 1, 0, h);
    }
    fill(colorChange(palette[0], palette[4]));
    triangle(x - w / 2, y, shadowPoint.x, shadowPoint.y, x + w / 2, y);
  }
}


color colorChange (color c1, color c2) {
  return lerpColor(c1, c2, map(sin(off), -1, 1, 0, 1));
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
