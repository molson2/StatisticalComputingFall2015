/*
  Implement the Gibbs sampler from beginning of notes.
  Illustrates how to compile an Rcpp example from separate file.
  You can also make use of other libraries (STL, OpenMP, etc)
  by including the appropriate header files.
*/

#include <Rcpp.h>
using namespace Rcpp;

// Need to type the below macro exactly for things to work

// [[Rcpp::export]]
NumericMatrix gibbsCpp(int N, int thin){
  RNGScope scope;
  
  int i, j;
  double x=0.0, y=0.0;
  NumericVector xvec(N), yvec(N);

  for(i=0; i<N; i++){
    // Keep every n*thin sample
    for(j=0; j<thin; j++){
      x=rgamma(1, 3.0,1.0/(y*y+4))[0];
      y=rnorm(1, 1.0/(x+1),1.0/sqrt(x+1))[0];
    }
    
    xvec[i] = x;
    yvec[i] = y;
    
    // Print progress to R console
    if( !(i%500) ) Rprintf("Iter: %d\n", i);

  }
  // We can assign slices of a matrix.
  // Although, I'de rather use armadillo whenever I touch a matrix.
  NumericMatrix S(N,2);
  S(_,0) = xvec;
  S(_,1) = yvec;
  return S;

}

