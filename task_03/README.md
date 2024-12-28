
Used automatic training in OpenMarkov for both:

1) Hill Climbing Algorithm
    - Metric: K2 
    - $\alpha$ = 0.5 (Laplace-like correction)
    - Width-equal binning with 3 bins

![](images/bayes_net_hc.png)

2) PC Algorithm
   - Independence test: Cross Entropy
   - significance level: 0.05 
   - $\alpha$ = 0.5 (Laplace-like correction)
   - Width-equal binning with 3 bins

![](images/bayes_net_pc.png)