class CarShape {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;

  // Constructor
  CarShape(float x, float y, float w_, float h_, boolean lock) {
    w = w_;
    h = h_;

    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(new Vec2(x, y)));
    if (lock) bd.type = BodyType.STATIC;
    else bd.type = BodyType.DYNAMIC;

    body = box2d.createBody(bd);
    Vec2[] vertices = new Vec2[5];
    vertices[0]  = box2d.vectorPixelsToWorld(new Vec2(-w/2+w/4, h/2));
    vertices[1]  = box2d.vectorPixelsToWorld(new Vec2(-w/2, 5*h/16));
    vertices[2]  = box2d.vectorPixelsToWorld(new Vec2(-w/2+w/4, -h/4));
    vertices[3]  = box2d.vectorPixelsToWorld(new Vec2(w/2+w/4, -h/2));
    vertices[4]  = box2d.vectorPixelsToWorld(new Vec2(w/2+w/4+w/8, h/2));
    //vertices[4]  = box2d.vectorPixelsToWorld(new Vec2(-w/2, -h/2));
    // Define the shape -- a  (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    sd.set(vertices, vertices.length);
    //float box2dW = box2d.scalarPixelsToWorld(w/2);
    //float box2dH = box2d.scalarPixelsToWorld(h/2);
    //sd.setAsBox(box2dW, box2dH);


//    Vec2[] vertices2 = new Vec2[3];5//    vertices2[0]  = box2d.vectorPixelsToWorld(new Vec2(w/2, -h/2));
//    vertices2[1]  = box2d.vectorPixelsToWorld(new Vec2(w/2+10, h/2));
//    vertices2[2]  = box2d.vectorPixelsToWorld(new Vec2(w/2, h/2));

//    // Define the shape -- a  (this is what we use for a rectangle)
//    PolygonShape sd1 = new PolygonShape();
//    sd1.set(vertices2, vertices2.length);
    //CircleShape cs = new CircleShape();
    //cs.m_radius = box2d.scalarPixelsToWorld(h);
    //Vec2 offset = new Vec2(w/2, -h/2);
    //println(offset);
    //offset = box2d.vectorPixelsToWorld(offset);
    //cs.m_p.set(offset.x, offset.y);


    //CircleShape cs1 = new CircleShape();
    //cs1.m_radius = box2d.scalarPixelsToWorld(h/2);
    //Vec2 offset1 = new Vec2(-w/2, -h/2);
    //offset1 = box2d.vectorPixelsToWorld(offset1);
    //cs.m_p.set(offset1.x, offset1.y);


    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;

    // Parameters that affect physics
    fd.density = .01;
    fd.friction = 0.1;
    fd.restitution = 0.5;

    //FixtureDef c = new FixtureDef();
    //c.shape = sd1;

    //// Parameters that affect physics
    //c.density = .01;
    //c.friction = 0.1;
    //c.restitution = 0.5;

    //FixtureDef c1 = new FixtureDef();
    //c1.shape = cs;

    //// Parameters that affect physics
    //c1.density = .01;
    //c1.friction = 0.1;
    //c1.restitution = 0.5;

    body.createFixture(fd);
    //body.createFixture(c);
    //body.createFixture(c1);
    body.setLinearVelocity(new Vec2(0, 0));
    body.setAngularVelocity(0);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  Vec2 pos() {
    Vec2 pos = box2d.getBodyPixelCoord(body);

    return pos;
  }

  // Drawing the box
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    Fixture f = body.getFixtureList();
    PolygonShape sd = (PolygonShape) f.getShape();

    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(127);
    stroke(0);
    strokeWeight(1);
    beginShape();
    //println(vertices.length);
    // For every vertex, convert to pixel vector
    for (int i = 0; i < sd.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(sd.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    //rect(0, 0, w, h);
    //arc(w/2, h/2, 2*h, 2*h, PI+HALF_PI, TWO_PI);
    //arc(-w/2, h/2, 2*h, 2*h, PI, HALF_PI+PI);
    popMatrix();
  }
}
