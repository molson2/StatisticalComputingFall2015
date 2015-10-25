# Andreas Buja: 10/22/2015

##================================================================


## DATA PROCESSING WITH THE PACKAGE 'DPLYR'


## * PACKAGES in R: contributed software, deposited usually on the CRAN site at
##     https://cran.r-project.org/
##   Currently > 7000 packages, and growing.
##
##   - We will use as a first package 'dplyr' by H. Wickham.
##       It has some powerful and fast ways of getting simple answers quickly
##       from dataframes.  You will be doing useful things in no time.
##
##   - Install the package 'dplyr' once:
##       RStudio:  Tools > Install Packages > (type:) dplyr > Install
##       ... (wait till it finished successfully)


## * STARTING UP WITH 'DPLYR':
##
##
##   - In every session in which you use a package, you have to
##     enact it with the 'library()' function:
         library(dplyr)
##     (Later we'll see how to do this automatically for your favorite packages.)
         search()
##     You will now find a namespace "package:dplyr" which contains the symbols
##     of data and functions that come with the package 'dplyr'.
         ls("package:dplyr")   # 202 symbols righ here!
##     We will have a look at only a handful of these.
##
##
##   - Add some printing capabilities to the dataframe
##     using the function 'tlb_df()':
         realEst.tbl <- tbl_df(realEst)
##     This is still a dataframe:
         is.data.frame(realEst.tbl)   # TRUE
##     So you can still do with it what you can do with dataframes, such as:
         dim(realEst.tbl)   # [1] 225  21
         str(realEst.tbl)
##     but the information prints in abbreviated form:
         realEst.tbl
         realEst.tbl[,"Location"]
##     as opposed to
         realEst
##     which prints the whole thing.
##     This prevents you from INADVERTENTLY PRINTING LARGE DATASETS.
##     This a nuisance that happens quite a lot by mistake because
##     few data analysts have the patience to write brackets every time
##     to limit what is printed:
         realEst[1:10,1:5]


## * THE POWERS OF 'dplyr':
##
##   The functions of 'dplyr' work like 'with()':
##   the first argument is a dataframe, and in the following arguments we can
##   use the column names as as symbols, unquoted.
##
##   The package offers a handful of intuitive functions for some of the most
##   common data-analytic tasks:
##
## - Selecting cases/rows:
       filter(realEst.tbl,    Location=="SUBNEW")           # Select cases; similar to'subset()'
       filter(realEst.tbl,    Location=="SUBNEW", Age<10)   # Select cases; combined by '&'
       # Same without 'dplyr':
           realEst.tbl[realEst.tbl[,"Location"]=="SUBNEW",]
           realEst.tbl[realEst.tbl[,"Location"]=="SUBNEW" & realEst.tbl[,"Age"]<10, ]
## - Selecting variables/columns:
       select(realEst.tbl,    Location, Renttotal, Sqft)    # Select variables/columns
       # Same without 'dplyr':
           realEst.tbl[, c("Location", "Renttotal", "Sqft")]
## - Sorting, ascending and descending:
       arrange(realEst.tbl,   Renttotal)                    # Sort by 'Renttotal', ascending
       arrange(realEst.tbl,   desc(Renttotal))              #    "         "     , descending
       arrange(realEst.tbl,   Location, desc(Renttotal))    #    "    Location, and within by -Renttotal
       # Same without 'dplyr':  (dont' worry yet...)
           ord <- order(realEst[,"Renttotal"]);                         realEst[ord,]
           ord <- order(realEst[,"Renttotal"], decr=T);                 realEst[ord,]
           ord <- order(realEst[,"Location"], -realEst[,"Renttotal"]);  realEst[ord,]
## - Global summaries:
       summarize(realEst.tbl,                               # Summary stats to your liking
                 mean = mean(Renttotal),                    # Wickham is from NZ, so he writes 'summarise()'
                 sdev = sd(Renttotal),                      # in his documentation, but both 'z' and 's' work.
                 min = min(Renttotal),
                 max = max(Renttotal),
                 n=n() )
## - Grouped summaries:
       summarize(group_by(realEst.tbl, Location),        # <<<<<<<< grouping the dataframe by 'Location'
                 mean = mean(Renttotal),
                 sdev = sd(Renttotal),
                 min = min(Renttotal),
                 max = max(Renttotal),
                 n=n() )
       summarize(group_by(realEst.tbl, Location, Firm),  # <<<<<<<< grouping the dataframe by 'Location', 'Firm'
                 mean = mean(Renttotal),
                 sdev = sd(Renttotal),
                 min = min(Renttotal),
                 max = max(Renttotal),
                 n=n() )
## - Creating new variables:
       mutate(realEst.tbl, Loc = c("CITY"="Center of City", "SUBNEW"="New Suburb", "SUBOLD"="Old Suburb")[Location])
       mutate(realEst.tbl, Rent1000 = Renttotal/1000, RentSqft = Renttotal / Sqft )


## * PIPES IN 'DPLYR':
##
##   Notation can get cumbersome even with 'dplyr' if we have to
##   nest functions inside functions.  Here is a more intuitive way of
##   achieving the same thing using the so-called 'pipe' operator '%>%':
##
       realEst.tbl  %>%  group_by(Location)  %>%  summarize(m=mean(Sqft), s=sd(Sqft))
##   Location        m        s
##      (chr)    (dbl)    (dbl)
## 1     CITY 21842.52 25640.40
## 2   SUBNEW 25795.45 26912.54
## 3   SUBOLD 19425.56 21549.29


## * HOW PIPES WORK IN 'DPLYR':
##
##   - You type the dataframe just once at the beginning of the pipe.
##     This becomes the first argument to the second expression,
##     so you type the function in the second expression without its
##     first argument (the dataframe).
##   - Subsequently, at every step of the pipe, the result of the previous
##     expression becomes the first argument to the next pipe expression.
##   - The last expression returns the final result.
##
##  What's behind '%>%'?  It is a binary operation which does just this:
##  Takes the result of the first argument and uses it as the first argument
##  to the second expressions.
##
##  Keep in mind that all 'dplyr' functions create new dataframes from old dataframes,
##  except for the 'summarize()' function.


## * A BIG EXAMPLE:
##
##   Tasks:
##   . Re-express Renttotal in $1000
##   . Calculate Rent per Sqft
##   . Re-express Sqft in 1000 Sqft
##   . Group by 'Location', and within 'Location' by 'Firm'
##   . Show grouped 'mean()' for Renttotal in $1000, Rent/Sqft, and Sqft in 1000s
##     as well as the number of properties in each group.
##
       realEst.tbl                                  %>%
           select(Renttotal, Sqft, Location, Firm)  %>%     # Not necessary but efficient
               mutate(RpS   = Renttotal / Sqft,             # Define new columns
                      R1000 = Renttotal/1000,
                      S1000 = Sqft/1000)            %>%
                   group_by(Location, Firm)         %>%     # Group by CITY, SUBNEW, SUBOLD
                       summarize(meanR1000=mean(R1000),
                                 meanRpS=mean(RpS),
                                 meanS=mean(S1000),
                                 count=n())                 # Note: counts obtained with 'n()'
##
##    Location   Firm meanR1000  meanRpS     meanS count
##       (chr)  (chr)     (dbl)    (dbl)     (dbl) (int)
## 1      CITY   BUS. 935.19782 26.84396 34.252295    17
## 2      CITY DOCTOR 136.44547 24.32557  5.620931    15
## 3      CITY   GOVT 669.92467 28.39932 23.770878    15
## 4      CITY  LEGAL 533.30180 25.10381 20.849238    25
## 5      CITY  OTHER 812.34400 22.85472 35.974685     2
## 6    SUBNEW   BUS. 827.75870 22.92507 34.553552    54
## 7    SUBNEW DOCTOR 123.12160 22.50435  5.433931    10
## 8    SUBNEW   GOVT 484.90812 21.71153 21.396540     8
## 9    SUBNEW  LEGAL 346.54900 22.01201 15.699382     9
## 10   SUBNEW  OTHER 127.57371 23.90827  5.328771     7
## 11   SUBOLD   BUS. 509.31494 21.42877 22.940759    16
## 12   SUBOLD DOCTOR  66.97362 21.25607  3.243210    13
## 13   SUBOLD   GOVT 492.71200 21.39503 22.741808     4
## 14   SUBOLD  LEGAL 599.28040 20.62781 28.251013    25
## 15   SUBOLD  OTHER  73.05100 21.17857  3.470754     5
##
##   The table as shown is hideous because of the decimals.
##   Do some reasonable rounding, and try another choice of column labels:
       realEst.tbl  %>%
           select(Renttotal, Sqft, Location, Firm)  %>%
               mutate(RpS = Renttotal / Sqft,
                      R1000 = Renttotal/1000,
                      S1000 = Sqft/1000)  %>%
                   group_by(Location, Firm)  %>%
                       summarize("Rent_($K)" =round(mean(R1000)),
                                 "Rent/Sqft" =round(mean(RpS),2),
                                 "Sqft_(K)"  =round(mean(S1000),1),
                                 "Count"     =n() )
##
##    Location   Firm Rent_($K) Rent/Sqft Sqft_(K) Count
##       (chr)  (chr)     (dbl)     (dbl)    (dbl) (int)
## 1      CITY   BUS.       935     26.84     34.3    17
## 2      CITY DOCTOR       136     24.33      5.6    15
## 3      CITY   GOVT       670     28.40     23.8    15
## 4      CITY  LEGAL       533     25.10     20.8    25
## 5      CITY  OTHER       812     22.85     36.0     2
## 6    SUBNEW   BUS.       828     22.93     34.6    54
## 7    SUBNEW DOCTOR       123     22.50      5.4    10
## 8    SUBNEW   GOVT       485     21.71     21.4     8
## 9    SUBNEW  LEGAL       347     22.01     15.7     9
## 10   SUBNEW  OTHER       128     23.91      5.3     7
## 11   SUBOLD   BUS.       509     21.43     22.9    16
## 12   SUBOLD DOCTOR        67     21.26      3.2    13
## 13   SUBOLD   GOVT       493     21.40     22.7     4
## 14   SUBOLD  LEGAL       599     20.63     28.3    25
## 15   SUBOLD  OTHER        73     21.18      3.5     5
##
##   Much better.  You can show this to your collaborators.
##
##   If you prefer nesting of Location within Firm,
##   change their order by switching the order from
##     'group_by(Location, Firm)'
##   to
##     'group_by(Firm, Location)'


## * WHAT IS RETURNED BY 'summarize()'?  A DATAFRAME!
##
##   Examine by assigning the returned structure to a symbol:
     tmp <- realEst.tbl                           %>%
              group_by(Firm)                      %>%  # Group by Firm type
                summarize("Count" = n() )            # Think of 'n()' as 'length()'.
     tmp
     str(tmp)
 
