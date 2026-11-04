# Quiz 3: Sessions 01 to 03

Each question has **one or more** correct answers. Click on "Answer" to check
your choices.

Session 01
--------------------------------------------------------------------------------

### 1. `elan`

Which statements about `elan` are true?

- [ ] It creates new projects
- [ ] It manages the different versions of Lean that you may need
- [ ] It is comparable to `nvm` for Node or `rustup` for Rust
- [ ] It stores everything inside the `.elan` directory in your home directory

<details>
<summary>Answer</summary>

All of them except the first one: `lake` creates the projects.

</details>

### 2. The `lean` command

Which descriptions are correct?

- [ ] `lean Main.lean` executes the program
- [ ] `lean --run Main.lean` executes the program with the interpreter
- [ ] `lean -c main.c Main.lean` compiles the Lean code to C
- [ ] `leanc -o main main.c` then gives an executable program `main`

<details>
<summary>Answer</summary>

All of them except the first one: `lean Main.lean` only typechecks the file.

</details>

### 3. `lake new`

Which commands create a new project?

- [ ] `lake new my-project exe`
- [ ] `lake new my-project lib`
- [ ] `lake new my-project math`
- [ ] `lake new my-project python`

<details>
<summary>Answer</summary>

The first three. `exe`, `std`, `lib` and `math` are templates, and `python` is
not one of them.

</details>

### 4. Types

Which type annotations are correct?

- [ ] `decide (1 ≤ 2) : Prop`
- [ ] `1 ≤ 2 : Prop`
- [ ] `IO.println "Hello world!" : IO Unit`
- [ ] `1 ≤ 2 : Bool`

<details>
<summary>Answer</summary>

The second and third ones. `1 ≤ 2` is a proposition, and `decide` turns it into a
`Bool`.

</details>

### 5. Loops and `exec`

In Python, consider the code below:

```python
squares = []
result = exec("""
for i in [1, 2, 3]:
    squares.append(i * i)
""")
```

Which statements are true afterwards?

- [ ] `result` is `[1, 4, 9]`
- [ ] `result` is `None`
- [ ] `squares` is `[1, 4, 9]`
- [ ] `squares` is `[]`, since `exec` has no side effect

<details>
<summary>Answer</summary>

The second and third ones. `exec` always returns `None`, but the loop runs and
mutates `squares`.

</details>

Session 02
--------------------------------------------------------------------------------

### 6. Type hierarchy

Which statements are true?

- [ ] `String : Type`
- [ ] `Type : Type`
- [ ] `Type : Type 1`
- [ ] `[Int, Nat, String] : List Type`

<details>
<summary>Answer</summary>

All of them except the second one. `Type` is `Type 0`, whose type is `Type 1`,
whose type is `Type 2`, and so on.

</details>

### 7. Implicit arguments

Given the signature below, which commands succeed?

```lean
List.reverse.{u} {α : Type u} (as : List α) : List α
```

- [ ] `#eval List.reverse [1, 2, 3]`
- [ ] `#eval List.reverse Nat [1, 2, 3]`
- [ ] `#eval List.reverse (α := Nat) [1, 2, 3]`
- [ ] `#eval List.reverse (α := String) [1, 2, 3]`

<details>
<summary>Answer</summary>

The first and third ones. `α` is implicit, so Lean infers it, but you can specify
it with a named argument. It cannot be passed as a regular positional argument,
and `1`, `2` and `3` cannot be strings, since there is no `OfNat String` instance
for them.

</details>

### 8. Type classes

Which statements are true?

- [ ] `#synth Group ℝˣ` finds an instance of `Group` for `ℝˣ`
- [ ] `#synth ToString Type` finds an instance of `ToString` for `Type`
- [ ] An instance of `ToString α` is what allows `IO.println` to convert a term of
      type `α` into a string
- [ ] Mathlib's `Group` type class only applies to `ℝˣ`

<details>
<summary>Answer</summary>

The first and third ones. There is no `ToString Type` instance, which is why
`#eval IO.println Int` fails, and `Group` has other instances, such as
`Group Unit`.

</details>

### 9. Function types

With `def add (m : Nat) (n : Nat) : Nat := m + n`, which terms have the type
`(Nat → Nat) → Nat`?

- [ ] `add`
- [ ] `fun (f : Nat → Nat) => f 0`
- [ ] `add 1`
- [ ] `fun (f : Nat → Nat) (n : Nat) => f n`

<details>
<summary>Answer</summary>

Only the second one, a function which takes a function as its argument and returns
a number. `add` has type `Nat → Nat → Nat`, `add 1` has type `Nat → Nat`, and the
last one has type `(Nat → Nat) → Nat → Nat`.

</details>

### 10. `Nat` and `Int`

Which statements are true?

- [ ] `def m := -12` gives `m` the type `Int`
- [ ] `#eval (42 : Nat) + (-12 : Int)` gives `30`
- [ ] `#eval ((12 : Int) : Nat)` gives `12`
- [ ] `[1, 2, "Hello"]` is a valid list with elements of different types

<details>
<summary>Answer</summary>

The first two. An `Int` is not accepted where a `Nat` is expected, and the `List`
type is polymorphic but homogeneous.

</details>

Session 03
--------------------------------------------------------------------------------

### 11. The left arrow

With `open Std.Time`, which definitions compile?

- [ ] A

  ```lean
  def showTime : IO Unit := do
    let ts : Timestamp <- Timestamp.now
    IO.println s!"{ts}"
  ```

- [ ] B

  ```lean
  def showTime : IO Unit := do
    let ts : Timestamp := (<- Timestamp.now)
    IO.println s!"{ts}"
  ```

- [ ] C

  ```lean
  def showTime : IO Unit := do
    let ts : Timestamp := Timestamp.now
    IO.println s!"{ts}"
  ```

- [ ] D

  ```lean
  def time : Timestamp := (<- Timestamp.now)
  ```

<details>
<summary>Answer</summary>

A and B. In C, `Timestamp.now` has type `IO Timestamp`, not `Timestamp`, and in D
the arrow is used outside of a `do` block.

</details>

### 12. Declaring constructors

Which declarations define a constructor `mk` with two `Float` arguments?

- [ ] A

  ```lean
  inductive Point2D where
    | mk (x y : Float)
  ```

- [ ] B

  ```lean
  inductive Point2D : Type where
    | mk (x : Float) (y : Float) : Point2D
  ```

- [ ] C

  ```lean
  inductive Point2D where
    | mk : Float -> Float -> Point2D
  ```

- [ ] D

  ```lean
  inductive Point2D where
    | mk (x, y : Float)
  ```

<details>
<summary>Answer</summary>

A, B and C, which are equivalent ways to declare the same constructor. The syntax
of D is invalid: arguments of the same type are grouped without a comma.

</details>

### 13. Types of constructors

Which statements are true?

- [ ] `Nat.succ` has type `Nat`
- [ ] `Nat.succ` has type `Nat → Nat`
- [ ] `List.cons 1 [2, 3]` has type `List Nat`
- [ ] Given the type `Color` with the constructor `named (name : String)`,
      `Color.named` has type `Color`

<details>
<summary>Answer</summary>

The second and third ones. A constructor with arguments is a function:
`Color.named` has type `String → Color`.

</details>

### 14. Default values

Given the definition below, which statements are true?

```lean
def List_reverse {α : Type} (list : List α) (acc : List α := List.nil) : List α :=
  match list with
  | List.nil => acc
  | List.cons a as => List_reverse as (List.cons a acc)
```

- [ ] `List_reverse [1, 2, 3]` is an error, since `acc` is missing
- [ ] `List_reverse [1, 2, 3]` evaluates to `[3, 2, 1]`
- [ ] `List_reverse [1, 2, 3] [4, 5]` evaluates to `[3, 2, 1, 4, 5]`
- [ ] `α` is inferred from the type of `list`

<details>
<summary>Answer</summary>

All of them except the first one. `acc` is `List.nil` when it is not provided.

</details>

### 15. Structures

Consider the two types below:

```lean
inductive Point2D where
  | mk (x y : Float)

structure Point where
  x : Float
  y : Float
```

Which statements are true?

- [ ] `Point` has a single constructor, `Point.mk`
- [ ] Lean generates the accessors `Point.x` and `Point.y`
- [ ] Lean generates the accessors `Point2D.x` and `Point2D.y`
- [ ] If `Point2D.norm` is defined, `p.norm` means `Point2D.norm p` for
      `p : Point2D`

<details>
<summary>Answer</summary>

All of them except the third one. For `Point2D`, you have to define the getters
yourself with pattern matching.

</details>
