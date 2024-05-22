# scripts for wallet-svc
## cli
```shell
# in root
alias ws=./target/debug/wallet_svc
ws -h
ws -c ./wallet-svc/wallet_svc.toml echo
ws -c ./wallet-svc/wallet_svc.toml async-echo
 
cargo run -p wallet_svc -- -h 
cargo run -p wallet_svc -- -c ./wallet-svc/wallet_svc.toml echo
cargo run -p wallet_svc -- -c ./wallet-svc/wallet_svc.toml async-echo
# or 
# in the following, all commands are run inside wallet-svc folder
cd wallet-svc
alias ws=../target/debug/wallet_svc
ws -h
cargo run -- -h
cargo run -- -c wallet_svc.toml -h

## cli - echo
ws -c wallet_svc.toml echo
ws -c wallet_svc.toml async-echo

cargo run -- -c wallet_svc.toml echo 
cargo run -- -c wallet_svc.toml async-echo 

## cli - admin
cargo run -- -c wallet_svc-owner.toml admin -h
### store code
cargo run -- -c wallet_svc-owner.toml admin store-code -h
cargo run -- -c wallet_svc-owner.toml admin store-code -w ../target/wasm32-unknown-unknown/release/.wasm
### instantiate ft contract - deprecated, use instantiate-contract
cargo run -- -c wallet_svc-owner.toml admin instantiate-ft-contract -h
cargo run -- -c wallet_svc-owner.toml admin instantiate-ft-contract -i 3 -l "tokenfactory" -t
### instantiate contract
cargo run -- -c wallet_svc-owner.toml admin instantiate-contract -h
#### ft
cargo run -- -c wallet_svc-owner.toml admin instantiate-contract -i 3 -l "fiat-tokenfactory" -m "{ \"is_tf\": false }"
#### aurum
cargo run -- -c wallet_svc-owner.toml admin instantiate-contract -i 5 -l "aurum" -m "{ \"tf_address\": \"wf1k8re7jwz6rnnwrktnejdwkwnncte7ek7gt29gvnl3sdrg9mtnqksnq9ru7\" }"

## cli - diag
ws -c wallet_svc.toml diag -h
cargo run -- -c wallet_svc.toml diag -h
### p11context
ws -c wallet_svc.toml diag p11context
cargo run -- -c wallet_svc.toml diag p11context
### slotcount
ws -c wallet_svc.toml diag slotcount
cargo run -- -c wallet_svc.toml diag slotcount
### slotinfo
ws -c wallet_svc.toml diag slotinfo
cargo run -- -c wallet_svc.toml diag slotinfo
### login
ws -c wallet_svc.toml diag login
cargo run -- -c wallet_svc.toml diag login

## cli - keys
ws -c wallet_svc.toml keys -h
cargo run -- -c wallet_svc.toml keys -h
### get pub key info from key lable
ws -c wallet_svc.toml keys get-pub-key -l "Slot Token 0/wfdc2/masterminter/1"
cargo run -- -c wallet_svc.toml keys get-pub-key -l "Slot Token 0/wfdc2/masterminter/1"
### generate a new key
ws -c wallet_svc.toml keys gen-key -l "Slot Token 0/wfdc2/masterminter/1" -t "Account" -a "Secp256k1" --persistent
cargo run -- -c wallet_svc.toml keys gen-key -l "Slot Token 0/wfdc2/masterminter/1" -t "Account" -a "Secp256k1" --persistent
ws -c wallet_svc.toml keys gen-key -l "Slot Token 0/wfdc2/user1/1" -t "Account" -a "Secp256k1" --persistent
cargo run -- -c wallet_svc.toml keys gen-key -l "Slot Token 0/wfdc2/user1/1" -t "Account" -a "Secp256k1" --persistent

## cli - query
ws -c wallet_svc.toml query -h
cargo run -- -c wallet_svc.toml query -h
### bank balance
ws -c wallet_svc.toml query get-bank-balance -h
cargo run -- -c wallet_svc.toml query get-bank-balance -h
ws -c wallet_svc-usa.toml query get-bank-balance -d "uwfusd"
cargo run -- -c wallet_svc-usa.toml query get-bank-balance -d "uwfusd"
ws -c wallet_svc-can.toml query get-bank-balance -d "uwfusd"
ws -c wallet_svc-usa.toml query get-bank-balance -a "wf1vnzcv55fxt2n9v3dam9dsjf7wrxww4mxj8gzvq" -d "uwfusd"
### owner
ws -c wallet_svc.toml query get-owner -h
cargo run -- -c wallet_svc.toml query get-owner -h
ws -c wallet_svc.toml query get-owner
cargo run -- -c wallet_svc.toml query get-owner
### master minter
ws -c wallet_svc.toml query get-master-minter -h
cargo run -- -c wallet_svc.toml query get-master-minter -h
ws -c wallet_svc.toml query get-master-minter
cargo run -- -c wallet_svc.toml query get-master-minter
### minter controller
ws -c wallet_svc.toml query get-minter-controller -h
cargo run -- -c wallet_svc.toml query get-minter-controller -h
ws -c wallet_svc.toml query get-minter-controller -a "wf1wn5nkfw57kpmlxhgskv56275mflmapxkr4tc8m"
cargo run -- -c wallet_svc.toml query get-minter-controller -a "wf1wn5nkfw57kpmlxhgskv56275mflmapxkr4tc8m"
### minting denom
ws -c wallet_svc.toml query get-minting-denom -h
cargo run -- -c wallet_svc.toml query get-minting-denom -h
ws -c wallet_svc.toml query get-minting-denom
cargo run -- -c wallet_svc.toml query get-minting-denom
### minter 
ws -c wallet_svc.toml query get-minter -h
cargo run -- -c wallet_svc.toml query get-minter -h
ws -c wallet_svc.toml query get-minter -a "wf1l4zym6tk6wnwe7p7m3yjr6zvsnljg0ud4drap6"
cargo run -- -c wallet_svc.toml query get-minter -a "wf1l4zym6tk6wnwe7p7m3yjr6zvsnljg0ud4drap6"
### blacklister 
ws -c wallet_svc.toml query get-blacklister -h
cargo run -- -c wallet_svc.toml query get-blacklister -h
ws -c wallet_svc.toml query get-blacklister
cargo run -- -c wallet_svc.toml query get-blacklister
### pauser 
ws -c wallet_svc.toml query get-pauser -h
cargo run -- -c wallet_svc.toml query get-pauser -h
ws -c wallet_svc.toml query get-pauser
cargo run -- -c wallet_svc.toml query get-pauser
### query tx
ws -c wallet_svc.toml query query-tx -h
cargo run -- -c wallet_svc.toml query query-tx -h
ws -c wallet_svc.toml query query-tx --hash "427FE1E2B8D25B580F2B28382E9F0D828A146B2D369D66605A165DBAA3E1A878"
cargo run -- -c wallet_svc.toml query query-tx --hash "427FE1E2B8D25B580F2B28382E9F0D828A146B2D369D66605A165DBAA3E1A878"
### tokenfactory config
ws -c wallet_svc.toml query get-tf-config -h
cargo run -- -c wallet_svc.toml query get-tf-config -h
ws -c wallet_svc.toml query get-tf-config
cargo run -- -c wallet_svc.toml query get-tf-config
### aurum config
ws -c wallet_svc.toml query get-aurum-config -h
cargo run -- -c wallet_svc.toml query get-aurum-config -h
ws -c wallet_svc.toml query get-aurum-config
cargo run -- -c wallet_svc.toml query get-aurum-config
### member
ws -c wallet_svc-minter.toml query get-member -h
cargo run -- -c wallet_svc-minter.toml query get-member -h
ws -c wallet_svc-minter.toml query get-member --id "CN=PartyC, OU=, O=PartyC, L=Dallas, C=US"
cargo run -- -c wallet_svc-minter.toml query get-member --id "CN=PartyC, OU=, O=PartyC, L=Dallas, C=US"

## cli - tx
ws -c wallet_svc.toml tx -h
cargo run -- -c wallet_svc.toml tx -h
### bank send
ws -c wallet_svc.toml tx bank-send -h
cargo run -- -c wallet_svc.toml tx bank-send -h
ws -c wallet_svc-usa.toml tx bank-send --to_addr "wf1qcnvhjpuue9a8kdhzk9x0mzy7u844pzvyxwzz7" -v 10 -d "uwfusd"
cargo run -- -c wallet_svc-usa.toml tx bank-send --to_addr "wf1qcnvhjpuue9a8kdhzk9x0mzy7u844pzvyxwzz7" -v 10 -d "uwfusd"
ws -c wallet_svc-can.toml tx bank-send --to_addr "wf1vnzcv55fxt2n9v3dam9dsjf7wrxww4mxj8gzvq" -v 10 -d "uwfusd"
cargo run -- -c wallet_svc-can.toml tx bank-send --to_addr "wf1vnzcv55fxt2n9v3dam9dsjf7wrxww4mxj8gzvq" -v 10 -d "uwfusd"
### update master minter
ws -c wallet_svc-owner.toml tx update-master-minter -h
cargo run -- -c wallet_svc-owner.toml tx update-master-minter -h
ws -c wallet_svc-owner.toml tx update-master-minter -a "wf1x5u0nzy2ygxanyrvtfp0tsvdyqzshh36q492w5"
cargo run -- -c wallet_svc-owner.toml tx update-master-minter -a "wf1x5u0nzy2ygxanyrvtfp0tsvdyqzshh36q492w5"
### configure minter controller
ws -c wallet_svc-masterminter.toml tx configure-minter-controller -h
cargo run -- -c wallet_svc-masterminter.toml tx configure-minter-controller -h
ws -c wallet_svc-masterminter.toml tx configure-minter-controller -c "wf1wn5nkfw57kpmlxhgskv56275mflmapxkr4tc8m" -m "wf1l4zym6tk6wnwe7p7m3yjr6zvsnljg0ud4drap6"
cargo run -- -c wallet_svc-masterminter.toml tx configure-minter-controller -c "wf1wn5nkfw57kpmlxhgskv56275mflmapxkr4tc8m" -m "wf1l4zym6tk6wnwe7p7m3yjr6zvsnljg0ud4drap6"
### configure minter
ws -c wallet_svc-mintercontroller.toml tx configure-minter -h
cargo run -- -c wallet_svc-mintercontroller.toml tx configure-minter -h
ws -c wallet_svc-mintercontroller.toml tx configure-minter -a "wf1l4zym6tk6wnwe7p7m3yjr6zvsnljg0ud4drap6" -d "uwfusd" -v 1000000
cargo run -- -c wallet_svc-mintercontroller.toml tx configure-minter -a "wf1l4zym6tk6wnwe7p7m3yjr6zvsnljg0ud4drap6" -d "uwfusd" -v 1000000
### update blacklister
ws -c wallet_svc-owner.toml tx update-blacklister -h
cargo run -- -c wallet_svc-owner.toml tx update-blacklister -h
ws -c wallet_svc-owner.toml tx update-blacklister -a "wf1fz3mzr4j8l9h8xsmx7lgxgncq6ah92w75wpe6p"
cargo run -- -c wallet_svc-owner.toml tx update-blacklister -a "wf1fz3mzr4j8l9h8xsmx7lgxgncq6ah92w75wpe6p"
### update pauser
ws -c wallet_svc-owner.toml tx update-pauser -h
cargo run -- -c wallet_svc-owner.toml tx update-pauser -h
ws -c wallet_svc-owner.toml tx update-pauser -a "wf1pxy6ntphdt6s0nnv4qd9frhv48sqzjs768kmzs"
cargo run -- -c wallet_svc-owner.toml tx update-pauser -a "wf1pxy6ntphdt6s0nnv4qd9frhv48sqzjs768kmzs"
### update member
ws -c wallet_svc-minter.toml tx update-member -h
cargo run -- -c wallet_svc-minter.toml tx update-member -h
#### change first letter of pk from 0 to x
ws -c wallet_svc-minter.toml tx update-member --id "CN=PartyA, OU=, O=PartyA, L=Dallas, C=US" --addr "wf1vnzcv55fxt2n9v3dam9dsjf7wrxww4mxj8gzvq" --pk "x25f99f611d4ef3dbc900cbfd9e6bf7d97d4fe6484559322240852c942ae706fcc" --grpc "localhost:8091"
cargo run -- -c wallet_svc-minter.toml tx update-member --id "CN=PartyA, OU=, O=PartyA, L=Dallas, C=US" --addr "wf1vnzcv55fxt2n9v3dam9dsjf7wrxww4mxj8gzvq" --pk "x25f99f611d4ef3dbc900cbfd9e6bf7d97d4fe6484559322240852c942ae706fcc" --grpc "localhost:8091"
#### change back to the correct pk
ws -c wallet_svc-minter.toml tx update-member --id "CN=PartyA, OU=, O=PartyA, L=Dallas, C=US" --addr "wf1vnzcv55fxt2n9v3dam9dsjf7wrxww4mxj8gzvq" --pk "025f99f611d4ef3dbc900cbfd9e6bf7d97d4fe6484559322240852c942ae706fcc" --grpc "localhost:8091"

ws -c wallet_svc-minter.toml query get-member --id "CN=PartyA, OU=, O=PartyA, L=Dallas, C=US" 
```
## grpc server
```shell
### owner
ws -c ./wallet_svc-owner.toml start
cargo run -- -c ./wallet_svc-owner.toml start
### masterminter
ws -c ./wallet_svc-masterminter.toml start
cargo run -- -c ./wallet_svc-masterminter.toml start
### mintercontroller
ws -c ./wallet_svc-mintercontroller.toml start
cargo run -- -c ./wallet_svc-mintercontroller.toml start
### minter
ws -c ./wallet_svc-minter.toml start
cargo run -- -c ./wallet_svc-minter.toml start
### usa
ws -c ./wallet_svc-usa.toml start
cargo run -- -c ./wallet_svc-usa.toml start
### can
ws -c ./wallet_svc-can.toml start
cargo run -- -c ./wallet_svc-can.toml start
```
## build
```shell
# in root folder
cargo build -p wallet_svc --release
# in wallet-svc folder
cd wallet-svc
cargo build --release
```

## Cross compile for linux targets on MacOs
Details are documented at https://github.com/wfblockchain/tmkms/blob/main/Developer.md
* NOTE: For gnu, the simple way that works for tmkms does not work here - need more env vars. see below.
### gnu
```shell
# on top of previously installed SergioBenitez/osxct/x86_64-unknown-linux-gnu which was 7.2.0,
#   install the messense version of x86_64-unknown-linux-gnu which is 13.2.0.
#   this may not be necessary but works. https://github.com/messense/homebrew-macos-cross-toolchains
brew install messense/macos-cross-toolchains/x86_64-unknown-linux-gnu
# need these env variables
export OPENSSL_DIR=/opt/homebrew/Cellar/openssl@3/3.2.0_1
export CC_x86_64_unknown_linux_gnu=x86_64-linux-gnu-gcc
export CXX_x86_64_unknown_linux_gnu=x86_64-linux-gnu-g++
export AR_x86_64_unknown_linux_gnu=x86_64-linux-gnu-ar
# note: it is mentioned by messense to export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER=x86_64-linux-gnu-gcc
#   but we have similar in .cargo/config.toml.

# in root folder
TARGET_CC=x86_64-unknown-linux-gnu cargo build -p wallet_svc --release --target x86_64-unknown-linux-gnu --target-dir ./target-gnu
# in wallet-svc folder
cd wallet-svc
TARGET_CC=x86_64-unknown-linux-gnu cargo build --release --target x86_64-unknown-linux-gnu --target-dir ../target-gnu
```
## musl
```shell
# in wallet-svc folder
cd wallet-svc
TARGET_CC=x86_64-linux-musl-gcc cargo build --release --target x86_64-unknown-linux-musl --target-dir ../target-musl

```

