set.seed(123)

library(car)

# Anzahl Wiederholungen
B <- 1000   

# Für jede Wiederholung eine Stichprobe der Größe 3 ziehen
sim_vals <- replicate(B, {
  z <- rnorm(1)       # N(0,1), rm(1)
  x <- z^2       # is distributed as Chisquared(df=1)
})
hist(sim_vals)

# Histogramm mit theoretischer Chi-Quadrat-Dichte
hist(sim_vals, breaks = 30, probability = TRUE,
     main = expression("Simulierte Werte vs. "*chi^2*" Dichte (df=1)"),
     xlab = "Werte")
curve(dchisq(x, df = 1), add = TRUE, lwd = 2, col = "red")
legend("topright", legend = c("Theor. χ²-Dichte"), col = "red", lwd = 2)

# Q-Q Plot gegen theoretische χ²-Verteilung
qqPlot(sim_vals)
qqPlot(sim_vals, distribution = "chisq", 
       df = 1)

