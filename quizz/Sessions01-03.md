# Quiz: Sessions 01 to 03

Each question has **one or more** correct answers. Click on "Answer" to check
your choices.

Session 01
--------------------------------------------------------------------------------

### 1. Lean tools

Which command-line tool is the project manager, the one that you use most of the
time to create and build a project?

- [ ] `elan`
- [ ] `lean`
- [ ] `lake`
- [ ] `leanc`

<details>
<summary>Answer</summary>

`lake`. It dispatches the calls to the other tools. `elan` manages the Lean
toolchains and `lean` is the typechecker / interpreter / compiler.

</details>

### 2. Symbols

Given `def answer : Nat := 42`, which statements are true?

- [ ] `answer == 42` has type `Bool`
- [ ] `answer = 42` has type `Prop`
- [ ] `answer = 42` has type `Bool`
- [ ] `:=` declares the type of a term and `:` gives a name to a value

<details>
<summary>Answer</summary>

The first two. `==` is the boolean equality and `=` the propositional equality.
It is `:` that declares a type, and `:=` that gives a name to a value.

</details>

### 3. `#eval`

Which of these commands succeed?

- [ ] `#eval 1 ≤ 2`
- [ ] `#eval IO.println "Hello world!"`
- [ ] `#eval 1 + "Hello"`
- [ ] `#eval fermat`, where `fermat : Prop` is Fermat's last theorem

<details>
<summary>Answer</summary>

The first two: `#eval` evaluates decidable propositions as booleans and executes
`IO` actions. There is no way to add a `Nat` and a `String`
(`HAdd Nat String ?` cannot be synthesized) and `fermat` is not known to be
decidable.

</details>

### 4. Expressions in Python

Which of these strings does Python's `eval` accept?

- [ ] `"a = 2"`
- [ ] `"lambda n : n + 1"`
- [ ] `"[i * i for i in [1, 2, 3]]"`
- [ ] `"def succ(n): return n + 1"`

<details>
<summary>Answer</summary>

The lambda and the list comprehension, since they are expressions. The two other
ones are statements, which raise a `SyntaxError` in `eval` but work with `exec`.

</details>

### 5. `exec`

What is the value of `exec("1 + 1")` in Python?

- [ ] `2`
- [ ] `None`
- [ ] It raises a `SyntaxError`

<details>
<summary>Answer</summary>

`None`. The code runs, but `exec` always returns `None`, so the value `2` is lost.

</details>

Session 02
--------------------------------------------------------------------------------

### 6. Mixing actions and values

Which definition compiles and returns `n + 1` after printing a message?

- [ ] A

  ```lean
  def f (n : Nat) : Nat :=
    IO.println "Hello"
    n + 1
  ```

- [ ] B

  ```lean
  def f (n : Nat) : Nat := do
    IO.println "Hello"
    return n + 1
  ```

- [ ] C

  ```lean
  def f (n : Nat) : IO Nat :=
    IO.println "Hello"
    return n + 1
  ```

- [ ] D

  ```lean
  def f (n : Nat) : IO Nat := do
    IO.println "Hello"
    return n + 1
  ```

<details>
<summary>Answer</summary>

D. The return type has to be `IO Nat`, `do` is required to sequence two actions
and `return` turns the pure `n + 1` into a value of type `IO Nat`.

</details>

### 7. Numbers

Which results are correct?

- [ ] `#eval 3 - 7` gives `-4`
- [ ] `#eval (3 : Int) - 7` gives `-4`
- [ ] `#eval (255 : UInt8) + 1` gives `0`
- [ ] `#eval (8 : Fin 10) + 3` gives `11`
- [ ] `#eval ((0.1 + 0.2) + 0.3) == (0.1 + (0.2 + 0.3))` gives `false`

<details>
<summary>Answer</summary>

The second, third and last ones. Subtraction on `Nat` gives the junk value `0`
when the result would be negative, so `3 - 7` is `0`. `Fin 10` wraps around, so
`(8 : Fin 10) + 3` is `1`. Addition on `Float` is not associative.

</details>

### 8. Reading a signature

Consider the signature:

```lean
IO.println.{u_1} {α : Type u_1} [ToString α] (s : α) : IO Unit
```

Which statements are true?

- [ ] You usually don't provide `α`, because Lean infers it from `s`
- [ ] `[ToString α]` requires an instance of the type class `ToString` for `α`
- [ ] `#eval IO.println Int` works, because `IO.println` is polymorphic
- [ ] `IO.println "Hello"` is a value of type `IO Unit`

<details>
<summary>Answer</summary>

All of them except `#eval IO.println Int`, which fails because there is no
`ToString Type` instance.

</details>

### 9. Currying

Given `def add (m : Nat) (n : Nat) : Nat := m + n`, which statements are true?

- [ ] `add` has type `Nat → Nat → Nat`
- [ ] `Nat → Nat → Nat` means `(Nat → Nat) → Nat`
- [ ] `add 1` is an error, since an argument is missing
- [ ] `add 1` has type `Nat → Nat`

<details>
<summary>Answer</summary>

The first and last ones. The arrow is right-associative, so `Nat → Nat → Nat`
means `Nat → (Nat → Nat)`, and `add 1` is a partially applied function.

</details>

### 10. `true` or `True`?

Which statements are true?

- [ ] `true` has type `Bool`
- [ ] `True` has type `Prop`
- [ ] `True` and `true` are two names for the same term
- [ ] `#eval True` gives `true`, because `True` is decidable

<details>
<summary>Answer</summary>

All of them except the third: `true` is a boolean, while `True` is a proposition.

</details>

Session 03
--------------------------------------------------------------------------------

### 11. Local definitions

Which expression can replace `let x := 2.0 ; 1.0 + x` and evaluate to the same
value?

- [ ] `(fun (x : Float) => 1.0 + x) 2.0`
- [ ] `fun (x : Float) => 1.0 + x`
- [ ] `def x := 2.0 ; 1.0 + x`

<details>
<summary>Answer</summary>

The first one, the IIFE (immediately invoked function expression) pattern. The
second one is a function which is never applied, and `def` is not an expression.

</details>

### 12. Recursion

You define a recursive function that computes the length of a Collatz sequence.
Nobody has a proof that it terminates for every input, but you want to execute it.
What do you need?

- [ ] `partial def`
- [ ] `let rec`
- [ ] `termination_by`, with an argument of your choice and no further proof
- [ ] Nothing: Lean always accepts recursive definitions

<details>
<summary>Answer</summary>

`partial def`. Lean would otherwise require a termination proof, which here
would amount to solving the Collatz conjecture. `let rec` only defines a
recursive function locally.

</details>

### 13. `main` and `IO`

Knowing that `Timestamp.now : IO Timestamp`, which statements are true?

- [ ] `def main (args : List String) : IO UInt32` is a valid signature for `main`
- [ ] A return code of `0` means that the program has failed
- [ ] In a `do` block, `let ts <- Timestamp.now` binds `ts` to a `Timestamp`
- [ ] In a `do` block, `let ts := Timestamp.now` binds `ts` to a `Timestamp`

<details>
<summary>Answer</summary>

The first and third ones. `0` means success, and `:=` merely names the action
itself, so with `let ts := Timestamp.now` the type of `ts` is `IO Timestamp`.

</details>

### 14. Pattern matching

Given the type below, which definitions of `canGo` does Lean accept?

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
    | Light.green => true
    | Light.red => false
  ```

- [ ] B

  ```lean
  def canGo (light : Light) : Bool :=
    match light with
    | Light.green | Light.orange => true
    | Light.red => false
  ```

- [ ] C

  ```lean
  def canGo (light : Light) : Bool :=
    match light with
    | Light.red => false
    | _ => true
  ```

- [ ] D

  ```lean
  def canGo (light : Light) : Bool :=
    match light with
    | _ => true
    | Light.red => false
  ```

<details>
<summary>Answer</summary>

B and C. A does not cover `Light.orange`. In D, the catch-all pattern comes first,
which makes the `Light.red` branch redundant, and Lean rejects this as well.

</details>

### 15. Inductive types

Which statements are true?

- [ ] With `def list := [4, 2, 1]`, `list[100]?` evaluates to `none`
- [ ] `[1, 2]` is `List.cons 1 (List.cons 2 List.nil)`
- [ ] `{ p with x := 1.0 }` modifies the field `x` of the structure `p`
- [ ] Given `inductive Color` with the constructors `rgb` and `named`,
      `def Color.black := Color.rgb 0 0 0` adds a third constructor
- [ ] Lean supports guards in patterns, such as `| n if n > 0 => ...`

<details>
<summary>Answer</summary>

Only the first two. `{ p with x := 1.0 }` builds a new value and leaves `p`
unchanged, `Color.black` is a mere value stored in the `Color` namespace, and
Lean has no pattern guards: use an `if` expression in the branch instead.

</details>
