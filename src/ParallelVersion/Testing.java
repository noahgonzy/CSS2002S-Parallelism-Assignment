package ParallelVersion;

public class Testing {
    static String[] torun = new String[8];
    static int rows; //grid size
	static int columns;
	static double xmin, xmax, ymin, ymax; //x and y terrain limits
	static double searches_density;	// Density - number of Monte Carlo  searches per grid position - usually less than 1!
    static int sequentialcutoff;

    public static void main(String[] args) {
        int[] rowsandcol = new int[]{10,100,1000,5000};
        int[] grisizes = new int[]{10,100,1000,5000};
        int[] sequentialcutoffs = new int[]{10,100,1000,10000,100000,1000000};

        //Defaults
        rows = 1000;
        columns = 1000;
        xmin = -1000;
        xmax = 1000;
        ymin = -1000;
        ymax = 1000;
        searches_density = 0.8;
        sequentialcutoff = 10000;
        ArrUpdate();

        int testnum = 0;
            for(int j = 0; j < rowsandcol.length; j++){
            rows = rowsandcol[j];
            columns = rowsandcol[j];
            for(int k = 0; k < grisizes.length; k++){
                xmin = -(grisizes[k]);
                xmax = grisizes[k];
                ymin = -(grisizes[k]);
                ymax = grisizes[k];
                for(double i = 0.1; i < 1; i += 0.1){
                    double density = (double)(Math.round(i * 100)) / 100;
                    searches_density = density;
                    ArrUpdate();
                    testnum += 1;
                    System.out.println("Test: " + testnum + " of " + rowsandcol.length*grisizes.length*10);
                    MonteCarloMinimizationParallel.main(torun);
                }
            }
        }
    }
   
    public static void ArrUpdate(){
        torun[0] = Integer.toString(rows);
        torun[1] = Integer.toString(columns);
        torun[2] = Double.toString(xmin);
        torun[3] = Double.toString(xmax);
        torun[4] = Double.toString(ymin);
        torun[5] = Double.toString(ymax);
        torun[6] = Double.toString(searches_density);
        torun[7] = Integer.toString(sequentialcutoff);
    }
}
