# TMKMS with PKCS11 HSM backend
The [orginal tmkms repo](https://github.com/iqlusioninc/tmkms) does not support PKCS11 HSM backend.
That is a major limitation for three reasons:
1. Enterprises have invested heavily in HSM for key management. But the original work only supports YubiHSM, Ledger and FortanixDSM and they are either not approved or not widely used in enterprises.
2. The latest offerings from major cloud HSM vendors have no support for EdDSA especially Ed25519 which is currently the only curve supported by the Tendermint validator consensus protocol. 
3. PKCS11 3.0 has added mechanism for EdDSA and Ed25519. And many HSM vendors have had firmware support for EdDSA and Ed25519 for quite some time and their PKCS11 libraries have also been upgraded to include EdDSA.
 
Our contribution is to add a new feature, `p11hsm`, to the original `tmkms` crate. The new feature is being tested with SoftHSM and FutureX HSM.

## Build with features=p11hsm
```shell
cargo build --release --features=p11hsm --target-dir ./target-p11
# binary tmkms is created in ./target-p11/release

./target-p11/release/tmkms init ./.tmkms-p11

```

## cli
```shell
# p11hsm cli
./target-p11/release/tmkms p11hsm --help

# p11hsm diag cli
./target-p11/release/tmkms p11hsm diag --help
./target-p11/release/tmkms p11hsm diag p11context -c ./.tmkms-p11-val-all/tmkms.toml
./target-p11/release/tmkms p11hsm diag slotcount -c ./.tmkms-p11-val-all/tmkms.toml
./target-p11/release/tmkms p11hsm diag slotinfo -c ./.tmkms-p11-val-all/tmkms.toml
./target-p11/release/tmkms p11hsm diag login -c ./.tmkms-p11-val-all/tmkms.toml

# p11hsm keys cli
./target-p11/release/tmkms p11hsm keys --help
./target-p11/release/tmkms p11hsm keys pubkey --help
./target-p11/release/tmkms p11hsm keys generate --help

./target-p11/release/tmkms p11hsm keys pubkey -c ./.tmkms-p11-val-all/tmkms.toml -l "Slot Token 0/tmkms/ed25519-1/1"
./target-p11/release/tmkms p11hsm keys generate -c ./.tmkms-p11-val-all/tmkms.toml -l "Slot Token 0/tmkms/ed25519-1/1"

```


## Example of tmkms.toml using p11hsm providers
```toml
# Tendermint KMS configuration file
### One chain with 4 validators

## Signing Provider Configuration

### PKCS11 HSM Provider Configuration
# env_cfg must be unique
# module must be unique
# val_ids must be unique
#### FX
[[providers.p11hsm]]
##env_module = "FXPKCS11_MODULE" # optional
module = "/Users/johnz/futurex/fxpkcs11-mac-arm-4.58-422d/libfxpkcs11.dylib"
env_cfg = "FXPKCS11_CFG"
cfg = "/Users/johnz/futurex/fxpkcs11-mac-arm-4.58-422d/fxpkcs11.cfg"
hsms = [
    # token_label must be unique
    # val_ids actually must be a single value
    { token_label = "Slot Token 0", user_pin = "safest", signing_keys = [ { val_ids = ["val-1"], key_type = "consensus", key_label = "Slot Token 0/tmkms/ed25519-1/1" }, ]},
    #    { token_label = "Slot Token 1", user_pin = "safest", signing_keys = [ { val_ids = ["val-2"], key_type = "consensus", key_label = "Slot Token 0/tmkms/ed25519-1/1" }, ]},
]

#### SoftHSM
[[providers.p11hsm]]
#env_module = "PKCS11_SOFTHSM2_MODULE" # optional
module = "/usr/local/lib/softhsm/libsofthsm2.so"
env_cfg = "SOFTHSM2_CONF"
cfg = "/etc/softhsm2.conf"
hsms = [
    # token_label must be unique
    # val_ids actually must be a single value
    #    { token_label = "Slot Token 0", user_pin = "5678", signing_keys = [ { val_ids = ["val-1"], key_type = "consensus", key_label = "Slot Token 0/tmkms/ed25519-1/1" },]},
    { token_label = "Slot Token 0", user_pin = "5678", signing_keys = [ { val_ids = ["val-2"], key_type = "consensus", key_label = "Slot Token 0/tmkms/ed25519-2/1" }, { val_ids = ["val-3"], key_type = "consensus", key_label = "Slot Token 0/tmkms/ed25519-3/1" }, { val_ids = ["val-4"], key_type = "consensus", key_label = "Slot Token 0/tmkms/ed25519-4/1" },]},
]

## Validator Configuration

[[validator]]
id = "val-1"
chain_id = "chain-9"
addr = "tcp://localhost:1111"
secret_key = "/Users/johnz/Project/rust/cosmos/tmkms/.tmkms-p11-val-all/secrets/kms-identity.key"
key_format = { type = "bech32", account_key_prefix = "wf", consensus_key_prefix = "wf" }
sign_extensions = false # Should vote extensions for this chain be signed? (default: false)
state_file = "/Users/johnz/Project/rust/cosmos/tmkms/.tmkms-p11-val-all/state/val-1-consensus.json"
protocol_version = "v0.34"
reconnect = true

[[validator]]
id = "val-2"
chain_id = "chain-9"
addr = "tcp://localhost:1112"
secret_key = "/Users/johnz/Project/rust/cosmos/tmkms/.tmkms-p11-val-all/secrets/kms-identity.key"
key_format = { type = "bech32", account_key_prefix = "wf", consensus_key_prefix = "wf" }
sign_extensions = false # Should vote extensions for this chain be signed? (default: false)
state_file = "/Users/johnz/Project/rust/cosmos/tmkms/.tmkms-p11-val-all/state/val-2-consensus.json"
protocol_version = "v0.34"
reconnect = true

[[validator]]
id = "val-3"
chain_id = "chain-9"
addr = "tcp://localhost:1113"
secret_key = "/Users/johnz/Project/rust/cosmos/tmkms/.tmkms-p11-val-all/secrets/kms-identity.key"
key_format = { type = "bech32", account_key_prefix = "wf", consensus_key_prefix = "wf" }
sign_extensions = false # Should vote extensions for this chain be signed? (default: false)
state_file = "/Users/johnz/Project/rust/cosmos/tmkms/.tmkms-p11-val-all/state/val-3-consensus.json"
protocol_version = "v0.34"
reconnect = true

[[validator]]
id = "val-4"
chain_id = "chain-9"
addr = "tcp://localhost:1114"
secret_key = "/Users/johnz/Project/rust/cosmos/tmkms/.tmkms-p11-val-all/secrets/kms-identity.key"
key_format = { type = "bech32", account_key_prefix = "wf", consensus_key_prefix = "wf" }
sign_extensions = false # Should vote extensions for this chain be signed? (default: false)
state_file = "/Users/johnz/Project/rust/cosmos/tmkms/.tmkms-p11-val-all/state/val-4-consensus.json"
protocol_version = "v0.34"
reconnect = true
```

## A note about validator's consensus key
Now that the consensus key is hosted in the HSM, we need to use the pubkey from the HSM to generate the genesis transaction.
Example script to initialize a new chain with a validator consensus key PUB_KEY which is the public key for the HSM key associated with key_label in tmkms.toml.
```bash
# Details of the script:
# 0. cleanup. NOTE: it will COMPLETELY DELETE the existing chain if any and start new.
# 1. initialization of a new chain
# 2. add a validator key to keyring and add it as genesis account with funds
#   note: this is a secp256k1 key as a wallet account instead of consensus key which will be hosted in tmkms
# 3. gentx use the validator pubkey from tmkms to generate the genesis transaction
#  --pubkey string The validator's Protobuf JSON encoded public key
# 4. edit config.toml to enable the tmkms
# 4.1 On tmkms side, make the corresponding changes in the tmkms.toml for testchan-1 chain

BINARY="wfchaind"
CHAINID="testchain-1"
CHAINID_ARG="--chain-id $CHAINID"
CHAINDIR="testchain"
HOME="$CHAINDIR/$CHAINID"
HOME_ARG="--home $HOME"
VALIDATOR_PORT="1234"

STAKE_DENOM="stake"
STAKE_BASE_DENOM="u$STAKE_DENOM"
DENOM="wfusd"
BASE_DENOM="u$DENOM"
#STAKE_COINS="1000000000$STAKE_DENOM,1000000000000$STAKE_BASE_DENOM"
COINS="1000000000$STAKE_DENOM,1000000000000$BASE_DENOM"
DELEGATE="100000000$STAKE_DENOM"

KEYRING="--keyring-backend=test"

PUB_KEY="{\"@type\":\"/cosmos.crypto.ed25519.PubKey\",\"key\":\"DRvpQ98n4/WeY/1x7Tw9l/yG0guNtkQmPH+51eYZwLo=\"}"

echo "CHAINID: $CHAINID; HOME: $HOME"

#0. cleanup. WARNING: it will delete the existing chain if any and start new.
killall $BINARY
[ -d $HOME ] && rm -r $HOME

#1. initialization of a new chain
#$($BINARY init $CHAINID --home $HOME --chain-id $CHAINID --overwrite)
$BINARY init "$CHAINID" $HOME_ARG $CHAINID_ARG --overwrite

#2. add a validator key to keyring and add it as genesis account with funds
$BINARY keys add validator $HOME_ARG $KEYRING --output json > $HOME/validator.json 2>&1
$BINARY add-genesis-account $($BINARY keys show validator -a $HOME_ARG $KEYRING) $COINS $HOME_ARG
#3. gentx use the validator pubkey from tmkms to generate the genesis transaction
$BINARY gentx validator $DELEGATE $HOME_ARG $CHAINID_ARG $KEYRING --pubkey $PUB_KEY
$BINARY collect-gentxs $HOME_ARG

#4. edit config.toml to enable the tmkms
# at this stage, we still need these two files priv_validator_key.json and priv_validator_state.json
# also, we may not need to change the priv_validator_laddr yet at this stage
# because this gentx is to define the validator and no consensus signing is required yet.
sed -i .bak 's#priv_validator_laddr = ""#priv_validator_laddr = "tcp://0.0.0.0:'"$VALIDATOR_PORT"'"#g' "$HOME/config/config.toml"
sed -i .bak 's#priv_validator_key_file = "config/priv_validator_key.json"#\#priv_validator_key_file = "config/priv_validator_key.json"#g' "$HOME/config/config.toml"
sed -i .bak 's#priv_validator_state_file = "data/priv_validator_state.json"#\#priv_validator_state_file = "data/priv_validator_state.json"#g' "$HOME/config/config.toml"

```

## Start tmkms
```shell
# start tmkms
./target-p11/release/tmkms start -c ./.tmkms-p11/tmkms.toml

```


