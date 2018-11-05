class Car {
  // Our object is one box and two wheels
  CarShape box;
  Wheel wheel1;
  Wheel wheel2;

  Car(float x, float y) {
    // Initialize position of the box
    box = new CarShape(x, y, 90, 25, false);
    // Initialize position of two wheels
    wheel1 = new Wheel(x-15, y+8, false, 15);
    wheel2 = new Wheel(x+60, y+8, false, 15);

    // Define joints
    RevoluteJointDef rjd1 = new RevoluteJointDef();
    rjd1.initialize(box.body, wheel1.body, wheel1.body.getWorldCenter());
    rjd1.motorSpeed = -PI*2;
    rjd1.maxMotorTorque = 3000.0;
    rjd1.enableMotor = true;
    box2d.world.createJoint(rjd1);

    RevoluteJointDef rjd2 = new RevoluteJointDef();
    rjd2.initialize(box.body, wheel2.body, wheel2.body.getWorldCenter());
    rjd2.motorSpeed = -PI*2;
    rjd2.maxMotorTorque = 3000.0;
    rjd2.enableMotor = true;
    box2d.world.createJoint(rjd2);
  }

  void display() {
    box.display();
    wheel1.display();
    wheel2.display();
  }
}
