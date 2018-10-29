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
    acc.add(f.div(num));
  }

  public void show() {
    //stroke(255,50);
    //strokeWeight(5);
    //bezier(prevPos.x,prevPos.y,prevPos.x+pos.x/2,prevPos.y+pos.y/2,pos.x,pos.y,prevPos.x+pos.x/2,prevPos.y+pos.y/2);
    //line(prevPos.x,prevPos.y,pos.x,pos.y);
    //point(pos.x, pos.y);
    if (num == 1) {
      //tint(63, 120, 119, 10);
      tint(40, 95, 65, 15);
      image(img1, pos.x, pos.y);
    } else if (num == 2) {
      //tint(69, 91, 152, 10);
      tint(105, 225, 124, 5);
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
