class GyroRing implements Drawable {
  //ring should size should not be editted, only orientation
  private RingHollowCylinder ringBody;
  private SuperShape.VectorRotator rotator;
  private GyroRing childRing;
  
  //spin vector variables. ring should only spin in one direction unless acted upon
  private PVector axisOfRotation;
  private PVector rotationVector;
  private boolean rotationEnable;
  private float   rotationSpeed;
  
  public GyroRing(float diameter, float ringWidth) {
    this(diameter, ringWidth, color(154, 230, 232));
  }
  public GyroRing(float diameter, float ringWidth, GyroRing child) {
    this(diameter, ringWidth, color(154, 230, 232), new PVector(0, 1, 0), child);
  }
  public GyroRing(float diameter, float ringWidth, color ringColor) {
    this(diameter, ringWidth, ringColor, new PVector(1, 0, 0));
  }
  public GyroRing(float diameter, float ringWidth, color ringColor, GyroRing child) {
    this(diameter, ringWidth, ringColor, new PVector(1, 0, 0), child);
  }
  public GyroRing(float diameter, float ringWidth, color ringColor, PVector axis) {
    this(diameter, ringWidth, ringColor, axis, null);
  }
  public GyroRing(float diameter, float ringWidth, PVector axis) {
    this(diameter, ringWidth, color(154, 230, 232), axis, null);
  }
  public GyroRing(float diameter, float ringWidth, PVector axis, GyroRing child) {
    this(diameter, ringWidth, color(154, 230, 232), axis, child);
  }
  public GyroRing(float diameter, float ringWidth, color ringColor, PVector axis, GyroRing child) {
    ringBody = new RingHollowCylinder(diameter, ringWidth, ringColor);  //ring visual
    rotator = ringBody.getVectorRotatorObject();  //rotator object to change axis of rotation
    childRing = child;  //next inner ring in the gyro
    axisOfRotation = axis.copy();
    rotationVector = new PVector(0, 0, 0);
    rotationEnable = false;
  }
  
  void draw() {
    //debugging axis of rotation
    //stroke(#FFFF00);
    //line(0, 0, 0, 500*axisOfRotation.x, 500*axisOfRotation.y, 500*axisOfRotation.z);
    //line(0, 0, 0, -500*axisOfRotation.x, -500*axisOfRotation.y, -500*axisOfRotation.z);
    shape(ringBody);
    update(rotationVector);
  }
  
  public void rotateAxisOfRotation(PVector axisRotationVector) {
    //rotate axis of rotation by using SuperShape's vector rotator
    rotator.rotateVector(axisOfRotation, axisRotationVector);
    //update rotation vector
    rotationVector = axisOfRotation.copy().mult(PI/90 * rotationSpeed);
    //enable rotation
    rotationEnable = true;
    //rotate for the rotation of outer ring
    update(axisRotationVector);
  }
  public void spinOnAxis(float speed /*in degrees*/) {
    rotationSpeed  = speed;
    rotationVector = axisOfRotation.copy().mult(PI/90 * speed);
    rotationEnable = speed != 0;
  }
  public void stopSpinning() {
    spinOnAxis(0.0);
  }
  public void toggleSpinning() {
    if(rotationSpeed != 0) stopSpinning();
    else spinOnAxis(1.0);
  }
  
  private void update(PVector rotationVector) {
    if(rotationEnable) {
      ringBody.rotate(rotationVector);
      if(childRing != null) childRing.rotateAxisOfRotation(rotationVector);
    }
  }
  
  //class to represent the body of the ring
  private class RingHollowCylinder extends HollowCylinder {
    public RingHollowCylinder(float diameter, float ringWidth, color fillColor) {
      super((int)(diameter / 15), diameter / 2, ringWidth, ringWidth, fillColor, #000000);
    }
  }
}