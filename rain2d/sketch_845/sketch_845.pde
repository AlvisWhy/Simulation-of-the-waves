import ddf.minim.analysis.*;
import ddf.minim.*;
Minim       minim;
AudioPlayer jingle;
FFT         fft;
float sum;
float ang;
int cols = 1920;
int rows = 1080;
float[][] current = new float[cols][rows];
float[][] previous = new float[cols][rows];
// like reverb sustain. generally how long it takes for ripples to fade away in this 'puddle'
// .981 - .99999, more dampening to more sustain.

float dampening = .980;
//float dampening = .99999;
int index = 0;
// set limit to 30, light drizzle. 
// set limit to 1, downpour


int limit = 2;
void setup() {
  size(1920, 1080, P3D);
  stroke(0, 200, 255);
  minim = new Minim(this);
  jingle = minim.loadFile("14747.wav", 1024);


  jingle.loop();
  fft = new FFT( jingle.bufferSize(), jingle.sampleRate() );
}

void mousePressed() {
  // create raindrop at coordinates mouseX, mouseY
  // value controls how bright the raindrop is.
  previous[mouseX][mouseY] = random(50);
}

void addRainDrops() {
  int x = int(random(float(cols)));
  int y = int(random(float(rows)));
  previous[x][y] = random(50);
}

void draw() {
  
  background(0);
/*
  sum = 0;
  fft.forward( jingle.mix );
  
  for(int i = 0; i < fft.specSize(); i++)
  {
    
   sum+=fft.getBand(i);
  }
  limit = floor(map(sum,50,2000,10,0));
  println(index);
  */
  loadPixels();

  if (index == 0) {
    addRainDrops();
  }
  index++;
  if (index >= limit) {
    index = 0;
  }

  //go through all pixel coordinates
  //use current and previous to get next, which is put into current. 
  //changing offset is almost like zoom and speed at the same time. 
  //>> need to fill in the pixels arount current out to offset value.
  int offset = 1;
  for (int i = offset; i < cols - offset; i++) {
    for (int j = offset; j < rows - offset; j++) {

      // anything done in here is done to each pixel with access to both buffers 
      // so you can do your math on each pixel here with access to all values in the array. 
      current[i][j] = (
        previous[i-offset][j] +
        previous[i+offset][j] +
        previous[i][j-offset] +
        previous[i][j+offset]
        ) / 2 - 
        current[i][j];
      current[i][j] = current[i][j] * dampening;

      // pixels must be native to processing. 
      // set of all pixels on screen sorted by single index
      // which means current number of rows (i) + number of columns * current number of columns 

      int index = i + j * cols;
      pixels[index] = color(0, current[i][j] * 255, current[i][j] * 255,current[i][j] * 255);
    }
  }
  updatePixels();
  ang+=10;

  float[][]temp = previous;
  previous = current; 
  current = temp;
  if(dampening < 0.995){ 
  dampening +=0.0001;
  }
 if(frameCount < 2500){
  save("ssp-" + frameCount + ".png");
 }
  }
