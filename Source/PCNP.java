import java.util.Scanner;

public class PCNP {	
	public static void main(String[]args){ 
    //put in the parameter
	Scanner in=new Scanner(System.in);
	System.out.print("n=");
	int n=in.nextInt();
	System.out.print("K=");
	int K=in.nextInt();
	double [] weight=new double[n];
	double[][]b=new double[n][n];
	//put in the difference of factors
	for (int i=0;i<n;i++){
		for(int j=0;j<n;j++){
			if (i==j){
			b[i][j]=0;
			}else{			
			  System.out.print("b"+(i+1)+(j+1)+"=");
			  double a=in.nextDouble();
			  while (a<-K||a>K){
				 System.out.println("Please putin b between "+(-K)+" and "+(K));
				 System.out.print("b"+(i+1)+(j+1)+"=");
				 a=in.nextDouble();
			  }
			  b[i][j]=a;
			}
		 }
	  }
	//calculate the weight
	for (int i=0;i<n;i++){
		double sum=0;
		for(int j=0;j<n;j++){
		sum=sum+b[i][j];
		}
		weight[i]=(sum/n+K)/(n*K);
		System.out.println("weight"+(i+1)+"=="+weight[i]);
	}
	
  }
}
