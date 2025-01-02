import java.text.SimpleDateFormat;
import java.util.Date;

int[] rowPattern = {0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1};
int[] colPattern = {1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1};

int u = 20;
int rowStitches = 110;
int colStitches = 110;
int rowSpaces = rowStitches * 2;
int colSpaces = colStitches * 2;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 1;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[0]);
  strokeWeight(5);
  strokeCap(PROJECT);
  push();
  translate(-u, -u);
  for (int j = 0; j < rowStitches; j++) {
    stroke(palette[3]);
    row(j);
  }

  for (int i = 0; i < colStitches; i++) {
    stroke(palette[4]);
    col(i);
  }
  pop();
  sig(day, prompts.getString(day - 1, 0), true, 1, 0);
  off += rate;
  // record();
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

void row(int num) {
  int x1, x2, y;
  y = u +(num * u);
  if (num % 2 == 0) {
    if (rowPattern[num%rowPattern.length] == 0) {
      // shorter even row
      for (int i = 1; i < rowSpaces - 1; i++) {
        if (i % 2 == 1) {
          x1 = u +(i * u);
          x2 = x1 + u;
          line(x1, y, x2, y);
        }
      }
    } else {
      // longer even row
      for (int i=0; i<rowSpaces; i++) {
        if (i % 2 == 1) {
          x1 = (i * u);
          x2 = x1 + u;
          line(x1, y, x2, y);
        }
      }
    }
  } else {
    if (rowPattern[num%rowPattern.length] == 0) {
      // shorter odd row
      for (int i = rowSpaces-1; i > 1; i--) {
        if (i % 2 == 1) {
          x1 =(i * u);
          x2 = x1 - u;
          line(x1, y, x2, y);
        }
      }
    } else {
      // longer odd row
      for (int i=rowSpaces; i>0; i--) {
        if (i % 2 == 0) {
          x1 = (i * u);
          x2 = x1 - u;
          line(x1, y, x2, y);
        }
      }
    }
  }
}

void col(int num) {
  int y1, y2, x;
  x = u +(num * u);
  if (num % 2 == 0) {
    if (colPattern[num%colPattern.length] == 0) {
      // shorter even column
      for (int i = 1; i < colSpaces - 1; i++) {
        if (i % 2 == 0) {
          y1 =(i * u);
          y2 = y1 + u;
          line(x, y1, x, y2);
        }
      }
    } else {
      // longer even column
      for (int i=0; i<colSpaces; i++) {
        if (i % 2 == 1) {
          y1 =(i * u);
          y2 = y1 + u;
          line(x, y1, x, y2);
        }
      }
    }
  } else {
    if (colPattern[num%colPattern.length] == 0) {
      // shorter odd column
      for (int i = colSpaces - 1; i > 1; i--) {
        if (i % 2 == 1) {
          y1 =(i * u);
          y2 = y1 - u;
          line(x, y1, x, y2);
        }
      }
    } else {
      // longer odd column
      for (int i=colSpaces; i>0; i--) {
        if (i % 2 == 0) {
          y1 = i * u;
          y2 = y1 - u;
          line(x, y1, x, y2);
        }
      }
    }
  }
}
