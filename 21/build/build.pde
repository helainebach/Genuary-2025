import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ArrayList;

color[] palette = {#102341, #faf0f8, #00f5b8, #ffef85, #6190ff };
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 21;
ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  for (int i = 0; i < 35; i++) {
    particles.add(new Particle(random(width), random(height), palette[(int)random(0, 5)]));
  }
}

void draw() {
  background(palette[1]);

  // Check for collisions and add new particles
  for (int i = 0; i < particles.size(); i++) {
    for (int j = i + 1; j < particles.size(); j++) {
      Particle p1 = particles.get(i);
      Particle p2 = particles.get(j);
      p1.collide(p2);
    }
  }

  // Update and display all particles
  for (Particle p : particles) {
    p.update();
    p.edges();
    p.show();
  }


  sig(day, prompts.getString(day - 1, 0), true, 1, 4);
  off += rate;
  record();
}

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float r;
  color c;

  Particle(float x, float y, color _c) {
    position = new PVector(x, y);
    velocity = PVector.random2D();
    velocity.mult(random(2, 6));
    acceleration = new PVector(0, 0);
    mass = random(2, 6);
    r = sqrt(mass) * 20;
    c = _c;
  }

  void applyForce(PVector force) {
    PVector f = force.copy();
    f.div(mass);
    acceleration.add(f);
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }


  // Collision Detection and Resolution
  void collide (Particle other) {
    PVector impactVector = PVector.sub(other.position, this.position);
    float d = impactVector.mag();
    if (d < this.r + other.r) {
      // Push the particles out so that they are not overlapping
      float overlap = d - (this.r + other.r);
      PVector dir = impactVector.copy();
      dir.setMag(overlap * 0.5);
      this.position.add(dir);
      other.position.sub(dir);
      // Correct the distance!
      d = this.r + other.r;
      impactVector.setMag(d);

      float mSum = this.mass + other.mass;
      PVector vDiff = PVector.sub(other.velocity, this.velocity);
      // Particle A (this)
      float num = vDiff.dot(impactVector);
      float den = mSum * d * d;
      PVector deltaVA = impactVector.copy();
      deltaVA.mult(2 * other.mass * num / den);
      this.velocity.add(deltaVA);
      // Particle B (other)
      PVector deltaVB = impactVector.copy();
      deltaVB.mult(-2 * this.mass * num / den);
      other.velocity.add(deltaVB);
    }
  }

  // Bounce edges
  void edges() {
    if (this.position.x > width - this.r) {
      this.position.x = width - this.r;
      this.velocity.x *= -1;
    } else if (this.position.x < this.r) {
      this.position.x = this.r;
      this.velocity.x *= -1;
    }

    if (this.position.y > height - this.r) {
      this.position.y = height - this.r;
      this.velocity.y *= -1;
    } else if (this.position.y < this.r) {
      this.position.y = this.r;
      this.velocity.y *= -1;
    }
  }

  // Method to display
  void show() {
    strokeWeight(3);
    stroke(palette[4]);
    fill(c);
    ellipse(this.position.x, this.position.y, this.r * 2, this.r * 2);
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
