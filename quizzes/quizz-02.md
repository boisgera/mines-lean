# Quiz 2: Sessions 01 to 03

Each question has **one or more** correct answers. Click on "Answer" to check
your choices.

Session 01
--------------------------------------------------------------------------------

### 1. Project layout

Which statements about a typical Lean project are true?

- [ ] `lakefile.toml` contains the source code of the program
- [ ] `lean-toolchain` holds version info such as `leanprover/lean4:v4.35.0`
- [ ] `.lake` stores the build artifacts and is not tracked by git
- [ ] `lake build`, with no target name, relies on `defaultTargets`

<details>
<summary>Answer</summary>

All of them except the first one. `lakefile.toml` is the project config file;
the source code of the program is in `Main.lean`.

</details>

### 2. `#check`

Which outputs are correct?

- [ ] `#check "Hello " ++ "world!"` shows `"Hello world!" : String`
- [ ] `#check 1 ≤ 2` shows `1 ≤ 2 : Prop`
- [ ] `#check decide (1 ≤ 2)` shows `decide (1 ≤ 2) : Bool`
- [ ] `#check 1 + 1` shows `2 : Nat`

<details>
<summary>Answer</summary>

The second and third ones. `#check` shows the type of an expression but does not
evaluate it, so the expression is displayed as `"Hello " ++ "world!"` and
`1 + 1`.

</details>

### 3. `#eval` or `#print`?

Given `def succ (n : Nat) : Nat := n + 1`, which commands succeed?

- [ ] `#eval succ`
- [ ] `#print succ`
- [ ] `#eval succ 42`
- [ ] `#eval Nat`
- [ ] `#print Bool`

<details>
<summary>Answer</summary>

`#print succ`, `#eval succ 42` and `#print Bool`. The result of `#eval` has to be
printable, which is not true for functions and types: use `#print` for them.

</details>

### 4. Theorems

Consider `theorem the_answer_is_forty_two : answer = 42 := by decide`, where
`answer` is defined by `def answer : Nat := 42`. Which statements are true?

- [ ] `the_answer_is_forty_two` is the name of the theorem
- [ ] `answer = 42` is the proposition
- [ ] `by decide` is the proof
- [ ] This proof works for any proposition, including `fermat`

<details>
<summary>Answer</summary>

All of them except the last one. `by decide` works here because `answer = 42` is
decidable, but `fermat` is not known to be.

</details>

### 5. Conditional expression

In Python, with `name = "Penelope"`, what is the result of the code below?

```python
eval('"Hello Odysseus!" if name == "Noman" else f"Hello {name}!"')
```

- [ ] A `SyntaxError`, since `if` is a statement
- [ ] `None`, but `Hello Penelope!` gets printed
- [ ] The string `'Hello Penelope!'`

<details>
<summary>Answer</summary>

The string `'Hello Penelope!'`. `A if condition else B` is the expression
counterpart of the `if` / `else` statement, so `eval` accepts it and returns its
value.

</details>

Session 02
--------------------------------------------------------------------------------

### 6. `print` in Python

Which statements about `print('Hello')` in Python are true?

- [ ] It is a statement, so `eval("print('Hello')")` raises a `SyntaxError`
- [ ] It is an impure expression: it has a value and a side effect
- [ ] Its value is `None`
- [ ] The Lean equivalent of `None` is `()`, of type `Unit`

<details>
<summary>Answer</summary>

All of them except the first one. `print('Hello')` is an expression, so `eval`
accepts it, prints `Hello` and returns `None`.

</details>

### 7. Dot syntax

Which commands evaluate successfully?

- [ ] `#eval "Lean 4".length`
- [ ] `#eval String.length 42`
- [ ] `#eval [1, 2, 3].reverse`
- [ ] `#eval (1.0).sin`

<details>
<summary>Answer</summary>

All of them except `String.length 42`: `42` cannot be used where a `String` is
expected, since there is no `OfNat String 42` instance.

</details>

### 8. Text and characters

Which statements are true?

- [ ] `"A"` has type `Char`
- [ ] `'😀'` has type `Char`
- [ ] `#eval "Hi".toList` gives `['H', 'i']`
- [ ] `#eval 'A'.toNat` gives `65`
- [ ] With `def name := "Lean"`, `#eval s!"Hello, {name}!"` gives `"Hello, Lean!"`

<details>
<summary>Answer</summary>

All of them except the first one: double quotes make a `String`, single quotes a
`Char`.

</details>

### 9. Tuples

Which statements are true?

- [ ] `(1, "Hello", true)` has type `Nat × String × Bool`
- [ ] `Nat × String × Bool` means `(Nat × String) × Bool`
- [ ] `Prod` has exactly two fields, `fst` and `snd`
- [ ] `#eval Prod.snd (1, "Hello", true)` gives `("Hello", true)`

<details>
<summary>Answer</summary>

All of them except the second one. A triple is a pair whose second component is
itself a pair: `Nat × String × Bool` means `Nat × (String × Bool)`.

</details>

### 10. Logical operators

Which statements are true?

- [ ] `#eval ((True ∧ ¬False) ∨ False)` gives `true`
- [ ] `∧` and `∨` operate on `Bool`, `&&` and `||` on `Prop`
- [ ] `#eval Bool.or (Bool.and true (Bool.not false)) false` gives `false`
- [ ] `#eval Or (And True (Not False)) False` gives `true`

<details>
<summary>Answer</summary>

The first and last ones. `&&` and `||` are the boolean operators and `∧` and `∨`
the logical ones, and the third expression is `(true && !false) || false`, which
is `true`.

</details>

Session 03
--------------------------------------------------------------------------------

### 11. `let`

Which statements are true?

- [ ] `#eval (let y := 1.0 ; let x := 2.0 ; y + x)` gives `3.000000`
- [ ] `let x := 2.0` makes sense in isolation, as a top-level command
- [ ] `#eval (fun (x : Float) => 1.0 + x) (x := 2.0)` gives `3.000000`
- [ ] Without `let`, some computations could not be expressed at all

<details>
<summary>Answer</summary>

The first and third ones. `let` only binds an identifier locally, in a specific
expression. It is convenient but not fundamental, since the IIFE pattern can
replace it.

</details>

### 12. Termination

Given the definition of `mod` below, which statements are true?

```lean
def mod (m n : Nat) : Nat :=
  if n = 0 ∨ m < n then
    m
  else
    mod (m - n) n
```

- [ ] `fact` uses structural recursion: it defines `fact n` from `fact (n - 1)`
- [ ] Lean can identify every valid recursive definition automatically
- [ ] `termination_by` specifies what decreases and `decreasing_by` proves it
- [ ] `mod` terminates because its first argument `m` strictly decreases

<details>
<summary>Answer</summary>

All of them except the second one. Sometimes you have to provide your own proof,
as in `Total.gcd`, which uses `Nat.mod_lt`.

</details>

### 13. Command-line arguments

Which statements are true when you execute `lake new my-project math` in bash?

- [ ] `lake` is provided with the arguments `["new", "my-project", "math"]`
- [ ] `lake` is provided with the arguments `["lake", "new", "my-project", "math"]`
- [ ] Right afterwards, `echo $?` displays the return code of the command
- [ ] If the displayed return code is `1`, the command has failed

<details>
<summary>Answer</summary>

All of them except the second one: the arguments are the strings that come after
the name of the executable. `0` means success and any other value means failure.

</details>

### 14. `Option`

With `def list := [4, 2, 1]`, which statements are true?

- [ ] `Option` is not a type by itself, but `Option Nat` is
- [ ] `list[0]!` has type `Option Nat`
- [ ] `list[0]?` has type `Option Nat`
- [ ] `#eval Option.none` fails, because nothing tells Lean what `α` is
- [ ] `#eval list[100]!` panics

<details>
<summary>Answer</summary>

All of them except the second one: `list[0]!` has type `Nat`. Only `list[i]?`
yields an `Option`, while `list[i]!` panics when the index is out of bounds.

</details>

### 15. Accumulator

Given the definition below, what does `List_reverseAux [1, 2, 3] [4, 5]` evaluate
to?

```lean
def List_reverseAux {α : Type} (list acc : List α) : List α :=
  match list with
  | List.nil => acc
  | List.cons a as => List_reverseAux as (List.cons a acc)
```

- [ ] `[1, 2, 3, 4, 5]`
- [ ] `[4, 5, 3, 2, 1]`
- [ ] `[3, 2, 1, 4, 5]`
- [ ] `[5, 4, 3, 2, 1]`

<details>
<summary>Answer</summary>

`[3, 2, 1, 4, 5]`. The elements of `list` move one at a time to the front of
`acc`, which reverses their order, and the elements of `acc` don't move.

</details>
