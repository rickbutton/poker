# Enova No-Limit-Code-Em poker bot

Written by Rick Button and Scott Opell over a 5 hour hackathon at Purdue University.

## How it works

We base our actions on the expected value of a call.

```
p = Probability of winning that hand
q = 1 - p
m = Current pot size
EV = (p * m) + (q * -call)
```

If the EV is positive, we are likely to stay positive with that hand in the long run, so we call. If it is negative, we fold. Plain and simple.

Later in the tournament, we added a more aggressive component to our algorithm. If the probability of winning a hand is greater than 50%, then we would raise using the Kelly Criterion, which is a percentage of the current stack (bankroll). It is calculated as follows.

```
p = Probability of winning that hand
b = 1 / p
f = (p * (b + 1) - 1) / b
```

If that value was within a certain threshold, we would play more aggressively.

Credits

[Scott Opell](http://github.com/scottopell) for writing the other half of the code, and doing math things.

Thanks to Enova for running a really fun hackathon.
