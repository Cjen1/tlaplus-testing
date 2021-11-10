---- MODULE MC ----

EXTENDS VectorPaxos, TLC, Integers

Symmetry == Permutations(Commands) \union Permutations(Acceptors)

ILEQ(a,b) == a <= b

RECURSIVE BalDepth(_)
BalDepth(b) == 
  IF b = InitBalNum
  THEN 0
  ELSE 1 + Max(ILEQ, {BalDepth(b1): b1 \in b[2]})

MaxBallotDepth ==
  LET nacks == {m \in msgs: m.type = "nack"}
      m1a == {m \in msgs: m.type = "1a"}
      m1b == {m \in msgs: m.type = "1b"}
      m2a == {m \in msgs: m.type = "2a"}
      m2b == {m \in msgs: m.type = "2b"}
      mbals == {m.balNum : m \in nacks} \cup 
               {m.balNum : m \in m1a}   \cup
	       {m.balNum : m \in m1b}   \cup
	       {m.bal.bal : m \in m2a}  \cup
	       {m.bal.bal : m \in m2b}
      accMBals == {acc[a].maxBalNum : a \in Acceptors}
      accMVBals == {acc[a].maxBal.bal : a \in Acceptors}
      propBals == {prop[p].balNum : p \in Proposers}
      bals == mbals \cup accMBals \cup accMVBals \cup propBals
  IN Max(ILEQ, {BalDepth(b) : b \in bals})

CONSTANT MaxDepth
BallotConstraint == MaxBallotDepth <= MaxDepth

=============================================================================
\* Modification History
\* Created Thu Sep 09 11:49:18 BST 2021 by cjen1
