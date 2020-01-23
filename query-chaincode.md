
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/universe.at/tlsca/tlsca.universe.at-cert.pem

# query peer 0
export CORE_PEER_TLS_CERT_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/server.crt"
export CORE_PEER_TLS_KEY_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/server.key"
export CORE_PEER_ADDRESS="peer0.athen.universe.at:7051"

## query chaincode on peer 0
echo "peer 0 - value: Roland "
docker exec -e CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS -e CORE_PEER_TLS_CERT_FILE=$CORE_PEER_TLS_CERT_FILE -e CORE_PEER_TLS_KEY_FILE=$CORE_PEER_TLS_KEY_FILE cli peer chaincode query -n sacc -c '{"Args":["query","Roland"]}' -C samlinux --tls --cafile $ORDERER_CA

## set new value
docker exec -e CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS -e CORE_PEER_TLS_CERT_FILE=$CORE_PEER_TLS_CERT_FILE -e CORE_PEER_TLS_KEY_FILE=$CORE_PEER_TLS_KEY_FILE cli peer chaincode invoke -n sacc -c '{"Args":["set","Iris","330"]}' -C samlinux --tls --cafile $ORDERER_CA

# query peer 1
export CORE_PEER_TLS_CERT_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls/server.crt"
export CORE_PEER_TLS_KEY_FILE="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls/server.key"
export CORE_PEER_ADDRESS="peer1.athen.universe.at:7051"

## query chaincode on peer 1
echo "peer 1 - value: Roland "
docker exec -e CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS -e CORE_PEER_TLS_CERT_FILE=$CORE_PEER_TLS_CERT_FILE -e CORE_PEER_TLS_KEY_FILE=$CORE_PEER_TLS_KEY_FILE cli peer chaincode query -n sacc -c '{"Args":["query","Roland"]}' -C samlinux --tls --cafile $ORDERER_CA

# change value

# docker exec -e CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS -e CORE_PEER_TLS_CERT_FILE=$CORE_PEER_TLS_CERT_FILE -e CORE_PEER_TLS_KEY_FILE=$CORE_PEER_TLS_KEY_FILE cli peer chaincode invoke -n sacc -o raft.universe.at:7050 -C samlinux  -c '{"Args":["set","Joana","520"]}' --tls --cafile $ORDERER_CA

