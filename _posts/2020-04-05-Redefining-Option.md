## Redefining option

---
Sum types are very tempting. I often find myself wanting to define a new type because they're cool!
However, there are numerous cases where a custom enum can elide use of built-ins.

Consider a program that can either read from a file or standard in.
Based on the previous sentence alone, it sounds like we have defined a new type with two variants: `File` and `Stdin`:
```rust
enum FileType<'a> {
    File(&'a str),
    Stdin,
}
```

Using our new enum we can write a function that opens a `FileType` and prints its lines.
```rust
fn print(file: FileType) -> io::Result<()> {
    let stdin = stdin();
    match file {
        FileType::File(f) => {
            let file = File::open(f)?;
            print_lines(&mut BufReader::new(file))
        }
        FileType::Stdin => print_lines(&mut stdin.lock()),
    }
}

fn print_lines<T: BufRead>(buf: T) -> io::Result<()> {
    for line in buf.lines() {
        let line = line?;
        println!("{}", line);
    }

    Ok(())
}
```

This works ok, but it forces us to explicitly use case analysis on our `FileType` enum.
Let's try to rescope this problem with `Option<&'a str>`
```rust
fn print(file: Option<&str>) -> io::Result<()> {
    let stdin = stdin();
    file.map_or_else(
        || print_lines(&mut stdin.lock()),
        |f| File::open(f).and_then(|file| print_lines(&mut BufReader::new(file))),
    )
}

fn print_lines<T: BufRead>(buf: T) -> io::Result<()> {
    for line in buf.lines() {
        let line = line?;
        println!("{}", line);
    }

    Ok(())
}
```
Using `Option<&'a str>` gets us all of the combinators defined on `Option<T>` to write the same function concisely.

So is this really better? I don't know. It might be.
