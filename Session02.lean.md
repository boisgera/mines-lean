
```lean4
import Mathlib
```

Expression (functional) or statement (imperative)? (Python)
--------------------------------------------------------------------------------

If you want to explore this theme further in Python, ask yourself the following
questions:

 1. **print.** `print('Hello world!')`: expression or statement?
    If it is an expression, what is its value?


 2. **The walrus operator.** What is the purpose (or what are the use cases) of
    the code `a := 1` in Python? Is it an expression or a statement?


 3. **Pattern matching.** Does Python's structural pattern matching,
    using the `match` and `case` keywords, produce expressions or statements?


### Answers

### `print`

```pycon
>>> print('Hello world!')
Hello world!
>>> val = print('Hello world') # it's an impure expression (whose eval has side-effects)
Hello world
>>> val is None # it evals to the "'no information' value"
True
>>> type(None)
<class 'NoneType'>
```

#### The walrus operator `:=`

```pycon
>>> eval("a = 1") # assignment is a statement
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<string>", line 1
    a = 1
    ^^^^^
SyntaxError: invalid syntax. Maybe you meant '==' or ':=' instead of '='?
```

```pycon
>>> print("(b := 1):") # "impure" expression: value + side effect
1
>>> b
1
```

An example use case. First note that `str.find` returns `-1` when the substring
is not found.

```pycon
>>> "no special symbol".find(":")
-1
```

You could use this function like that:

```pycon
>>> message = "My name is: Bond"
>>> index = message.find(":")
>>> if index >= 0:
...     name = message[index + 1:]
...     print(name.strip())
... else:
...     print("no ':' in the message")
...
Bond
```

But with the walrus operator you have a terser implementation:

```python
>>> if (walrus_index := message.find(":")) >= 0:
...     name_ = message[walrus_index + 1:]
...     print(name_.strip())
... else:
...     print("no ':' in the message")
...
Bond
```


Civet
--------------------------------------------------------------------------------

The imperative and functional versions of Python's if-then-else,
function definitions, and for loops "merge" in a single
(impure expressio) in the functional language Civet, and may be used
for the value it computes, for the side-effects, or both.

#### if-then-else

```civet
"civet autolet"
// @ts-nocheck

console.log("Hello Civet!")
console.log "Hello Civet!"

name = "Penelope"

if name == "Nobody" then
  console.log("Hello Odysseus!")
else
  console.log(`Hello ${name}!`)
// -> Hello Penelope

greeting =
  if name == "Nobody" then
    "Hello Odysseus!"
  else
    `Hello ${name}!`

console.log(greeting) // -> Hello Penelope!

if name == "Nobody" then
  console.log("Odysseus detected")
  "Hello Odysseus!"
else
  1 + 1 // no effect!
  console.log("Not Odysseus")
  `Hello ${name}!`
// -> Not Odysseus

val = if name == "Nobody" then
  console.log("Odysseus detected")
  "Hello Odysseus!"
else
  1 + 1 // no effect!
  console.log("Not Odysseus")
  `Hello ${name}!`

console.log("val:", val) // -> val: Hello Penelope!
```

#### Function definition

```civet
// equivalent to the `def` Python statement
function succ (n) {
  return n + 1
}

console.log(succ(42))

// equivalent to the lambda expr in Python
succ_alt = (n) => n + 1
console.log(succ_alt(42))

// alt2: alt is only a terser expression for the following:
succ_alt2 = function (n) {
  return n + 1
}
console.log(succ_alt2(42))
```


Expression vs Statements in Lean
--------------------------------------------------------------------------------

In Lean, you can have pure expressions, that have no side-effect,
and "pure actions" with only side-effects, like `IO.println`.


```lean4
def succ (n : Nat) : Nat := n + 1

#check succ -- "pure" function, no side-effect
-- succ (n : Nat) : Nat

#eval succ 42
-- 43

def hello := IO.println "Hello world!"

#check hello
-- hello : IO Unit
```

`Unit` is the Lean equivalent of `NoneType` in Python.
`()` (or `Unit.unit`) is the equivalent of `None` in Python.

```lean4
#eval hello
-- Hello world!
```

... but mixing both kind of constructs is not as immediate as in Civet.
That won't work for example:

```lean4
-- Doesn't work!
def f_v1 (n : Nat) : Nat :=
  IO.println "Hello world!"
  n + 1
```

To eval a natural number and print something, we need a function whose
return type is `IO Nat`. Then, sequencing actions is enabled by the
`do` keyword. Finally, we need to apply the keyword `return` to convert
a "pure" natural number into something of type `IO Nat`:

```lean4
def f_v2 (n : Nat) : IO Nat := do
  IO.println "Hello world!"
  return n + 1

def f_v3 (n : Nat) : IO Nat := do
  IO.println "Hello world!"
  return (succ n) -- It's ok to call a pure function in a `IO` context.

def f_v4 n := do -- Lean can infer both the parameter and return type here.
  IO.println "Hello world!"
  return (succ n)

#eval f_v4 42
-- 43
```

You can use, but you don't **need** to use a `do` block to define a single action:

```lean4
def main_v1 := IO.println "Hello L∃∀N!"

def main_v2 := do
  IO.println "Hello L∃∀N!"
```

However you need it to sequence 2 actions or more:

```lean4
def main_v3 :=
  IO.println "Hello L∃∀N!"
  IO.println "Hello L∃∀N!" -- won't work

def main_v4 := do
  IO.println "Hello L∃∀N!"
  IO.println "Hello L∃∀N!" -- OK!
```

Note that for pure data, it does make sense to specify more than one
expression since no side-effect is possible. Below, the expression
would compute `1 + 1`, which has no side-effect, then throw the result,
which is meaningless. Lean will reject this code.

```lean4
def g (n : Nat) : Nat :=
  1 + 1
  n + 2 -- won't work a single expression is required!
```

--------------------------------------------------------------------------------

```lean4
-- Evaluate simple expressions
#eval 1 + 1           -- Output: 2
#eval "Hello" ++ "!"  -- Output: "Hello!"
#eval 2 ^ 10          -- Output: 1024

-- Evaluate function calls
#eval String.length "Lean 4"  -- Output: 6
#eval List.reverse [1, 2, 3]  -- Output: [3, 2, 1]
```

Within the `String` namespace, you can find some data, functions and theorems
related to strings.

```lean4
#check String.length
-- String.length (b : String) : Nat

#check String.length_eq_zero_iff
-- String.length_eq_zero_iff {s : String} : s.length = 0 ↔ s = ""
```

Instead of the notation `String.length "Lean 4"`, since `"Lean 4"` is a term
of type `String`, you can use the *method syntax*, or *dot syntax*
(also called [uniform function call syntax](https://en.wikipedia.org/wiki/Uniform_function_call_syntax)).

```lean4
#eval "Lean 4".length
-- 6

#eval [1, 2, 3].reverse
-- [3, 2, 1]

#eval String.length 42
-- failed to synthesize instance of type class
--   OfNat String 42
-- numerals are polymorphic in Lean, but the numeral `42` cannot be used in a context where the expected type is
--   String
-- due to the absence of the instance above

def n : Int := 42
def m := -12
#check m
-- m : Int

#eval (42 : Nat) + (-12 : Int)
-- 30

#eval ((12 : Int) : Nat)
-- Type mismatch
--   12
-- has type
--   Int
-- but is expected to have type
--   Nat


#check "Hello World"   -- String
#check 42              -- Nat
#check true            -- Bool
#check [1, 2, 3]       -- List Nat

-- Check function types
#check String.length   -- String.length (b : String) : Nat
#check List.reverse    -- List.reverse.{u} {α : Type u} (as : List α) : List α


#check [1, 2, 3]
-- [1, 2, 3] : List Nat

#check ["Hello", " ", "world", "!"]
-- ["Hello", " ", "world", "!"] : List String

#check [1, 2, "Hello"]

#eval List.reverse [1, 2, 3]
-- failed to synthesize instance of type class
--   OfNat String 2
-- numerals are polymorphic in Lean, but the numeral `2` cannot be used in a context where the expected type is
--   String
-- due to the absence of the instance above
```

The `List` type is polymorph but homogeneous.

### Implicit arguments

In a function signature, the braces refer to implicit arguments, that Lean
should infer from the other, explicit arguments. For example in `List.reverse`,
the type `α` of the elements in the list can be inferred from the type
`List α` of the list itself.

```lean4
#check List.reverse
-- List.reverse.{u} {α : Type u} (as : List α) : List α

#eval List.reverse [1, 2, 3] -- [3, 2, 1] -- Nat is *implicit*

#eval List.reverse ["Hello", " ", "world", "!"]
-- ["!", "world", " ", "Hello"] -- String is *implicit*
```

You can however specify explicitly arguments declared as implicit if you want:

```lean4
#eval List.reverse (α := Nat) [1, 2, 3] -- [1, 2, 3]

#eval List.reverse (α := String) [1, 2, 3] -- [1, 2, 3] -- Nope...
-- failed to synthesize instance of type class
--   OfNat String 1
-- numerals are polymorphic in Lean, but the numeral `1` cannot be used in a context where the expected type is
--   String
-- due to the absence of the instance above

/-
The notations `u` and `Type u` in the signature of this function refer to the
hierarchy of types in `Lean`:
-/

#check "Hello!"
-- "Hello!" : String

#check String
-- String : Type

#check Type -- i.e. Type 0
-- Type : Type 1

#check Type 1
-- Type 1: Type 2
```

`List` and `List.reverse` are universe-polymorphic: you can make lists of
data but also of types for example:

```lean4
#check List.reverse [Int, Nat, String]
-- [Int, Nat, String].reverse : List Type

theorem my_theorem :
    [Int, Nat, String].reverse = [String, Nat, Int] := by
  rfl
```

`IO.println` is also polymorphic somehow: it can be called for example
on a `Nat` or a `String`.

```lean4
#eval IO.println 42
-- 42

#eval IO.println "Hello!"
-- Hello!
```

But not every type will work:

```lean4
#eval IO.println Int
-- failed to synthesize instance of type class
--   ToString Type
```

Let's have a look at the signature of `IO.println`:

```lean4
#check IO.println
-- IO.println.{u_1} {α : Type u_1} [ToString α] (s : α) : IO Unit
```

`[ToString α]` is the (implicit) requirement that `α` has an instance
of the *type class* `ToString`, which concretely means that there is an
explicit function that has been declared to convert terms of type `α`
into strings.

The same (implicit) type class construct can be used in theorems.
For example, to formalize and prove that in any group $G$,
any element $a$ such that for any $b \in G$, $a \times b = b$ and
$b \times a = b$ is the neutral element $1$, one uses the `Group`
type class:


```lean4
theorem unique_inverse.{u} (G : Type u) [Group G] :
    ∀ (a : G), (∀ (b : G), a * b = b ∧ b * a = b) → a = 1
  := by
  intro a h
  specialize h 1
  have ⟨hl, _⟩ := h
  simp only [mul_one] at hl
  exact hl
```

The theorem is proven for all groups, we can now specialize it for
any group, for example $\mathbb{R}^*$, the group of units (invertible elements)
of $\mathbb{R}$.

```lean4
theorem unique_inverse_real_units :
    ∀ (a : ℝˣ), (∀ (b : ℝˣ), a * b = b ∧ b * a = b) → a = 1 :=
  unique_inverse ℝˣ
```

That works because Lean knows that `ℝˣ` is a group (an instance of
`Group ℝˣ` has been defined).

```lean4
#synth Group ℝˣ
-- Units.instGroup
```

Primitive Types
--------------------------------------------------------------------------------

```lean4
#check Int
#check Nat
#check String
#check Float
-- Float: Type

#eval 1.2e3
-- 1200.000000

#check 1.2e3
-- 12e2 : Float

#check 1.2e10
-- 12e9 : Float

#check 1.2e-10
-- 12e-11 : Float

#eval IO.println 1.2e10
-- 12000000000.000000

#eval IO.println 1.2e-10
-- 0.000000

#eval IO.println 1.2345678910123456789

#eval IO.println ((0.1 + 0.2) + 0.3)
-- 0.600000

#eval IO.println (0.1 + (0.2 + 0.3))
-- 0.600000

#eval ((0.1 + 0.2) + 0.3) == (0.1 + (0.2 + 0.3))
-- false

def pi := 4 * (Float.atan 1.0)

#eval pi
-- 3.141593

def Float.pi := 4 * (atan 1.0)

#eval Float.pi
-- 3.141593

namespace Float

def pi_alt := 4 * (atan 1.0)

end Float

#eval Float.pi_alt

#eval Float.sin 1.0
-- 0.841471

#eval (1.0).sin
-- 0.841471

#check Bool
-- Bool : Type

#check true
-- Bool.true : Bool

#check True
-- True : Prop

#eval True -- decidable Prop
-- true

#eval ((true && !false) || false)
-- true

#eval Bool.and -- &&

#eval ((True ∧ ¬False) ∨ False)
-- true

#check UInt8 -- 1 byte
#check Int32 -- 4 byte

#eval (255 : UInt8) + 1
-- 0

#check Fin 10

#eval (8 : Fin 10)
-- 8

#eval (8 : Fin 10) + 3
-- 1

#check Float   -- 64 bits ("double")
#check Float32 -- 32 bits ("single")

#check Nat.add
-- Nat.add : Nat → Nat → Nat

#check Nat.sub
-- Nat.sub : Nat → Nat → Nat

#eval 3 - 7
-- 0 -- !!! "Junk value"

#eval (3 : Int) - 7
-- -4

#check String
-- String : Type

#check Char
-- Char: Type

#check "Hello world!"
-- "Hello world!" : String

#check 'A'
-- 'A' : Char

#check "Hello world!".toList
-- "Hello world!".toList : List Char

#eval "Hello world!".toList
-- ['H', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd', '!']

#eval String.ofList ['H', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd', '!']
-- "Hello world!"

#check '∀'
-- '∀' : Char

#check '😀'
-- '😀' : Char

#eval '😀'.toNat
-- 128512

#eval 'A'.toNat
-- 65 -- ASCII: number <= 127

#eval 'é'.toNat
-- 233

#eval Char.ofNat 128512
-- '😀'

-- String interpolation
def name := "Lean"

#eval s!"Hello, {name}!"
-- "Hello, Lean!"

#check Unit
-- Unit: Type

#check ()
-- () : Unit

#check Unit.unit
-- Unit.unit : Unit
```

Functions
--------------------------------------------------------------------------------

```lean4
namespace Sandbox

def oneAddOne : Nat := 1 + 1

def succ (n : Nat) : Nat := n + 1

def succ_alt : Nat → Nat := fun (n : Nat) => (n + 1 : Nat)

#check succ_alt
-- Sandbox.succ_alt (n : Nat) : Nat

#check @succ_alt
-- succ_alt : Nat → Nat

def add (m : Nat) (n : Nat) : Nat := m + n

#check @add -- Currying
-- add : Nat → Nat → Nat

#check Nat → Nat → Nat -- Nat → (Nat → Nat)? or (Nat → Nat) → Nat?
-- Nat → Nat → Nat : Type

#check Nat → (Nat → Nat)
-- Nat → Nat → Nat : Type

#check (Nat → Nat) → Nat
-- (Nat → Nat) → Nat : Type

#eval add 1 2
-- 3

#check (add 1) 2
-- add 1 2 : Nat

def succ_alt2 := add 1

#eval succ_alt2 2
-- 3

#check (1, "Hello", true)
-- (1, 2, 3) : Nat × String × Bool

#check Nat × (String × Bool)
-- Nat × String × Bool : Type

#print Prod
-- structure Prod.{u, v} (α : Type u) (β : Type v) : Type (max u v)
-- number of parameters: 2
-- fields:
--   Prod.fst : α
--   Prod.snd : β
-- constructor:
--   Prod.mk.{u, v} {α : Type u} {β : Type v} (fst : α) (snd : β) : α × β

end Sandbox
```
