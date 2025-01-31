import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 31;
PImage[]images = new PImage[30];
PGraphics pg;
float imgSize;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  for (int i = 0; i < 30; i++) {
    images[i] = loadImage((i + 1) + ".png");
  }
  imgSize = width / 6;
  pg = createGraphics(width, int(height-imgSize));
}

void draw() {
  background(palette[1]);
  pg = createGraphics(width, height);
  pg.beginDraw();
  for (int i = 0; i<images.length; i++) {
    pg.image(images[i], i%6 * imgSize, floor(i/6) * imgSize, imgSize, imgSize);
  }
  pg.endDraw();
  color [] colors = new color[int(width * (height-imgSize))];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height-imgSize; y++) {
      color target = pg.get(x+1, y);
      colors[x + y * width] = closestColor(target);
    }
  }
  color[] sorted = sort(colors, palette); // Assign the result of sort to sorted

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height-imgSize; y++) {
      fill(sorted[x + y * width]);
      noStroke();
      rect(x, y + imgSize, 1, 1);
    }
  }





  // image(pg, 0, imgSize);
  textAlign(CENTER, CENTER);
  textFont(font);
  textSize(imgSize/2);
  fill(palette[4]);
  text("Genuary 2025", width/2, imgSize/2);
  sig(day, prompts.getString(day - 1, 0), false, 0, 1);
  off += rate;
  // record();
}

color[] sort(color[] colors, color[] palette) {
  //find how many pixels are palette[0]
  int zero = 0;
  int one = 0;
  int two = 0;
  int three = 0;
  int four = 0;

  for (color c : colors) {
    if (c == palette[0]) {
      zero++;
    }
    if (c == palette[1]) {
      one++;
    }
    if (c == palette[2]) {
      two++;
    }
    if (c == palette[3]) {
      three++;
    }
    if (c == palette[4]) {
      four++;
    }
  }
  //create a new array with the correct number of pixels
  color[] sorted = new color[colors.length];
  int index = 0;
  for (int i = 0; i < zero; i++) {
    sorted[index] = palette[0];
    index++;
  }
  for (int i = 0; i < one; i++) {
    sorted[index] = palette[1];
    index++;
  }
  for (int i = 0; i < two; i++) {
    sorted[index] = palette[2];
    index++;
  }
  for (int i = 0; i < three; i++) {
    sorted[index] = palette[3];
    index++;
  }
  for (int i = 0; i < four; i++) {
    sorted[index] = palette[4];
    index++;
  }

  return sorted;
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
  textSize(20);

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

color closestColor(color target) {
  float minDist = 256;
  color closest = palette[0];
  for (color c : palette) {

    float d = dist(
      red(target), green(target), blue(target),
      red(c), green(c), blue(c)
      );
    if (d < minDist) {
      minDist = d;
      closest = c;
    }
  }
  return closest;
}
