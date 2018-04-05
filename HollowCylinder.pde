class HollowCylinder extends SuperShape {
  
  public HollowCylinder(int sides, float r, float h, float w) {
    this(sides, r, h, w, #FFFFFF, #000000);
  }
  public HollowCylinder(int sides, float r, float h, float w, color fillColor, color strokeColor) {
    createHollowCylinder(sides, r, h, w, fillColor, strokeColor);
  }
  
  private void createHollowCylinder(int sides, float r, float h, float w, color fillColor, color strokeColor) {
    
    float angle = 360.0 / sides;
    float halfHeight = h / 2;
    
    PShape topSheet = createShape();
    PShape botSheet = createShape();
    PShape outBod = createShape();
    PShape inBod  = createShape();
    
    PShape topOutRim = createShape();
    PShape botOutRim = createShape();
    PShape topInRim = createShape();
    PShape botInRim = createShape();
    
    int i;
    float x;
    float y;
    //float z;
    
    //create body
    beginExteriorShapes(fillColor, outBod, inBod, topSheet, botSheet);
    //create top and bottom rims
    beginStrokeShapes(strokeColor, topOutRim, botOutRim, topInRim, botInRim);
    for (i = 0; i <= sides; i++) {
      //outer shapes, and sheets
      x = cos( radians( i * angle ) ) * r;
      y = sin( radians( i * angle ) ) * r;
      outBod.vertex( x, y, halfHeight);
      outBod.vertex( x, y, -halfHeight);
      topOutRim.vertex( x, y, halfHeight);
      botOutRim.vertex( x, y, -halfHeight);
      topSheet.vertex( x, y, halfHeight);
      botSheet.vertex( x, y, -halfHeight);
      //inner shapes, and sheets
      x = cos( radians( i * angle ) ) * (r - w);
      y = sin( radians( i * angle ) ) * (r - w);
      inBod.vertex( x, y, halfHeight);
      inBod.vertex( x, y, -halfHeight);
      topInRim.vertex( x, y, halfHeight);
      botInRim.vertex( x, y, -halfHeight);
      topSheet.vertex( x, y, halfHeight);
      botSheet.vertex( x, y, -halfHeight);
    }
    
    //add all parts to list of shapes
    addShapesInOrder(inBod, outBod, topSheet, botSheet, topOutRim, topInRim, botOutRim, botInRim);
    //end all shapes
    closeAllShapes();
  }
  
}