Run:  python3 predikaty.py rules.tx

### Implementation details

#### evaluations.py

The `solve` function doesn't use standardization, because variables are already unique across all the KB. (standardization is used to make names of variables to be unique across KB, so there is no fact in KB with same variable name as in the rule).


