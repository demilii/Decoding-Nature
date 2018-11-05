class Wheel {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  //boolean noMove=false;

  Wheel(float x, float y, boolean noMove, float radius) {
    r = radius;

    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    if (noMove)
      bd.type = BodyType.STATIC;
    else
      bd.type = BodyType.DYNAMIC;
    if (r<10)
      bd.fixedRotation = true; 
    body = box2d.world.createBody(bd);



    Vec2[] vertices = new Vec2[6];
    vertices[0]  = box2d.vectorPixelsToWorld(new Vec2(r, 0));
    vertices[1]  = box2d.vectorPixelsToWorld(new Vec2(r/2, sqrt(3)*r/2));
    vertices[2]  = box2d.vectorPixelsToWorld(new Vec2(-r/2, sqrt(3)*r/2));
    vertices[3]  = box2d.vectorPixelsToWorld(new Vec2(-r, 0));
    vertices[4]  = box2d.vectorPixelsToWorld(new Vec2(-r/2, -sqrt(3)*r/2));
    vertices[5]  = box2d.vectorPixelsToWorld(new Vec2(r/2, -sqrt(3)*r/2));

    Vec2[] vertices2 = new Vec2[3];
    vertices2[0]  = box2d.vectorPixelsToWorld(new Vec2(r,-sqrt(3)*r/2));
    vertices2[1]  = box2d.vectorPixelsToWorld(new Vec2(0, sqrt(3)*r/2));
    vertices2[2]  = box2d.vectorPixelsToWorld(new Vec2(-r, -sqrt(3)*r/2));
    PolygonShape sd = new PolygonShape();
    sd.set(vertices2, vertices2.length);
    // Make the body's shape a circle
    //CircleShape cs = new CircleShape();
    //cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 10;
    fd.friction = 1;
    fd.restitution = 0.0;

    // Attach fixture to body
    body.createFixture(fd);
    body.setLinearVelocity(new Vec2(0, 0));
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    Fixture f = body.getFixtureList();
    PolygonShape sd = (PolygonShape) f.getShape();
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(127);
    stroke(0);
    strokeWeight(2);
    beginShape();
    //println(vertices.length);
    // For every vertex, convert to pixel vector
    for (int i = 0; i < sd.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(sd.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    //ellipse(0, 0, r*2, r*2);
    // Let's add a line so we can see the rotation
    //line(0, 0, r, 0);
    popMatrix();
  }
}
