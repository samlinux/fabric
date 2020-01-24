# fabric
## fabric learning version

### start cryptogen version

1. mkdir {config,crypto-config}
2. ./generate.sh (create crypto material)
3. ./start.sh (start and install the mini network)
4. docker-compose down (stop the network)

### start fabca version
1. mkdir fabca
2. sudo cp -R crypto-config fabca
3. sudo find fabca/crypto-config -maxdepth 10 -type f -exec rm -fv {} \;


