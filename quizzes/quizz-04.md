# Quiz 4: Sessions 01 to 03

Each question has **one or more** correct answers. Click on "Answer" to check
your choices.

Session 01
--------------------------------------------------------------------------------

### 1. Development environments

Which statements are true?

- [ ] The Lean Web editor requires a local installation of Lean
- [ ] You can share a snippet from the Lean Web editor by copying its URL
- [ ] QED64 runs in your browser, thanks to WebAssembly
- [ ] Installing the Visual Studio Code extension also gives you the CLI tools

<details>
<summary>Answer</summary>

All of them except the first one: the Lean Web editor is a zero-installation
solution, which runs in the cloud.

</details>

### 2. Proofs by `decide`

With `def answer : Nat := 42`, which theorems does Lean accept?

- [ ] `theorem t1 : answer = 43 := by decide`
- [ ] `theorem t2 : answer = 42 := by decide`
- [ ] `theorem t3 : 1 ≤ 2 := by decide`
- [ ] `theorem t4 : fermat := by decide`, where `fermat : Prop` is Fermat's last
      theorem

<details>
<summary>Answer</summary>

`t2` and `t3`. The proposition of `t1` is decidable, but it is false, and Lean
cannot synthesize `Decidable fermat` for `t4`.

</details>

### 3. Definition syntax

Which lines does Lean accept?

- [ ] `def a : Nat := 42`
- [ ] `def b := 42`
- [ ] `def c = 42`
- [ ] `def d : Nat = 42`
- [ ] `#check (42 : Nat)`

<details>
<summary>Answer</summary>

The first, second and last ones. A value is assigned with `:=`, and the type
annotation is optional in `def b := 42`, since Lean can infer it.

</details>

### 4. Python syntax errors

With `name = "Penelope"`, which of these calls raise a `SyntaxError`?

- [ ] `eval('(lambda n : n + 1)(42)')`
- [ ] `eval('if name == "Noman": print("Hello")')`
- [ ] `exec('if name == "Noman": print("Hello")')`
- [ ] `eval('a = 2')`

<details>
<summary>Answer</summary>

The second and last ones: `eval` only accepts expressions. A lambda which is
immediately invoked is an expression (whose value is `43`), and `exec` accepts
statements.

</details>

### 5. Lambdas in Python

Which statements are true?

- [ ] `lambda n : n + 1` is an expression
- [ ] `eval("lambda n : n + 1")` returns a function object
- [ ] A lambda has to be given a name before it can be called
- [ ] `succ_alt = lambda n : n + 1` is a statement

<details>
<summary>Answer</summary>

All of them except the third one: `(lambda n : n + 1)(42)` directly gives `43`.
The assignment to `succ_alt` is a statement, even though the lambda on its
right-hand side is an expression.

</details>

Session 02
--------------------------------------------------------------------------------

### 6. Sequencing

Which definitions does Lean accept?

- [ ] A

  ```lean
  def main := IO.println "Hello"
  ```

- [ ] B

  ```lean
  def main := do
    IO.println "Hello"
  ```

- [ ] C

  ```lean
  def main :=
    IO.println "Hello"
    IO.println "Hello"
  ```

- [ ] D

  ```lean
  def main := do
    IO.println "Hello"
    IO.println "Hello"
  ```

- [ ] E

  ```lean
  def g (n : Nat) : Nat :=
    1 + 1
    n + 2
  ```

<details>
<summary>Answer</summary>

A, B and D. A single action does not need `do`, but two actions do (C). In E, a
single expression is required: computing `1 + 1` and throwing the result away
would be meaningless, since it has no side effect.

</details>

### 7. Lists

Which commands succeed?

- [ ] `#check ["Hello", " "]`
- [ ] `#check [1, 2, "Hello"]`
- [ ] `#check [Int, Nat, String]`
- [ ] `#eval IO.println Int`

<details>
<summary>Answer</summary>

The first and third ones. Lists are homogeneous, so `1` and `2` would have to be
strings. A list of types is fine, since `List` is universe-polymorphic, but such a
type cannot be printed: there is no `ToString Type` instance.

</details>

### 8. Namespaces

Which definitions does Lean accept (assuming that they don't conflict with each
other)?

- [ ] A

  ```lean
  def pi := 4 * (Float.atan 1.0)
  ```

- [ ] B

  ```lean
  def pi : Float := 4 * (atan 1.0)
  ```

- [ ] C

  ```lean
  def Float.pi_alt := 4 * (atan 1.0)
  ```

- [ ] D

  ```lean
  namespace Float

  def pi_alt2 := 4 * (atan 1.0)

  end Float
  ```

<details>
<summary>Answer</summary>

A, C and D. In B, we are not in the `Float` namespace, so `atan` is an unknown
identifier.

</details>

### 9. Bounded numbers and floats

Which statements are true?

- [ ] `#eval (255 : UInt8) + 2` gives `1`
- [ ] `#eval (9 : Fin 10) + 1` gives `10`
- [ ] `Float` is a 64-bit type and `Float32` a 32-bit type
- [ ] `#eval IO.println 1.2e-10` gives `0.000000`

<details>
<summary>Answer</summary>

All of them except the second one. `Fin 10` wraps around beyond `9`, so the result
is `0`. The default string representation of floats can also lose a lot of
precision, as the last line shows.

</details>

### 10. The walrus and `match` in Python

Which statements are true?

- [ ] `eval("a = 1")` and `eval("(a := 1)")` both raise a `SyntaxError`
- [ ] `(b := 1)` is an impure expression: it has the value `1` and binds `b`
- [ ] `"no special symbol".find(":")` evaluates to `-1`
- [ ] `match` / `case` produces a statement, so it cannot go through `eval`

<details>
<summary>Answer</summary>

All of them except the first one. `eval("a = 1")` does raise a `SyntaxError`, but
`eval("(a := 1)")` returns `1`.

</details>

Session 03
--------------------------------------------------------------------------------

### 11. Local recursion

Which definitions does Lean accept?

- [ ] A

  ```lean
  def repeatStr (s : String) (n : Nat) : String :=
    let rec go (k : Nat) : String :=
      match k with
      | 0     => ""
      | k + 1 => s ++ go k
    go n
  ```

- [ ] B

  ```lean
  def repeatStr (s : String) (n : Nat) : String :=
    let go (k : Nat) : String :=
      match k with
      | 0     => ""
      | k + 1 => s ++ go k
    go n
  ```

<details>
<summary>Answer</summary>

A. A local recursive function requires `let rec`: in B, `go` is an unknown
identifier in its own body.

</details>

### 12. Accepted or rejected?

Which definitions does Lean accept?

- [ ] A

  ```lean
  def spin (n : Nat) : Nat := spin n
  ```

- [ ] B

  ```lean
  partial def spin (n : Nat) : Nat := spin n
  ```

- [ ] C

  ```lean
  def fact : ℕ -> ℕ := fun n ↦
    if n = 0 then 1 else n * fact (n - 1)
  ```

- [ ] D

  ```lean
  def gcd (m n : Nat) : Nat :=
    if n = 0 then
      m
    else
      gcd n (m % n)
  ```

<details>
<summary>Answer</summary>

B and C. A has no termination proof, and neither has D: Lean does not find one
automatically and needs some help, such as `Nat.mod_lt`. In C, `↦` is an
alternative to `=>`, preferred by the Mathlib community.

</details>

### 13. Signature of `main`

Which definitions are valid?

- [ ] A

  ```lean
  def main (args : List String) : IO Unit :=
    IO.println args
  ```

- [ ] B

  ```lean
  def main (args : List String) : IO Nat :=
    return args.length
  ```

- [ ] C

  ```lean
  def main (args : List String) : UInt32 :=
    0
  ```

- [ ] D

  ```lean
  def main (args : List String) : IO UInt32 := do
    if args.length > 0 then
      IO.println s!"args: {args}"
      return 0
    else
      IO.println "You have provided no argument"
      return 1
  ```

<details>
<summary>Answer</summary>

A and D. A return code is a `UInt32`, not a `Nat` (B), and `main` has to be an `IO`
action (C).

</details>

### 14. Identifiers in patterns

Given the type below, which definitions does Lean accept?

```lean
inductive Light where
  | green
  | orange
  | red
```

- [ ] A

  ```lean
  def canGo (light : Light) : Bool :=
    match light with
    | Light.red => false
    | _anyLight => true
  ```

- [ ] B

  ```lean
  def canGo (light : Light) : Bool :=
    match light with
    | red => false
    | _ => true
  ```

- [ ] C

  ```lean
  def next (light : Light) : Light :=
    match light with
    | Light.green => Light.orange
    | Light.orange => Light.red
    | Light.red => Light.green
  ```

- [ ] D

  ```lean
  def isPositive (n : Nat) : Bool :=
    match n with
    | n if n > 0 => true
    | _ => false
  ```

<details>
<summary>Answer</summary>

A and C. In B, outside the `Light` namespace, `red` is not a constructor: it is an
identifier which matches anything, so the `_` branch is redundant and Lean rejects
it. D uses a guard, which Lean does not support.

</details>

### 15. Building structures

Given the structure below, which definitions does Lean accept?

```lean
structure Point where
  x : Float
  y : Float

def Point.origin : Point := { x := 0.0, y := 0.0 }
```

- [ ] `def p1 : Point := Point.mk 1.0 2.0`
- [ ] `def p2 : Point := { x := 1.0 }`
- [ ] `def p3 : Point := { Point.origin with x := 1.0 }`
- [ ] `def p4 := Point.origin.x := 1.0`

<details>
<summary>Answer</summary>

`p1` and `p3`. The field `y` is missing in `p2`, and there is no such thing as an
assignment to a field in `p4`: to change a field, build a new value with `with`.

</details>
