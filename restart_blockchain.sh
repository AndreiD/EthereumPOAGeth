#!/usr/bin/env bash
# edit the --name and after -- you put the arguments
pm2 stop all
pm2 delete all

pm2 start bootnode --name bootnode -- -nodekey boot.key -verbosity 9 -addr :30303

pm2 start geth --name node1 -- --datadir node1/ --syncmode 'full' --port 30341 --rpc --rpcaddr '0.0.0.0' --rpccorsdomain "*" --rpcport 8545 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --bootnodes 'enode://21763a17be78928a4884ba2a4f65cc91934be8ac7e662313c5e017c964ff0ac4291c737881994470ef160793954c296195f2c050e599e566305ccae511559681@127.0.0.1:30303' --networkid 1337 --gasprice '1' -unlock '0x7e330d94fb568d299180023df46e5f7bafb292a9' --password node1/password.txt --mine

pm2 start geth --name node2 -- --datadir node2/ --syncmode 'full' --port 30342 --rpc --rpcaddr 'localhost' --rpcport 8542 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --bootnodes 'enode://21763a17be78928a4884ba2a4f65cc91934be8ac7e662313c5e017c964ff0ac4291c737881994470ef160793954c296195f2c050e599e566305ccae511559681@127.0.0.1:30303' --networkid 1337 --gasprice '1' -unlock '0x2046015c03ec183cc10ee2ea345b9b4faad9cb7a' --password node2/password.txt  --ipcdisable --mine

pm2 logs node1

