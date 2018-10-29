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
float max_freq_low;
float max_freq_mid;
float max_freq_high;

int num = 3500; //how many particles we'll have in the system. More particles = slower sketch.
Particle[] particle = new Particle[num]; 

int particleCount = 800;
iso[] iso = new iso[particleCount+1];
Attractor a1;
Attractor a2;
Attractor a3;

ArrayList<Twinkle> t_s;
int t_num =5;
void setup() {
  //fullScreen();
  size(3072,2304);
  smooth();
  background(0, 0, 0);
  minim = new Minim(this);
  input = minim.getLineIn();

  fft = new FFT(input.bufferSize(), input.sampleRate());

  for (int i=0; i<particle.length; i++) {
    particle[i] = new Particle(random(0, width), random(0, height), 2, 100);
  }

  a1 = new Attractor(width/6, height/2, 1);
  a2 = new Attractor(width/2, height/2, 1);
  a3 = new Attractor(5*width/6, height/2, 1);
  t_s = new ArrayList();
  for (int i=0; i<t_num; i++) {
    t_s.add(new Twinkle(new PVector(random(width), random(height)), random(50), random(3, 6)));
  }

  for (int x = particleCount; x >= 0; x--) { 
    iso[x] = new iso();
  }
}

void draw() {
  float turn = 0;
  float max_amp_low = 0;
  float max_amp_mid = 0;
  float max_amp_high = 0;
  float mal = 0;//max amplitude for low freq after mapping
  float mam = 0;
  float mah = 0;
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;

  fft.forward(input.mix);


  for (int i = 0; i < fft.specSize()*specLow; i++) {
    float amp_temp_low = fft.getBand(i);
    scoreLow += amp_temp_low; //returns the amplitude of frequency band i
    if (amp_temp_low > max_amp_low) {
      max_amp_low = amp_temp_low;
      if (max_amp_low > 10) {
        max_amp_low = 10;
      }
      //mal = constrain(max_amp_low, 0, 100);
      mal = map(max_amp_low, 0.0, 10.0, 0, height/2); // change the map value
      max_freq_low = map(i, 0, 7, 0, width/3);
    }
  }

  for (int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++) {
    float amp_temp_mid = fft.getBand(i);
    scoreMid += amp_temp_mid;
    if (amp_temp_mid > max_amp_low) {
      max_amp_mid = amp_temp_mid;
      //mah = constrain(max_amp_mid, 0, 100);
      if (max_amp_mid > 10) {
        max_amp_mid = 10;
      }
      mam = map(max_amp_mid, 0.0, 10.0, 0, height/2);
      max_freq_mid = map(i, 7, 20, width/3, 2*width/3);
    }
  }

  for (int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++) {
    float amp_temp_high = fft.getBand(i);
    scoreHi += amp_temp_high;
    if (amp_temp_high > max_amp_low) {
      max_amp_high = amp_temp_high;
      //mah = constrain(max_amp_mid, 0, 100);
      if (max_amp_high > 10) {
        max_amp_high = 10;
      }
      mah = map(max_amp_high, 0.0, 10.0, 0, height/2);
      max_freq_high= map(i, 20, 51, 2*width/3, width);
    }
  }
  a1.loc.x = max_freq_low;
  a1.loc.y = 3*height/4-mal;
  a2.loc.x = max_freq_mid;
  a2.loc.y = 3*height/4-mam;
  a3.loc.x = max_freq_high;
  a3.loc.y = 3*height/4-mah;

  //scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  for (Particle p : particle) {
    p.applyForce(a1.attractionForce(p));
    p.applyForce(a2.attractionForce(p));
    p.applyForce(a3.attractionForce(p));

    p.update();
    p.bounds();
    int r = int(random(3));
    if (r == 0) {
      p.display(a1);
    }
    if (r == 1) {
      p.display(a2);
    }
    if (r == 2) {
      p.display(a3);
    }
  }
  //draw twinkling star
  for (int i = t_s.size()-1; i>0; i--) {
    Twinkle t = t_s.get(i);
    t.run();
    if (t.isDead()) {
      t_s.remove(t);
    }
  }

  if (t_s.size() < t_num) {
    for (int i = 0; i <= 1; i++) {
      t_s.add(new Twinkle(new PVector(random(width), random(height)), random(30), random(3, 6)));
    }
  }

  if (mal + mam+ mah >=3550) {
    for (int i = particleCount; i >= 0; i--) { 
      iso p = (iso) iso[i];
      p.update(0);
    }
  }
  //a1.display();
  //a2.display();
  //a3.display();
  print("low: ");
  println(mal);
  print("mid: ");
  println(mam);
  print("high: ");
  println(mah);
}

void keyPressed() {
  saveFrame();
}

void mousePressed() {
  for (int i = particleCount; i >= 0; i--) { 
    iso p = (iso) iso[i];
    p.update(0);
  }
}
