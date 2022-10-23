ArrayList<sinWaveSorce> sw = new ArrayList<sinWaveSorce>();
ArrayList<cosWaveSorce> cw = new ArrayList<cosWaveSorce>();
WaveField f = new WaveField();
Medium myMedium = new Medium(f);
ArrayList<PVector> ptCloud = new ArrayList<PVector>();
int xNum = 250;
int yNum = 250;
float sizeX ;
float sizeY ;

int ExactRate = 256;
int frequencyDomain = 20;

//analyse musics //

import ddf.minim.analysis.*;
import ddf.minim.*;

Minim       minim;
AudioPlayer jingle;
FFT         fft;




void setup() {

  minim = new Minim(this);
  jingle = minim.loadFile("renhua.mp3", ExactRate);
  jingle.loop();
  fft = new FFT( jingle.bufferSize(), jingle.sampleRate() );

 
  size(1920, 1080, P3D);
 
  sizeX = 1000/xNum;
  sizeY = 1000/yNum;
  myMedium.p = ptCloud;
  for (int i = 10; i< ExactRate; i+= frequencyDomain) {
    sw.add(new sinWaveSorce(i, 0, new PVector(800, 800)));
    sw.add(new sinWaveSorce(i, 0, new PVector(200, 200)));
    sw.add(new sinWaveSorce(i, 0, new PVector(800, 200)));
    sw.add(new sinWaveSorce(i, 0, new PVector(200, 800)));
 
    
  }

  for (sinWaveSorce ss : sw) {
    f.s.add(ss);
  }
  for (cosWaveSorce ss : cw) {
    f.c.add(ss);
  }
  for (int i = 0; i<xNum; i++) {
    for (int j = 0; j<yNum; j++) {
      ptCloud.add(new PVector(i*sizeX, j*sizeY));
    }
  }

  print(f.s.size());
}

void draw() {
 translate(width/2 -500,height/2 -500);
  fft.forward( jingle.mix );
  background(0);
  pushStyle();
  //fill(0, 50, 100, 10);
  //rect(0, 0, width, height);
  popStyle();
  noFill();
  stroke(0, 255, 255);

  for (sinWaveSorce it : f.s) {
    it.amplitude = (fft.getBand(int(it.frequency))*5);
    it.display();
  }



  myMedium.update();

  for (PVector pt : myMedium.p ) {
    point(pt.x, pt.y);
  }
}
