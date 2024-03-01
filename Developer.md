# Developer notes
This repo is intended to be a private fork of https://github.com/iqlusioninc/tmkms.  
We need to be able to fetch future changes in the original repo via upstream.
## upstream
```bash
git remote add upstream https://github.com/iqlusioninc/tmkms.git
git remote set-url --push upstream DISABLE
git remote -v
# should show something like this:
origin  https://github.com/wfblockchain/tmkms.git (fetch)
origin  https://github.com/wfblockchain/tmkms.git (push)
upstream        https://github.com/iqlusioninc/tmkms.git (fetch)
upstream        DISABLE (push)

# We can pull changes from the original repo like this:
git fetch upstream
# TBD: git rebase upstream/main
# resolve any conflicts
# Review the upsteam PRs and merge appropriately or manually update the code
```

# ref: https://gist.github.com/0xjac/85097472043b697ab57ba1b1c7530274
# ref: https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository
# ref: https://git-scm.com/docs/git-clone#Documentation/git-clone.txt---mirror
```
## Major files that are affected
- [Cargo.toml](Cargo.toml)
- [Cargo.lock](Cargo.lock)
- [lib.rs](src/lib.rs)
- [config_builder.rs](src/commands/init/config_builder.rs)
- [error.rs](src/error.rs)
- [config provider.rs](src/config/provider.rs)
- [config p11hsm.rs](src/config/provider/p11hsm.rs)
- [keyring.rs](src/keyring.rs)
- [keyring providers.rs](src/keyring/providers.rs)
- [keyring p11hsm.rs](src/keyring/providers/p11hsm.rs)
- [softsign.rs](src/keyring/providers/softsign.rs) # fix a bug
- [template p11hsm.toml](src/commands/init/templates/keyring/p11hsm.toml)
- [test pkcs11.rs](tests/pkcs11.rs)
- 

## Build tmkms binary
```shell
rustup toolchain list
# currently default using 1.75
# use 1.69 rust to see if it works
rustup default 1.69
# no, requries 1.72 because clap_builder v4.4.18 requires rustc 1.70.0 or newer
rustup default 1.75
```
### features=softsign chain+validator
```shell
# since we are using softsign and later p11hsm, we may not need libusb or pkg-config as mentioned in README.md.
# so build as is
# in ~/Project/rust/cosmos/tmkms,
cargo build --release --features=softsign
# binary tmkms is created in ./target/release
# wfchain-1 is not recognized:  ./target/release/tmkms init -n wfchain-1 ./.tmkms
./target/release/tmkms init ./.tmkms
# create a secret key for wfchain-2. wfchain-1 uses kms-identity.key which is created by init
./target/release/tmkms softsign keygen ./.tmkms/secrets/secret_connection_key

./target/release/tmkms softsign keygen -t consensus ./.tmkms/secrets/test_consensus_key

# copy the existing validator priv key(s)
cp ~/.chains/wfchain-1/config/priv_validator_key.json ./.tmkms/secrets/priv_validator_key.json
cp ~/.chains/wfchain-2/config/priv_validator_key.json ./.tmkms/secrets/priv_validator_key_2.json
# import priv_validator_key to tmkms
./target/release/tmkms softsign import ./.tmkms/secrets/priv_validator_key.json ./.tmkms/secrets/priv_validator_key
./target/release/tmkms softsign import ./.tmkms/secrets/priv_validator_key_2.json ./.tmkms/secrets/priv_validator_key_2

# edit ~/.chains/wfchain-1/config/config.toml
# comment out priv_validator_key_file, priv_validator_state_file
# make this change: priv_validator_laddr = "tcp://0.0.0.0:36850"

# edit ~/.chains/wfchain-2/config/config.toml
# comment out priv_validator_key_file, priv_validator_state_file
# make this change: priv_validator_laddr = "tcp://0.0.0.0:36950"
# edit ./.tmkms/tmkms.toml correspondingly

# start tmkms
./target/release/tmkms start -c ./.tmkms/tmkms.toml
```
### features=softsign, validator-only
```shell
cargo build --release --features=softsign --target-dir ./target-softsign-val
# binary tmkms is created in ./target-softsign-val/release

./target-softsign-val/release/tmkms init ./.tmkms-softsign-val
# edit ./.tmkms-softsign-val/tmkms.toml

# start tmkms
./target-softsign-val/release/tmkms start -c ./.tmkms-softsign-val/tmkms.toml
```
### features=softsign, validator-only, 1 chain with many validators
```shell
cargo build --release --features=softsign --target-dir ./target-softsign-val
# binary tmkms is created in ./target-softsign-val/release

./target-softsign-val/release/tmkms init ./.tmkms-softsign-val-all
# edit ./.tmkms-softsign-val/tmkms.toml

# generate secret_connection_key for each validator
./target-softsign-val/release/tmkms softsign keygen ./.tmkms-softsign-val-all/secrets/secret_connection_key_1
./target-softsign-val/release/tmkms softsign keygen ./.tmkms-softsign-val-all/secrets/secret_connection_key_2
./target-softsign-val/release/tmkms softsign keygen ./.tmkms-softsign-val-all/secrets/secret_connection_key_3
./target-softsign-val/release/tmkms softsign keygen ./.tmkms-softsign-val-all/secrets/secret_connection_key_4

./target-softsign-val/release/tmkms softsign keygen ./.tmkms-softsign-val-all/secrets/secret_connection_key_5
./target-softsign-val/release/tmkms softsign keygen ./.tmkms-softsign-val-all/secrets/secret_connection_key_6


# note: priv_validator_key_n.json were copied from /Users/johnz/Project/go/cosmos/ignite/wfchains/wfchain/testnet/priv_validator_keys/
./target-softsign-val/release/tmkms softsign import ./.tmkms-softsign-val-all/secrets/priv_validator_key_1.json ./.tmkms-softsign-val-all/secrets/priv_validator_key_1
./target-softsign-val/release/tmkms softsign import ./.tmkms-softsign-val-all/secrets/priv_validator_key_2.json ./.tmkms-softsign-val-all/secrets/priv_validator_key_2
./target-softsign-val/release/tmkms softsign import ./.tmkms-softsign-val-all/secrets/priv_validator_key_3.json ./.tmkms-softsign-val-all/secrets/priv_validator_key_3
./target-softsign-val/release/tmkms softsign import ./.tmkms-softsign-val-all/secrets/priv_validator_key_4.json ./.tmkms-softsign-val-all/secrets/priv_validator_key_4

./target-softsign-val/release/tmkms softsign import ./.tmkms-softsign-val-all/secrets/priv_validator_key_5.json ./.tmkms-softsign-val-all/secrets/priv_validator_key_5
./target-softsign-val/release/tmkms softsign import ./.tmkms-softsign-val-all/secrets/priv_validator_key_6.json ./.tmkms-softsign-val-all/secrets/priv_validator_key_6

# start tmkms
./target-softsign-val/release/tmkms start -c ./.tmkms-softsign-val-all/tmkms.toml
```

### features=p11hsm, chain+validator
```shell
cargo build --release --features=p11hsm --target-dir ./target-p11
# binary tmkms is created in ./target-p11/release

./target-p11/release/tmkms init ./.tmkms-p11
# edit ./.tmkms-p11/tmkms.toml per README.p11hsm.md

# start tmkms
./target-p11/release/tmkms start -c ./.tmkms-p11/tmkms.toml
```

### features=p11hsm, validator-only, each chan has one validator
```shell
cargo build --release --features=p11hsm --target-dir ./target-p11-val
# binary tmkms is created in ./target-p11-val/release

./target-p11-val/release/tmkms init ./.tmkms-p11-val
# edit ./.tmkms-p11-val/tmkms.toml per README.p11hsm.md

# start tmkms
./target-p11-val/release/tmkms start -c ./.tmkms-p11-val/tmkms.toml
```

### features=p11hsm, validator-only, 1 chain with many validators
```shell
cargo build --release --features=p11hsm --target-dir ./target-p11-val
# binary tmkms is created in ./target-p11-val/release

./target-p11-val/release/tmkms init ./.tmkms-p11-val-all
# edit ./.tmkms-p11-val-all/tmkms.toml per README.p11hsm.md

# start tmkms
./target-p11-val/release/tmkms start -c ./.tmkms-p11-val-all/tmkms.toml
```

### features=p11hsm, validator-only, 1 chain with many validators and cli
```shell
cargo build --release --features=p11hsm --target-dir ./target-p11-val-cli
# binary tmkms is created in ./target-p11-val-cli/release

#./target-p11-val-cli/release/tmkms init ./.tmkms-p11-val-all
# edit ./.tmkms-p11-val-all/tmkms.toml per README.p11hsm.md

# p11hsm cli
./target-p11-val-cli/release/tmkms p11hsm --help

# p11hsm diag cli
./target-p11-val-cli/release/tmkms p11hsm diag --help
./target-p11-val-cli/release/tmkms p11hsm diag p11context -c ./.tmkms-p11-val-all/tmkms.toml
./target-p11-val-cli/release/tmkms p11hsm diag slotcount -c ./.tmkms-p11-val-all/tmkms.toml
./target-p11-val-cli/release/tmkms p11hsm diag slotinfo -c ./.tmkms-p11-val-all/tmkms.toml
./target-p11-val-cli/release/tmkms p11hsm diag login -c ./.tmkms-p11-val-all/tmkms.toml

# p11hsm keys cli
./target-p11-val-cli/release/tmkms p11hsm keys --help
./target-p11-val-cli/release/tmkms p11hsm keys pubkey --help
./target-p11-val-cli/release/tmkms p11hsm keys generate --help
./target-p11-val-cli/release/tmkms p11hsm keys sign-verify --help

./target-p11-val-cli/release/tmkms p11hsm keys pubkey -c ./.tmkms-p11-val-all/tmkms.toml -l "Slot Token 0/tmkms/ed25519-1/1"
./target-p11-val-cli/release/tmkms p11hsm keys generate -c ./.tmkms-p11-val-all/tmkms.toml -l "Slot Token 0/tmkms/ed25519-1/1"
./target-p11-val-cli/release/tmkms p11hsm keys sign-verify -c ./.tmkms-p11-val-all/tmkms.toml -l "Slot Token 0/tmkms/ed25519-1/1"
./target-p11-val-cli/release/tmkms p11hsm keys sign-verify -c ./.tmkms-p11-val-all/tmkms.toml -l "Slot Token 0/tmkms/ed25519-1/1" -m "hello world"

# start tmkms
./target-p11-val-cli/release/tmkms start -c ./.tmkms-p11-val-all/tmkms.toml
```

## Cross compile for linux targets on MacOs
ref: https://betterprogramming.pub/cross-compiling-rust-from-mac-to-linux-7fad5a454ab1
### musl
```shell
rustup target add x86_64-unknown-linux-musl
brew install FiloSottile/musl-cross/musl-cross
# edit ~/.cargo/config.toml by adding
[target.x86_64-unknown-linux-musl]
linker = "x86_64-linux-musl-gcc"

TARGET_CC=x86_64-linux-musl-gcc cargo build --release --features=p11hsm --target x86_64-unknown-linux-musl --target-dir ./target-p11-val-cli-musl

```
### gnu
```shell
rustup target add x86_64-unknown-linux-gnu
brew install SergioBenitez/osxct/x86_64-unknown-linux-gnu
# edit ~/.cargo/config.toml by adding
[target.x86_64-unknown-linux-gnu]
linker = "x86_64-unknown-linux-gnu-gcc"

TARGET_CC=x86_64-unknown-linux-gnu cargo build --release --features=p11hsm --target x86_64-unknown-linux-gnu --target-dir ./target-p11-val-cli-gnu

```


## Open Issues
- Thread safety. The code may not be thread safe.
PCSK11 Session implements only Send and intentionally prohibits implementing Sync for sharing across threads. They may have their reason for that.  
SDK which has inner Session in it implements both Sync and Send. That is because Signer in KeyRing requires both to satisfy the GlobalRegistry which has an inner Rc of Registry which has KeyRing.  
The potential issue may be when a p11hsm provider supports multiple validators - the provider has a single SDK which is shared via Arc among those validators. Is that the reason why every block has one or more "signing operation failed: signature error" among those validators, even though that does not seem to affect the service functionality.