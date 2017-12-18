void keyPressed() {
  switch(key) {

  case 'c':
  case 'C':
    if (calibrateOn) calibrateOn = false;
    else if (!calibrateOn) calibrateOn = true;
    println("Calibration is " + calibrateOn);
    break;

  case 'l':
  case 'L':
    ksKinect.load();
    loadKinectMask(maskCornersKinect, kinectMask);
    loadDepthCalib();
    println("Kinect Mask Loaded");
    break;

  case 's':
  case 'S':
    ksKinect.save();
    saveKinectMask(maskCornersKinect);
    saveDepthCalib(depths);
    println("Kinect Mask Saved");
    break;


  case 'd':
  case 'D':
    ksKinect.toggleCalibration();
  break;
  }
}


void saveKinectMask(ArrayList<PVector> corners) {
  int[] cornersX = new int[corners.size()];
  int[] cornersY = new int[corners.size()];

  for (int i = 0; i < corners.size(); i++) {
    cornersX[i] = int(corners.get(i).x);
    cornersY[i] = int(corners.get(i).y);
  }

  saveStrings("CalibratedKinectCornersX.txt", str(cornersX));
  saveStrings("CalibratedKinectCornersY.txt", str(cornersY));
}

void loadKinectMask(ArrayList<PVector> corners, java.awt.Polygon p) {
  int[] cornersX = new int[corners.size()];
  int[] cornersY = new int[corners.size()];

  if (loadStrings("CalibratedKinectCornersX.txt") != null && loadStrings("CalibratedKinectCornersY.txt") != null) {
    cornersX = parseInt(loadStrings("CalibratedKinectCornersX.txt"));
    cornersY = parseInt(loadStrings("CalibratedKinectCornersY.txt"));

    for (int i = 0; i < corners.size(); i++) {
      corners.get(i).set(cornersX[i], cornersY[i]);
      p.xpoints[i] = cornersX[i];
      p.ypoints[i] = cornersY[i];
    }
  }
}



void saveDepthCalib(int[] d) {
  if (d != null) {
    saveStrings("depths.txt", str(kinect.getRawDepth()));
    println("Surface Depth Calibration SAVED");
  } else println("Surface Depth Calibration Save FAILED");
}

void loadDepthCalib() {
  if (loadStrings("depths.txt") != null) {
    calibDepths = parseInt(loadStrings("depths.txt")); 
    println("Surface Calibration LOADED");
  } else println("Surface Calibration Load FAILED");
}

void loadOnStart() {
  ksKinect.load();
  loadKinectMask(maskCornersKinect, kinectMask);
  loadDepthCalib();
  println("Kinect Mask Loaded");
}