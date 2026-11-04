import Mathlib

/-!

Local scope
--------------------------------------------------------------------------------

We frequently use local definitions to simplify the definition of complex
expressions: instead of
-/

def f (x y : Float) : Float :=
  (x - y) / (x + y)

#eval f 3.0 2.0
-- 0.200000

/-!
we could use
-/

def f_alt (x y : Float) : Float :=
  let num := x - y
  let den := x + y
  num / den

#eval f_alt 3.0 2.0
-- 0.200000

#guard f 3.0 2.0 == f_alt 3.0 2.0

/-!
These `let` constructs do not make sense in isolation:
they merely define a binding for an identifier to be used locally,
in a specific expression.
-/

#eval 1.0 + 2.0
-- 3.000000

#eval (let x := 2.0 ; 1.0 + x)
-- 3.000000

#eval (let y := 1.0 ; let x := 2.0 ; y + x)
-- 3.000000

#eval (let x := 2.0 ; 1.0 + x)
-- 3.000000

/-!
This syntaxic construct is very convenient, but not fundamental. We could do
without it if we were ready to use the IIFE (immediately invoked function
expression) pattern instead.
-/

#check (fun (x : Float) => 1.0 + x) -- function definition
-- fun x => 1.0 + x : Float → Float

#eval (fun (x : Float) => 1.0 + x) 2.0 -- function def + invocation
-- 3.000000

#eval (fun (x : Float) => 1.0 + x) (x := 2.0) -- IIFE with named argument
-- 3.000000

/-!
Recursive functions
--------------------------------------------------------------------------------

Functions can be recursively defined. For example, we can define the
factorial function like that:

-/

def fact (n : Nat) : Nat :=
  if n = 0 then
    1
  else
    n * fact (n - 1)

#guard fact 5 = 5 * 4 * 3 * 2 * 1

/-!
Alternatively, we could define to emphasize the definition of a function
term and optionally prefer the mathematical notation of `↦` instead of
`=>` to define the association between the function argument and values
(the Mathlib community does prefer this, the Computer Science one tends
to stick with `=>`).
-/

def factAlt : Nat -> Nat :=
  fun n =>
    if n = 0 then
      1
    else
      n * factAlt (n - 1)

#guard factAlt 5 = fact 5

def factAlt2 : ℕ -> ℕ := fun n ↦
  if n = 0 then 1 else n * factAlt2 (n - 1)

#guard factAlt2 5 = fact 5

/-!
To locally define a function of this kind, `let rec` is required.
For example:
-/

def repeatStrAlt (s : String) (n : Nat) : String :=
  let rec repeat_s (k : Nat) : String :=
    match k with
    | 0     => ""
    | k + 1 => s ++ repeat_s k
  repeat_s n

#eval repeatStrAlt "ab" 3  -- "ababab"

/-!
Our definition of factorial is using structural recursion on its argument `n`:
it defines the value of `fact n` using the value of `fact (n - 1)`, with the
adjunction of a base case for `n = 0`. Some recursive function definitions
won't work like but are still valid terminating in every case, for example
-/

def mod (m n : Nat) : Nat := -- implementation of m % n
  if n = 0 ∨ m < n then
    m
  else
   mod (m - n) n

#eval mod 7 4 -- 3

/-!
This one is accepted by Lean because in a sequence of recursive calls,
the first argument `m` is a strictly decreasing natural number, hence
the sequence has to be finite. Here Lean recognizes that automatically;
this definition is actually equivalent to the one where we explicitly
specify the decreasing argument and provide the proof that it decreases
(here using the generic tactic `decreasing_by`).
-/

def Explicit.mod (m n : Nat) : Nat := -- implementation of m % n
  if n = 0 ∨ m < n then
    m
  else
   mod (m - n) n
termination_by m
decreasing_by decreasing_tactic

/-!
Lean cannot automatically identify all valid recursive definition which use
well-founded recursion. In some cases, you may have to provide your own
proof.
For example, to compute the greatest common divisor of $m$ and $n$,
we can use the property that it's the same as the greatest common divisor
of $n$ and $m \% n$. To prove that the second argument is decreasing,
we use the theorem that if $m % n < m$ whenever $n > 0$.
-/

#check Nat.mod_lt
-- Nat.mod_lt (x : ℕ) {y : ℕ} (hy : 0 < y) : x % y < y

def Total.gcd (m n : Nat) : Nat :=
  if h : n = 0 then
    m
  else
    gcd n (m % n)
termination_by n
decreasing_by
  apply Nat.mod_lt
  exact Nat.pos_of_ne_zero h

#guard Total.gcd (8 * 3) (8 * 7) = 8

/-!
If you can't provide a proof that your recursion terminates in every
case, or if you your function can genuinely not terminate for some
values of the arguments but you still want an executable version of it,
you can use the keyword `partial` instead:
-/

partial def Partial.gcd (m n : Nat) : Nat :=
  if n = 0 then
    m
  else
    gcd n (m % n)

#guard Partial.gcd (8 * 3) (8 * 7) = 8

/-!
For example, the Collatz sequence, defined recursively with
$x_{n + 1} = x_n / 2$ if $x_n$ is even and
$x_{n + 1}$ if $x_n$ is odd, experimentally converges to $1$ in a finite
number of steps for every positive initial value $x_0$ that has ever been
tested (every integer up to $2.36 \times 10 ^ 31$). But we do not have a proof
that the property holds for every positive initial value.
Therefore, if we want to implement recursively a function that computes the
length of the Collatz sequence starting at a given value until it reaches 1,
we are going to need the `partial` keyword.

-/

def Collatz.next (n : Nat) : Nat :=
  if n % 2 == 0 then
    n / 2
  else
   3 * n + 1

partial def Collatz.length (x0 : Nat) : Nat :=
  if x0 = 0 then
    0
  else if x0 = 1 then
    1
  else
    Collatz.length (next x0) + 1

#guard Collatz.length 99 = 26






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

/-
Custom types:

  - Sum types
  - Product types (~ structures)
  - Mix
  - Polymorphism
  - Inductif

-/

namespace Traffic

/-- "enums" -/
inductive MyEmptyType : Type where

inductive Light : Type where
  | green : Light
  | orange : Light
  | red : Light

inductive LightAlt where
  | green
  | orange
  | red

#check (1 : Nat)

def canGo (light : Light) : Bool :=
  match light with
  | Light.green => true
  | Light.orange => true
  | Light.red => false

#eval canGo Light.green -- true

def canGo (light : Light) : Bool :=
  match light with
  | Light.green | Light.orange => true
  | Light.red => false

def canGoAlt2 (light : Light) : Bool :=
  match light with
  | Light.red => false
  | _anyLight => true

def next (light : Light) : Light :=
  match light with
  | Light.green => Light.orange
  | Light.orange => Light.red
  | Light.red => Light.green

end Traffic

/-!
But no guards!
-/

namespace Sandbox

inductive Empty -- ... empty

inductive Unit where
  | unit

inductive Bool where
  | false
  | true

end Sandbox

#check Bool

inductive Point2D where
  | mk (x y : Float)

inductive Point2DAlt : Type where
  | mk (x : Float) (y : Float) : Point2DAlt

inductive Point2DAlt2 where
  | mk : Float -> Float -> Point2DAlt2

#check Point2D.mk
-- Point2D.mk (x y : Float) : Point2D

#eval Point2D.mk 1.0 2.0
-- Point2D.mk 1.000000 2.000000

def Point2D.norm (point : Point2D) : Float :=
  match point with
  | mk x y => Float.sqrt (x * x + y * y)

#eval (Point2D.mk 1.0 1.0).norm
-- 1.414214

/-
Manual definition of accessors (getters) ...
-/

def Point2D.x (point : Point2D) : Float :=
  match point with
  | mk x _ => x

def Point2D.y (point : Point2D) : Float :=
  match point with
  | mk _ y => y

def Point2D.normAlt (point : Point2D) : Float :=
  let x := point.x
  let y := point.y
  x * x + y * y

/-
Let's use structures instead ...
-/

structure Point where
  x : Float
  y : Float

def Point.origin : Point := { x := 0.0, y := 0.0 }

#eval Point.origin.x
-- 0.000000

#eval { Point.origin with x := 1.0 }
-- { x := 1.000000, y := 0.000000 }

inductive Color where
  | rgb (r g b : UInt8)
  | named (name : String)

#eval Color.named "red"
-- Color.named "red"

def Color.black := Color.rgb 0 0 0

/-!
Example of polymorphism
-/

#print Option
-- inductive Option (α : Type u) where
--   | none : Option α
--   | some (val : α) : Option α

#eval (Option.none : Option Nat)
-- Option.none

#eval (Option.some 42 : Option Nat)
-- Option.some 42

def list := [4, 2, 1]

#eval list[0]!
-- 4

#check list[0]?
-- list[0]? : Option ℕ

#eval list[0]?
-- some 4

#eval list[100]?
-- none

#print Nat
-- inductive Nat : Type
-- number of parameters: 0
-- constructors:
-- Nat.zero : ℕ
-- Nat.succ : ℕ → ℕ

/-
inductive Nat where
  | zero : Nat
  | succ (n : Nat) : Nat
-/

def Nat_add (m n : Nat) : Nat :=
  match n with
  | Nat.zero => m
  | Nat.succ n => Nat.succ (Nat_add m n)

def Nat_add_alt (m n : Nat) : Nat :=
  match n with
  | 0 => m
  | n + 1 => (Nat_add m n) + 1

inductive ListNat where
  | nil : ListNat
  | cons (n : Nat) (listNat : ListNat) : ListNat

#print List
-- inductive List.{u} : Type u → Type u
-- number of parameters: 1
-- constructors:
-- List.nil : {α : Type u} → List α
-- List.cons : {α : Type u} → α → List α → List α

/-
inductive List (α : Type u) where
  | nil : List α
  | cons (head : α) (tail : List α) : List α
-/

def List_length {α : Type} (list : List α) : Nat :=
  match list with
  | List.nil => 0
  | List.cons _ list => (List_length list) + 1

/-

List : reverse, concat / append, []? -> Option

-/

def List.getElem? {α} (as : List α) (i : Nat) : Option α :=
  match as, i with
  | [], _i => Option.none
  | a :: _as, 0 => Option.some a
  | _a :: as , i + 1 => List.getElem? as i
