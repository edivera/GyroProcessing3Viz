void shape(SuperShape ss) {
  ss.draw();
}

abstract class SuperShape {
  
  private final VectorRotator rotator = new VectorRotator();
  private final PVector y2DUnitVector = new PVector(0, 1);
  
  private ArrayList<PShape> shapes;
  protected PVector normal;
  
  public SuperShape() {
    shapes = new ArrayList<PShape>();
    normal = new PVector(0, 0, 1);
  }
  public void draw() {
    for(PShape pshape : shapes) {
      shape(pshape);
    }
    //debugging normal vector
    //stroke(#007F00);
    //line(0, 0, 0, normal.x * 500, normal.y * 500, normal.z * 500);
  }
  
  public VectorRotator getVectorRotatorObject() {
    //returns the useful vector rotator
    return rotator;
  }
  public void rotate(PVector rotationVector) {
    //it's in order to update normal vector
    rotateX(rotationVector.x);
    rotateY(rotationVector.y);
    rotateZ(rotationVector.z);
    updateNormal(rotationVector);
  }
  public void rotateX(float radians) {
    for(PShape pshape : shapes) {
      pshape.rotateX(radians);
    }
  }
  public void rotateY(float radians) {
    for(PShape pshape : shapes) {
      pshape.rotateY(radians);
    }
  }
  public void rotateZ(float radians) {
    for(PShape pshape : shapes) {
      pshape.rotateZ(radians);
    }
  }
  
  protected void addShapesInOrder(PShape... shapesToAdd) {
    for(int i = 0; i < shapesToAdd.length; i++) {
      shapes.add(shapesToAdd[i]);
    }
  }
  protected void beginExteriorShapes(color strokeAndFill, PShape... shapesToBegin) {
    beginExteriorShapes(strokeAndFill, strokeAndFill, shapesToBegin);
  }
  protected void beginExteriorShapes(color stroke, color fill, PShape... shapesToBegin) {
    for(PShape shape : shapesToBegin) {
      beginExteriorShape(shape, stroke, fill);
    }
  }
  protected void beginExteriorShape(PShape shape, color strokeAndFill) {
    beginExteriorShape(shape, strokeAndFill, strokeAndFill);
  }
  protected void beginExteriorShape(PShape shape, color stroke, color fill) {
    shape.beginShape(TRIANGLE_STRIP);
    shape.stroke(stroke);
    shape.fill(fill);
  }
  protected void beginStrokeShapes(color stroke, PShape... shapesToBegin) {
    for(PShape shape : shapesToBegin) {
      beginStrokeShape(shape, stroke);
    }
  }
  protected void beginStrokeShape(PShape shape, color stroke) {
    shape.beginShape();
    shape.stroke(stroke);
    shape.noFill();
  }
  protected void closeAllShapes() {
    //assumes all shapes are in shapes arraylist
    for(PShape shape : shapes) {
      shape.endShape(CLOSE);
    }
  }
  
  private void updateNormal(PVector rotationVector) {
    //rotate normal vector using vector rotator
    rotator.rotateVector(normal, rotationVector);
  }
  
  //class to generalize vector rotation formula
  private class VectorRotator {
    public void rotateVector(PVector vectorToRotate, PVector rotationVector) {
      //renaming
      PVector vect = vectorToRotate;
      
      //pointer objects
      FloatPtr vectX = new FloatPtr(vect.x);
      FloatPtr vectY = new FloatPtr(vect.y);
      FloatPtr vectZ = new FloatPtr(vect.z);
    
      //if there is rotation vector component, apply rotation formulas
      if(rotationVector.x != 0) {
        applyNormalRotationFormulaFor(vectY, vectZ, -rotationVector.x);
      }
      if(rotationVector.y != 0) {
        applyNormalRotationFormulaFor(vectX, vectZ, rotationVector.y);
      }
      if(rotationVector.z != 0) {
        applyNormalRotationFormulaFor(vectX, vectY, -rotationVector.z);
      }
      //update normal vector with final updated values
      vect.x = vectX.value;
      vect.y = vectY.value;
      vect.z = vectZ.value;
    }
    
    private void applyNormalRotationFormulaFor(FloatPtr var1, FloatPtr var2, float var3Rotation) {
      float hypLength;
      float rotationAngle;
      PVector normalToAxis;
    
      //calculate current normal angle using var1 and var2
      normalToAxis = new PVector(var1.value, var2.value);
      hypLength = normalToAxis.mag();
      rotationAngle = angleBetween(y2DUnitVector, normalToAxis.normalize());
    
      //rotate normal around y first
      rotationAngle += var3Rotation;
      var1.value = hypLength * sin(rotationAngle);
      var2.value = hypLength * cos(rotationAngle);
      //return var1 and var2 by reference
    }
    /* sample of the rotation formula for var1=x, var2=z, var3Rotation=rotationVector.y
    
      //find the vector normal to the y axis, projection of normal onto x-z plane
      normalToAxis = new PVector(normal.x, 0, normal.z);
      //find magnitude of the projection
      hyp = normalToAxis.mag();
      //find angle from the z axis to the projection
      angleRotation.y = angleBetween(zUnitVector, normalToAxis.copy().normalize());
      
      //increment angle of rotation by rotation vector y value
      angleRotation.y += rotationVector.y;
      //rotate projection vector about the y axis, and update noraml.x and normal.z
      normal.x = hyp * sin(angleRotation.y);
      normal.z = hyp * cos(angleRotation.y);      
    */
    private float angleBetween(PVector vect1, PVector vect2) {
      float angle = PVector.angleBetween(vect1, vect2);
      if(vect2.x < 0) { //i.e. quadrants 2 and 3
        angle = TWO_PI - angle;
      }
      return angle;
    }
  }
  //return by reference object for floats
  private class FloatPtr {
    public Float value;
    public FloatPtr(float _value) {
      value = _value;
    }
    @Override
    public String toString() {
      return value.toString();
    }
  }
  
}