# GMRF
svg(filename = "Gaussian_curve.svg")

par(mar=c(0,0,0,0))
plot(0,0,type="n",xlim=c(-4,4),ylim=c(-0.05,0.4),axes=FALSE)
curve(dnorm(x),-4,4,n=2000,xlab="",ylab="",add=TRUE)
segments(x0=-4,x1=4,y0=0,y1=0)

dev.off()

# Laplace approximation

# Gamma distribution
x <- seq(-1,25, length.out = 500)
y <- dgamma(x, 5,1)
plot(x,y, type = "n",
     axes = FALSE,
     xlab = "", ylab = "")
abline(h = 0, col = "lightgrey", lwd = 5)
lines(x,y, lwd = 5)
segments(x0 = x[which.max(y)],
        x1 = x[which.max(y)],
        y0 = 0,
        y1 = max(y), col = "blue", lwd = 5)

plot(log(dgamma(seq(-1,25, length.out = 200), 5,1)), type = "l")
