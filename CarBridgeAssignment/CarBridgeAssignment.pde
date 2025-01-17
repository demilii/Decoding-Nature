// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Example demonstrating distance joints 
// A bridge is formed by connected a series of particles with joints

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
Box2DProcessing box2d;

// An object to describe a Bridget (a list of particles with joint connections)
Bridge bridge;

// A list for all of our rectangles
ArrayList<Car> cars;
Surface surface;
void setup() {
  size(1280, 640);
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();


  // Make the bridge
  bridge = new Bridge(width/2, width/20);
  // Create the surface
  surface = new Surface();
  // Create ArrayLists	
  cars = new ArrayList<Car>();
}

void draw() {
  background(255);

  // We must always step through time!
  box2d.step();

  // Draw the windmill
  bridge.display();

  for (Car c : cars) {
    c.display();
  }
  fill(0);
  //text("Click mouse to add boxes.", 10, height-10);
  
   surface.display();
   surface.display2();
}

void mousePressed() {

  Car c = new Car(mouseX, mouseY);
  cars.add(c);
}
