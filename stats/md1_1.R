library(prob)
# HOMEWORK - SIMPLE PROBABILITY SPACES IN R (Lecture 1, task 1)

# SUBSECTION 1
roll2 = iidspace(c(1:6), ntrials=2, probs=rep(1/6, times=6))
A = subset(roll2, X1 == X2)
B = subset(roll2, X1+X2 >= 7 & X1+X2 <= 10)
C = subset(roll2, X1+X2 == 2 | X1+X2 == 7 | X1+X2 == 8)
test1 = subset(roll2, X1 == 1)
test2 = subset(roll2, X2 == 2)
# Individual probabilities
Prob(A)
Prob(B)
Prob(C)
# Compare conditional prob to multiplied
(Prob(intersect(A,B,C)) == Prob(A) * Prob(B) * Prob(C))
# Are A and B independent?
(Prob(intersect(A,B)) == Prob(A) * Prob(B))
# Are B and C independent?
(Prob(intersect(B,C)) == Prob(B) * Prob(C))
# Test to see if the darn formula even works
(Prob(intersect(test1, test2)) == Prob(test1) * Prob(test2))

# SUBSECTION 2
roll3 = iidspace(c(1:6), ntrials=3, probs=rep(1/6, times=6))
A = subset(roll3, !((X1 == X2) | (X1 == X3) | (X2 == X3)))
B = subset(roll3, X1 == 1 | X2 == 1 | X3 == 1)
Prob(B, given = A)