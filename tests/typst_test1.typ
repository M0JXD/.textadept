// Testing Typst document

// Set rules and variable usage:
#set page(width: 10cm, height: auto)
#set heading(numbering: "1.")
#let variable = [_\# syntax_]

// If/else clauses
#if 1 < 2 {
    variable
} else if 3 < 2 [
    This is not shown.
    *Not even this bit in bold*
] else {
    let newvar = 10
    newvar * 2
} <label>

// A comment is always of this form no matter the "mode"

/* Multiline style comments
are also available */

= Top Level Heading

Raw text for Python below:
I have a string "asdf".

```python
def func()
    print("Hello!")
```

== Second Level Heading
A link is like so: https://typst.app/

Typst has *strong* and _emphasis_. else if it does not
A paragraph may use #variable to access a code mode variable in a sentence.

Lists can start with + or - depending on if they're numbered or bulleted:

- Bullet Item 1
- Bullet Item 2

+ Numbered Item 1
+ Numbered Item 2

Example inline mathematics look like $F_n = F_n(n-1) + pi + F_(n-2)$.
Mathematics that are not inline occur like so:

$ pi F_n = round(1 / sqrt(5) phi.alt^n), quad phi.alt = (1 + sqrt(5)) / 2 $

// Code mode is accessed via '#' and continues until an expression end
#let count = 8
#let nums = range(1, count + 1)
#let fib(n) = (
    if n <= 2 { 1 } else { fib(n - 1) + fib(n - 2) }
)

#(2 + 1)

#for c in "ABC" [
    #c is a letter.
]

#let n = 2
#while n < 10 {
    n = (n * 2) - 1
    (n,)
}



// Markup can be passed as content into code mode via []
#link("https://typst.app")[
== Linked Subheading
]

// Longer expressions can be like so
#{
    let a = 1
    let b = 2
    // Sadly sometimes comments in expressions are also caputured.
    (a, b) = (b, a)
    [a = #a, b = #b]
    for c in "STR" {

    }

    if 2 < 3 {

    }

    while false {
        variable
    }
}

==== Random Heading

#align(center, table(
    columns: count,
    ..nums.map(n => $F_#n$),
    ..nums.map(n => str(fib(n)))
))

== A new Heading

#align(center + bottom)[
    *Glaciers form an important part of the earth's climate system.*
]

My new lexer can sometimes incorrectly highlight keywords, e.g.

The protagonist (for whom in their [or so they thought] dream) discovered their true purpose.
