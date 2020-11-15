Hi - hope I am not too late to the party.

**tl;dr** Taleb's paper draws incorrect conclusions from a set of wrong assumptions. 
In practice, [the movements of the forecast at 538][1] are very much in line with what can be defined an "arbitrage free prediction" based on a binary option model.

---

The gist of the article is summarized in its incipit.

> A standard result in quantitative finance is that when the volatility of the underlying security increases, arbitrage pressures push the corresponding binary option to trade closer to 50%, and become less variable over the remaining time to expiration. Counterintuitively, the higher the uncertainty of the underlying security, the lower the volatility of the binary option. This effect should hold in all domains where a binary price is produced – yet we observe severe violations of these principles in many areas where binary forecasts are made, in particular those concerning the U.S. presidential election of 2016.

There are quite a number of fallacies in the above statements:

*Taleb's assumptions:*
 1. Any forecast of a dichotomous outcome is equivalent to the pricing of a binary option. 
 2. Increase in the underlying's volatility pushes a binary option price to trade close to 50% of its payoff. **Incorrect**
 3. Increase in the underlying's volatility reduces the volatility of the option price itself. **Incorrect**

*Taleb's Conclusions:*

Any forecasts of binary outcomes should behave according to principles 1 and 2. Therefore any prediction that - at the same time - *a)* claims high uncertainty and that *b)* fluctuates heavily, goes against no-arbitrage principle, or put otherwise: 538's predictions is rubbish. **For the sake of clarity, this is not a valid claim!**

---

**Analysis of assumption no.1**
Assume we are happy with 1, i.e. we agree to model the an election forecast as a binary option. From a financial perspective, the underlying `S` can be interpreted as the "consensus" for the two candidates, being the strike `K` the amount of consensus required to "exercise" the option (i.e. to claim the elections). Tbh, one could argue on the appropriateness of the choice of a binary option since the "consensus variable" `S` that has a lower bound (zero, as prices cannot go negative). Let us pass on that critique assuming that it is not a big issue when `S` and `K` are sufficiently distant from 0. Side note - we will be working with an `European Call Option` (as elections are normally "callable" only at expiry, i.e. only after election day has passed - wink wink).

---

**Analysis of assumption no.2**
We hereby simulate how the price of a binary option with the above mentioned features behaves with changes in volatility. We examine the outcome for ATM, ITM, and OTM options, for the sake of completeness. **Regardless from the moneyness of the option, the increase in volatility pushes the option value towards 0.** *This invalidates assumption no.2*

[![Moneyness - Vega][2]][2]

- The price of an OTM binary option is 0% of the payoff for very small and for very large volatilities. There is a sweet volatility spot where option value is maximized, which can be interpreted as the level of volatility that maximises the chances of S > K at maturity. Away from that sweep spot the increasing chances that the S < K at maturity push option value to 0.

- The price of an ATM binary option is exactly 50% of its payoff for small volatilities then decays to 0. The higher the volatility the higher the chances that the S < K at maturity.

- The price of an ITM binary option is 100% of the payoff for small volatilities then decays to 0. The higher the volatility the higher the chances that the S < K at maturity.

A more extensive discussion on binary option *vega* can be found here: [https://quant.stackexchange.com/questions/2059/how-does-volatility-affect-the-price-of-binary-options][3]

---

**Analysis of assumption no.3**
We hereby simulate how the price of a binary option fluctuates as it approaches maturity, based on the volatility of the underlying process `S`. We examine here the case of an ATM Option, outcome for OTM and ITM are however aligned. Simulation covers one year time period prior to the exercise. Our methodology requires that the same binary option is re-priced daily based on a) the `TTM` (time-to-maturity) and on b) the value of the underlying discrete random process `S` which is assumed to behave as a random walk. Perfect knowledge of the underlying process is assumed, i.e. the `vol` of the binary option is perfectly aligned to the true volatility volatility of `S`.

 [![Binary Option Price Fluctuation][4]][4]

The increase in volatility pushes the option value towards 0 for larger `TTM` but the process converges (i.e the forecast) converges closer to expiry. **Regardless from the volatility of the underlying process, the price of the binary option never converges to 50%** *This invalidates assumption no.3*

There is an interesting [post on Quora][5] that highlights how Taleb "proves" his point by means of a chart (Fig 3. in Taleb's paper) generated with a incorrect Mathematica code. I am not sure if he purposefully uses that chart to deceive a reader already confused by his math or if this is a genuine - though misguided - attempt of his to numerically prove the theory. Either way, it is not correct.

---

I feel there is quite some confusion revolving this paper and its commentaries, partially due to the cryptic and unapologetic style of Taleb as well as to the fact that many opinions on the issue are imo excessively polarized by the pov of his follower/detractors.

For the sake of transparency: all the analysis above are based on the implementation of binary option pricer from https://www.quantlib.org/ and the script used for the analysis is available for scrutiny and corrections at my [github][6]

---

**Edit**:

If `S` is assumed to follow Arithmetic Brownian Motion:

**Analysis of assumption no.2** We hereby simulate how the price of a binary option with the above mentioned features behaves with changes in volatility. We examine the outcome for ATM, ITM, and OTM options, for the sake of completeness. **Option price converges towards 50% as volatility increases.** *This is coherent with Assumption 2*

[![Moneyness - Vega | Arithmetic Brownial Motion][7]][7]

**Analysis of assumption no.3**
We hereby simulate how the price of a binary option fluctuates as it approaches maturity, based on the volatility of the underlying process `S`. We examine here the case of an ATM Option, outcome for OTM and ITM are however aligned. Simulation covers one year time period prior to the exercise. Our methodology requires that the same binary option is re-priced daily based on a) the `TTM` (time-to-maturity) and on b) the value of the underlying discrete random process `S` which is assumed to behave as a random walk. Perfect knowledge of the underlying process is assumed, i.e. the vol of the binary option is perfectly aligned to the true volatility volatility of `S`.

[![Binary Option Price Fluctuation | Arithmetic Brownial Motion][8]][8]

The fluctuation of the forecast is completely insensitive to different values of volatility. The charts for different volatility *perfectly* overlaps. This is explained by observing that the volatility of the realized process `S` (i.e. the swings in the consensus) is the same as that employed. **Regardless from the volatility of the underlying process, the price of the binary option never converges to 50%** *This (still) invalidates assumption no.3*

---

**Postscript**

Taleb's main argument is that an arbitrage-free forecast should stick around 50% as volatility increases. This can only be true under the assumption that *a)* the future volatility of the consensus `S` will be *much* larger than the historical volatility and *b)* **that the polls will not reflect such change in volatility**. (The gray lines in the chart are the representation of the option price w/ forward volatility being 2x, 5x and 10x of the polled volatility). 

[![Binary Option Price Fluctuation | Arithmetic Brownial Motion | Larger FWD vol][9]][9]

Clearly, if you believe that *polls are rubbish* it is then perfectly meaningful to model the election as a coin-toss. It is - I hope - self-evident that **this position does not stand to the simplest of backtesting (i.e. poll-based prediction is in hindsight much more accurate than a coin-toss)**. There is some irony in the observation that Taleb's 50-50 prediction could be more prone to arbitrage than 538's one. 

Conversely, if we accept the assumption that the polls will keep adjusting to the "true" new volatility, then the forecast fluctuation is pulled towards the "volatility insensitive" limiting black line.


  [1]: https://projects.fivethirtyeight.com/2020-election-forecast/
  [2]: https://i.stack.imgur.com/DaEto.png
  [3]: https://quant.stackexchange.com/questions/2059/how-does-volatility-affect-the-price-of-binary-options
  [4]: https://i.stack.imgur.com/vg32b.png
  [5]: https://qr.ae/pNOkdZ
  [6]: https://github.com/gbonomib/forecastarbitrage/
  [7]: https://i.stack.imgur.com/A0dFt.png
  [8]: https://i.stack.imgur.com/iHIJr.png
  [9]: https://i.stack.imgur.com/QNpTT.png

