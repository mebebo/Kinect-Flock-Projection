// Flocking to peak points + contour bounding box affect diameter

// no food points flock interaction
// calibration of values
// fade in - out / presentation gimmicks

// Depth opencv calibration - min area - min brightness - 
// Swarm calibration - coherence lower? - number of agents - velocity - acceleration - food avoidance - food detect radius


// OpenCV
import processing.video.*;
import java.awt.Rectangle;
import gab.opencv.*;
import processing.opengl.*;

import deadpixel.keystone.*;


// Size
int kinectW = 640;
int kinectH = 480;
int kinectSrfW = kinectH;
int kinectSrfH = kinectH;

int projWidth = 1920;
int projHeight = 1080;
int projSrfWidth = 1200;
int projSrfHeight = projSrfWidth;


// Interaction
PGraphics depthImg;

boolean calibrateOn = false;
boolean loadCalibrateOnStart = true;

boolean startSecondScreen = true;
boolean secondFullscreenOn = true;

boolean drawFood = false;



void settings() {
  size(kinectW, kinectH, P3D);
}

void setup() {
  initializeKinect();
  initializeKinectKeystone();
  setKinectMaskCorners(maskCornersKinect);
  initializeKinectMask(kinectMask, maskCornersKinect, kinectSurface);

  initializeOpencvDepth();

  depthImg = createGraphics(kinectW, kinectH);



  if (loadCalibrateOnStart) loadOnStart();
  if (startSecondScreen) win = new PWindow();
}


void draw() {
  background(baseVal);

  if (calibrateOn) {
    image(kinect.getVideoImage(), 0, 0);
    drawKinectMask(kinectMask);

    PGraphics scr = createGraphics(kinectSrfW, kinectSrfH);
    scr.beginDraw();
    scr.background(255, 0);
    scr.endDraw();
    kinectSurface.render(scr);
  } else {

    depths = kinect.getRawDepth();
    drawDepthImage(kinectMask, depths, calibDepths, depthImg);

    findPeaks(depthImg, peaks, areas);

    image(depthImg, 0, 0);


    ArrayList<PVector> transPeaks = new ArrayList<PVector>();
    for (PVector p : peaks) {
      transPeaks.add(kinectSurface.getTransformedCursor(int(p.x), int(p.y)));
    }
    
    if (startSecondScreen) {
      win.updateWin(transPeaks, areas);
    }
  }
  //if (startSecondScreen) println(win.frameRate);
}