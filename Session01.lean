
/-!

Lean resources
--------------------------------------------------------------------------------

Web sites:
- [Lean language](https://lean-lang.org/),
- [Lean community](https://leanprover-community.github.io/),

API reference:
- [Lean + Mathlib API](https://leanprover-community.github.io/mathlib4_docs/index.html)

Discussion:
- [Zulip chat](https://leanprover.zulipchat.com/),

Books:
 - [Functional Programming in Lean](https://lean-lang.org/functional_programming_in_lean/)
 - [the Hitchhiker's Guide to Logical Verification](https://github.com/lean-forward/logical_verification_2025)
   (aka LoVe)

External courses:
 - [Lean4dev](https://lean4.dev/)


Lean development environments
--------------------------------------------------------------------------------

### Playgrounds

Zero-installation solutions.

- Lean Web editor: <https://live.lean-lang.org/>

  - UI: code editor + infoview,

  - Runs "in the cloud" (on someone else's computer),

  - Select Lean version and  Mathlib CSL dependencies,

  - Share your code snippets: copy the URL.

- QED64 : <https://qed64.fawadworkaddress.workers.dev/>

  - Runs in your browser (⚠️ large memory requirements!)

  - Relies on the [WebAssembly] technology

[WebAssembly]: https://webassembly.org/


### Lean command-line interface (CLI)

[Install Lean manually] or [install the Visual Studio Code Lean extension]
and get the CLI tools "for free".

Main CLI tools are:

- `elan`: toolchain installer / version manager
  - equivalent to [nvm] in the Node (JS) world, or [rustup] in the Rust world,
  - manages the different version of Lean that you may need,
  - stores everything inside the `.elan` directory in your home directory,
  - (sub-)commands:
    - `elan --help`,
    - `elan show`,
    - `elan self update`,
    - etc.

- `lean`: lean typechecker / interpreter / compiler
  - (sub-)commands:
    - `lean --help`,
    - `lean Main.lean` (type checker)
    - `lean --run Main.lean`, (program interpreter)
    - `lean -c main.c Main.lean` (Lean -> C compiler).
      Follow by `leanc -o main main.c` to get an executable program `main`.
    - etc.

- `lake`: project manager
  Create/configure new projects, manage versions, dependencies,
  build and execution. Most of the time you don't deal with `elan` and `lean`
  directly, only with `lake` who dispatches the calls.

  - A typical Lean project layout for a Lean program:
    - `lakefile.toml`: project config file, looks like:
      ```toml
      name = "my-project"
      version = "0.1.0"
      defaultTargets = ["my-project"]

      [[lean_exe]]
      name = "my-project"
      root = "Main"
      ```
    - `lean-toolchain`: toolchain version info, like `leanprover/lean4:v4.35.0`
    - `README.md`,
    - `Main.lean`.
    - Hidden files:
      - .lake: directory that stores all build artifacts (not tracked by git)
      - .git: git repo info
      - .github: declares a github action that automatically builds your project
        if you host you repo on GitHub.

  - (sub-)commands:
    - `lake --help`,
    - `lake new --help`,
    - `lake new my-project exe`: create a new project for a Lean program
      (see also `std`, `lib` and `math` templates)
    - `lake build my-project` (or simply: `lake build`, see `defaultTargets`
      in the project config file)


[Install Lean manually]: https://lean-lang.org/install/manual/
[install the Visual Studio Code Lean extension]: https://lean-lang.org/install/
[nvm]: https://github.com/nvm-sh/nvm
[rustup]: https://rustup.rs/


### Lean Visual Studio code extension.

(not much to say there!)


Lean commands
--------------------------------------------------------------------------------

Enable some "notebook-like" features (won't affect the execution of your
compiled program)

### `#check`

Check/show the type of your expression

-/

#check 1 + 1
-- 1 + 1 : Nat

#check "Hello " ++ "world!"
-- "Hello " ++ "world!" : String

#check 1 + "Hello"
-- failed to synthesize instance of type class
--   HAdd Nat String ?m.5

/-!

### `#eval`

Evaluates an expression and prints it

- ⚠️: your result needs to be "printable" (with a known conversion to `String`),
  which is not true for types and functions for examples. For them, use `#print`

- ⚠️: be aware that `#eval` can perform automatically some additional tasks
  to make your life simpler. For example:
  - automatically execute `IO` actions,
  - evaluate propositions as bools (when they are decidable).
-/

#eval 1 + 1
-- 2

#check IO.println "Hello world!"
-- IO.println "Hello world!" : IO Unit

#eval IO.println "Hello world!"
-- Hello world!

/-!
The proposition `1 ≤ 2` is decidable so we can evaluate it as a `Bool`:
-/

#check 1 ≤ 2
-- 1 ≤ 2 : Prop

#eval 1 ≤ 2
-- true

#check decide (1 ≤ 2)
-- decide (1 ≤ 2) : Bool

#eval decide (1 ≤ 2)
-- true

/-!
This proposition won't work (you need a proof of Fermat last theorem!)
-/

def fermat : Prop :=
  ∀ (n : Nat), ∀ (x y z : Nat),
  n > 2 ∧ x > 0 ∧ y > 0 ∧ z > 0 → x ^ n + y ^ n ≠ z ^ n

#eval fermat
-- failed to synthesize
--   Decidable fermat


/-!
### `#print`

Displays information about a declaration
-/

def one : Nat := 1

#print one
-- def one : Nat := 1

def succ (n : Nat) : Nat := n + 1

#print succ
-- def succ : Nat → Nat :=
--   fun n => n + 1

#print Bool
-- inductive Bool : Type
-- number of parameters: 0
-- constructors:
-- Bool.false : Bool
-- Bool.true : Bool

/-!

Symbols `:`, `:=`, `==`, `=`
--------------------------------------------------------------------------------

- `:` type declaration

- `:=` assign a name to a value (comparable to `=` in Python)

- `==` boolean equality (like `==` in Python)

- `=` propositional equality

-/

#check (42 : Nat)
-- 42 : Nat

def answer : Nat := 42

#check answer == 42
-- answer == 42 : Bool

#eval answer == 42
-- true

#check answer = 42
-- answer = 42 : Prop

/-!
A theorem is made of:
  - a name,
  - a proposition,
  - a proof of the proposition.

Here we are lucky, the proposition `answer = 42` is decidable, so the proof
is very simple!
-/

theorem the_answer_is_forty_two : answer = 42 := by decide
