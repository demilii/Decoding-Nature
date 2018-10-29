
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput input;
FFT fft;

float specLow = 0.015; // 1.5%, 
float specMid = 0.04;  // 5%,
float specHi = 0.1;   // 10%, 51.2

// scoring values for each zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

float scoreGlobal;


import processing.pdf.*;
boolean record;
ArrayList<ParticleSystem> ps;
PShader blur;
PImage img;
PImage bg;
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
int noOfPoints =2000;

Particle[] particles = new Particle[noOfPoints];
Particle[] particles2 = new Particle[noOfPoints];
PVector[] flowField;

void setup() {
  size(1728, 2304, P3D);
  minim = new Minim(this);
  input = minim.getLineIn();

  fft = new FFT(input.bufferSize(), input.sampleRate());
  orientation(LANDSCAPE);
  img1 = loadImage("s.png");
  bg = loadImage("bg2.tif");
  background(0);
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
    t_s.add(new Twinkle(new PVector(random(width), random(height), random(-100, 100)), random(100, 255), random(3, 5)));
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

  float scoreLow = 0;
  float scoreMid = 0;
  float scoreHi = 0;
  float scoreGlobal = 0;
  fft.forward(input.mix);
  for (int i = 0; i <fft.specSize()*0.1; i++) {
    scoreGlobal += fft.getBand(i);
  }


  for (int i = 0; i < fft.specSize()*specLow; i++) {
    scoreLow += fft.getBand(i); //returns the amplitude of frequency band i
  }

  for (int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++) {
    scoreMid += fft.getBand(i);
  }

  for (int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++) {
    scoreHi += fft.getBand(i);
  }
  println(scoreGlobal);
  //drawField();
  background(bg); 
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
      t_s.add(new Twinkle(new PVector(random(width), random(height), random(-100, 100)), random(100, 255), random(3, 5)));
    }
  }

  blendMode(ADD);
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
  
  if(scoreGlobal > 200){
    ps.add(new ParticleSystem(10, new PVector(random(3*width/4), random(height/8)), random(150, 350),scoreGlobal));
  }
  if (record) {
    //endRaw();
    saveFrame();
    record = false;
  }
  //filter(blur);
}


void keyPressed() {
  if (key == 'r') {
    record = true;
  } else {
    ps.add(new ParticleSystem(10, new PVector(random(width/4), random(height/8)), random(120, 300),scoreGlobal));
  }
}
