/*
RcppArmadillo implementation of LM, plus some other junk for illustration
*/

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;
using namespace arma;

// The signature List lmCpp(mat XX, vec yy)
// also works fine; here is another way to do it

// [[Rcpp::export]]
List lmCpp(NumericMatrix XX, NumericVector yy){

  // Cast NumericMatrix etc. to arma types
  vec y = as<vec>(yy);
  mat X = as<mat>(XX);
  int n = X.n_rows;
  int p = X.n_cols + 1;

  // Append a column of ones to X (Matlab: X = [ones(n,1) X])
  X = join_rows(ones(n,1),X);
  
  // Solve for beta: (Matlab: b = X\y;)
  vec b = solve(X,y);

  //For fun, let's replicate b using the LS formula...
  vec bCheck = solve(X.t() * X, X.t()*y);
  if(norm(b-bCheck,1) > 1e-10)
    stop("Uh oh...");

  // Residual
  //  vec r = y-X*b;
  mat r = y-X*b;
  
  // Residual std.err
  double sigma = as_scalar(sqrt(sum(pow(r,2.0))/(n-p)));

  // Covariance matrix of beta
  mat Sigma = pow(sigma,2.0) * inv(X.t() * X);

  // Create output structure
  List L = List::create(Named("beta")=b, Named("sigma")=sigma, Named("Sigma") = Sigma);
  return L;

}
