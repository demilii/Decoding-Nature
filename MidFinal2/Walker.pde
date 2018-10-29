class Walker {
  float x;
  float y;
  //float prevX;
  //float prevY;
  Walker() {
    x = width/2;
    y = height/2;
    //prevX = x;
    //prevY = y;
  }
  void step() {
    float r = random(1);
    if (r >0.02) {
      float rGaussianX =  randomGaussian()*random(10, 15);
      float rGaussianY =  randomGaussian()*random(-5, 7);
      x += rGaussianX;
      y += rGaussianY;
    } else {
      float rGaussianX =  randomGaussian()*random(100, 120);
      float rGaussianY =  randomGaussian()*random(80, 100);
      x += rGaussianX;
      y += rGaussianY;
    }

    hue -= div;
    hue += random(-1, 1);

    if (hue > 255) {
      hue =0;
    }
    if (hue < 0) {
      hue = 255;
    }
    println(hue);
    //if (hue < 100) hue += 150;
  }
  void display() {
    for (int i=0; i<3000; i++) {
      float r = random(-4*width/16, 4* width/16);
      float t = random(0, 2*PI);

      fill(hue, 150, 255, 1);
      dot = 3;
      if (random(0, 10000) < 0.1) {
        fill(0, 0, 255, random(80, 150));
        dot = random(5, 10);
      }
      noStroke();

      ellipse(x+ r*cos(t), y+ r*sin(t), dot, dot);
      //ellipse(x+ r*cos(t)-width/2, y+ r*sin(t)-height/2, dot, dot);
    }
  }

  void update() {
    if (x > width) {
      x = 0;
    }
    if (x <0) {
      x = width;
    }
    if (y > height) {
      y = 0;
    }
    if (y <0) {
      y = height;
    }
  }
}
