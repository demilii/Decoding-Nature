
import processing.pdf.*;
boolean record;
ArrayList<ParticleSystem> ps;
PShader blur;
PImage img;

float xOff;
float yOff;
float xstart = 0;
float ystart = 0;
ArrayList<Twinkle> t_s;
int num =200;
//Twinkle[] t_s = new Twinkle[num];

float inc = 0.1;
int scl = 10;
float zoff = 0;

int cols;
int rows;
PImage img1;
PImage img2;
int noOfPoints =2500;

Particle[] particles = new Particle[noOfPoints];
Particle[] particles2 = new Particle[noOfPoints];
PVector[] flowField;

void setup() {
  size(720, 960, P3D);
  orientation(LANDSCAPE);
  img1 = loadImage("tex_1.png");
  drawField();
  //background(0);
  hint(DISABLE_DEPTH_MASK);

  cols = floor(width/scl);
  rows = floor(height/scl);

  flowField = new PVector[(cols*rows)];

  for (int i = 0; i < noOfPoints; i++) {
    particles[i] = new Particle(1);
  }

  for (int i = 0; i < noOfPoints; i++) {
    particles2[i] = new Particle(2);
  }

  t_s = new ArrayList();
  for (int i=0; i<num; i++) {
    t_s.add(new Twinkle(new PVector(random(width), random(height), random(-100, 100)), random(100, 255), random(1, 1.5)));
  }

  smooth();
  blur = loadShader("blur.glsl"); 
  img = loadImage("star.png");
  ps = new ArrayList<ParticleSystem>();
}

void draw() {

   if (record) {
    //beginRaw(PDF, "output.pdf");
  }


  //drawField();
  //background(0); 
  //fill(0);
  //rect(0,0,width,height);
  noFill();

  float yoff = 0;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      int index = (x + y * cols);

      float angle = noise(xoff, yoff, zoff) * TWO_PI;
      PVector v = PVector.fromAngle(angle);
      v.setMag(0.01);

      flowField[index] = v;

      stroke(0, 50);

      //pushMatrix();

      //translate(x*scl, y*scl);
      //rotate(v.heading());
      //line(0, 0, scl, 0);

      //popMatrix();

      xoff = xoff + inc;
    }
    yoff = yoff + inc;
  }
  zoff = zoff + (inc / 50);

  for (int i = 0; i < particles.length; i++) {
    particles[i].follow(flowField);
    particles[i].update();
    particles[i].edges();
    particles[i].show();
  }
  for (int i = 0; i < particles.length; i++) {
    particles2[i].follow(flowField);
    particles2[i].update();
    particles2[i].edges();
    particles2[i].show();
  }
  for (int i = t_s.size()-1; i>0; i--) {
    Twinkle t = t_s.get(i);
    t.run();
    if (t.isDead()) {
      t_s.remove(t);
    }
  }

  if (t_s.size() < num) {
    for (int i = 0; i <= 10; i++) {
      t_s.add(new Twinkle(new PVector(random(width), random(height), random(-100, 100)), random(100, 255), random(1, 1.5)));
    }
  }

  //blendMode(ADD);
  for (int i = ps.size()-1; i >=0; i--) {
    ParticleSystem p =ps.get(i);
    float incr = random(3, 8);
    p.origin.x+=incr;
    p.origin.y+=incr;

    p.run();
    p.addParticle();
    if (p.dead()) {
      ps.remove(p);
    }
  }
 if (record) {
    //endRaw();
    saveFrame();
    record = false;
  }
  //filter(blur);
}

class Particle {
  PVector pos = new PVector(random(width), random(height));
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  float maxSpeed = 1;

  PVector prevPos = pos.copy();
  int num;
  Particle(int _num) {
    num = _num;
  }
  public void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
  }

  public void follow(PVector[] vectors) {
    int x = floor(pos.x / scl);
    int y = floor(pos.y / scl);
    int index = (x-1) + ((y-1) * cols);
    // Sometimes the index ends up out of range, typically by a value under 100.
    // I have no idea why this happens, but I have to do some stupid if-checking
    // to make sure the sketch doesn't crash when it inevitably happens.
    //
    index = index - 1;
    if (index > vectors.length || index < 0) {
      //println("Out of bounds!");
      //println(index);
      //println(vectors.length);
      index = vectors.length - 1;
    }
    PVector force = vectors[index];
    applyForce(force);
  }

  void applyForce(PVector force) {
    PVector f = force.copy();
    acc.add(f.div(num*random(2)));
  }

  public void show() {
    //stroke(255,50);
    //strokeWeight(5);
    //bezier(prevPos.x,prevPos.y,prevPos.x+pos.x/2,prevPos.y+pos.y/2,pos.x,pos.y,prevPos.x+pos.x/2,prevPos.y+pos.y/2);
    //line(prevPos.x,prevPos.y,pos.x,pos.y);
    //point(pos.x, pos.y);
    if (num == 1) {
       tint(63, 120, 119, 10);
      //tint(225, 110, 160, 8);
      image(img1, pos.x, pos.y);
    } else if (num == 2) {
      tint(69, 91, 152, 10);
      //tint(115, 110, 250, 8);
      float x = pos.x;
      float y = pos.y;
      image(img1, x, y);
    }



    //image(img2,pos.x+random(-20,20),pos.y+random(-20,20));
  }

  public void updatePrev() {
    prevPos.x = pos.x;
    prevPos.y = pos.y;
  }

  public void edges() {
    if (pos.x > width) {
      pos.x = random(width/2);
      updatePrev();
    }
    if (pos.x < 0) {
      pos.x = random(3*width/4, width);
      updatePrev();
    }

    if (pos.y > height) {
      pos.y = random(height/4, height/2);
      updatePrev();
    }
    if (pos.y <0) {
      pos.y = random(height/2, 3*height/4);
      updatePrev();
    }
  }
}


void drawField() {
  loadPixels();
  xOff = xstart;
  yOff = ystart;
  for (int y = 0; y < height; y++) {
    yOff += .003;
    xOff =xstart;
    for (int x = 0; x < width; x++) {
      float brightness = noise(xOff, yOff);
      xOff += .003;
      int loc = x + y*width;
      pixels[loc] = color(0, brightness*random(32, 35), brightness*150, brightness*255);
    }
  }
  xstart+=0.01;
  ystart+=0.003;
  updatePixels();
}



// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList<sh_star> particles;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are birthed
  float lifespan;
  PImage tex;
  float r;
  ParticleSystem(int num, PVector v, float _lifespan) {
    particles = new ArrayList();              // Initialize the arraylist
    origin = v.get();   
    lifespan = _lifespan;
    r = random(-1, 1);
    // Store the origin point
    for (int i = 0; i < num; i++) {
      particles.add(new sh_star(origin, lifespan));    // Add "num" amount of particles to the arraylist
    }
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      sh_star sh = particles.get(i);
      sh.run();
      if (sh.isDead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle() {

    for (int i=0; i<10; i++) {
      particles.add(new sh_star(origin, lifespan));
    }
  }

  //void addParticle(Star p) {
  //  particles.add(p);
  //}

  // A method to test if the particle system still has particles
  boolean dead() {
    for (sh_star p : particles) {
      if (p.pos.x > width) {
        return true;
      } else {
        return false;
      }
    }
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }
}
class sh_star {
  PVector pos;
  PVector vel;
  PVector acc;
  float lifespan;
  float damping;

  sh_star(PVector l, float _lifespan) {
    pos = l.copy();
    acc = new PVector(0, 0, 0);
    //acc = new PVector(random(-0.02, -0.01), random(-0.02, -0.01), -0.5);
    //float vx = randomGaussian()*0.05;

    float vy = randomGaussian() -4;
    vel = new PVector(vy, vy, 0);
    lifespan = _lifespan;
    damping = 0.99;
  }
  void run() {
    update();
    render();
  }

  void update() {
    vel.add(acc);
    vel.mult(damping);
    pos.add(vel);
    lifespan -= 20;
  }
  void render() {
    imageMode(CENTER);
    tint(255, lifespan);
    tint(255, 110, 190, lifespan);
    image(img, pos.x, pos.y);
  }

  boolean isDead() {
    if (lifespan <= 0.0 ||pos.x>width) {
      return true;
    } else {
      return false;
    }
  }
}

void keyPressed() {
  ps.add(new ParticleSystem(10, new PVector(random(width), random(width/4)), random(127, 350)));
if (key == 'r') {
    record = true;
  }
}

class Twinkle {
  PVector pos;
  float lifespan;
  float r;
  Twinkle(PVector t_origin, float _lifespan, float _r) {
    pos = t_origin.copy();
    lifespan = _lifespan;
    r = _r;
  }
  void run() {
    update();
    display();
  }
  void update() {
    lifespan -= random(5);
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    noStroke();
    lights();
    fill(255, lifespan);
    sphere(r+random(-.5, .5));
    popMatrix();
  }
  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
