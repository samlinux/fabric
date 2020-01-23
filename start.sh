#!/bin/bash

# Exit on first error, print all commands.
set -ev

# we first stop the network
docker-compose down

# start the network
docker-compose up -d

export CORE_PEER_MSPCONFIGPATH="CORE_PEER_MSPCONFIGPATH=/root/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at/msp"

# create channel and join peer0
docker exec -e $CORE_PEER_MSPCONFIGPATH cli peer channel create -c samlinux -f ./config/channel.tx -o orderer.universe.at:7050
docker exec -e $CORE_PEER_MSPCONFIGPATH cli peer channel join -b samlinux.block

# fetch channel to peer 1 and join
docker exec -e $CORE_PEER_MSPCONFIGPATH -e "CORE_PEER_ADDRESS=peer1.athen.universe.at:7051" cli peer channel fetch 0 -o orderer.universe.at:7050 -c samlinux
docker exec  -e $CORE_PEER_MSPCONFIGPATH -e "CORE_PEER_ADDRESS=peer1.athen.universe.at:7051" cli peer channel join -b samlinux_0.block

# install chaincode
# - peer0
docker exec -e $CORE_PEER_MSPCONFIGPATH -e "CORE_PEER_ADDRESS=peer0.athen.universe.at:7051" cli peer chaincode install -n sacc -v 1.0 -p sacc
docker exec  -e $CORE_PEER_MSPCONFIGPATH -e "CORE_PEER_ADDRESS=peer0.athen.universe.at:7051" cli peer chaincode list --installed

# - peer1
docker exec -e $CORE_PEER_MSPCONFIGPATH -e "CORE_PEER_ADDRESS=peer1.athen.universe.at:7051" cli peer chaincode install -n sacc -v 1.0 -p sacc
docker exec -e $CORE_PEER_MSPCONFIGPATH -e "CORE_PEER_ADDRESS=peer1.athen.universe.at:7051" cli peer chaincode list --installed

# instantiate chaincode 
# peer0 set first value
docker exec -e $CORE_PEER_MSPCONFIGPATH -e "CORE_PEER_ADDRESS=peer0.athen.universe.at:7051" cli peer chaincode instantiate -n sacc  -v 1.0 -o orderer.universe.at:7050 -C samlinux  -c '{"Args":["Roland","50"]}'

# we wait some time
sleep 5
docker exec -e $CORE_PEER_MSPCONFIGPATH -e "CORE_PEER_ADDRESS=peer0.athen.universe.at:7051" cli peer chaincode query -n sacc -c '{"Args":["query","Roland"]}' -C samlinux

# we show all logs in switch to detached mod
docker-compose logs -f








