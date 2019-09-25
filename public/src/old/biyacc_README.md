# What is this repository for? #

* BiYacc - a tool for generating a reflective printer and its parser in a single program.

----

#Installation#
1. Install GHC(Glasgow Haskell Compiler) or Haskell Platform.
2. Install Happy (run `cabal install happy` in the command line)
3. Install BiGUL (run `cabal install bigul` in the terminal)
4. Change your directory to the root of biyacc and run `cabal install`.
   Cabal will automatically generate you the executable file somewhere in your computer.
   In mac, the location usually is: `/Users/AccountName/Library/Haskell/bin/biyacc`
   In ubuntu, the location usually is: `/home/AccountName/.cabal/bin/biyacc`
   It depends on the system as well as the *version of the cabal and GHC*.

----

#Usage#
1) generate the executable: type `biyacc BiYaccFile OutputExecutableFile`
2) run the transformations.

for parsing:  type `OutPutExecutableFile get InputFile OutputFile`

for printing: type `OutPutExecutableFile put InputFile1 (code) InputFile2 (AST) OutputFile (code')`

If "OutputFile(updated code)" is ommitted, the "InputFile1" file will be updated.

----

#Try it on the website#
Go to
http://www.prg.nii.ac.jp/project/biyacc.html or
http://biyacc.yozora.moe
to try the examples online.
Also, you can install this website on your own computer.

----

#Changes from ver 0.2#
1) Change three parts: `Abstract`, `Concrete`, `Actions`  
to four parts: `#Abstract`, `#Concrete`, `#Directives`, `#Actions`.

2) Move the declaration for comments (`%commentLine 'xxx' ;` and `%commentBlock 'yyy' 'zzz';` )
from `Concrete` to `#Directives`,  
with new syntax: `LineComment: "xxx" ;` `BlockComment: "yyy" "zzz" ;`.

3) To describe literals (keywords), single-quotes (`''`) is no longer equivalent to double-quotes (`""`). For literals longer than one character, please use double-quotes instead, e.g. `P -> "let" Exp "in" Exp`. For a single character, both are fine.

4) New Kleene* syntax for **zero-or-more occurrence** and **one-or-more occurrence**. E.g.:

```
#Abstract
data Arith = ArithList [Arith] [Int] [Int]
           | Add Arith Arith
           | Mul Arith Arith
           | ...
           
#Concrete
Exprs -> Expr {',' Expr Dummy Dummy}* ; -- zero-or-more
-- use Exprs -> Expr {',' Expr Dummy Dummy}+ for one-or-more

Expr   -> Expr '+' Term
        | Expr '*' Term
        | ... 

#Actions
Arith +> Exprs
ArithList  (e:es) ls1 ls2 +>
  (e +> Expr) {',' (es ~*> Expr) (ls1 ~*> Dummy) (ls2 ~*> Dummy)}* ;

```


hints:  
1. put terminals and non-terminals within `{}*` or `{}+` brackets.  
2. **use `~*>` arrow** instead of `+>` for update within the `{}*` and `{}+` brackets.  
3. in the put direction, min-edit-distance-based alignment for the elements in the list is automatically done.

5) New syntax for user-defined adaptations

```
#Concrete
Expr -> [EAdd] Expr '+' Term
      | [ESub] Expr '-' Term
      | ...
      ;

Factor -> Numerics
        | ...
Arith +> Expr
Add x   y            +>   (x +> Expr) '+' (y +> Term);

Adaptive:
  [p| EAdd _ _ _ |] [p| Add _ _  |]
  [f| \_ (Add l r) -> EAdd ExprNull "\n  \n  "  TermNull |] ;

e@(Sub (Num 0) _)    +>   (e +> Term);
Sub x   y            +>   (x +> Expr) '-' (y +> Term);
e                    +>   (e +> Term);

Adaptive:
  [f| \_ v -> case v of
                Add _ _ -> True
                _       -> False  |]
  [f| \(ESub el _ er) (Add l r) ->  EAdd el " \n " er |] ;
```

Here, we name `Expr '+' Term` to be `EAdd` and `Expr '-' Term` to be `ESub` so we can use them in the adaptation functions.

Use an example to illustrate the Haskell datatypes generated for production rules are:

```
data Expr = EAdd Expr String Term
          | ESub Expr String Term
          | ...

data Factor = Factor0 (String,String)
            | ...
```

0. We generate a datatype for each nonterminal using the name of the nonterminal.

1. If a nonterminal have many production rules, then we use sum type in Haskell to capture each possibility. By default, the constructors for each case are the name of the nonterminal with numbers, for example, `Expr0`, `Expr1`, and so on ... unless the user specify a unique name, for example, here `EAdd` and `ESub`

2. The terminal is omitted in the datatype if it is unique. For example, keywords such as `+` and `let` are all unique. Terminals are not unique if it is a collection of values, such as `Numeric`, `Name`, and `String`.

3. We use a `String` field to hold the layouts after a terminal. So if the value of a terminal is unique, you can see there is a `String` field in the datatypes for holding layouts only. If the value of a terminal is not unique, you will see `(String,String)` in the datatype. The first component of the tuple represents the value in String type. The second component represents the layouts after the value. We use String to represent any value to make sure there is no information loss (such as the several initial zeros in 0001).

4. Each datatype additionally has a `Null` constructor, you can use it to represent a hole with this type. We need it as a default value when converting AST to CST from scratch.

5. The datatype generated for Kleene* part also follows the above criteria, in addition it becomes a right dense 2-tuple. E.g. we generate `( (String,String) , (Expr , (String,String)))` for `{Numeric Expr Name}+`

6. Known all above, now you can control the behaviour when CST and AST mismatches. For instance, you can control the layouts to be generated for terminals in every production rules using the **Adaptive** feature.

(Add more details later)

#Guidance (disclaimers) for writing production rules#

BiYacc is for research purpose, and is designed to be simple, lightweight rather than full-fledged. Currently we simplifies the lexing procedure and make several contracts.

0. Only supports three primitive types: String, Name, and Numeric.
  1. String recognises a string. The definition for string is the same as mainstream programming languages such as C and Java. Escaped characters are supported.
  2. Name recognises a sequence of characters, numbers, and underscore which starts from a character. `Name -> [a-zA-Z][a-zA-Z0-9_]*`
  3. Numerics recognises integers and decimals: `Numerics -> [0-9]+{.[0-9]+}?`
  4. Define others using production rules, e.g. `Bool -> "True" | "False"`
    
0. Separators are fixed to whitespaces: `WS -> [ \t\v\r\n]`

0. More than one *separators* are required between two terminals, with the exception:  
`not (Alphat || Number || Underscore)` and `(Alpha || Number || Underscore)` (for example, `a>2`, `<ab2>`)
  
Without proper separators, the input can be ambiguous for the simpler lexer. 

Assume we have a production `P -> "int" Name '=' Exp` and the input is `inta=3`, the lexer cannot cleverly know that `"int"` is a keyword and `a` is a identifier. However, for `int a=3` it is kind of rational to recognise `a` as an identifier and `=` as a symbol under the condition that there is no keyword `a=` or `a=3`.

For another example, assume we have production rules `P -> Name '{' '}' Name` and `P -> Name "{}" Name`, and the input is `a{}b`, the lexer cannot decide whether the `{}` is a terminal `T "{}"` (keywords) or two terminals `T '{' and T'}'`


----
#What does BiYacc actually do?
Saying that BiYacc is for bidirectional parsing and reflective printing is wrong, in fact.
Parsing is to find a tree structure for a grammar in string representation (program text).
Printing is to re-produce a string representation from a tree structure.
So there is no transformation between two trees in either case, but only transformations between program text and trees.
For transformations between program text and its concrete syntax tree (CST), currently we ad hoc generate two programs and wish the two programs to be isomorphisms.
There is no guarantee, and even not necessary to make the two transformations bidirectional.

To be precise, BiYacc's main job is to synchronise two algebraic data structures, exactly the same as BiGUL does.
But why are parsing and synchronising confused?
This has much to do with the origin of the name of BiYacc --- Yacc.
Yacc is a parser generator which automatically build CSTs for users' given grammar, and in addition allow some semantic actions to be performed simultaneously.
So in practice, users can only get the result of their semantic actions instead of a CST.
This is usually a simplified version of CST --- an abstract syntax tree (AST), and in "worse situations" only an integer in examples shown in many tutorials.

Since it is hard to directly modify program text, tools usually make modifications to the tree representation of the program text and produce a new piece of program text.
Then we encounter a problem: for a programming language, the parser come with the compiler usually builds an AST instead of a concrete one.
Producing program text from such a tree will lose lots of important information.
So the tool had to build CSTs wasting additional effort and modify CSTs instead, which also makes algorithms complex and hard to be performed.
Alternatively, it would be easier for tools to design algorithms modifying ASTs and automatically get synchronised CSTs.
However, the mapping between CSTs and ASTs is usually not injective, which brings additional difficulties.

Then we have a point: BiYacc may do a good job on synchronising CSTs and ASTs by declaratively writing synchronising actions.
In addition, parsers and printers are freely generated all together.
In conclusion, using BiYacc to write front end of a compiler, make many other jobs easier or comes for free: resugaring, code refactoring, "language evolution", etc.

We should develop BiYacc and make it better for performing synchronisation between tree structures.
Potentially BiYacc brings insight for research in database represented by trees: in particular XML database.


-------------
So, interact parsing and printing with synchronising is just a good application ~

