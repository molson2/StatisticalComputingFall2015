% Matt Olson 
% Gradient Descent
% September 18, 2015

# Gradient Descent #

## The algorithm ... ##

\begin{equation}
    x_{t+1} = x_{t} - \eta \nabla f(x_{t})
\end{equation}

## Code for the algorithm ##

~~~~ {.matlab}
function [x] = gradientDescent(gradf, maxIter, x0, eta)
    TOL = 1e-6;
    iter = 1;
    x = x0;
    while (norm(gradf) > TOL) && iter <= maxIter
        x = x - eta*gradf(x);
        iter = iter + 1;
    end
end
~~~~


