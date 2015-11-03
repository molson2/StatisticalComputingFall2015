nslots <- strtoi(Sys.getenv("NSLOTS"))
library(doParallel)
library(doRNG)
set.seed(123)

cl <- makeCluster(nslots, methods = FALSE, type = "MPI")
registerDoParallel(cl)

x <- foreach(i = 1:100, .combine="c" ) %dorng%  sqrt(i)

cat(x)

stopCluster(cl)
