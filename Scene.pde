abstract class Scene {
  ArrayList<Drawable> sceneObjects;
  public Scene() {
    sceneObjects = new ArrayList<Drawable>();
  }
  void draw() {
    for(Drawable object: sceneObjects) {
      object.draw();
    }
  }
  abstract void keyPressed();
}