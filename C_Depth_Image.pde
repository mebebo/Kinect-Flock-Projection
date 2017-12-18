

// Interaction
int[] depths = new int[kinectW*kinectH];
int[] calibDepths = new int[kinectW*kinectH];

int depthThresholdMin = 500;
int depthThresholdMax = 2040;
int offsetMin = 5;
int offsetMax = 200;
int offsetRange = abs(offsetMax - offsetMin);
int offsetOvershoot = 500;

int baseVal = 0;
int targetVal = 255;

//float changeMult = 1.5;
float changeMult = 20;

void drawDepthImage(java.awt.Polygon p, int[] d, int [] calibD, PGraphics dBuffer) {
  if (d == null || calibD == null) return;

  dBuffer.beginDraw();
  dBuffer.background(baseVal);
  dBuffer.loadPixels();

  for (int x = 0; x < kinectW; x++) {
    for (int y = 0; y < kinectH; y++) {

      int pixNo = x + y*kinectW;

      if (p.contains(x, y)) {
        int pixZeroDepth = calibD[pixNo];
        int pixCurDepth = d[pixNo];
        int pixOffset = abs(pixCurDepth - pixZeroDepth);

        // MOUSE PROBE DEPTH ===========================
        if (mouseX == x && mouseY == y) 
        println("Calibrated Depth: " + pixZeroDepth + "\t Current Depth: " 
        + pixCurDepth + "\t Pixel Offset: " + pixOffset);


        if (pixZeroDepth > depthThresholdMin && pixZeroDepth < depthThresholdMax) {

          if (pixOffset > offsetMin && pixOffset < offsetMax) {
            int colorVal = int(map(pixOffset, offsetMin, offsetMax, baseVal, targetVal));
            dBuffer.pixels[pixNo] = color(colorVal*changeMult);
          } else if (pixOffset >= offsetMax && pixOffset < offsetOvershoot) {
            dBuffer.pixels[pixNo] = color(targetVal);
          } else dBuffer.pixels[pixNo] = color(baseVal);
        } else dBuffer.pixels[pixNo] = color(baseVal);
      } 
      //else dBuffer.pixels[pixNo] = color(0);
    }
    dBuffer.updatePixels();
    dBuffer.endDraw();
  }
}