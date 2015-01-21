void startPuredata(String patchfile) {
  //initialize pd with audio rate of 44100, no inputs, and two 
  //outputs, load the patch and start the object
  pd = new PureData(this, 44100, 0, 2);
  pd.openPatch(patchfile);
  pd.start();
}

void generatePatch(String patchfile) {
  if (createAndAssertDir("data")) {
    generatePatchfile("data/"+patchfile, FREQ0, ALL_STEPS);
  }
  else {
    System.out.println("Couldn't create data directory");
    exit();
  }
}

boolean createAndAssertDir(String dirname) {
  File dir = new File(dirname);

  if (dir.exists())
    return true;
  else {
    dir.mkdirs();
    if (dir.exists()) {
      return true;
    }
  }

  return false;

}

void generatePatchfile(String patchfileName, float freq0, int nUnits) {

  PrintWriter patch = createWriter(patchfileName);

  patch.println("#N canvas 1000 70 762 624 10;");  
  patch.println("#X obj 78 116 dac~;");

  float freq = freq0;
  for (int unit = 0; unit < nUnits; unit++) {
    freq = freq * STEP_RATIO;

    patch.println("#X obj 121 -86 r unit" + unit + ";"); // 1
    patch.println("#X obj 23 -27 osc~ "   + freq + ";"); // 2
    patch.println("#X obj 78 63 *~;"); // 3

    patch.println("#X obj 100 100 sig~;");     // 4
    patch.println("#X obj 200 200 lop~ 3;");   // 5
  }

  int elem = 0;
  for (int unit=0; unit < nUnits; unit++) {
    elem = unit*5;  //patch.println("elem: " + elem);

    patch.println("#X connect " + (elem+1) + " 0 " + (elem+4) + " 0;");
    patch.println("#X connect " + (elem+4) + " 0 " + (elem+5) + " 0;");
    patch.println("#X connect " + (elem+5) + " 0 " + (elem+3) + " 1;");

    patch.println("#X connect " + (elem+1) + " 0 " + (elem+3) + " 1;");
    patch.println("#X connect " + (elem+3) + " 0 " + " 0 "    + " 0;");
    patch.println("#X connect " + (elem+3) + " 0 " + " 0 "    + " 1;");
    patch.println("#X connect " + (elem+2) + " 0 " + (elem+3) + " 0;");

  }

  patch.flush();
  patch.close();
}


// http://rosettacode.org/wiki/Nth_root#Java
public static double nthroot(int n, double A) {
	return nthroot(n, A, .001);
}
public static double nthroot(int n, double A, double p) {
	if(A < 0) {
		System.err.println("A < 0");// we handle only real positive numbers
		return -1;
	} else if(A == 0) {
		return 0;
	}
	double x_prev = A;
	double x = A / n;  // starting "guessed" value...
	while(Math.abs(x - x_prev) > p) {
		x_prev = x;
		x = ((n - 1.0) * x + A / Math.pow(x, n - 1.0)) / n;
	}
	return x;
}
