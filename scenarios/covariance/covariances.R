popsize <- 1000
d <- 1/(2*popsize)
pops <- c("p4","p5","p2", "p3")


c41 <- 850
c42 <- 100
c5  <- 100
c21 <- 500
c22 <- 100
c3  <- 600
cC  <- 500

w <- 0.7
f <- matrix(
  c( c41 + c42 , w*c41                            ,              0 ,       0,
     w*c41     , c5 + w*c41 + (1-w)*(c21+cC)      ,          (1-w)*(cC+c21),      cC,
     0         , (1-w)*(cC + c21)                         , cC + c21 + c22 ,      cC,
     0         , cC                               , cC             , cC + c3
  ), nrow = length(pops)
)

f <- d*f

rownames(f) <- pops
colnames(f) <- pops

f
write.table(f, "simple_w070.tab",
            sep =  " ",
            row.names = TRUE,
            col.names = FALSE,
            quote = FALSE)

