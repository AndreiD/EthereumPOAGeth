# Ethereum POA Geth

### Step 1: Initial Setup :alien:

download and build geth

https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum

download and install node & npm (we will use pm2 to manage start/restart/logs)

~~~~
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential libssl-dev
sudo npm install pm2 -g
~~~~

Create 2 folders: node1 and node2
Generate 2 new accounts with geth

~~~~
geth --datadir node1/ account new
geth --datadir node2/ account new
~~~~

create a password.txt file under each node containing the password for that account
or, create 2 small AWS instances, 15GB of space should do it

generate a genesis with puppeth... or use this one
Modify the clique period (that is how fast the blocks are mined).

### Step 2 :mushroom:

~~~~
geth --datadir node1/ init genesis.json
geth --datadir node2/ init genesis.json
~~~~

### 3. Bootnode :mushroom:

the node that helps other nodes discover each-other. Put it on a static ip.

~~~~
bootnode -genkey boot.key
~~~~

and run it with:

~~~~
bootnode -nodekey boot.key -verbosity 9 -addr :30303
~~~~

can be an AWS micro instance
### 4. Going Live :mushroom:

check the file restart_blockchain.sh and replace the stuff with yours
ex: replace the enode address with yours, and the account with yours

At this moment it looks like this:
~~~~
# edit the --name and after -- you put the arguments
pm2 stop all
pm2 delete all

pm2 start bootnode --name bootnode -- -nodekey boot.key -verbosity 9 -addr :30303

pm2 start geth --name node1 -- --datadir node1/ --syncmode 'full' --port 30341 --rpc --rpcaddr '0.0.0.0' --rpccorsdomain "*" --rpcport 8545 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --bootnodes 'enode://21763a17be78928a4884ba2a4f65cc91934be8ac7e662313c5e017c964ff0ac4291c737881994470ef160793954c296195f2c050e599e566305ccae511559681@127.0.0.1:30303' --networkid 1337 --gasprice '1' -unlock '0x7e330d94fb568d299180023df46e5f7bafb292a9' --password node1/password.txt --mine

pm2 start geth --name node2 -- --datadir node2/ --syncmode 'full' --port 30342 --rpc --rpcaddr 'localhost' --rpcport 8542 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --bootnodes 'enode://21763a17be78928a4884ba2a4f65cc91934be8ac7e662313c5e017c964ff0ac4291c737881994470ef160793954c296195f2c050e599e566305ccae511559681@127.0.0.1:30303' --networkid 1337 --gasprice '1' -unlock '0x2046015c03ec183cc10ee2ea345b9b4faad9cb7a' --password node2/password.txt  --ipcdisable --mine

pm2 logs node1
~~~~


replace the enode address with yours, and the account with yours, the bootnode with yours

~~~~
geth --datadir node2/ --syncmode 'full' --port 30342 --rpc --rpcaddr 'localhost' --rpcport 8542 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --bootnodes 'enode://61c3869413da609fa9d83c8a8a7771bac29ca673fdea5331933ecb6d90d3d59e8065557a9b08bbc4ddd11196984ee963c7abe568e329c1a0a81789d872173fe0@127.0.0.1:30303' --networkid 1337 --gasprice '1' -unlock '0x2046015c03ec183cc10ee2ea345b9b4faad9cb7a' --password node2/password.txt  --ipcdisable --mine
~~~~

### 5. Almost Finish :mushroom:
~~~~
$ geth attach 'http://localhost:8501'
~~~~

You should see:

~~~~
Welcome to the Geth JavaScript console!
instance: Geth/v1.8.15-unstable/windows-amd64/go1.10.3
coinbase: 0x3b6ebb548039b55d2e8a5d538888f1886955c6ed
at block: 37 (Sun, 26 Aug 2018 17:32:09 EEST)
 modules: eth:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0
~~~~

### Real Finish :mushroom:

Add a Chain Explorer
Check https://github.com/etherparty/explorer …there are others too

### Happy hacking. Problems ? Write in issues



