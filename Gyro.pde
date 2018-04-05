/*
  Edilio Vera
  Overflow
  March 2018
*/
import peasy.*;

//easy camera control
PeasyCam cam;

//some geneeral unit vectors
final PVector xAxis = new PVector(1000, 0, 0);
final PVector yAxis = new PVector(0, 1000, 0);
final PVector zAxis = new PVector(0, 0, 1000);

//project scene variables
Scene[] projectScenes;
int numberOfScenes = 1;
int currentScene = 0;

void settings() {
  //size(1000, 1000, P3D);
  fullScreen(P3D);
}

void setup() {
  cam = new PeasyCam(this, 1000);
  projectScenes = new Scene[numberOfScenes];
  projectScenes[0] = new GyroScene();
}

void draw() {
  background(#7F7F7F);
  //drawAxis();
  projectScenes[currentScene].draw();
}

void drawAxis() {
  drawVector(xAxis, #00FF00);
  drawVector(yAxis, #FF0000);
  drawVector(zAxis, #0000FF);
}

void drawVector(PVector lineVector, color strokeColor) {
  stroke(strokeColor);
  line(0, 0, 0, lineVector.x, lineVector.y, lineVector.z);
}

void keyPressed() {
  projectScenes[currentScene].keyPressed();
}