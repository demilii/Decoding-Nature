class Twinkle {
  PVector pos;
  float lifespan;
  float lifespan_c;
  float r;
  Twinkle(PVector t_origin, float _lifespan,float _r) {
    pos = t_origin.copy();
    lifespan = _lifespan;
    lifespan_c= _lifespan;
    r = _r;
  }
  void run() {
    update();
    display();
  }
  void update() {
    lifespan -= .05;
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    noStroke();
    //lights();
    fill(255, lifespan_c);
    ellipse(0,0,r+random(-.5,.5),r+random(-.5,.5));
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
