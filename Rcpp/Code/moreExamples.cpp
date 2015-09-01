#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;
using namespace arma;

// Re-inventing the lapply function
// [[Rcpp::export]]
List lapplyCpp(List L, Function f){
  int n = L.size();
  List out(n);
  for(int i = 0; i<n;i++)
    out(i) = f(L(i));

  // Assign the names of L to out
  out.names() = L.names();
  return out;
}

/* A "stupid" version of outer.  The R function outer sometimes doesn't
   do what you want, so you can do this by brute force instead...
   this will probably be slower than the vectorized R version, but
   much faster than using R loops.
*/

// [[Rcpp::export]]
NumericMatrix outerCpp(NumericVector x, NumericVector y, Function f){

  int n = x.size();
  int m = y.size();
  NumericMatrix M(n,m);
  for(int i = 0; i < n; i++)
    for(int j = 0; j < m; j++)
      // Need to cast since f can have potentially any return type...
      // would want to find a better way to do this probably
      M(i,j) = as<double>(f(i,j));
  return M;

}

// Simulate a MVN (Taken from Rcpp by Example 2)
// [[Rcpp::export]]
mat mvn(int n, mat Sigma, vec mu){
  if (Sigma.n_cols != mu.n_elem)
    stop("Sigma and mu must conform!");
  mat Y = randn(n, Sigma.n_cols);
  return repmat(mu, 1, n).t() + Y * chol(Sigma);
}
