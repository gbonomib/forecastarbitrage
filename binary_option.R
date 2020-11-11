# LIBS
library(RQuantLib)
library(purrr)

# SIMULATE VEGA
underlying <- c(100, 100*0.8, 100/0.8)
vega <- list()
for(s in seq_along(underlying)){
  volatility <- seq(0,5, 0.01)
  vega[[s]] <-purrr::map_dbl(volatility, ~{
    RQuantLib::BinaryOption(
      binType = 'cash',
      type = 'call',
      excType = 'european',
      underlying = underlying[s],
      strike = 100,
      dividendYield = 0,
      riskFreeRate = 0,
      maturity = 1,
      volatility = .x,
      cashPayoff = 1)}$value)
}

# PLOT VEGA
par(mfrow=c(1,3))
plot(volatility, vega[[2]], type = 'l', main = 'Out-Of-The-Money', ylab = 'value')
legend("topright", legend = c("S = 80\n", "K = 100\n", "TTM = 1y\n"), inset = c(0.1, 0.1), bty = "n")
plot(volatility, vega[[1]], type = 'l', main = 'At-The-Money', ylab = 'value')
legend("topright", legend = c("S = 100\n", "K = 100\n", "TTM = 1y\n"), inset = c(0.1, 0.1), bty = "n")
plot(volatility, vega[[3]], type = 'l', main = 'In-The-Money', ylab = 'value')
legend("topright", legend = c("S = 100\n", "K = 125\n", "TTM = 1y\n"), inset = c(0.1, 0.1), bty = "n")


# SIMULATE FORECAST/BINARY OPTION APPROACHING MATURITY
vol = 0.01
strike = 100
years <- 1
days <- years*365
values <- list()
underlying <- list()
vols <- c(10, 1, 0.1, 0.01)
for(idx in seq_along(vols)){
  set.seed(123)
  vol = vols[idx]
  underlying[[idx]] <- filter(c(strike, rnorm(days-1, 0, vol)), 1, 'r')
  values[[idx]] <- purrr::map2_dbl(seq_len(days), underlying[[idx]], ~{
    RQuantLib::BinaryOption(
      binType = 'cash',
      type = 'call',
      excType = 'european',
      underlying = .y,
      strike = strike,
      dividendYield = 0,
      riskFreeRate = 0,
      maturity = years/.x,
      volatility = vol,
      cashPayoff = 1)$value})
}

# PLOT FORECA
par(mfrow=c(1,1))
plot(values[[1]], ylab = 'value', xlab = 'days', col = 'gray',
     type = 'l', ylim = c(0,1),
     main = paste("Binary Option Price | VOL = ", paste(sort(vols), collapse = ", ")))
lines(values[[2]], col = 'gray')
lines(values[[3]], col = 'gray')
lines(values[[4]], col = 'black')
