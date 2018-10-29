class Particle {
  PVector loc, vel, acc;
  float mass;
  int r;
  float xstart, xnoise, ystart, ynoise;    
  float Factor;
  Particle(float x, float y, int _r, float _mass) {
    loc = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    mass = _mass;
    r = _r;
    xstart = random(10); 
    ystart = random(10);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  void update() {
    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
  }

  void bounds() {
    if (loc.y > height || loc.y < 0) {
      vel.y *= -1;
    }
    if (loc.x > width || loc.x < 0) {
      vel.x *= -1;
    }
  }

  void display(Attractor a) {
    noStroke();
    if (scoreLow > scoreMid && scoreLow > scoreHi) {
      fill(0, a.distance, 255, 2);
      //fill(0, 255, a.distance, 1);
      //fill(0, 0, 128, 3);
    } else if (scoreMid >= scoreLow && scoreMid >= scoreHi) {
      fill(0, 255, a.distance, 1);
      //fill(0, a.distance, 255, 3);
      //fill( 151 ,255 ,255,1);
     
    } else if (scoreHi >= scoreMid && scoreHi >= scoreLow) {
      fill(a.distance, 0, 255, 2);
      //fill(218,112, 190, 1);
    }

    ellipse(loc.x, loc.y, r, r);
  }
}
