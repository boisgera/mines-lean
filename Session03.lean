
/-!
Local scope
--------------------------------------------------------------------------------

- local definitions
- local defs are not expression, they don't make sense in isolation:
  #eval (let x := 3.0 ; x + 1) vs #eval (let x := 3.0)
- desugaring of let (IIFE)
- local *function* definition

-> Autonomous work: rest of the chapter on functions
-/

/-!
Commands
--------------------------------------------------------------------------------

- `#guard`

- `#guard_msgs in` (vs `#eval`) (mmmm maybe not)

- `#synth`

-/


/-!
Main CLI Entry Point
--------------------------------------------------------------------------------

- arguments
- `args[]!`, `panic!` (or don't? would cannibalize pattern matching skill acqu?
  do but with a warning)
- return value
- `<-` (example with Timestamp) ; first create timestamp manually and
  check that it can be printed (also use #synth).
  Then use `Timestamp.now`, who has a different signature.


-/

/-
Inductive Types and Pattern Matching
--------------------------------------------------------------------------------

The construct in three (and a half) steps:
- variant/union/sum types (ex: `Traffic.Light`) -> def of a toString function.
  def of a `next` function, etc. def of a `toNat` function, etc...
  Std example : `Bool`
- product types (ex: `Point2D`) -> structures ; example def : origin,
  distance (?), etc.
  -> autonmous work: structure syntax stuff...
- mix these (ex : CSS.Color with RGB or name).
  Example of `Int`, of `Option` and `[]?` ; example of `Except` (?)
- induction and genericity : Nat, List, Tree, etc.
  **Tree representation**
  recursive definitions via structural induction (total function).
  A word about partial functions (collatz) and well-ordered induction.
  `let rec` for rec function in local scope.

  MyNat (or `Number`): define add, sumTo, toNat, toString (with instance)

  Terminal recursion? factorial, fibonacci (non-terminal recursive versions),
  fact and fib better with aux fct / default values and terminal recursive
  implementations.

  UPDATE : use modulo for both. Collatz only if time permits.
  example of partial rec def (collatz-steps-to-one)
  exmple of well-founded recursion with modulo.

  List.length,
  List.reverse before!!! need aux function, simple enough, needed in .concat,
  which does not requires anything recursive else than reverse.
  What about List.append then? Ah, this one is actually easy (also
  requires a reverse before hand, then a recursion on the reversed argument
  which implements a generalisation of .reverse actually, with a non-empty
  destination). Mmmm, interesting, since we already have that!

  So what's "natural" imho it to see that to do reverse you need a reverseAux
  with a non-nil destination, then concat becomes trivial (compose reverse,
  cons and reverse). And append could be implemented as reverse on the first
  argument, then reverseAux on the target. Which is optimal? the number of
  operation would be 2 times the length of the first list argument.
  Nah that can be reduced to n with direct recursive def.
  MMmm well that depends how you count pattern match/function calls...

  Tree.size, Tree.depth?
  Arithmetic expressions? (small calculus)

More about lists:
  - filter, map, |>
  - sum for List of Floats, manually. rec. elem def ; then left-folding version.
    foldr, foldl in generality?
-/
