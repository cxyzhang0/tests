#!/bin/sh
# get ed25519 pubkey and output to file
alias kmstool=./target/release/kmstool

folder="./pubkeys"

rm -r -f "$folder"

# Add folder, exit if error
if ! mkdir -p $folder 2>/dev/null; then
    echo "Failed to create folder. Aborting..."
    exit 1
fi

kmstool -c config.toml keys get-pub-key -l "slot-0/tsstrio-0/ed25519/1" -t "consensus" -a "ed25519" | egrep -o 'json: (.*?);' | cut -d' ' -f2 | cut -d';' -f1 > $folder/val_1_pubkey.json
kmstool -c config.toml keys get-pub-key -l "slot-0/tsstrio-1/ed25519/1" -t "consensus" -a "ed25519" | egrep -o 'json: (.*?);' | cut -d' ' -f2 | cut -d';' -f1 > $folder/val_2_pubkey.json
