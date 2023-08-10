package ParallelVersion;

import java.util.Random;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveTask;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class MonteCarloMinimizationParallel extends RecursiveTask<Integer> {
	int min=Integer.MAX_VALUE;
    int local_min=Integer.MAX_VALUE;
	int finder =-1;
	int minsearch, maxsearch, leftret, rightret;
	static int[] nums;

	static SearchParallel[] searches;		// Array of searches

	MonteCarloMinimizationParallel(int minsearchin, int maxsearchin){
		minsearch = minsearchin;
		maxsearch = maxsearchin;
	}

	//OPTIMIZE FOR DIFFERENT ARRAY SIZES
	@Override
	protected Integer compute(){
		if(maxsearch-minsearch <= 8000){
			for(int i = minsearch; i < maxsearch; i++){
				local_min=searches[i].find_valleys();
				if((!searches[i].isStopped())&&(local_min<min)) { //don't look at those who stopped because hit exisiting path
					min=local_min;
					finder=i; //keep track of who found it
					nums[i] = min;
				}
			}
			return min;
		}
		else{
			int split = (int)((maxsearch+minsearch)/2);
			MonteCarloMinimizationParallel left = new MonteCarloMinimizationParallel(minsearch,split);
			MonteCarloMinimizationParallel right = new MonteCarloMinimizationParallel(split, maxsearch);
			left.fork();
			rightret = right.compute();
			leftret = left.join();
			return Math.min(leftret, rightret);
		}
	}
    static long startTime = 0;
	static long endTime = 0;

    private static void tick(){
		startTime=System.currentTimeMillis();
	}
	private static void tock(){
		endTime=System.currentTimeMillis(); 
	}
    public static void main(String[] args) {
		int rows; //grid size
		int columns;
		double xmin, xmax, ymin, ymax; //x and y terrain limits
		TerrainArea terrain;  //object to store the heights and grid points visited by searches
		double searches_density;	// Density - number of Monte Carlo  searches per grid position - usually less than 1!

		int num_searches;		// Number of searches
		
		Random rand = new Random();  //the random number generator
		
    	if (args.length!=7) {  
    		System.out.println("Incorrect number of command line arguments provided.");   	
    		System.exit(0);
    	}
    	//Read argument values
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
    	searches= new SearchParallel [num_searches];
    	for (int i=0;i<num_searches;i++){
    		searches[i]=new SearchParallel(i+1, rand.nextInt(rows),rand.nextInt(columns),terrain);
		}

		nums = new int[searches.length];

		int newmin;
		ForkJoinPool threadpool = new ForkJoinPool();
    	//start timer
    	tick();

		MonteCarloMinimizationParallel newprocess = new MonteCarloMinimizationParallel(0, num_searches);
		newmin = threadpool.invoke(newprocess);

   		//end timer
   		tock();
		
		
		int finder = 0;
		for(int i = 0; i < nums.length; i++){
			if(nums[i] == newmin){
				finder = i;
				break;
			}
		}

		boolean firstWrite = false;

		try {
			File Resultsdir = new File("Results/");
			if (!Resultsdir.exists()){
				Resultsdir.mkdir();
			}
			File myfile = new File(Resultsdir, "PResults.txt");
			if (!myfile.exists()){
				myfile.createNewFile();
				firstWrite = true;
			}
			FileWriter fw = new FileWriter(myfile, true);
			if(firstWrite){
				fw.write("Rows Columns Xmin Xmax Ymin Ymax Search_Density Global_Minimum Xpos Ypos Search_Time\n");
			}
			fw.write(rows + " " + columns + " " + xmin + " " + xmax + " " + ymin + " " + ymax + " " + searches_density + " " + newmin + " " 
			+ terrain.getXcoord(searches[finder].getPos_row()) + " " + terrain.getYcoord(searches[finder].getPos_col()) + " " + (endTime - startTime) + "\n");
			fw.close();
		} catch (IOException e){
			System.out.println("An error has occurred");
			e.printStackTrace();
		}
	
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
		System.out.printf("Global minimum: %d at x=%.1f y=%.1f\n\n", newmin, terrain.getXcoord(searches[finder].getPos_row()), terrain.getYcoord(searches[finder].getPos_col()) );
    }
}

