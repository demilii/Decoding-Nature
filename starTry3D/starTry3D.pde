PImage bg;
int particleCount = 3500;
/* A particle array is made using our particle count. */
Particle[] particles = new Particle[particleCount+1];
ParticleSystem ps;
float x = width/2, y = height/2;
//import the real-time sound analysis library
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput input;
FFT fft;
boolean first = true;
float specLow = 0.015; // 1.5%, 
float specMid = 0.04;  // 5%,
float specHi = 0.1;   // 10%, 51.2

// scoring values for each zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

float scoreGlobal;
PImage img;

void setup() {
  size(2304, 1728);
  //background(0);
 bg = loadImage("bgd.png");
  for (int x = particleCount; x >= 0; x--) { 
    particles[x] = new Particle();
  }
  smooth();
  //frameRate(24);
  // Create an alpha masked image to be applied as the particle's texture
  img = loadImage("texture.png");
  minim = new Minim(this);
  input = minim.getLineIn();

  fft = new FFT(input.bufferSize(), input.sampleRate());
  ps = new ParticleSystem(0, new PVector(width/2, height/2));
}

void draw() {

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
  float _scoreGlobal = map(scoreGlobal, 0, 40, 3, 8);
  blendMode(ADD);
  //ps.origin.set(random(7*width/8,width), random(height/2-height/8, height/2+height/8), scoreGlobal);
  ps.origin.set(width/2, height/2, scoreGlobal);

  background(bg);

  ps.run();
  for (int i = 0; i < _scoreGlobal; i++) {
    ps.addParticle();
  }
  float turn = 0;
  /* 
   check to see if the user is clicking 
   if the user is, then the turnVelocity is calculated. It's determined by the x (horizontal) distance between the previous and current mouse position
   It's multiplied by 0.00001 to tone down the speed, and in the class itself it's later multiplied by (201 - radius), to have particles closer to center move faster than ones on outside.
   It's done this way to avoid having to recalculate (mouseX - pmouseX) * 0.00001 for every particle.
   */


  //if (mousePressed) 
  //  turn = (mouseX - pmouseX) * 0.00001;

  /* Loop through the particles, and update them */

  for (int i = particleCount; i >= 0; i--) { 
    Particle particle = (Particle) particles[i];
    particle.update(turn);
  }
}

void keyPressed() {
  if (key == 'r') {
    saveFrame();
  }
}
