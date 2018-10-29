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
