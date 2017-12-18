OpenCV opencvPeak;
ArrayList<PVector> peaks;
ArrayList<Contour> contours;
ArrayList<Float> areas;

int rangeLow = 1;
int rangeHigh = targetVal;
int peakAreaMin = 50;
int peakAreaMax = 5000;

int blurVal = 1;



void initializeOpencvDepth() {
  opencvPeak = new OpenCV(this, width, height);
  peaks = new ArrayList<PVector>();
  areas = new ArrayList<Float>();
}

void findPeaks(PGraphics g, ArrayList<PVector> p, ArrayList<Float> area) { 
  if (g == null || p == null) return;

  opencvPeak.loadImage(g.get());
  opencvPeak.blur(blurVal);
  opencvPeak.useGray();
  opencvPeak.inRange(rangeLow, rangeHigh);
  contours = opencvPeak.findContours(false, false);

  if (contours.size() > 0) { 
    p.clear();
    area.clear();
    for (Contour c : contours) {
      if (c.area() > peakAreaMin) {
        Rectangle r = c.getBoundingBox();
        PVector center = new PVector(r.x+r.width/2, r.y+r.height/2);
        p.add(center);
        area.add(c.area());

        noFill();
        stroke(255, 0, 0);
        rect(r.x, r.y, r.width, r.height);    
        ellipse(center.x, center.y, 20, 20);
      }
    }
  } else {
    p.clear();
    area.clear();
  }
}