class Attractor {
  float mass = 100;
  PVector loc;
  float distance;
  Attractor(float x, float y, float _mass) {
    loc = new PVector (x, y);
    mass = _mass;
  }

  PVector attractionForce(Particle m) {
    PVector force = PVector.sub(loc, m.loc);
    distance = force.mag();
    force.normalize();

    float forceMag = (200*mass*m.mass)/(distance*distance);
    //force.mult(forceMag);
    return force;
  }

  void display() {
    ellipse(loc.x, loc.y, 10, 10);
  }
}
