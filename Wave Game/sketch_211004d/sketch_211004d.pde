float Angle = 0; 
int Height = 100; 
int N = 50; 
int boxWidth = 2;
float damp = 0.5;
ArrayList<PVector> p = new ArrayList<PVector>();
import peasy.*;
PeasyCam cam;
CameraState state;
void setup() {
  cam = new PeasyCam(this, 400);
  state = cam.getState();
  size(1920, 1080, P3D); //set window size 1000 x 800 and introduce P3D system
  frameRate(50);
  noFill();
  strokeWeight(2);
  waveSetup(N);
}
void draw() {
  background(0); //set background color

  p.clear();
  cameraMove(N, boxWidth, Angle, Height);

  waveMove(N);
  waveDraw(N, boxWidth);
  int count = 0 ; 
  String[] points = new String[p.size()];

  for (PVector pt : p ) {

    points[count] = pt.x + "," + pt.y + "," + pt.z;
    count ++;
  }
  if (frameCount >0 && frameCount <2000) {
    saveStrings(frameCount + "points.txt", points);
  }
}
//save("s45sk-" + frameCount + ".png");


int pose = 0; //this variable "pose" is flag
void keyPressed() {

  switch(keyCode) {
  case RIGHT:
    Angle += 0.05;
    break;
  case LEFT:
    Angle -= 0.05;
    break;
    //case UP:
    // Height += 30;
    // break;
  case DOWN:
    Height -= 30;
    break;
    ///// stop and restart drawing /////
  case ' ':
    if (pose == 0) {
      noLoop();
      pose = 1;
    } else if (pose == 1) {
      loop();
      pose = 0;
    }
    break;

  case UP:
    int count = 0 ; 
    String[] points = new String[p.size()];

    for (PVector pt : p ) {

      points[count] = pt.x + "," + pt.y + "," + pt.z;
      count ++;
    }
    saveStrings(frameCount + "points.txt", points);
    break;
  }
}

void mousePressed() {
  int k = (int)(N*mouseX/width);
  int l = (int)(N*mouseY/height);
  du_dt[(int)(k)][N-1-(int)(l)] = 2.0;
}

float vel = 0.03; //velociaty of wave
float d = 0.5; //interval of lattice point
float g = 0.1; //value of gravity


float[][] u = new float[N][N]; //cuurrent value of displacement
float[][] du_dt = new float[N][N]; //first-order differentiation of u (variation of displacement)
float[][] d2u_dt2 = new float[N][N]; //second-order differentiation of u


void cameraMove(int NUM, int boxW, float cameraAngle, int cameraHeight) {
  camera((1.0/2.0)*NUM*boxW*cos(cameraAngle)+(NUM*boxW/2), 
    -(1.0/2.0)*NUM*boxW*sin(cameraAngle)+(NUM*boxW/2), cameraHeight, 
    (NUM*boxW/2), (NUM*boxW/2), 0, 
    1*cos(cameraAngle), -1*sin(cameraAngle), 0);
}

void waveSetup(int NUM) {

  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      //initial condition
      u[i][j] = 0.0;
      du_dt[i][j] = 0.0;
      d2u_dt2[i][j] = 0.0;
    }
  }
}

void waveDraw(int NUM, int boxW) {

  for (int k = 0; k < 3; k++) {
    for (int j = 0; j < NUM; j++) {
      for (int i = 0; i < NUM; i++) {
        pushMatrix(); //save the current coordinate system
        translate(boxW/2 + i*boxW, 
          boxW/2 + j*boxW, 
          200*atan(u[i][j]/100)/PI - boxW*k);

        if (u[i][j] >= 0) {
          stroke( 500*atan(u[i][j]/20)/PI, 200, 255, 128);
          fill((10*u[i][j]), (10*u[i][j]), 255);
        } else if (u[i][j] < 0) {
          stroke(200*atan(u[i][j]/500)/PI, 200, 255, 128);
        }
        if (u[i][j] >= 0) {
          stroke(800*atan(u[i][j]/100)/PI, 800*atan(u[i][j]/100)/PI, 200, 200);
        } else if (u[i][j] < 0) {
          stroke(200*atan(u[i][j]/500)/PI, 200*atan(u[i][j]/500)/PI, 200, 200);
        }
        */

          point(0, 0); //a section of water surface
        popMatrix(); //restore the prior coordinate system
      }
    }
  }
}

void waveMove(int NUM) {
  //boundary condition

  for (int j = 1; j < NUM-1; j++) {
    for (int i = 1; i < NUM-1; i++) {
      u[0][j] = 0.0;
      u[i][0] = 0;
      u[i][NUM-1] = 0;
      u[NUM-1][j] = 0.0;
      du_dt[0][j] = 0.0;
      du_dt[i][0] = 0.0;
      du_dt[i][NUM-1] = 0.0;
      du_dt[NUM-1][j] = 0.0;
    }
  }

  for (int j = 1; j < NUM-1; j++) {
    for (int i = 1; i < NUM-1; i++) {
      //wave equation (to compute acceleration)
      d2u_dt2[i][j] = -g*200*atan(u[i][j]/500)/PI
        + (vel*vel)/(d*d)*(u[i+1][j]+u[i-1][j]+u[i][j+1]+u[i][j-1]-4*u[i][j]);
      //du_dt is integrated value of d2u_dt2 (du_dt is velocity)
      du_dt[i][j] += d2u_dt2[i][j];
      //integral computation for displacement
      u[i][j] += 0.5*atan(du_dt[i][j]);
      p.add(new PVector(i, j, u[i][j]));
    }
  }
}
