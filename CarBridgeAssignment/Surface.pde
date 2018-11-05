// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// Box2DProcessing example

// An uneven surface boundary

class Surface {
  // We'll keep track of all of the surface points
  ArrayList<Vec2> surface1;
  ArrayList<Vec2> surface2;

  Surface() {
    surface1 = new ArrayList<Vec2>();
    surface2 = new ArrayList<Vec2>();
    // This is what box2d uses to put the surface in its world
    ChainShape chain = new ChainShape();
    ChainShape chain1 = new ChainShape();

    // Perlin noise argument
    float xoff = 0.0;

    // This has to go backwards so that the objects  bounce off the top of the surface
    // This "edgechain" will only work in one direction!
    float y = height/2;
    for (float x = width/4; x > -10; x -= 5) {

      // Doing some stuff with perlin noise to calculate a surface that points down on one side
      // and up on the other
      float diff = map(noise(xoff), 0, 1, 0 ,-5);

      y = y+diff;
      // Store the vertex in screen coordinates
      if (x == width/4) {
        y = height/2;
      }
      surface1.add(new Vec2(x, y));

      // Move through perlin noise
      xoff += 0.07;
    }

    for (float x = 3*width/4; x < width+10; x += 5) {

      // Doing some stuff with perlin noise to calculate a surface that points down on one side
      // and up on the other
      float diff = map(noise(xoff), 0, 1, 0, -4);

      y = y+diff;
      // Store the vertex in screen coordinates
      if (x == 3*width/4) {
        y = height/2;
      }
      surface2.add(new Vec2(x, y));

      // Move through perlin noise
      xoff += 0.07;
    }
    // Build an array of vertices in Box2D coordinates
    // from the ArrayList we made
    Vec2[] vertices = new Vec2[surface1.size()];
    Vec2[] vertices2 = new Vec2[surface2.size()];
    for (int i = 0; i < vertices.length; i++) {
      Vec2 edge = box2d.coordPixelsToWorld(surface1.get(i));
      vertices[i] = edge;
    }
    for (int i = 0; i < vertices2.length; i++) {
      Vec2 edge = box2d.coordPixelsToWorld(surface2.get(i));
      vertices2[i] = edge;
    }
    // Create the chain!
    chain.createChain(vertices, vertices.length);
    chain1.createChain(vertices2, vertices2.length);
    // The edge chain is now attached to a body via a fixture
    BodyDef bd = new BodyDef();
    bd.position.set(0.0f, 0.0f);
    Body body = box2d.createBody(bd);
    // Shortcut, we could define a fixture if we
    // want to specify frictions, restitution, etc.
    body.createFixture(chain, 1);
    body.createFixture(chain1, 1);
  }

  // A simple function to just draw the edge chain as a series of vertex points
  void display() {
    strokeWeight(4);
    stroke(0);
    noFill();
    beginShape();
    for (Vec2 v : surface1) {
      vertex(v.x, v.y);
    }
    endShape();
  }
  
  void display2() {
    strokeWeight(4);
    stroke(0);
    noFill();
    beginShape();
    for (Vec2 v : surface2) {
      vertex(v.x, v.y);
    }
    endShape();
  }
}
