/*
  Implement corrolation-based PCA using an SVD.
*/

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;
using namespace arma;

// [[Rcpp::export]]
List pca(mat X){
  
  int n = X.n_rows;

  // Standardize columns of X
  // Matlab code: S = (X-repmat(mean(X,1), [n 1]))./repmat(std(X,1), [n 1])
  // Notice also that "bycol" is 0 for the mean and stddev functions
  mat S = (X-repmat(mean(X,0), n, 1))/repmat(stddev(X,0), n, 1);

  mat U;
  vec d;
  mat V;
  
  // Matlab [U, d, V] = svd(X);
  svd(U,d,V,S);

  mat pcaScore = S * V;
  List out = List::create(Named("princomps")=V, Named("pcaScore")=pcaScore);
  return out;

}
