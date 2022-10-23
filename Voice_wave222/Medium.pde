class Medium {
  ArrayList<PVector> p = new ArrayList<PVector>();
  WaveField f;
  Medium(WaveField _f) {
    f = _f;
  }


  void update() {
    ArrayList<PVector> pts = new ArrayList<PVector>();
    for (PVector pt : p) {
      PVector sumVec = new PVector(0, 0);
      for (sinWaveSorce si : f.s) {
        sumVec.add(si.waveVector(pt));
      }
      for (cosWaveSorce co : f.c) {
        sumVec.add(co.waveVector(pt));
      }
      PVector newPt = pt.copy();
      newPt.add(sumVec);
      pts.add(newPt);
    }
    p = pts;
  }
}
