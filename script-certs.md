```shell

mkdir -p certs/{root-ca,issuing-ca,server,client}
# Generate password-protected EC keys using secp384r1 curve
PASSWORD="trustpass"  # Change this in production!

# Root CA
## Generate a password-protected EC key for the root CA
##  two steps: gen key and encryption
##  pkcs8 data structure (ASN.1 encoded in DER) wrapped in PEM  
openssl ecparam -genkey -name secp384r1 | \
openssl ec -aes256 -out certs/root-ca/root-ca.key -passout pass:$PASSWORD
### Display the private key
openssl pkcs8 -in certs/root-ca/root-ca.key -inform PEM -passin pass:$PASSWORD -topk8 -nocrypt
openssl ec -in certs/root-ca/root-ca.key -text -passin pass:$PASSWORD #-noout # use -noout to avoid displaying the private key
### Display the public key
openssl ec -in certs/root-ca/root-ca.key -pubout -passin pass:$PASSWORD
openssl pkey -in certs/root-ca/root-ca.key -passin pass:$PASSWORD #-noout 
### Output the key to DER file (raw binary by removing PEM wrapper)
openssl pkcs8 -in certs/root-ca/root-ca.key -passin pass:$PASSWORD -topk8 -out certs/root-ca/root-ca.der -passout pass:$PASSWORD -outform DER
#### Display the .der key 
openssl pkcs8 -in certs/root-ca/root-ca.der -inform DER -passin pass:$PASSWORD -topk8 -nocrypt

### Output key to unencrypted file
openssl pkcs8 -in certs/root-ca/root-ca.key -passin pass:$PASSWORD -topk8 -out certs/root-ca/root-ca-unencrypted.key -passout pass:
#### Display the unencrypted key
openssl pkcs8 -in certs/root-ca/root-ca-unencrypted.key -passin pass:

## Generate a self-signed root CA certificate
openssl req -x509 -new -key certs/root-ca/root-ca.key -passin pass:$PASSWORD \
 -days 3650 -out certs/root-ca/root-ca.crt \
 -subj "/C=US/ST=CA/O=Test Org/CN=Root CA"
### Display the certificate
openssl x509 -in certs/root-ca/root-ca.crt -text #-noout

# Intermediate CA
## Generate a password-protected EC key for the intermediate CA
openssl ecparam -genkey -name secp384r1 | \
openssl ec -aes256 -out certs/issuing-ca/issuing-ca.key -passout pass:$PASSWORD
## CSR
openssl req -new -key certs/issuing-ca/issuing-ca.key -passin pass:$PASSWORD \
 -out certs/issuing-ca/issuing-ca.csr \
 -subj "/C=US/ST=CA/O=Test Org/CN=Issuing CA"
## certificate 
openssl x509 -req -in certs/issuing-ca/issuing-ca.csr \
 -CA certs/root-ca/root-ca.crt -CAkey certs/root-ca/root-ca.key -passin pass:$PASSWORD \
 -CAcreateserial -days 3650 -out certs/issuing-ca/issuing-ca.crt
### Display the certificate
openssl x509 -in certs/issuing-ca/issuing-ca.crt -text #-noout
    
# Server Certificate
## Generate a password-protected EC key for the server
openssl ecparam -genkey -name secp384r1 | \
openssl ec -aes256 -out certs/server/server.key -passout pass:$PASSWORD
## CSR
openssl req -new -key certs/server/server.key -passin pass:$PASSWORD \
 -out certs/server/server.csr \
 -subj "/C=US/ST=CA/O=Test Org/CN=localhost"
## certificate
openssl x509 -req -in certs/server/server.csr \
 -CA certs/issuing-ca/issuing-ca.crt -CAkey certs/issuing-ca/issuing-ca.key -passin pass:$PASSWORD \
 -CAcreateserial -days 365 -out certs/server/server.crt \
 -extfile <(echo -e "basicConstraints=critical,CA:FALSE\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature,keyAgreement\nextendedKeyUsage=serverAuth")
### Display the certificate
openssl x509 -in certs/server/server.crt -text #-noout

# Client Certificate
## Generate a password-protected EC key for the client
openssl ecparam -genkey -name secp384r1 | \
openssl ec -aes256 -out certs/client/client.key -passout pass:$PASSWORD
## CSR
openssl req -new -key certs/client/client.key -passin pass:$PASSWORD \
 -out certs/client/client.csr \
 -subj "/C=US/ST=CA/O=Test Org/CN=Client"
## certificate 
openssl x509 -req -in certs/client/client.csr \
 -CA certs/issuing-ca/issuing-ca.crt -CAkey certs/issuing-ca/issuing-ca.key -passin pass:$PASSWORD \
 -CAcreateserial -days 365 -out certs/client/client.crt \
 -extfile <(echo -e "basicConstraints=critical,CA:FALSE\nkeyUsage=digitalSignature,keyAgreement\nextendedKeyUsage=clientAuth")
### Display the certificate
openssl x509 -in certs/client/client.crt -text #-noout 
```