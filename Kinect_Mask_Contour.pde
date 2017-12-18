java.awt.Polygon kinectMask = new java.awt.Polygon();

PVector maskTL;
PVector maskBL;
PVector maskBR;
PVector maskTR;

ArrayList<PVector> maskCornersKinect = new ArrayList<PVector>();
ArrayList<PVector> prevMaskCornersKinect = new ArrayList<PVector>();
int cornerMoveThreshold = 40;

// KEYSTONE KINECT
Keystone ksKinect;
CornerPinSurface kinectSurface;

void initializeKinectKeystone() {
  ksKinect = new Keystone(this);
  kinectSurface = ksKinect.createCornerPinSurface(kinectSrfW, kinectSrfH, 40);
  if (calibrateOn) ksKinect.toggleCalibration();
}


// Kinect Mask Corners

void setKinectMaskCorners(ArrayList<PVector> corners) {
  int topW = 300;
  int botW = 500;
  int h = 400;

  maskTL = new PVector((this.width-topW)/2, (this.height-h)/2);    // ADD CALIBRATION LOAD FUNCTION
  maskBL = new PVector((this.width-botW)/2, (this.height+h)/2);    // ADD CALIBRATION SAVE FUNCTION
  maskBR = new PVector((this.width+botW)/2, (this.height+h)/2);
  maskTR = new PVector((this.width+topW)/2, (this.height-h)/2);

  corners.add(maskTL);
  corners.add(maskBL);
  corners.add(maskBR);
  corners.add(maskTR);

  for (int i = 0; i < corners.size(); i++) {
    prevMaskCornersKinect.add(corners.get(i));
  }
}

void initializeKinectMask(java.awt.Polygon p, ArrayList<PVector> corners, CornerPinSurface s) {

  for (int i = 0; i < corners.size(); i++) {
    p.addPoint(int(corners.get(i).x), int(corners.get(i).y));
  }

  PVector surfaceCornerTL = new PVector(0, 0);
  PVector surfaceCornerBL = new PVector(0, kinectSrfH);
  PVector surfaceCornerBR = new PVector(kinectSrfW, kinectSrfH);
  PVector surfaceCornerTR = new PVector(kinectSrfW, 0);

  PVector distTL = PVector.sub(maskTL, surfaceCornerTL);
  PVector distBL = PVector.sub(maskBL, surfaceCornerBL);
  PVector distBR = PVector.sub(maskBR, surfaceCornerBR);
  PVector distTR = PVector.sub(maskTR, surfaceCornerTR);

  s.moveMeshPointBy(CornerPinSurface.TL, distTL.x, distTL.y);
  s.moveMeshPointBy(CornerPinSurface.BL, distBL.x, distBL.y);
  s.moveMeshPointBy(CornerPinSurface.BR, distBR.x, distBR.y);
  s.moveMeshPointBy(CornerPinSurface.TR, distTR.x, distTR.y);
}


void moveKinectMask(java.awt.Polygon p, ArrayList<PVector> corners, PVector target) {
  if (calibrateOn) {
    for (int i = 0; i < corners.size(); i++) {
      PVector part = corners.get(i);
      if (part.dist(target) < cornerMoveThreshold) {
        part.set(target);
        p.xpoints[i] = int(target.x);
        p.ypoints[i] = int(target.y);

        prevMaskCornersKinect.get(i).set(part);
      }
    }
    // Drag Whole Mask
    if (p.contains(mouseX, mouseY)) {
      int inR = 0;
      for (int i = 0; i < corners.size(); i++) {
        if (corners.get(i).dist(target) < cornerMoveThreshold) {
          inR++;
        }
      }
      if (inR == 0) {
        ///////////////////DRAG FUNCTION///////////////////////////////////////////////////////////////
      }
    }
  }
}


void drawKinectMask(java.awt.Polygon p) {
  beginShape();
  pushMatrix();
  fill(255, 0);
  stroke(0, 255, 0);
  strokeWeight(2);
  for (int i = 0; i < p.npoints; i++) {
    vertex(p.xpoints[i], p.ypoints[i]);
  }
  popMatrix();
  endShape(CLOSE);
}


void mouseDragged() {
  PVector mouse = new PVector(mouseX, mouseY);
  moveKinectMask(kinectMask, maskCornersKinect, mouse);
}