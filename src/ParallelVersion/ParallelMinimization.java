package ParallelVersion;

import java.util.Random;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveAction;

public class ParallelMinimization extends RecursiveAction {
	static int rows; //grid size
	static int columns;
	static double xmin, xmax, ymin, ymax; //x and y terrain limits
	static TerrainArea terrain;  //object to store the heights and grid points visited by searches
	static double searches_density;	// Density - number of Monte Carlo  searches per grid position - usually less than 1!

	static int num_searches;		// Number of searches
	static Search [] searches;		// Array of searches
	static Random rand = new Random();  //the random number generator

	static int min=Integer.MAX_VALUE;
    static int local_min=Integer.MAX_VALUE;
	static int finder =-1;

/*
	int rows, columns; //grid size
    double xmin, xmax, ymin, ymax; //x and y terrain limits
    TerrainArea terrain;  //object to store the heights and grid points visited by searches
    double searches_density;	// Density - number of Monte Carlo  searches per grid position - usually less than 1!

    int num_searches;		// Number of searches
    Search [] searches;		// Array of searches
    Random rand = new Random();  //the random number generator
	 
	ParallelMinimization(int rowsin, int columnsin, double xminin, double xmaxin, double yminin, double ymaxin, 
	TerrainArea terrainin, double searches_densityin, int num_searchesin, Search[] searchesin){
		rows = rowsin;
		columns = columnsin;
		xmax = xmaxin;
		xmin = xminin;
		ymax = ymaxin;
		ymin = yminin;
		terrain = terrainin;
		searches_density = searches_densityin;
		num_searches = num_searchesin;
		searches = searchesin;
	}
	*/

	@Override
	protected void compute(){
		if(num_searches <= 200){
			for(int i = 0; i < num_searches; i++){
				local_min=searches[i].find_valleys();
				if((!searches[i].isStopped())&&(local_min<min)) { //don't look at  those who stopped because hit exisiting path
					min=local_min;
					finder=i; //keep track of who found it
				}
			}
		}
		else{
			int split = (int)(num_searches/2);
			ParallelMinimization left = new ParallelMinimization();
			ParallelMinimization right = new ParallelMinimization();
		}
	}

	static final boolean DEBUG=true;

    static long startTime = 0;
	static long endTime = 0;

    private static void tick(){
		startTime = System.currentTimeMillis();
	}
	private static void tock(){
		endTime=System.currentTimeMillis(); 
	}
    public static void main(String[] args) {
		ForkJoinPool threadpool = new ForkJoinPool();

    	
    	if (args.length!=7) {  
    		System.out.println("Incorrect number of command line arguments provided.");   	
    		System.exit(0);
    	}
    	/* Read argument values */
    	rows =Integer.parseInt( args[0] );
    	columns = Integer.parseInt( args[1] );
    	xmin = Double.parseDouble(args[2] );
    	xmax = Double.parseDouble(args[3] );
    	ymin = Double.parseDouble(args[4] );
    	ymax = Double.parseDouble(args[5] );
    	searches_density = Double.parseDouble(args[6] );
    	
    	// Initialize 
    	terrain = new TerrainArea(rows, columns, xmin,xmax,ymin,ymax);
    	num_searches = (int)( rows * columns * searches_density );
    	searches= new Search [num_searches];
    	for (int i=0;i<num_searches;i++){
    		searches[i]=new Search(i+1, rand.nextInt(rows),rand.nextInt(columns),terrain);
		}

		if(DEBUG) {
    		/* Print initial values */
    		System.out.printf("Number searches: %d\n", num_searches);
    		//terrain.print_heights();
    	}

    	//start timer
    	tick();

		ParallelMinimization newprocess = new ParallelMinimization();
		threadpool.invoke(newprocess);
   		//end timer
   		tock();


		System.out.printf("Run parameters\n");
		System.out.printf("\t Rows: %d, Columns: %d\n", rows, columns);
		System.out.printf("\t x: [%f, %f], y: [%f, %f]\n", xmin, xmax, ymin, ymax );
		System.out.printf("\t Search density: %f (%d searches)\n", searches_density,num_searches );

		/*  Total computation time */
		System.out.printf("Time: %d ms\n",endTime - startTime );
		int tmp=terrain.getGrid_points_visited();
		System.out.printf("Grid points visited: %d  (%2.0f%s)\n",tmp,(tmp/(rows*columns*1.0))*100.0, "%");
		tmp=terrain.getGrid_points_evaluated();
		System.out.printf("Grid points evaluated: %d  (%2.0f%s)\n",tmp,(tmp/(rows*columns*1.0))*100.0, "%");
	
		/* Results*/
		System.out.printf("Global minimum: %d at x=%.1f y=%.1f\n\n", min, terrain.getXcoord(searches[finder].getPos_row()), terrain.getYcoord(searches[finder].getPos_col()) );
    }
}

