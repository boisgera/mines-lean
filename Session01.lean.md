

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


```lean4
#check 1 + 1
-- 1 + 1 : Nat

#check "Hello " ++ "world!"
-- "Hello " ++ "world!" : String

#check 1 + "Hello"
-- failed to synthesize instance of type class
--   HAdd Nat String ?m.5
```


### `#eval`

Evaluates an expression and prints it

- ⚠️: your result needs to be "printable" (with a known conversion to `String`),
  which is not true for types and functions for examples. For them, use `#print`

- ⚠️: be aware that `#eval` can perform automatically some additional tasks
  to make your life simpler. For example:
  - automatically execute `IO` actions,
  - evaluate propositions as bools (when they are decidable).

```lean4
#eval 1 + 1
-- 2

#check IO.println "Hello world!"
-- IO.println "Hello world!" : IO Unit

#eval IO.println "Hello world!"
-- Hello world!
```

The proposition `1 ≤ 2` is decidable so we can evaluate it as a `Bool`:

```lean4
#check 1 ≤ 2
-- 1 ≤ 2 : Prop

#eval 1 ≤ 2
-- true

#check decide (1 ≤ 2)
-- decide (1 ≤ 2) : Bool

#eval decide (1 ≤ 2)
-- true
```

This proposition won't work (you need a proof of Fermat last theorem!)

```lean4
def fermat : Prop :=
  ∀ (n : Nat), ∀ (x y z : Nat),
  n > 2 ∧ x > 0 ∧ y > 0 ∧ z > 0 → x ^ n + y ^ n ≠ z ^ n

#eval fermat
-- failed to synthesize
--   Decidable fermat
```

### `#print`

Displays information about a declaration

```lean4
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
```


Symbols `:`, `:=`, `==`, `=`
--------------------------------------------------------------------------------

- `:` type declaration

- `:=` assign a name to a value (comparable to `=` in Python)

- `==` boolean equality (like `==` in Python)

- `=` propositional equality


```lean4
#check (42 : Nat)
-- 42 : Nat

def answer : Nat := 42

#check answer == 42
-- answer == 42 : Bool

#eval answer == 42
-- true

#check answer = 42
-- answer = 42 : Prop
```

A theorem is made of:
  - a name,
  - a proposition,
  - a proof of the proposition.

Here we are lucky, the proposition `answer = 42` is decidable, so the proof
is very simple!

```lean4
theorem the_answer_is_forty_two : answer = 42 := by decide
```

```lean4
Expression vs statements
--------------------------------------------------------------------------------

One core characteristic of the functional style of programming with respect
to the imperative one is the emphasis on *expressions*, that are evaluated
(i.e. turned into a value), instead of **statements** who perform actions.

Python supports some imperative constructs as well as some functional ones.
The two built-ins `eval` and `exec` mirror this split:

| Function | Accepts | Returns |
|----------|---------|---------|
| `eval(source)` | expression only                | the value of that expression |
| `exec(source)` | any code (statements included) | always `None` |

Many statements have an expression-level counterpart; we illustrate this on
three examples:
  - `if` → conditional expression,
  - `def` → `lambda`,
  - `for` + `append` → list comprehension.

```pycon
>>> 1 + 1 # expression
2
```

```pycon
>>> a = 2 # statement (assignment)
```

```pycon
>>> eval("1 + 1")
2
```

The `exec` of this expression runs, but has no side-effect and the value is lost.

```pycon
>>> exec("1 + 1")
```

```pycon
>>> eval("a = 2")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<string>", line 1
    a = 2
      ^
SyntaxError: invalid syntax
```

```pycon
>>> exec("a = 2")
>>> print(a)
2
```

### `if-then-else` constructs

In the sequel, `name` stands for `"Penelope"`:

```pycon
>>> name = "Penelope"
```

In this context, we have:

```pycon
>>> if name == "Nobody":
...     print("Hello Odysseus!")
... else:
...     print(f"Hello {name}!")
...
Hello Penelope!
```

A classic branching statement: when `name = "Penelope"`,
the `else` branch runs and prints `Hello Penelope`.
The statement itself is not an expression, it has no value;
it acts through the side effect of `print`.

```python
>>> exec(
... """
... if name == "Nobody":
...     print("Hello Odysseus!")
... else:
...     print(f"Hello {name}!")
... """
... )
...
Hello Penelope!
```

```pycon
>>> eval(
... """
... if name == "Nobody":
...     print("Hello Odysseus!")
... else:
...     print(f"Hello {name}!")
... """
... )
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<string>", line 2
    if name == "Nobody":
    ^^
SyntaxError: invalid syntax
```

Since `if` is a statement, it cannot go through `eval`, but `exec` handles it.

```pycon
>>> greetings = "Hello Odysseus" if name == "Noman" else f"Hello {name}"
>>> print(greetings)
Hello Penelope!
```

`A if condition else B` is the *expression* counterpart of `if`/`else`:
it evaluates to a value (`"Hello Penelope"`), which is then stored in `greetings`
and printed. Instead of *doing* something in each branch, we *compute a value*.

```pycon
>>> eval('"Hello Odysseus!" if name == "Noman" else f"Hello {name}!"')
'Hello Penelope!'
```

Since we have an expression, `eval` accepts it and returns the string
`"Hello Penelope!"`.

### Function definition


```pycon
>>> def succ(n):
...     return n + 1
...
>>> succ(42)
43
```

`def` is a statement: it binds the name `succ` to a new function object.


```pycon
>>> eval(
... """
... def succ(n):
...     return n + 1
... """
... )
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<string>", line 2
    def succ(n):
    ^^^
SyntaxError: invalid syntax
```

Another `SyntaxError`: a function definition is a statement, so `eval` rejects it.
`exec` would be required here.

```pycon
>>> exec(
... """
... def succ(n):
...     return n + 1
... """
... )
```

But we can also use the anonymous (or lambda) function construct here:
```pycon
>>> succ_alt = lambda n : n + 1
>>> succ_alt(42)
43
```

`lambda n: n + 1` is an *expression* that evaluates to a function object.
Assigning it to `succ_alt` (a statement) gives a function equivalent to `succ`.
However we don't *need* to name this function, we can immediately invoke it:

```python
>>> (lambda n : n + 1)(42)
43
```

```pycon
>>> eval("lambda n : n + 1")
<function <lambda> at 0x...>
```

This works, because a lambda is an expression and `eval` returns the function
object itself .

### `for` constructs

To compute a list of squares in an imperative way: start with an empty list and
mutate it inside a loop. `for` is a statement and `append` works by side effect.


```pycon
>>> squares = []
>>> for i in [1, 2, 3]:
...     squares.append(i * i)
...
>>> squares
[1, 4, 9]
```

Here the for loop is an expression:

```pycon
>>> eval("""
... for i in [1, 2, 3]:
...     squares.append(i * i)
... """)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<string>", line 2
    for i in [1, 2, 3]:
    ^^^
SyntaxError: invalid syntax
```

A functional alternative is the loop comprehension:

```pycon
>>> squares_alt = [i * i for i in [1, 2, 3]]
>>> squares_alt
[1, 4, 9]
```
The comprehension is an *expression* that directly evaluates to the desired list,
with no mutation and no intermediate empty list.

```pycon
>>> eval("[i * i for i in [1, 2, 3]]")
[1, 4, 9]
```
```
