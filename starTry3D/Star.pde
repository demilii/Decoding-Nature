// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Simple Particle System

class Star {
  PVector pos;
  PVector vel;
  PVector acc;
  float lifespan;
  float _r, _g, _b;
  float damping;
  // Another constructor (the one we are using here)
  Star(PVector l, float r, float g, float b) {
    // Boring example with constant acceleration
    acc = new PVector(random(-0.5, 0.2), random(-0.4, 0.2));
    vel = new PVector(random(-1, 1), random(-1, 1));
    vel.mult(2);
    pos = l.copy();
    lifespan = 150;
    damping = 0.99;
    _r = r;
    _g = g;
    _b = b;
  }

  void run() {
    update();
    render();
  }

  // Method to update position
  void update() {
    vel.add(acc);
    vel.mult(damping);
    pos.add(vel);
    lifespan -= 0.4;
  }

  // Method to display
  void render() {
    imageMode(CENTER);
    tint(_r, _g, _b, lifespan);
    //tint(scoreMid*50,255,scoreHi*50,lifespan);
    image(img, pos.x, pos.y);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
