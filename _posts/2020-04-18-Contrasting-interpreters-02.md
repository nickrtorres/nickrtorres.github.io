---
layout: post
title: ! 'Contrasting interpreters: notes on porting jlox to Rust 02'
---
In a [previous post][blog-prev] I talked about using Generics instead of OOP
for [rlox's][rlox-gh] `Expr` representation. This did not work. Instead, I used
a sum type:
```rust
pub enum Expr<'a> {
    Binary(Box<Expr<'a>>, &'a Token, Box<Expr<'a>>),
    Grouping(Box<Expr<'a>>),
    Literal(Object),
    Unary(&'a Token, Box<Expr<'a>>),
}

```

There are a lot of `Box's` involved, which likely means this doesn't perform
well. However, for this first past at least, I'm not going to worry about it
too much.

[blog-prev]: https://blog.nickrtorres.com/2020/04/14/Contrasting-interpreters-notes-on-porting-jlox-to-Rust-01.html
[rlox-gh]: https://github.com/nickrtorres/rlox
