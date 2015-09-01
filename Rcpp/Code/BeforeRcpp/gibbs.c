#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <R.h>
#include <Rmath.h>
 
void gibbs(int *Np,int *thinp,double *xvec,double *yvec)
{
  int i,j;
  int N=*Np,thin=*thinp;
  GetRNGstate();
  double x=0;
  double y=0;
  for (i=0;i<N;i++) {
    for (j=0;j<thin;j++) {
      x=rgamma(3.0,1.0/(y*y+4));
      y=rnorm(1.0/(x+1),1.0/sqrt(x+1));
    }
    xvec[i]=x; yvec[i]=y;
  }
  PutRNGstate();
}
