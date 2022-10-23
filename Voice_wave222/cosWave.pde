class cosWaveSorce{
  float frequency;
  float amplitude;
  PVector startPoint;
  
  cosWaveSorce(float _frequency, float _amplitude, PVector st){
    frequency = _frequency;
    amplitude = _amplitude;
    startPoint = st;
  }
  
  PVector waveVector(PVector p ){
   float dist = dist(startPoint.x,startPoint.y, p.x,p.y);
    float w = 2*PI / frequency;
    float cose = amplitude*(cos(w* dist));
    PVector vec = new PVector(p.x - startPoint.x, p.y - startPoint.y);
    
    vec.normalize();
    vec.mult(cose);
    return vec;
  }
  
}
