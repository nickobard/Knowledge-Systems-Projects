
### Data Inspection

Basic data inspection is in the [data_inspection.ipynb](data_inspection.ipynb) notebook.


### Datasets

Original dataset is `data.csv` (from Kaggle, version 2), modified dataset is in the `preprocessed_data.csv`, where one column was removed (see data inspection notebook).

### Open Markov

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