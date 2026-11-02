
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
  Tree representation.
  recursive definitions via structural induction (total function).
  A word about partial functions (collatz) and well-ordered induction.
  `let rec` for rec function in local scope.
  Examples : factorial, fibonacci (ugly), Nat.add, fib better with aux fct.
  example of partial rec def (collatz-steps-to-one)

  List.length,
  List.concat maybe?
  List.append (ouch!) : trick with definition of an auxiliary function.
  Same thing with fibonacci, a better implementation.

  Tree.size, Tree.depth?

  Arithmetic expressions? (small calculus)

More about lists:
  - filter, map, |>
  - sum for List of Floats, manually. rec. elem def ; then left-folding version.
    foldr, foldl in generality?
-/
