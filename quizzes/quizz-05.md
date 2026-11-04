# Quiz 5: Sessions 01 to 03

Each question has **one or more** correct answers. Click on "Answer" to check
your choices.

Session 01
--------------------------------------------------------------------------------

### 1. Reading a config file

Consider the `lakefile.toml` below, in a project which contains a `Main.lean`
file:

```toml
name = "my-project"
version = "0.1.0"
defaultTargets = ["my-project"]

[[lean_exe]]
name = "my-project"
root = "Main"
```

Which statements are true?

- [ ] `lake build` and `lake build my-project` build the same target
- [ ] `[[lean_exe]]` declares an executable
- [ ] `root = "Main"` refers to the `Main.lean` file
- [ ] This file is what fixes the version of Lean used by the project

<details>
<summary>Answer</summary>

All of them except the last one: the toolchain version is in `lean-toolchain`.

</details>

### 2. Lean commands

Which statements are true?

- [ ] `#check`, `#eval` and `#print` provide notebook-like features
- [ ] These commands won't affect the execution of your compiled program
- [ ] `#eval` automatically executes `IO` actions
- [ ] `#check` executes `IO` actions, then displays their result

<details>
<summary>Answer</summary>

All of them except the last one: `#check` only shows the type of an expression,
such as `IO.println "Hello world!" : IO Unit`.

</details>

### 3. Propositions as booleans

With `def answer : Nat := 42`, which results are correct?

- [ ] `#eval answer = 42` gives `true`
- [ ] `#eval answer = 43` is an error, since this proposition has no proof
- [ ] `#eval answer == 43` gives `false`
- [ ] `#eval decide fermat` gives `false`, where `fermat : Prop` is Fermat's last
      theorem

<details>
<summary>Answer</summary>

The first and third ones. `answer = 43` is decidable, so `#eval` evaluates it as
the boolean `false`. Lean cannot synthesize `Decidable fermat`, so `decide fermat`
is an error.

</details>

### 4. `#print`

Which statements are true?

- [ ] `#print Bool` displays the constructors `Bool.false` and `Bool.true`
- [ ] `#print` only works on types
- [ ] With `def one : Nat := 1`, `#print one` displays `def one : Nat := 1`
- [ ] With `def succ (n : Nat) : Nat := n + 1`, `#print succ` shows that `succ` is
      the function `fun n => n + 1`

<details>
<summary>Answer</summary>

All of them except the second one: `#print` displays information about any
declaration.

</details>

### 5. Function objects in Python

Which pieces of code display `43`?

- [ ] A

  ```python
  exec("""
  def succ(n):
      return n + 1
  """)
  print(succ(42))
  ```

- [ ] B

  ```python
  succ = eval("""
  def succ(n):
      return n + 1
  """)
  print(succ(42))
  ```

- [ ] C

  ```python
  succ = eval("lambda n : n + 1")
  print(succ(42))
  ```

- [ ] D

  ```python
  succ = exec("lambda n : n + 1")
  print(succ(42))
  ```

<details>
<summary>Answer</summary>

A and C. B raises a `SyntaxError`, since `def` is a statement. In D, `exec` returns
`None`, which cannot be called.

</details>

Session 02
--------------------------------------------------------------------------------

### 6. Namespaces and methods

Which statements are true?

- [ ] A namespace such as `String` can contain data, functions and theorems
- [ ] `String.length "Lean 4"` and `"Lean 4".length` mean the same thing
- [ ] The dot syntax is only available for structures
- [ ] `String.length_eq_zero_iff` is a theorem

<details>
<summary>Answer</summary>

All of them except the third one. The dot syntax works for instance with
`[1, 2, 3].reverse`, and `List` is not a structure: it has two constructors.

</details>

### 7. Three arguments

Given `def add3 (a b c : Nat) : Nat := a + b + c`, which commands display `6`?

- [ ] `#eval add3 1 2 3`
- [ ] `#eval ((add3 1) 2) 3`
- [ ] `#eval add3 (1 2) 3`
- [ ] `#eval add3 (1, 2, 3)`
- [ ] `#eval (add3 1) 2 3`

<details>
<summary>Answer</summary>

The first, second and last ones, thanks to currying. `1` is not a function that
could be applied to `2`, and `add3` expects a `Nat` as its first argument, not a
triple.

</details>

### 8. What you see with floats

We have:

```lean
#eval IO.println ((0.1 + 0.2) + 0.3)
-- 0.600000

#eval IO.println (0.1 + (0.2 + 0.3))
-- 0.600000

#eval ((0.1 + 0.2) + 0.3) == (0.1 + (0.2 + 0.3))
-- false
```

Which conclusions are correct?

- [ ] `==` is broken on `Float`
- [ ] Two different floats can have the same default string representation
- [ ] The default string representation can lose precision
- [ ] Addition on `Float` is associative, but only in `IO.println`

<details>
<summary>Answer</summary>

The second and third ones. The two sums are actually different floats, but this
difference doesn't show with the default representation.

</details>

### 9. Junk values

Which results are correct?

- [ ] `#eval 3 - 7 + 7` gives `3`
- [ ] `#eval 3 + 7 - 7` gives `3`
- [ ] `#eval (3 - 7 : Int)` gives `-4`
- [ ] `#eval ((3 - 7 : Nat) : Int)` gives `-4`

<details>
<summary>Answer</summary>

The second and third ones. On `Nat`, `3 - 7` is the junk value `0`, so `3 - 7 + 7`
is `7`. In the last one, the subtraction takes place in `Nat` and gives `0`, before
the conversion to `Int`.

</details>

### 10. Civet

Consider this Civet code, with `name = "Penelope"`:

```civet
val = if name == "Nobody" then
  console.log("Odysseus detected")
  "Hello Odysseus!"
else
  1 + 1 // no effect!
  console.log("Not Odysseus")
  `Hello ${name}!`

console.log("val:", val)
```

Which statements are true?

- [ ] `Not Odysseus` gets printed
- [ ] `val` is `2`
- [ ] `val` is `"Hello Penelope!"`
- [ ] This `if` is used both for its value and for its side effects

<details>
<summary>Answer</summary>

All of them except the second one. The value of the branch is the one of its last
expression, while the result of `1 + 1` is simply lost.

</details>

Session 03
--------------------------------------------------------------------------------

### 11. Recursion on `Nat`

Consider the definition below:

```lean
def Nat_add (m n : Nat) : Nat :=
  match n with
  | Nat.zero => m
  | Nat.succ n => Nat.succ (Nat_add m n)
```

Which statements are true?

- [ ] The recursion terminates, because each call is applied to a part of `n`
- [ ] In the last branch, `n` refers to the argument of the function
- [ ] `| 0 => ...` and `| n + 1 => ...` could replace these two patterns
- [ ] `#guard Nat_add 2 3 = 5` succeeds

<details>
<summary>Answer</summary>

All of them except the second one: the `n` bound by the pattern `Nat.succ n` shadows
the argument `n` of the function in this branch.

</details>

### 12. Terminal calls

In which definitions is the recursive call terminal, that is the very last thing
that the function does?

- [ ] A

  ```lean
  def fact (n : Nat) : Nat :=
    if n = 0 then
      1
    else
      n * fact (n - 1)
  ```

- [ ] B

  ```lean
  def List_reverseAux {α : Type} (list acc : List α) : List α :=
    match list with
    | List.nil => acc
    | List.cons a as => List_reverseAux as (List.cons a acc)
  ```

- [ ] C

  ```lean
  def List_appendAlt {α : Type} (xs ys : List α) : List α :=
    match xs with
    | List.nil => ys
    | List.cons x xs => List.cons x (List_appendAlt xs ys)
  ```

- [ ] D

  ```lean
  def mod (m n : Nat) : Nat :=
    if n = 0 ∨ m < n then
      m
    else
      mod (m - n) n
  ```

<details>
<summary>Answer</summary>

B and D. In A, the result of the recursive call still has to be multiplied by `n`,
and in C, `List.cons` still has to be applied to it, so the pending calls pile up
on the stack.

</details>

### 13. Putting lists end to end

With `xs := [1, 2, 3]` and `ys := [4, 5]`, which expressions evaluate to
`[1, 2, 3, 4, 5]`? `List_reverseAux`, `List_reverse` and `List_appendAlt` are the
functions of the session.

- [ ] `List_reverseAux xs ys`
- [ ] `List_reverseAux (List_reverse xs) ys`
- [ ] `List_appendAlt xs ys`
- [ ] `List_reverse (List_appendAlt ys xs)`
- [ ] `List_reverse (List_appendAlt (List_reverse ys) (List_reverse xs))`

<details>
<summary>Answer</summary>

The second, third and last ones. The first one gives `[3, 2, 1, 4, 5]` and the
fourth one `[3, 2, 1, 5, 4]`. In the last one, the inner expression is
`[5, 4, 3, 2, 1]`, which is then reversed.

</details>

### 14. Matching several values

Consider the definition below:

```lean
def List.getElem? {α} (as : List α) (i : Nat) : Option α :=
  match as, i with
  | [], _i => Option.none
  | a :: _as, 0 => Option.some a
  | _a :: as , i + 1 => List.getElem? as i
```

Which statements are true?

- [ ] `[4, 2, 1].getElem? 0` evaluates to `4`
- [ ] `[4, 2, 1].getElem? 2` evaluates to `some 1`
- [ ] `([] : List Nat).getElem? 0` evaluates to `none`
- [ ] Lean would reject this definition without its first branch
- [ ] `a :: as` is the usual notation for `List.cons a as`

<details>
<summary>Answer</summary>

All of them except the first one, which evaluates to `some 4`. Without the first
branch, the patterns would not cover the empty list.

</details>

### 15. Counting values

Which statements are true?

- [ ] `Empty` has no value
- [ ] `Option Bool` has two values
- [ ] `Bool × Bool` has four values
- [ ] The type below has three values:

  ```lean
  inductive T where
    | a (b : Bool)
    | c
  ```

<details>
<summary>Answer</summary>

All of them except the second one. `Option Bool` has three values: `none`,
`some false` and `some true`. The values of the constructors of a sum type add up
(`T` has `a false`, `a true` and `c`), while a product multiplies them.

</details>
