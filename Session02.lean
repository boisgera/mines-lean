/-!
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

-/


/-!
Civet
--------------------------------------------------------------------------------

The imperative and functional versions of Python's if-then-else,
function definitions, and for loops "merge" in a single construct in
the functional language Civet.

-/


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

/-!
--------------------------------------------------------------------------------
-/

-- Evaluate simple expressions
#eval 1 + 1           -- Output: 2
#eval "Hello" ++ "!"  -- Output: "Hello!"
#eval 2 ^ 10          -- Output: 1024

-- Evaluate function calls
#eval String.length "Lean 4"  -- Output: 6
#eval List.reverse [1, 2, 3]  -- Output: [3, 2, 1]

#print List.reverse

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

/-!
List is polymorph but homogeneous.
-/

#check List.reverse
-- List.reverse.{u} {α : Type u} (as : List α) : List α

#eval List.reverse [1, 2, 3] -- [3, 2, 1] -- Nat is *implicit*

#eval List.reverse ["Hello", " ", "world", "!"]
-- ["!", "world", " ", "Hello"] -- String is *implicit*

#eval List.reverse (α := Nat) [1, 2, 3] -- [1, 2, 3]

#eval List.reverse (α := String) [1, 2, 3] -- [1, 2, 3] -- Nope...

#check "Hello!"
-- "Hello!" : String

#check String
-- String : Type

#check Type -- i.e. Type 0
-- Type : Type 1

#check Type 1
-- Type 1: Type 2

#check List.reverse [Int, Nat, String]
-- [Int, Nat, String].reverse : List Type

theorem my_theorem :
    [Int, Nat, String].reverse = [String, Nat, Int] := by
  rfl

#eval toString 42
-- "42"

#eval toString "Hello!"
-- "Hello!"

#eval toString Int
-- failed to synthesize instance of type class
--   ToString Type

#check toString
-- ToString.toString.{u} {α : Type u} [self : ToString α] : α → String

/-
TODO: prove that one * one = one for groups.
-/


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

/-!
Functions
--------------------------------------------------------------------------------
-/

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
