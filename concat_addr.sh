#!/bin/sh
# get multiple acct addrs and output one per line
alias kmstool=./target/release/kmstool
concat=""
res=$(kmstool -c config.toml keys get-pub-key -l "Slot Token 0/wfdc2/owner/1" -t "account" -a "secp256k1" -p "wf" | egrep -o 'addr: (.*?);' | cut -d' ' -f2 | cut -d';' -f1)
concat="$concat\"$res\" \\ \n"
res=$(kmstool -c config.toml keys get-pub-key -l "Slot Token 0/wfdc2/masterminter/1" -t "account" -a "secp256k1" -p "wf" | egrep -o 'addr: (.*?);' | cut -d' ' -f2 | cut -d';' -f1)
concat="$concat\"$res\""
echo $concat
