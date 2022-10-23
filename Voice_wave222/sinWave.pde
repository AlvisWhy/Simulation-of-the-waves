class sinWaveSorce{
  float frequency;
  float amplitude;
  PVector startPoint;
  
  sinWaveSorce(float _frequency, float _amplitude,PVector st){
    frequency = _frequency;
    amplitude = _amplitude;
    startPoint = st;
  }
  
  PVector waveVector( PVector p ){
   float dist = dist(startPoint.x,startPoint.y, p.x,p.y);
    float w = 2*PI / frequency;
    float sine = amplitude*(sin(w* dist));
    PVector vec = new PVector(p.x - startPoint.x, p.y - startPoint.y);
   
    vec.normalize();
    
    vec.mult(sine);
    return vec;
  }
  void display(){
    pushStyle();
    noStroke();
    fill(255,100,50,10);
    ellipse(startPoint.x,startPoint.y,amplitude*20,amplitude*20);
    popStyle();
  }
  
}
