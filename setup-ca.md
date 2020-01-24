
docker-compose -f docker-compose-ca.yaml down  

# start CA mit init Parameter
docker-compose -f docker-compose-ca.yaml up

# copy ca key
ll fabca/crypto-config/tlsca-server/universe.at/msp/keystore/
sudo cp fabca/crypto-config/tlsca-server/universe.at/msp/keystore/02**_sk fabca/crypto-config/tlsca-server/universe.at/tlsca.universe.at-key.pem

# start CA mit start Parameter
docker-compose -f docker-compose-ca.yaml up

# copy CA Keys
sudo cp fabca/crypto-config/tlsca-server/universe.at/tlsca.universe.at-cert.pem fabca/crypto-config/peerOrganizations/athen.universe.at/ca/

sudo cp fabca/crypto-config/tlsca-server/universe.at/tlsca.universe.at-cert.pem fabca/crypto-config/peerOrganizations/athen.universe.at/msp/tlscacerts/

sudo cp fabca/crypto-config/tlsca-server/universe.at/tlsca.universe.at-cert.pem fabca/crypto-config/peerOrganizations/athen.universe.at/msp/cacerts/

sudo cp fabca/crypto-config/tlsca-server/universe.at/tlsca.universe.at-cert.pem fabca/crypto-config/peerOrganizations/athen.universe.at/msp/tlscacerts/

sudo cp fabca/crypto-config/tlsca-server/universe.at/tlsca.universe.at-cert.pem fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/msp/tlscacerts/

sudo cp fabca/crypto-config/tlsca-server/universe.at/tlsca.universe.at-cert.pem fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/msp/tlscacerts/

sudo cp fabca/crypto-config/tlsca-server/universe.at/tlsca.universe.at-key.pem fabca/crypto-config/peerOrganizations/athen.universe.at/ca/


export FABRIC_CA_CLIENT_TLS_CERTFILES=${PWD}/fabca/crypto-config/tlsca-server/universe.at/tlsca.universe.at-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/tlsca-server/universe.at/admin
# Enroll TLS CA’s Admin
fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminpw@0.0.0.0:7052


# register 
fabric-ca-client register -d --id.name peer0.athen.universe.at --id.secret peer0PW --id.type peer -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name peer1.athen.universe.at --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052

fabric-ca-client register -d --id.name Admin@athen.universe.at --id.secret po1AdminPW --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7052
fabric-ca-client register -d --id.name User1@athen.universe.at --id.secret po1UserPW --id.type user -u https://0.0.0.0:7052

# Enroll peers
export FABRIC_CA_CLIENT_MSPDIR=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/msp
fabric-ca-client enroll -u https://peer0.athen.universe.at:peer0PW@0.0.0.0:7052

export FABRIC_CA_CLIENT_MSPDIR=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/msp
fabric-ca-client enroll -u https://peer1.athen.universe.at:peer1PW@0.0.0.0:7052

# Enroll and Get the TLS cryptographic material for the peer. 
# This requires another enrollment,
# Enroll against the tls profile on the TLS CA. 

export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/tlsca-server/universe.at/admin
export FABRIC_CA_CLIENT_MSPDIR=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/
export FABRIC_CA_CLIENT_TLS_CERTFILES=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/msp/tlscacerts/tlsca.universe.at-cert.pem

fabric-ca-client enroll -d -u https://peer0.athen.universe.at:peer0PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer0.athen.universe.at

# rename TLS 
sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/keystore/*_sk fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/server.key

sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/signcerts/cert.pem fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/server.crt

sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/tlscacerts/tls-0-0-0-0-7052.pem fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/ca.crt

export FABRIC_CA_CLIENT_MSPDIR=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls
export FABRIC_CA_CLIENT_TLS_CERTFILES=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/msp/tlscacerts/tlsca.universe.at-cert.pem

fabric-ca-client enroll -d -u https://peer1.athen.universe.at:peer1PW@0.0.0.0:7052 --enrollment.profile tls --csr.hosts peer1.athen.universe.at

# rename TLS 
sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls/keystore/*_sk fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls/server.key

sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls/signcerts/cert.pem fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls/server.crt

sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls/tlscacerts/tls-0-0-0-0-7052.pem fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer1.athen.universe.at/tls/ca.crt


# ------------------------------------------------------------------------------------------------------
# Enroll and Setup peer org Admin User
# The admin identity is responsible for activities such as # installing and instantiating chaincode. 
# The commands below assumes that this is being executed on Peer1's host machine.
# Fabric does this by Creating folder user/Admin@po1.fabric.com
# ------------------------------------------------------------------------------------------------------
export FABRIC_CA_CLIENT_TLS_CERTFILES=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/ca/tlsca.universe.at-cert.pem
export FABRIC_CA_CLIENT_HOME=$PWD/fabca/crypto-config/tlsca-server/universe.at/admin
export FABRIC_CA_CLIENT_MSPDIR=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at/msp
fabric-ca-client enroll -d -u https://Admin@athen.universe.at:po1AdminPW@0.0.0.0:7052

# AdminCerts
fabric-ca-client identity list
fabric-ca-client certificate list --id Admin@athen.universe.at --store $PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at/msp/admincerts

# Enroll user
export FABRIC_CA_CLIENT_MSPDIR=$PWD/fabca/crypto-config/peerOrganizations/athen.universe.at/users/User1@athen.universe.at/msp
fabric-ca-client enroll -d -u https://User1@athen.universe.at:po1UserPW@0.0.0.0:7052

mkdir fabca/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at/tls
mkdir fabca/crypto-config/peerOrganizations/athen.universe.at/users/User1@athen.universe.at/tls

sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/ca.crt fabca/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at/tls

sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/server.crt fabca/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at/tls

sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/server.key fabca/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at/tls
#---
sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/ca.crt fabca/crypto-config/peerOrganizations/athen.universe.at/users/User1@athen.universe.at/tls

sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/server.crt fabca/crypto-config/peerOrganizations/athen.universe.at/users/User1@athen.universe.at/tls

sudo cp fabca/crypto-config/peerOrganizations/athen.universe.at/peers/peer0.athen.universe.at/tls/server.key fabca/crypto-config/peerOrganizations/athen.universe.at/users/User1@athen.universe.at/tls

<!---- -->
cp fabca/crypto-config/peerOrganizations/athen.universe.at/users/Admin@athen.universe.at/msp/admincerts/Admin@athen.universe.at.pem fabca/crypto-config/peerOrganizations/athen.universe.at/msp/admincerts/
