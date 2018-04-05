class GyroScene extends Scene {
  private final PVector xAxis = new PVector(1, 0, 0);
  private final PVector yAxis = new PVector(0, 1, 0);
  private final PVector zAxis = new PVector(0, 0, 1);
  
  private int numRings;

  //six rings gyro constructor
  public GyroScene() {
    this(6);
  }
  //any rings constructor
  public GyroScene(int rings) {
    if(rings <= 0) return;
    numRings = rings;
    createNewRings();
    spinAll(1.0);
  }
  
  void keyPressed() {
    switch(key) {
      case '0': stopAll(); break;
      case '1': spinAll(1.0); break;
      case '9': resetScene(); break;
      default:
        toggleSpinning(key - 0x30 - 2);
        break;
    }
  }
  
  public void spinAll(float speed) {
    for(Drawable object : sceneObjects) {
      if(object instanceof GyroRing) {
        ((GyroRing)object).spinOnAxis(speed);
      }
    }
  }
  public void stopAll() {
    spinAll(0);
  }
  
  private void createNewRings() {
    //add the first ring
    sceneObjects.add(new GyroRing(200, 50, xAxis.copy()));
    //add the outer 5 rings
    for(int ringi = 1; ringi < numRings; ringi++) {
      sceneObjects.add(new GyroRing(200 + ringi * 80, 40, (ringi%2 == 0) ? 
        xAxis.copy() : yAxis.copy(), (GyroRing)sceneObjects.get(ringi-1)));
    }
  }
  private void removeRings() {
    sceneObjects = new ArrayList<Drawable>();
  }
  private void resetScene() {
    removeRings();
    createNewRings();
  }
  private void toggleSpinning(int ringi) {
    if(ringi < 0 || ringi >= numRings) return;
    GyroRing ring = (GyroRing)(sceneObjects.get(ringi));
    if(ring != null) ring.toggleSpinning();
  }
  
}