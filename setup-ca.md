# Preparations
```bash
docker-compose -f docker-compose-ca.yaml down 
rm -R fabca 
mkdir fabca
sudo cp -R crypto-config fabca
sudo find fabca/crypto-config -maxdepth 10 -type f -exec rm -fv {} \;
```

# Setup TLS CA
```bash
docker-compose -f docker-compose-cas.yaml up ca-tls.universe.at
```

## Enroll TLS CA’s Admin
```bash
export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/ca-tls/universe.at/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/ca-tls/universe.at/admin

fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminpw@0.0.0.0:7052
fabric-ca-client register -d --id.name peer0.athen.universe.at --id.secret peer0PW --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name peer1.athen.universe.at --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name orderer1-org0 --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7052
```

# start Orderer CA
```bash
docker-compose -f docker-compose-cas.yaml up ca-orderer.universe.at
```

## Enroll Orderer Org’s CA Admin
```bash
export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/ca-orderer/universe.at/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/ca-orderer/universe.at/admin

fabric-ca-client enroll -d -u https://ca-orderer-admin:ca-orderer-adminpw@0.0.0.0:7053
fabric-ca-client register -d --id.name orderer1-universe.at --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7053
fabric-ca-client register -d --id.name admin-orderer1-universe.at --id.secret org0adminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7053
```

# start athen CA
```bash
docker-compose -f docker-compose-cas.yaml up ca-athen.universe.at
```
## Enroll athen identities
```bash
export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/ca-athen/universe.at/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/ca-athen/universe.at/admin

fabric-ca-client enroll -d -u https://ca-athen-admin:ca-athen-adminpw@0.0.0.0:7054
fabric-ca-client register -d --id.name peer0.athen.universe.at --id.secret peer0PW --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name peer1.athen.universe.at --id.secret peer1PW --id.type peer -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name admin-athen.universet.at --id.secret athenAdminPW --id.type user -u https://0.0.0.0:7054
fabric-ca-client register -d --id.name user1-athen.universet.at --id.secret user1UserPW --id.type user -u https://0.0.0.0:7054
```

# Setup Peers
## Setup athen peers

### Peer 0 
#### Identity
```bash
export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/ca-athen/universe.at/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at

fabric-ca-client enroll -d -u https://peer0.athen.universe.at:peer0PW@0.0.0.0:7054
```

#### TLS Cert
```bash
export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/ca-tls/universe.at/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls

fabric-ca-client enroll -d -u https://peer0.athen.universe.at:peer0PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer0.athen.universe.at

mv fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/msp/keystore/*_sk fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/msp/keystore/key.pem
```

### Peer 1 
#### Identity
```bash
export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/ca-athen/universe.at/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at

fabric-ca-client enroll -d -u https://peer1.athen.universe.at:peer1PW@0.0.0.0:7054
 ```
#### TLS Cert
```bash
export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/ca-tls/universe.at/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls

fabric-ca-client enroll -d -u https://peer1.athen.universe.at:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1.athen.universe.at

mv fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls/msp/keystore/*_sk fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls/msp/keystore/key.pem
```

## Enroll athen.universe.at Admin
```bash
export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/ca-athen/universe.at/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at
export FABRIC_CA_CLIENT_MSPDIR=msp

fabric-ca-client enroll -d -u https://admin-athen.universet.at:athenAdminPW@0.0.0.0:7054

cp fabca/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at/msp/signcerts/cert.pem fabca/crypto-config/
peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/msp/admincerts/admin-athen-cert.pem

cp fabca/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at/msp/signcerts/cert.pem fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/msp/admincerts/admin-athen-cert.pem
```

# Launch Athen's Peers
```bash
docker-compose -f docker-compose-ca-mode.yaml up peer0.athen.universe.at peer1.athen.universe.at
```
# Setup Orderer

## Enroll Orderer
```bash
export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/ca-orderer/universe.at/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/ordererOrganizations/universe.at/

fabric-ca-client enroll -d -u https://orderer1-universe.at:ordererpw@0.0.0.0:7053
```
## Enroll TLS
```bash
export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/ca-tls/universe.at/tls-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tlsca

fabric-ca-client enroll -d -u https://orderer1-org0:ordererPW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts orderer1-org0

mv fabca/crypto-config/ordererOrganizations/universe.at/tlsca/keystore/*_sk fabca/crypto-config/ordererOrganizations/universe.at/tlsca/keystore/key.pem
```
## Enroll Orderer Org0’s Admin
```bash
export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/ca-orderer/universe.at/tls-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/ordererOrganizations/universe.at/users/Admin@universe.at
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin-orderer1-universe.at:org0adminpw@0.0.0.0:7053

cp fabca/crypto-config/ordererOrganizations/universe.at/users/Admin@universe.at/msp/signcerts/cert.pem fabca/crypto-config/ordererOrganizations/universe.at/msp/admincerts/orderer-admin-cert.pem

<!-- create config.yaml in peerOrganizations/msp -->
<!-- create config.yaml in peerOrganizations/users/Admin@athen.universe.at/msp -->
cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/msp/cacerts/0-0-0-0-7054.pem fabca/crypto-config/peerOrganizations/athen.universe.at/msp/cacerts/ca.athen.universe.at-cert.pem

```
# Create Genesis Block and Channel Transaction
```bash
configtxgen -profile OneOrgOrdererGenesis -outputBlock $PWD/fabca/config/genesis.block -channelID orderersyschannel

configtxgen -profile OneOrgChannel -outputCreateChannelTx $PWD/fabca/config/channel.tx -channelID samlinux

configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./config/AthenMSPanchors.tx -channelID samlinux -asOrg AthenMSP
```
# Launch Orderer and peers
```bash
docker-compose -f docker-compose-ca-mode.yaml up 
```
# Create and Join Channel
```bash
docker exec -it cli bash
export CORE_PEER_MSPCONFIGPATH="/root/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at/msp"
peer channel create -c samlinux -f ./config/channel.tx -o orderer.universe.at:7050
````
