Walker w;
float div;

float hue = 250;
float dot = 3;
//import the real-time sound analysis library
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

float angle = 0;
float a_speed = PI/1000;

float[] a = new float[12];
float[] b = new float[12];
float[] x= new float[12];
float[] y = new float[12];
float[]  prev_x= new float[12];
float[] prev_y = new float[12];
void setup() {
  minim = new Minim(this);
  input = minim.getLineIn();
  smooth();
  fft = new FFT(input.bufferSize(), input.sampleRate()); 
  size(3072, 2304);
  background(0);
  w = new Walker();
  colorMode(HSB, 255);

  for (int i = 0; i < 12; i++) {
    a[i] = 300 + 110*i;
    b[i] = 60 + 55*i;
    x[i] = width/2+a[i]*cos(angle);
    y[i] = height/2+b[i]*sin(angle);
    prev_x[i] = x[i];
    prev_y[i] = y[i];
  }
}

void draw() {
  fft.forward(input.mix); 
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;

  for (int i = 0; i < fft.specSize()*specLow; i++) {
    scoreLow += fft.getBand(i); //returns the amplitude of frequency band i
  }

  for (int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++) {
    scoreMid += fft.getBand(i);
  }

  for (int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++) {
    scoreHi += fft.getBand(i);
  }

  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  //println(scoreGlobal);

  div = map(scoreGlobal, 0, 200, 0, 1);
  a_speed = map(scoreGlobal, 0, 120, PI/100, PI/200);
  //println(div);
  //println(frameCount);
  w.step();
  w.update();
  w.display();
  if (frameCount>=10000&&frameCount<=13000) {
    for (int i=0; i<10; i++) {
      x[i] = width/2+a[i]*cos(angle);
      y[i]= (height/2+b[i]*sin(angle))+randomGaussian()*5;
      if (frameCount%180 == 0||frameCount%180 == 10||frameCount%180 == 15) {
        strokeWeight(random(3));
        stroke(0, 0, 255, 50);
        point(x[i], y[i]);
      }
      strokeWeight(1);
      stroke(0, 0, 255, random(20)+15*sin(angle));
      line(prev_x[i], prev_y[i], x[i], y[i]);

      prev_x[i] = x[i];
      prev_y[i] = y[i];
    }

    angle+=a_speed;
  }
}

void keyPressed() {
  saveFrame();
}
