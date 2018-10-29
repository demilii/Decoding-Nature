// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList<Star> particles;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are birthed

  PImage tex;

  ParticleSystem(int num, PVector v) {
    particles = new ArrayList();              // Initialize the arraylist
    origin = v.get();                        // Store the origin point
    for (int i = 0; i < num; i++) {
      particles.add(new Star(origin, 255, 255, 255));    // Add "num" amount of particles to the arraylist
    }
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Star p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle() {
    if (scoreLow >= scoreMid && scoreLow >= scoreHi) {
      particles.add(new Star(origin, 200, 110, 190));
    } else if (scoreMid >= scoreLow && scoreMid >= scoreHi) {
      particles.add(new Star(origin, 80, 110, 250));
    } else if (scoreHi >= scoreMid && scoreHi >= scoreLow) {
      particles.add(new Star(origin, 140, 110, 250));
    }
    //particles.add(new Star(origin, 255, 255, 255));
    particles.add(new Star(origin, 200, 110, 190));
    particles.add(new Star(origin, 80, 110, 250));
    particles.add(new Star(origin, 140, 110, 250));
  }

  //void addParticle(Star p) {
  //  particles.add(p);
  //}

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }
}
