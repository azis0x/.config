fn main() -> () {
    let name = "Test";

    passed(name);
}

#[test]
fn passed(arg: &str) -> () {
    println!("Hey buddy! {}", arg);
}
