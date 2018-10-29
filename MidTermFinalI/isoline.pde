class iso {
  /* 
   Global class variables
   Angle is measured in radians, Radius is the distance each particle is from center, previous is the previous points of the particles for tail drawing, 
   dec is the constant rate of rotation (determined by radius), while turnVelocity is the rate of rotation determined by the user's cursor
   tilt is the tilt of the particle's rotation
   */
  float angle;
  float radius;
  PVector previous = new PVector();
  float dec;
  float tilt;
  float turnVelocity;
  iso() {
    /* 
     This function creates the particle
     Our angle is measured in radians, and because of this, we have a random number between 0.00 and 6.28.
     Note that 6.28, or 2*Pi is about a full circle in radians
     radius is between 70 and 200 pixels from the center, 
     and the tilt is between 60 below to 60 above.  Dec is propotional to the distance from the center  
     */
    angle = random(0, 628) * 0.01;
    radius = random(350, 600);
    tilt = random(-180, 200);
    dec = (200 - radius) * 0.00014;
  }
  void update (float turn) {
    /* 
     This function updates the particle. It is the ultimate formula the particle abides to
     the coordinate uses traditional trigonometric formulas to rotate the particle around the origin.
     Remember that y is up and down.
     */
    PVector current = new PVector(radius * cos(angle)+width/2, tilt -50 * cos(angle + 3.5)-3*height/16, radius * sin(angle));

    /* 
     Checks to see if turn is done. we make sure it doesn't equal zero because by default it's zero, and so that the turning won't stop suddenly 
     (0 * anything = 0, so it'd instantly stop the turning if the cursor has stopped. we don't want that) 
     */
    if (turn != 0)
      turnVelocity = turn * (201-radius);

    /* The angle is decreased by its regular rotation, and the turnVelocity determined by the user */
    angle -= dec + turnVelocity;
    /* Simulate friction in the turn velocity. */
    turnVelocity *= 0.95;

    /* 
     This sets previous coordinates just for the first frame, to allow the animation to start off a little more cleanly */
    if (previous.x == 0) {
      previous.set(current);
    }

    /* 
     The isoline function is called  
     Isoline takes our (x,y,z) coordinates and renders them as (x,y) coordinates.
     */
    isoLine(current, previous, angle);

    /* Previous coordinates are updated. They're for the next frame, so a trail can be drawn behind each particle. */
    previous.set(current);
  }
}  

void isoLine(PVector begin, PVector end, float angle) {
  /* 
   Isoline Function (begin coordinate, end coordinate,angle)
   both begin coordinates and end coordinates are calculated using the same isometric formula.
   these formulas have been simplified though
   they were formerly ((x - z) * cos(radians(30)) + width/2, (x + z) * sin(radians(30)) - y + height/2)
   The function pretty much adjusts each x and z coordinate to be 30 degrees from the x axis, giving the illusion of 3D
   
   The cosine and sine are constant, so they could be precalculated. Cosine of 30 degrees returns roughly 0.866, which is rounded to 1
   Leaving it out would be seemless, unless placed side-by-side to more accurate renderings, where everything would appear wider in this version
   */
  PVector newBegin = new PVector(int(begin.x - begin.z), int((begin.x + begin.z)/2 - begin.y));
  PVector newEnd = new PVector(int(end.x - end.z), int((end.x + end.z)/2 - end.y));

  /* 
   The angle is only used to calculate the shade of each particle 
   Since the RGB mode is set so that the color values are in between 0 and 2, and since the cosine + 1 is between 1 and 2, no multiplying is necessary.
   */
  stroke(255, 60+70*cos(angle));

strokeWeight(1);
  /* The line is drawn using the newly calculated (x1,y1) and (x2,y2) coordinates */
  //point(newEnd.x, newEnd.y);
  line (newBegin.x, newBegin.y, newEnd.x, newEnd.y);
  //  noStroke();
  //  fill(2, 0.1);
  //ellipse(newEnd.x, newEnd.y,3,3);
}
