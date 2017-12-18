PWindow win;


public class PWindow extends PApplet {

  ArrayList<PVector> foodInput = new ArrayList<PVector>();
  ArrayList<PVector> food = new ArrayList<PVector>();
  ArrayList<Float> foodAreas = new ArrayList<Float>();

  PGraphics outBuffer;

  PWindow() {
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    size(projWidth, projHeight, P3D);
    if (secondFullscreenOn) fullScreen(2);
  }

  void setup() {
    initializeOutKeystone(this);
    initializeOpencvOut(this);
    initializeOutMask(maskCornersOut, outSurface);

    outBuffer = createGraphics(projSrfWidth, projSrfHeight);

    initializeSwarm();
    spawnSwarm(outBuffer);
  }


  void draw() {
    background(0);
    food.clear();

    if (foodInput.size() > 0) {

      for (PVector f : foodInput) {
        food.add(new PVector(map(f.x, 0, kinectSrfW, 0, projSrfWidth), map(f.y, 0, kinectSrfH, 0, projSrfHeight)));
      }

      //printArray(foodAreas);
    }


    drawOutBuffer();
    outSurface.render(outBuffer);
  }



  public void updateWin(ArrayList<PVector> p, ArrayList<Float> area) {
    foodInput = p;
    foodAreas = area;
  }


  void drawOutBuffer() {
    outBuffer.beginDraw();
    outBuffer.pushMatrix();

    outBuffer.background(255);
    outBuffer.noStroke();

    flock.swarm(food, foodAreas);
    flock.update();
    flock.render(outBuffer);
    flock.torusCorrect(outBuffer, torusBuffer);

    if (drawFood) {
      for (PVector f : food) {
        outBuffer.pushMatrix();
        outBuffer.fill(255, 0, 0);
        outBuffer.ellipse(f.x, f.y, 50, 50);
        outBuffer.popMatrix();
      }
    }

    //for (int i = 0; i < food.size(); i++) {
    //  PVector part = food.get(i);

    //  outBuffer.fill(0, 255, 0);
    //  //outBuffer.ellipse(part.x, part.y, foodAreas.get(i), foodAreas.get(i));
    //}

    outBuffer.popMatrix();
    outBuffer.endDraw();
  }
}