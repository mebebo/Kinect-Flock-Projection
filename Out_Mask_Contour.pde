// Projector Mask Contour Detect OpenCV
OpenCV opencvOut;
PImage maskOut;
Contour maskContourOut;
ArrayList<PVector> maskCornersOut;


// KEYSTONE PROJECTOR
Keystone ksOutput;
CornerPinSurface outSurface;

void initializeOutKeystone(PApplet p) {
  ksOutput = new Keystone(p);
  outSurface = ksOutput.createCornerPinSurface(projSrfWidth, projSrfHeight, 40);
  if (calibrateOn) ksOutput.toggleCalibration();
}



void initializeOpencvOut(PApplet p) {
  maskOut = loadImage("mask.png");
  maskOut.resize(p.width, p.height);
  opencvOut = new OpenCV(p, maskOut);
  maskContourOut = opencvOut.findContours(false, true).get(0).getPolygonApproximation();
  maskCornersOut = maskContourOut.getPoints();
}


void initializeOutMask(ArrayList<PVector> c, CornerPinSurface s) {
  ArrayList<PVector> sCorners = new ArrayList<PVector>();
  sCorners.add(new PVector(0, 0));
  sCorners.add(new PVector(0, projSrfHeight));
  sCorners.add(new PVector(projSrfWidth, projSrfHeight));
  sCorners.add(new PVector(projSrfWidth, 0));

  ArrayList<PVector> dists = new ArrayList<PVector>();

  for (int i = 0; i < c.size(); i++) {
    dists.add(PVector.sub(c.get(i), sCorners.get(i)));
  }

  s.moveMeshPointBy(CornerPinSurface.TL, dists.get(0).x, dists.get(0).y);
  s.moveMeshPointBy(CornerPinSurface.BL, dists.get(1).x, dists.get(1).y);
  s.moveMeshPointBy(CornerPinSurface.BR, dists.get(2).x, dists.get(2).y);
  s.moveMeshPointBy(CornerPinSurface.TR, dists.get(3).x, dists.get(3).y);
}