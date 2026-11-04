import Std

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
of $n$ and $m \bmod n$. To prove that the second argument is decreasing,
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
case, or if your function can genuinely not terminate for some
values of its arguments but you still want an executable version of it,
you can use the keyword `partial`:
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
tested (every integer up to $2.36 \times 10 ^ {31}$, cf. [here][Collatz]).
But we do not have a proof that the property holds for every positive initial value.
Therefore, if we want to implement recursively a function that computes the
length of the Collatz sequence starting at a given value until it reaches 1,
we are going to need the `partial` keyword.

[Collatz]: https://en.wikipedia.org/wiki/Collatz_conjecture

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
CLI: more about `main`
--------------------------------------------------------------------------------

- arguments
- `args[]!`, `panic!` (or don't? would cannibalize pattern matching skill acqu?
  do but with a warning)
- return value
- `<-` (example with Timestamp) ; first create timestamp manually and
  check that it can be printed (also use #synth).
  Then use `Timestamp.now`, who has a different signature.


-/

/-!
The classic `main` definition

```lean4
def main : IO Unit :=
  IO.println "Hello Lean!"
```

can be augmented to support arguments and return code. Argument are the list
of strings that you provide on the command-line after the name of your
executable. For example, when you do

```bash
$ lake new my-project math
```

the `lake` executable is provided with the arguments `["new", "my-project", "math"]`.
The return code is the information that your program provides to the caller
to tell him if the program execution was a success (return code 0) or
a failure (any other 32 bit unsiged integer).

In bash, after a program call, this result is stored in a special variable
named `?`. So to check that your lake command was a success, you would do:

```bash
$ lake new my-project math
$ echo $?
0
```

To use command-line arguments and return codes in Lean, change the signature
of your definition of `main`:
-/

def main (args : List String) : IO UInt32 := do
  if args.length > 0 then
    IO.println s!"args: {args}"
    return 0 -- 0 means success
  else
    IO.println "You have provided no argument"
    return 1 -- non-zero means failure

/-!
The standard library gives us a `Timestamp` type that represent the time
elapased since the [Unix epoch](https://en.wikipedia.org/wiki/Unix_time).
This timestamp can be printed with `IO.println`.
-/

open Std.Time

#check Timestamp
-- Std.Time.Timestamp : Type

#eval Timestamp.ofSecondsSinceUnixEpoch 60
-- Timestamp.ofNanoseconds 60000000000

#eval IO.println (Timestamp.ofSecondsSinceUnixEpoch 60)
-- 60

/-!
It also provides an interface to query the current timestamp:
-/

#check Timestamp.now
-- Std.Time.Timestamp.now : IO Timestamp

#eval Timestamp.now
-- Timestamp.ofNanoseconds 1793788691972331000

/-!
Note that this is a `IO` action, not a pure value (and indeed, the value
part will change in time due to the side-effect of time passing ...).
To print the timestamp, we need a `Timestamp` argument, not a `IO Timestamp`.
To get the value out of the action, we use the left arrow `<-` notation:
-/

/--
Display time elapsed since Unix epoch
-/
def displayTime (_ : List String) : IO UInt32 := do
  let getTs : IO Timestamp := Timestamp.now
  let ts : Timestamp <- getTs -- or : let ts : Timestamp := (<- getTs)
  IO.print s!"⏱️ timestamp: {ts}"
  return 0

/-!
Of course, this left arrow can only be used within a do block associated
to `IO` context.
-/




/-!
Inductive Types and Pattern Matching
--------------------------------------------------------------------------------

Custom types:
  - Sum types
  - Product types (~ structures)
  - Mix
  - Polymorphism
  - Inductif

-/

/-!
The `inductive` keyword defines a new type by listing all the possible ways
to build a value of this type: its *constructors*. In the simplest case, the
constructors have no argument and the type is a mere enumeration of values
(a sum type).
-/

/-
The constructors are stored in the namespace of the type, hence `Light.green`.
The type annotations (`: Type` for the type, `: Light` for the constructors)
are optional, as demonstrated by `LightAlt`. We define everything in the
`Traffic` namespace, so the full name of our type is `Traffic.Light`.
-/



namespace Traffic

/-- "enums" -/


inductive Light : Type where
  | green : Light
  | orange : Light
  | red : Light

inductive LightAlt where
  | green
  | orange
  | red

/-!
To define a function of such a type, we use pattern matching: `match` compares
its argument to each pattern, from top to bottom, and the first pattern that
matches selects the result. The patterns must cover every possible case,
otherwise Lean rejects the definition.
-/

def canGo (light : Light) : Bool :=
  match light with
  | Light.green => true
  | Light.orange => true
  | Light.red => false

#eval canGo Light.green -- true

/-!
Several patterns which lead to the same result can share a single branch,
when they are separated with `|`:
-/

def canGoAlt (light : Light) : Bool :=
  match light with
  | Light.green | Light.orange => true
  | Light.red => false

/-!
An identifier which is not a constructor is a pattern that matches anything
and binds the value to this identifier. Since we don't use this value here,
we prefix its name with an underscore to tell Lean that this is on purpose
(`_` alone would work too). The order of the branches matters here: this
catch-all pattern has to come last.
-/

def canGoAlt2 (light : Light) : Bool :=
  match light with
  | Light.red => false
  | _anyLight => true

/-!
The result of a `match` can be of any type, including the type of the argument:
-/

def next (light : Light) : Light :=
  match light with
  | Light.green => Light.orange
  | Light.orange => Light.red
  | Light.red => Light.green

end Traffic

/-!
But no guards! Unlike Haskell or Rust for example, Lean does not allow a
boolean condition to be attached to a pattern (something like
`| n if n > 0 => ...`).
If a branch depends on such a condition,
use an `if` expression in the body of this branch.
-/

/-!
Several standard types are nothing more than such enumerations. Here are
definitions similar to the ones of `Empty` (no value), `Unit` (a single value)
and `Bool` (two values) in the standard library; we use a `Sandbox` namespace
to avoid a conflict with the original names.
-/

namespace Sandbox

inductive Empty -- ... empty

inductive Unit where
  | unit

inductive Bool where
  | false
  | true

end Sandbox

/-!
Constructors can also have arguments. A type with a single constructor which
has several arguments is a product type: a value of `Point2D` holds a `Float`
**and** another `Float`. The name `mk` ("make") is the usual choice for such
a unique constructor.

The three definitions below are equivalent ways to declare the same
constructor: we can name its arguments or not, and group those of the same
type.
-/

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

/-!
Pattern matching is also how we get the data out of a value: the pattern
`mk x y` binds the arguments of the constructor to the identifiers `x` and `y`.
We can write `mk` instead of `Point2D.mk` here, since the namespace `Point2D`
is open in the definition of `Point2D.norm`.

Since this function is in the `Point2D` namespace and its argument is a
`Point2D`, we can call it with the dot notation: `p.norm` means
`Point2D.norm p`.
-/

def Point2D.norm (point : Point2D) : Float :=
  match point with
  | mk x y => Float.sqrt (x * x + y * y)

#eval (Point2D.mk 1.0 1.0).norm
-- 1.414214

/-!
We can use pattern matching to define *getters* for the indivuals values
stored in a point. The pattern `_` matches any
value and ignores it, which is all we need for the arguments we don't use.
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
  Float.sqrt (x * x + y * y)

/-!
A structure is essentially an inductive type with a single constructor
(`Point.mk` here), but Lean also generates the accessors `Point.x` and `Point.y`
for us and provides a dedicated syntax:

- `{ x := 0.0, y := 0.0 }` builds a value from the name of its fields,

- `{ p with x := 1.0 }` builds a new value which is a copy of `p`,
  except for the listed fields (`p` itself is not modified).
-/

structure Point where
  x : Float
  y : Float

def Point.origin : Point := { x := 0.0, y := 0.0 }

#eval Point.origin.x
-- 0.000000

#eval { Point.origin with x := 1.0 }
-- { x := 1.000000, y := 0.000000 }

/-!
Sum and product types can be mixed: a type can have several constructors,
each one with its own arguments. Here a color is either three integer
components or a name.

Note that a definition such as `Color.black` is not a new constructor: it is
merely a value of type `Color` stored in the `Color` namespace.
-/

inductive Color where
  | rgb (r g b : UInt8)
  | named (name : String)

#eval Color.named "red"
-- Color.named "red"

def Color.black := Color.rgb 0 0 0

/-!
An inductive type can have a type parameter: `Option` is not a type by itself,
but `Option Nat` and `Option String` are. A value of type `Option α` is either
`none` (no value) or `some val` where `val` has type `α`. Since `Option.none`
alone says nothing about `α`, we specify the type that we want.
-/

#print Option
-- inductive Option (α : Type u) where
--   | none : Option α
--   | some (val : α) : Option α

#eval (Option.none : Option Nat)
-- none

#eval (Option.some 42 : Option Nat)
-- some 42

/-!
`Option` is the standard way to represent the result of an operation that may
fail. For example, indexing a list with `list[i]!` panics if the index is out
of bounds, while `list[i]?` yields an `Option` that you have to deal with.
-/

def list := [4, 2, 1]

#eval list[0]!
-- 4

#check list[0]?
-- list[0]? : Option ℕ

#eval list[0]?
-- some 4

#eval list[100]?
-- none

/-!
Inductive types can also be recursive: a constructor may have an argument of
the type being defined. This is what actually makes them *inductive*. The
natural numbers are the classic example: a natural number is either zero or
the successor of a natural number, so `3` is
`Nat.succ (Nat.succ (Nat.succ Nat.zero))`.
-/

#print Nat
-- inductive Nat : Type
-- number of parameters: 0
-- constructors:
-- Nat.zero : ℕ
-- Nat.succ : ℕ → ℕ

/-!
That corresponds to the type definition:

```lean4
inductive Nat where
  | zero : Nat
  | succ (n : Nat) : Nat
```
-/

/-!
The natural way to define a function on a recursive type is to use a recursive
function with one branch per constructor: this is the structural recursion
that we have seen earlier. Each recursive call is applied to a part of the
original value, therefore the recursion always terminates.

Note: the `n` bound by the pattern `Nat.succ n` shadows the argument `n` of the
function in this branch.
-/

def Nat_add (m n : Nat) : Nat :=
  match n with
  | Nat.zero => m
  | Nat.succ n => Nat.succ (Nat_add m n)

/-!
For `Nat`, the patterns `0` and `n + 1` can be used instead of the constructors
`Nat.zero` and `Nat.succ n`.
-/

def Nat_add_alt (m n : Nat) : Nat :=
  match n with
  | 0 => m
  | n + 1 => (Nat_add_alt m n) + 1

/-!
Lists of natural numbers follow the same pattern: a list is either empty (`nil`)
or made of a first element and of the list of the other ones (`cons`).
So the list `[4, 2, 1]` is `cons 4 (cons 2 (cons 1 nil))`.
-/

inductive ListNat where
  | nil : ListNat
  | cons (n : Nat) (listNat : ListNat) : ListNat

/-!
Combine this with a type parameter and you get the generic type `List`:
-/

#print List
-- inductive List.{u} : Type u → Type u
-- number of parameters: 1
-- constructors:
-- List.nil : {α : Type u} → List α
-- List.cons : {α : Type u} → α → List α → List α

/-
The definition of `List` actually is:

```lean4
inductive List (α : Type u) where
  | nil : List α
  | cons (head : α) (tail : List α) : List α
```
-/

/-!
The curly braces make `α` an implicit argument: we don't provide it when we
call `List_length`, since Lean can infer it from the type of `list`.
-/

/-!
Computing the length of a `List α` is straightforward:
-/

def List_length {α : Type} (list : List α) : Nat :=
  match list with
  | List.nil => 0
  | List.cons _ list => (List_length list) + 1

/-!
Reversing a list is less straightforward: the recursive call gives us the
reversed tail, but the head then has to go at the *end* of this result, and
we don't know yet how to do that.

The trick is to solve a more general problem, with an auxiliary function that
reverses `list` in front of an existing list `acc` (for accumulator). We take
the elements of `list` one at a time and move them to the front of `acc`, like
we would move a stack of plates to another stack: the order gets reversed.
-/

def List_reverseAux {α : Type} (list acc : List α) : List α :=
  match list with
  | List.nil => acc
  | List.cons a as => List_reverseAux as (List.cons a acc)

#eval List_reverseAux [1, 2, 3] [4, 5]
-- [3, 2, 1, 4, 5]

/-!
Reversing a list is the special case where the accumulator starts empty:
-/

def List_reverse' {α : Type} (list : List α) : List α :=
  List_reverseAux list List.nil

#eval List_reverse' [1, 2, 3]
-- [3, 2, 1]

#guard List_reverse' [1, 2, 3] = [1, 2, 3].reverse

/-!
We can actually avoid defining an auxiliary function and instead code its
behavior using extra "hidden" arguments to our main `List_reverse` function.
The trick relies on the use of default function argument values.
-/

def List_reverse {α : Type} (list : List α) (acc : List α := List.nil) : List α :=
  match list with
  | List.nil => acc
  | List.cons a as => List_reverse as (List.cons a acc)

#eval List_reverse [1, 2, 3] [4, 5]
-- [3, 2, 1, 4, 5]

#eval List_reverse [1, 2, 3]
-- [3, 2, 1]

/-!
With `List.cons`, it's easy to add an element at the start of a list. To add it
at the end (`concat`), we don't need any new recursion: we can reverse the list,
add the element at the start and reverse the result.
-/

def List_concat {α : Type} (list : List α) (a : α) : List α :=
  List_reverse (List.cons a (List_reverse list))

#eval List_concat [1, 2, 3] 4
-- [1, 2, 3, 4]

#guard List_concat [1, 2, 3] 4 = [1, 2, 3].concat 4

/-!
To put two lists end to end (`append`), we can reuse our auxiliary function
as well: reversing `xs` in front of `ys` yields the elements of `xs` in the
wrong order, so we reverse `xs` first to compensate.
-/

def List_append {α : Type} (xs ys : List α) : List α :=
  List_reverseAux (List_reverse xs) ys

#eval List_append [1, 2, 3] [4, 5]
-- [1, 2, 3, 4, 5]

#guard List_append [1, 2, 3] [4, 5] = [1, 2, 3] ++ [4, 5]

/-!
But there is a direct recursive definition, with one step per element of `xs`
instead of two (one for each traversal). `ys` is never traversed in either
version, so the cost depends only on the length of `xs`.
-/

def List_appendAlt {α : Type} (xs ys : List α) : List α :=
  match xs with
  | List.nil => ys
  | List.cons x xs => List.cons x (List_appendAlt xs ys)

#guard List_appendAlt [1, 2, 3] [4, 5] = [1, 2, 3] ++ [4, 5]

/-!
This shorter definition has its own cost, however. In `List_reverseAux`, the
recursive call is the very last thing that the function does (it's a *terminal*
call), so nothing needs to be remembered between the calls. In `List_appendAlt`,
we still have to apply `List.cons` to the result of the recursive call, so the
pending calls pile up on the stack, in proportion to the length of `xs`.
-/

/-!
We can match several values at once, with patterns separated by commas: here
we match on the list `as` and the index `i` at the same time. Each case is
covered: an empty list has no element, whatever the index is, and for a
non-empty list we either have reached the index `0` or we look for the element
of index `i` in the tail of the list.

The patterns `[]` and `a :: as` are the usual notations for
`List.nil` and `List.cons a as`.
-/

def List.getElem? {α} (as : List α) (i : Nat) : Option α :=
  match as, i with
  | [], _i => Option.none
  | a :: _as, 0 => Option.some a
  | _a :: as , i + 1 => List.getElem? as i

#eval [4, 2, 1].getElem? 0
-- some 4

#eval [4, 2, 1].getElem? 2
-- some 1

#eval [4, 2, 1].getElem? 3
-- none

#eval ([] : List Nat).getElem? 0
-- none

#eval ["a", "b"].getElem? 1
-- some "b"

#guard [4, 2, 1].getElem? 0 = [4, 2, 1][0]?
#guard [4, 2, 1].getElem? 3 = [4, 2, 1][3]?
