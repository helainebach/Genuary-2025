import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 3;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[0]);
  for (int i = 0; i<42; i++) {
    for (int j = 0; j<42; j++) {
      float n = noise(i*0.1, j*0.1, off);	
      int u = width/42;
      color c;
      String code;	
      boolean bubble = false;	
      if (n > 0.5) {
        c = palette[2];
        code = "1";
        bubble = true;
      } else {	
        c = palette[3];
        code = "0";
      }
      if (j % 14 ==7 || i % 14 == 7) {		
        c = palette[2];
        code = "#";
        bubble = false;
      }	
      cell(code, i*u+(u), j*u+(u), bubble, c, u);
    }
    sig(day, prompts.getString(day - 1, 0), true, 0, 2);
  }
  off += rate;
  record();
}
void cell (String code, int x, int y, boolean bubble, color c, int u) {
  textFont(font);
  textAlign(CENTER, CENTER);
  if (bubble) {
    noFill();
    stroke(c);	
    strokeWeight(1);	
    circle(x, y, u*.8);	
    fill(c);
  } else {
    fill(c);
  }
  text(code, x, y);
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
void record() {
  saveFrame("../exports/" + folderName + "/###.png");
  if (frameCount > TWO_PI / rate) exit();
}
