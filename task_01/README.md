### HOW-TO

The program is in [receipts.pl](receipts.pl).

To run program:

```shell
$ swipl receipts.pl
```

In prolog run main predicate:

```prolog
main.
```

Answer questions until final result.

If IČO has invalid format, type any wrong IČO, i.e. `12345678` or `12341234` to stop querying for IČO in correct format.

### Implementation details

- Program is written using Horn clause form, except one place in `ask` function, because prolog do not support straightforward way to break from inner predicate call. But all other predicates are in Horn clause form.
- Implementation tries to save known facts as much as possible to avoid practically same questions asked twice, i.e. `missing(IČO)` and `has(IČO)` check if same kind of question is asked, even regarding negative counterparts.

### Test dataset results

Test results are in [test_results.txt](test_results.txt).

```text
test0001 ano 11
test0002 ne null
test0003 ano 10
test0004 ano 6
test0005 ano 3+4
test0006 ano 5
test0007 ano 11
test0008 ano 5
test0009 ano 12
```

### Bonus implementation

To required implementation additionally were added:
- automatic IČO checking, where user should type IČO in correct format. 
- validation of input and querying again if IČO is in incorrect format (letters, longer input, etc.).
- printed instructions to validate certain fields, if needed.