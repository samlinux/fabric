# fabric
## fabric learning version 
This fabric network is based on Fabric v1.4.4

## Development setup
Use Visual Studio Code and Remote Development Extension.

### start cryptogen version

1. rm -R {config,crypto-config}
2. mkdir {config,crypto-config}
3. ./generate.sh (create crypto material)
4. ./start.sh (start and install the mini network)
5. docker-compose down (stop the network)
6. docker-compose up (restart the network)

### start fabca version
1. mkdir fabca
2. sudo cp -R crypto-config fabca
3. sudo find fabca/crypto-config -maxdepth 10 -type f -exec rm -fv {} \;


