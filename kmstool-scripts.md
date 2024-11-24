## keys
```bash
cargo run -- -c config.toml keys -h
cargo run -- -c config.toml keys gen-key -h
cargo run -- -c config.toml keys get-pub-key -h

cargo run -- -c config.toml keys gen-key -l "Slot Token 0/wfdc2/masterminter/1" -a "secp256k1" --persistent
cargo run -- -c config.toml keys gen-key -l "Slot Token 0/test/p256/1" -a "secp256r1" --persistent
cargo run -- -c config.toml keys gen-key -l "slot-0/tsstrio-0/ed25519/1" -a "ed25519" --persistent

cargo run -- -c config.toml keys get-pub-key -l "Slot Token 0/wfdc2/masterminter/7" -t "account" -a "secp256k1" -p "wf"
cargo run -- -c config.toml keys get-pub-key -l "Slot Token 0/test/p256/1" -t "account" -a "secp256r1" -p "wf"
cargo run -- -c config.toml keys get-pub-key -l "slot-0/tsstrio-0/ed25519/2" -t "consensus" -a "secp256r1"
cargo run -- -c config.toml keys get-pub-key -l "slot-0/tsstrio-0/ed25519/3" -t "consensus" -a "ed25519"
```

## Cross compile for linux targets on MacOs
### gnu
```shell
rustup target add x86_64-unknown-linux-gnu
brew install SergioBenitez/osxct/x86_64-unknown-linux-gnu
# edit ~/.cargo/config.toml by adding
[target.x86_64-unknown-linux-gnu]
linker = "x86_64-unknown-linux-gnu-gcc"

TARGET_CC=x86_64-unknown-linux-gnu cargo build --release --features=p11hsm --target x86_64-unknown-linux-gnu --target-dir ./target-gnu
#TARGET_CC=x86_64-unknown-linux-gnu cargo build --release --features=p11hsm --target x86_64-unknown-linux-gnu --target-dir ./target-test-gnu

```