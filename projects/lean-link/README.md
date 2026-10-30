Lean Link
================================================================================

Introduction
--------------------------------------------------------------------------------

The [Lean Web] project develops a Lean playground, which provides a Lean 4
code editor and execution environment in the browser. 

The official playground instance is hosted at <https://live.lean-lang.org/>.

This web app stores the your Lean program source inside the browser URL.
That makes it very easy to share some Lean snippets that can be readily tested;
for example, to try my program

```lean
def main := IO.println "Hello Lean Web!"

#eval main
```

you can click on <https://live.lean-lang.org/#codez=CYUwZgBAtghglgOwgLgLwQJIHkB0AHAJ0QBcAbJAIgAkRTSB7CAGRBiQHUQAjAQgoCh%2BAYhAA3GKWjwEQA>.

The idea of the Lean Link project is to bridge local development with the online
playground: if you have a local version `Hello.lean` of the above program, 
invoke `lean-link` to get the corresponding link:

```bash
$ lean-link HelloLeanWeb.lean
https://live.lean-lang.org/#code=def%20main%20%3A%3D%20IO.println%20%22Hello%20Lean%20Web!%22%0A%0A%23eval%20main
```

Preparation
--------------------------------------------------------------------------------

Have a look at the [Lean Web Usage] document. 
Specifically, search for the documentation of the URL arguments 
`code` and `codez`. 

In the playground, search for the User settings and experiment with the
"Compress code URL" option which is enabled by default. 
What is the impact of this user selection on the playground URL?

Study [the documentation of the JavaScript `encodeURIComponent` function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/encodeURIComponent). 
How is this function connected to the Lean Web URL?
    
Lean development
--------------------------------------------------------------------------------

Start a Lean `exe` project named `lean-link`.

### Hex codes

Develop a function

```lean
def Hex.code (n : UInt8) : String := 
  sorry
```

that give the hex code of any number between 0 and 255.

```lean
#guard Hex.code 0 = "00"
#guard Hex.code 1 = "01"
#guard Hex.code 9 = "09"
#guard Hex.code 10 = "0A"
#guard Hex.code 16 = "10"
#guard Hex.code 255 = "FF"
```

### URI encoding

Develop a function that maps every character from string into the corresponding 
`%XX` code used by `encodeURIComponent`.

```lean
def URI.encodeAll (s : String) : String :=
  sorry
```
  
```lean
#guard URI.encodeAll "A B C" = "%41%20%42%20%43"
```

Then, make a second version that only encodes the characters that need to
be escaped.

```lean
def URI.encodeMinimal (s : String) : String :=
  sorry
```

```lean
#guard encodeMinimal "A B C" = "A%20B%20C"
```

Implement a `Lean.uri` function that computes the Lean Web playground link
associated to a Lean source.

```lean
def Lean.uri (source : String) : String :=
  sorry
```

```lean
/--
info: https://live.lean-lang.org/#code=def%20two%20%3A%3D%201%20%2B%201-/
#guard_msgs in
#eval IO.println (Lean.uri "def two := 1 + 1")
```

### Command-line interface

Define a `usage` action that prints the tool help message 
`"Usage: lean-link LEAN-FILE [EXTRA-FILE]..."`

```lean
def usage : IO Unit :=
  sorry
```

Implement the `main` program entry point that
- prints the help message if no argument is given or
- display the playground link for each file given in the arguments.

```lean
def main (args : List String) : IO Unit :=
  sorry
```




[Lean Web]: https://github.com/leanprover-community/lean4web
[Hello Lean Web]: https://live.lean-lang.org/#codez=CYUwZgBAtghglgOwgLgLwQJIHkB0AHAJ0QBcAbJAIgAkRTSB7CAGRBiQHUQAjAQgoCh%2BAYhAA3GKWjwEQA 
[Lean Web Usage]: https://github.com/leanprover-community/lean4web/blob/main/doc/Usage.md#url-arguments