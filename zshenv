# use homebrew's cert for now
# created with security find-certificate -a -p /Library/Keychains/System.keychain /System/Library/Keychains/SystemRootCertificates.keychain > cert.pem
export OPENSSL_X509_CERT_FILE=/usr/local/etc/openssl/cert.pem
export GIT_SSL_CAINFO=$OPENSSL_X509_CERT_FILE
