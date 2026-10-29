
Expression (functional) or statement (imperative)? (Python)
--------------------------------------------------------------------------------

If you want to explore this theme further in Python, ask yourself the following
questions:

- **print.** `print('Hello world!')`: expression or statement?
  If it is an expression, what is its value?

- **The walrus operator.** What is the purpose (or what are the use cases) of
  the code `a := 1` in Python? Is it an expression or a statement?

- **Pattern matching.** Does Python's structural pattern matching,
  using the `match` and `case` keywords, produce expressions or statements?


Civet
--------------------------------------------------------------------------------

The imperative and functional versions of Python's if-then-else,
function definitions, and for loops "merge" in a single construct in
the functional language Civet.


```lean4
def succ (n : Nat) : Nat := n + 1

#check succ -- "pure" function, no side-effect
-- succ (n : Nat) : Nat

#eval succ 42
-- 43

def hello := IO.println "Hello world!"

#check hello
-- hello : IO Unit

-- Unit is the Lean equivalent of NoneType in Python
-- () (or Unit.unit) is the equivalent of None in Python.

#eval hello
-- Hello world!

-- Doesn't work!
def f_v1 (n : Nat) : Nat :=
  IO.println "Hello world!"
  n + 1

def f_v2 (n : Nat) : IO Nat := do
  IO.println "Hello world!"
  return n + 1

def f_v3 (n : Nat) : IO Nat := do
  IO.println "Hello world!"
  return (succ n)

def f_v4 (n : Nat) := do
  IO.println "Hello world!"
  return (succ n)

def f_v5 n := do
  IO.println "Hello world!"
  return (succ n)

#eval f_v5 42
-- 43

def main_v1 := IO.println "Hello L∃∀N!"

def main_v2 := do
  IO.println "Hello L∃∀N!"

def main_v3 :=
  IO.println "Hello L∃∀N!"
  IO.println "Hello L∃∀N!"

def main_v4 := do
  IO.println "Hello L∃∀N!"
  IO.println "Hello L∃∀N!"

def g (n : Nat) : Nat :=
  1 + 1
  n + 2 -- no, a single expression is required!
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

#check String.length_eq_zero_iff
-- String.length_eq_zero_iff {s : String} : s.length = 0 ↔ s = ""

#check String.length
-- String.length (b : String) : Nat

#eval "Lean 4".length -- "method syntax", "dot syntax", "UFCS" (https://en.wikipedia.org/wiki/Uniform_function_call_syntax)
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
```
