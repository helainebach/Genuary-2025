// Code mostly borrowed from https://github.com/amorton12/gen-doodleplot


import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 25;
ArrayList<PVector> layerPaths;
int u = 10;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  noLoop();
  generateLayer();
}

void draw() {
  background(palette[1]);
  drawLayer(layerPaths);
  sig(day, prompts.getString(day - 1, 0), true, 0, 1);
  off += rate;
  // record();
}

void keyPressed() {
  switch(key) {
  case 'p':
    String fileName = new SimpleDateFormat("yyyyMMddHHmmss'.png'").format(new Date());
    saveFrame("../exports/" + folderName + "/" + fileName);
    break;
  case 'n':
    generateLayer();
    redraw();
    break;
  }
}


ArrayList<PVector> generateLayer() {
  layerPaths = new ArrayList<PVector>();
  int steps = 2000;
  int startX = snapToGrid((int)random(u, width - u));
  int startY = snapToGrid((int)random(u, height - u));
  int currentX = startX;
  int currentY = startY;
  PVector prevDirection = getOppositeDirection(1);
  layerPaths.add(new PVector(currentX, currentY));
  currentX += u;
  currentY += u;

  if (!isInsideCanvas(currentX, currentY)) {
    println("Stopped: Outside canvas at(" + currentX + ", " + currentY + ")");
    return layerPaths;
  }
  if (currentX == 0 || currentX == width || currentY == 0 || currentY == height) {
    //println("Stopped: Reached edge at(" + currentX + ", " + currentY + ")");
    layerPaths.add(new PVector(currentX, currentY));
    return layerPaths;
  }
  layerPaths.add(new PVector(currentX, currentY));
  int i = 0;
  // Main loop for generating the path

  while (true) {
    i++;
    ArrayList<PVector> directions = getValidDirections(prevDirection);
    PVector chosenDirection = null;
    //println("Step " + i + ": Valid directions: " + validDirectionstoString(directions));

    // Avoid running into an edge until i == steps
    if (i < steps) {
      for (int j = 0;
        j < directions.size();
        j++) {
        PVector direction = directions.get(j);
        if (isEdge(snapToGrid(currentX + direction.x * u), snapToGrid(currentY + direction.y * u))) {
          directions.remove(j);
          j--;
        }
      }
    }
    // Try to find a non-overlapping direction
    ArrayList<PVector> nonOverlappingDirections = new ArrayList<PVector>();
    for (PVector direction : directions) {
      if (!isOverlapping(direction, layerPaths)) {
        nonOverlappingDirections.add(direction);
      }
    }
    //println("Step " + i + ": Non-overlapping directions: " + validDirectionstoString(nonOverlappingDirections));
    if (nonOverlappingDirections.size() > 0) {
      chosenDirection = nonOverlappingDirections.get(int(random(nonOverlappingDirections.size())));
    } else {
      chosenDirection = directions.get((int)random(directions.size()));
    }
    //println("Step " + i + ": Chosen direction: " + getCardinalName(chosenDirection));

    // Move in the chosen direction a number of steps chosen at random between 1 and 11 - directionChangeFrequency
    int stepsToMove =(int)random(1, 5);
    for (int j=0; j<stepsToMove; j++) {
      // If the next move would go outside the canvas or hit an edge before i == steps, stop and return the path
      if ((!isInsideCanvas(currentX + chosenDirection.x * u, currentY + chosenDirection.y * u) || isEdge(snapToGrid(currentX + chosenDirection.x * u), snapToGrid(currentY + chosenDirection.y * u))) && i < steps) {
        layerPaths.add(new PVector(snapToGrid(currentX), snapToGrid(currentY)));
        return layerPaths;
      }
      currentX = snapToGrid(currentX +(chosenDirection.x * u));
      currentY = snapToGrid(currentY +(chosenDirection.y * u));
      //println("Moved to:(" + currentX + ", " + currentY + ")");

      if (!isInsideCanvas(currentX, currentY)) {
        println("Stopped: Outside canvas at(" + currentX + ", " + currentY + ")");
        // Add the last point to the path where it intersects the canvas boundary
        layerPaths.add(new PVector(currentX - chosenDirection.x * u, currentY - chosenDirection.y * u));
        return layerPaths;
      }
      if (currentX == 0 || currentX == width || currentY == 0 || currentY == height) {
        //println("Stopped: Reached edge at(" + currentX + ", " + currentY + ")");
        layerPaths.add(new PVector(currentX, currentY));
        return layerPaths;
      }
      layerPaths.add(new PVector(currentX, currentY));
    }
    prevDirection = chosenDirection;
  }
}
boolean isOverlapping(PVector direction, ArrayList<PVector> path) {
  float currentX = path.get(path.size() - 1).x;
  float currentY = path.get(path.size() - 1).y;
  for (PVector point : path) {
    if (point.x == currentX + direction.x * u && point.y == currentY + direction.y * u) {
      return true;
    }
  }
  return false;
}

ArrayList<PVector> getValidDirections(PVector prevDirection) {
  ArrayList<PVector> validDirections = new ArrayList<PVector>();

  if (prevDirection.x != 1) validDirections.add(new PVector(-1, 0)); // Left
  if (prevDirection.x != -1) validDirections.add(new PVector(1, 0)); // Right
  if (prevDirection.y != 1) validDirections.add(new PVector(0, -1)); // Up
  if (prevDirection.y != -1) validDirections.add(new PVector(0, 1)); // Down

  return validDirections;
}

PVector getOppositeDirection(int edge) {
  switch(edge) {
  case 0: // Top edge
    return new PVector(0, 1); // Down
  case 1: // Right edge
    return new PVector(-1, 0); // Left
  case 2: // Bottom edge
    return new PVector(0, -1); // Up
  case 3: // Left edge
    return new PVector(1, 0); // Right
  default:
    return new PVector(0, 0); // No movement
  }
}
void drawLayer(ArrayList<PVector> path) {
  stroke(palette[0]);
  strokeWeight(2);
  noFill();
  beginShape();
  for (PVector point : path) {
    curveVertex(point.x, point.y);
  }
  endShape();
}

int snapToGrid(float value) {
  return(int)(round(value / u) * u);
}

boolean isInsideCanvas(float x, float y) {
  return x >= u && x <= width-u && y >= u && y <= height-u;
}

boolean isEdge(float x, float y) {
  return x == u || x == width-u || y == u || y == height-u;
}


void record() {
  saveFrame("../exports/" + folderName + "/###.png");
  if (frameCount > TWO_PI / rate) exit();
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
