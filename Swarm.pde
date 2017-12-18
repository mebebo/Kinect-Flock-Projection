flock flock;

int bodyLen = 5;
int torusBuffer = -bodyLen;
float maxV = bodyLen/1;
float maxA = maxV/15.0;

int cohR = 5*bodyLen; 
int aliR = 2*bodyLen;
int sepR = 4*bodyLen;

float cohW = 1.; 
float aliW = 1.1;
float sepW = 2;

int attractR = 60*bodyLen;
int foodSwarmR = 30*bodyLen;
int foodAvoidR = 10*bodyLen;

int attractRMin = foodAvoidR;
int attractRMax = 60*bodyLen;

float foodW = 1;
float foodAvoidW = 0.2;


int spawnCount = 1300;

color boidC = color(0);



void initializeSwarm() {
  flock = new flock(bodyLen, maxV, maxA, cohR, sepR, aliR, attractR);
}

void spawnSwarm(PGraphics g) {
  for (int i = 0; i < spawnCount; i++) {
    flock.boids.add(new boid(random(torusBuffer, g.width-torusBuffer), random(torusBuffer, g.height-torusBuffer), 
      random(maxV), random(maxV)));
  }
}





class boid {
  PVector pos;
  PVector vel;
  PVector velPrev;
  PVector acc;
  float effectiveA;

  boid(float x, float y, float vx, float vy) {
    pos = new PVector(x, y);
    vel = new PVector(vx, vy);
    velPrev = new PVector(0, 0);
    acc = new PVector(0, 0);
  }

  void render(PGraphics g) {
    //g.beginDraw();
    g.pushMatrix();
    g.noStroke();
    g.fill(boidC);
    g.ellipse(pos.x, pos.y, bodyLen/2, bodyLen/2);
    g.popMatrix();
    //g.endDraw();
  }

  void torusCorrect(PGraphics g, int buffer) {
    if (pos.x < -buffer) {
      vel.x = -vel.x;
      acc.x = -acc.x;
    }
    if (pos.y < -buffer) {
      vel.y = -vel.y;
      acc.y = -acc.y;
    }
    if (pos.x > g.width + buffer) {
      vel.x = -vel.x;
      acc.x = -acc.x;
    }
    if (pos.y > g.height + buffer) {
      vel.y = -vel.y;
      acc.y = -acc.y;
    }
  }
}


class flock {
  int bodyLength;

  float maxVel;     // flight parameters
  float maxAcc;

  int cohereR, separateR, alignR;

  float foodR;
  float foodWeight = foodW;

  ArrayList<boid> boids;

  flock(int bodL, float maxV, float maxA, int cR, int sR, int aR, float fR) {
    bodyLength = bodL;
    boids = new ArrayList<boid>();

    maxVel = maxV;
    maxAcc = maxA;
    cohereR   = cR;
    separateR = sR;
    alignR    = aR;

    foodR = fR;
  }

  void render(PGraphics g) {
    for (boid b : boids) {
      b.render(g);
    }
  }

  void swarm(ArrayList<PVector> foods, ArrayList<Float> areas) {

    for (boid b : boids) {

      PVector cohere = new PVector(0, 0);      // cohere becomes the centroid
      int coherePop  = 0;                     // of b's neighbors

      PVector separate = new PVector(0, 0);
      int separatePop  = 0;

      PVector align = new PVector(0, 0);
      int  alignPop = 0;


      PVector food = new PVector(0, 0);
      int foodPop = 0;



      if (foods.size() > 0 && areas.size() > 0) {
        int closestIndex = 0;
        float closestDist = width*5;

        for (int i = 0; i < foods.size(); i++) {
          float foodD = PVector.dist(b.pos, foods.get(i));
          if (foodD < closestDist) {
            closestIndex = i;
            closestDist = foodD;
          }
        }

        PVector closestFood = foods.get(closestIndex);/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //float closestFoodArea = areas.get(closestIndex);

        //foodR = map(closestFoodArea, peakAreaMin, peakAreaMax, attractRMin, attractRMax);
        //foodR = constrain(foodR, attractRMin, attractRMax);

        if (closestDist > foodAvoidR && closestDist < foodR) {
          food = PVector.sub(closestFood, b.pos);
          foodPop++;
        }
        if (closestDist > 0 && closestDist <= foodAvoidR) {
          food = PVector.sub(b.pos, closestFood);
          foodPop++;
        }
      }





      ///////////////////////////////////
      //if (closestDist > foodAvoidR && closestDist < foodSwarmR) {
      //  maxVel = maxV;
      //  maxAcc = maxA*2.5;
      //  foodWeight = foodW;
      //} else if (closestDist > 0 && closestDist <= foodAvoidR) {
      //  maxVel = maxV;
      //  maxAcc = maxA*3;
      //  foodWeight = foodAvoidW;
      //} 
      /////////////////////////////////////

      //else {
      maxVel = maxV;
      maxAcc = maxA;
      foodWeight = foodW;
      //}

      for (boid a : boids) {
        float d = PVector.dist(a.pos, b.pos);

        if (d > 0 && d < cohereR) {       
          cohere.add(a.pos);
          coherePop++;
        }

        if (d > 0 && d < separateR) {
          PVector avoidA = PVector.sub(b.pos, a.pos);
          // the desire to avoid a neighbor is proportional to 1 / distance^2
          avoidA.normalize();
          avoidA.div((d/10.0));       // weight by 1/distance
          separate.add(avoidA);
          separatePop++;
        }

        if (d > 0 && d < alignR) {
          align.add(a.vel);
          alignPop++;
        }
      }


      if (coherePop != 0) {
        cohere.div((float)coherePop); // cohere is now the centroid of its neighbors
        cohere.sub(b.pos);            // now we have a vector from the boid to the centroid of its neighbors
        cohere.setMag(maxVel);        // now cohere is an "impulse" vector in the right direction, a desired velocity
        //cohere.sub(b.vel);            // now cohere points from the current velocity to the desired one
        cohere.limit(maxAcc);
        cohere.mult(cohW);            // the cohere impulse is limited by maxAcc * cohW
        b.acc.add(cohere);
      }

      if (separatePop > 0) {
        //separate.div((float)separatePop);
        separate.setMag(maxVel);
        separate.sub(b.vel);
        separate.limit(maxAcc);
        separate.mult(sepW);
        b.acc.add(separate);
      }

      if (alignPop > 0) {
        //align.div((float)alignPop);
        align.setMag(maxVel);
        align.sub(b.vel);
        align.limit(maxAcc);
        align.mult(aliW);
        b.acc.add(align);
      }

      if (foodPop > 0) {
        food.setMag(maxVel);
        food.sub(b.vel);
        food.limit(maxAcc);
        food.mult(foodWeight);
        b.acc.add(food);
      }
    }
  }

  // updates each boid's parameters
  void update() {
    for (boid b : boids) {
      //b.acc.limit(maxAcc);
      b.velPrev = b.vel;
      b.vel.add(b.acc);
      b.vel.limit(maxVel);
      b.pos.add(b.vel);
      b.acc.mult(0);
    }
  }

  void torusCorrect(PGraphics g, int buffer) {
    for (boid b : boids) {
      b.torusCorrect(g, buffer);
    }
  }
}