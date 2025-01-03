import java.text.SimpleDateFormat;
import java.util.Date;

//array of PGraphics layers
ArrayList<PGraphics> layers = new ArrayList<PGraphics>();

//array of PGraphics masks
ArrayList<PGraphics> masks = new ArrayList<PGraphics>();


color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 2;
int layerNum = 10; // Initial number of layers

void setup() {
  frameRate(2);
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[0]);
  for (int i = 0; i < layerNum; i++) {
    PGraphics layer = createGraphics(width, height);
    createLayer(layer);
    PGraphics mask = createGraphics(width, height);
    createMask(mask);
  }
  PGraphics topLayer = createGraphics(width, height);
  createLayer(topLayer);
  PGraphics topMask = createGraphics(width, height);
  topMask(topMask);

  for (int i = 0; i < layers.size(); i++) {
    cheese(layers.get(i), masks.get(i));
  }
  sig(day, prompts.getString(day - 1, 0), true, 0, 1);
  record();
  off += rate;
  //clear layers and masks
  layers.clear();
  masks.clear();
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
  int n = txt.length();\
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

void createLayer(PGraphics layer) {
  layer.beginDraw();
  layer.background( palette[(int)random(palette.length)]);
  layer.endDraw();
  layers.add(layer);
}

void createMask(PGraphics mask) {
  mask.beginDraw();
  mask.background(255);
  for (int i = 0; i < 50; i++) {
    float r = random(1);
    if (r < 0.5) {
      mask.stroke(0);
      mask.strokeWeight(random(20, 50));
      mask.fill(255);
    } else {
      mask.noStroke();
      mask.fill(0);
    }
    mask.circle(random(width), random(height), random(5, 300));
  }
  mask.endDraw();
  masks.add(mask);
}

void cheese(PGraphics layer, PGraphics mask) {
  layer.mask(mask);
  image(layer, 0, 0);
}

void topMask(PGraphics topMask) {
  topMask.beginDraw();
  topMask.background(255);
  topMask.fill(255);
  topMask.stroke(0);
  topMask.strokeWeight(width/4);
  topMask.circle(width/2, height/2, width*.75);
  topMask.fill(0);
  topMask.noStroke();
  topMask.circle(width/2, height/2, width*.25);
  topMask.endDraw();
  masks.add(topMask);
}
