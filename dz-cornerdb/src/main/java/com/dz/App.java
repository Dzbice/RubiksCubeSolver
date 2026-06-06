package com.dz;

import java.io.IOException;

/** Hello world! */
public class App {
  public static void main(String[] args) throws IOException {
    System.out.println("making ts cpd now ig");
    PatternDb cornerDb = new PatternDb();
    long startTime = System.nanoTime();
    cornerDb.makeDB();
    long end = System.nanoTime();
    System.out.println((end-startTime)/1000000);
    System.out.println("alr gotta save ts");
    cornerDb.save("../resources/corner_db.dat");
    System.out.println("done");
  }
}
