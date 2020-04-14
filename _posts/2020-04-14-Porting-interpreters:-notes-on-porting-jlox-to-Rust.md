## Abstraction, object-oriented programming, and traits

[Crafting Interpreters][ci] is really good. I've been working through it in Rust.
Below are some notes from my campaign:

Consider jlox's [Expr implementation][jlox-expr]:
```java
abstract class Expr {
    static class Binary {
        Binary(Expr left, Token operator, Expr right) {
            this.left = left;
            this.operator = operator;
            this.right = right;
        }

        final Expr left;
        final Token operator;
        final Expr right;
    }

    // ...
}
```

Implementing this in Rust (with static polymorphism) might look like this:
```rust
struct Binary<T, U> {
    left: T,
    operator: Token,
    right: U,
}

impl<T, U> for Binary<T, U> {
    pub fn new(left: T, operator: Token, right: operator) -> Self {
        Binary {
            left,
            operator,
            right,
        }
    }
}
```

This differs from jlox's implementation in a number of ways, notably: it is
generic over any type (T, U) for `left` and `right`. Since Rust allows
[bounds][doc-bounds] on generics, T and U can easily be restricted to conform to
an interface of our choosing later. In fact, trait bounds are similar to how
jlox gets around this problem in Java. To avoid having to muck with the
internals of each `Expr` specialization, [jlox uses the visitor
pattern][jlox-visitor]; allowing an arbitrary number of new methods to be
implemented for each `Expr` implementation without having to muck with the
implementation details of each specialization.

---
[ci](http://www.craftinginterpreters.com/)
[jlox-visitor](https://github.com/munificent/craftinginterpreters/blob/3dc7cc2030b26dc747d339cde4aa31dad1189b7b/java/com/craftinginterpreters/lox/Expr.java#L7)
[jlox-expr](https://github.com/munificent/craftinginterpreters/blob/3dc7cc2030b26dc747d339cde4aa31dad1189b7b/java/com/craftinginterpreters/lox/Expr.java#L40)
[doc-bounds](https://doc.rust-lang.org/stable/rust-by-example/generics/bounds.html)
