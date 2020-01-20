#!/bin/bash
set -exo
curl https://keybase.io/hashicorp/pgp_keys.asc | gpg --import
apt-get install unzip
VERSION="1.5.1"
TOOL="packer"
EDITION="linux_amd64"
cd /usr/local/bin
# Download the binary and signature files.
wget "https://releases.hashicorp.com/$TOOL/$VERSION/${TOOL}_${VERSION}_${EDITION}.zip"
wget "https://releases.hashicorp.com/$TOOL/$VERSION/${TOOL}_${VERSION}_SHA256SUMS"
wget "https://releases.hashicorp.com/$TOOL/$VERSION/${TOOL}_${VERSION}_SHA256SUMS.sig"

# Verify the signature file is untampered.
gpg --verify "${TOOL}_${VERSION}_SHA256SUMS.sig" "${TOOL}_${VERSION}_SHA256SUMS"

#only check against your tool
sed '/linux_amd64/!d' ${TOOL}_${VERSION}_SHA256SUMS
sed '/linux_amd64/!d' ${TOOL}_${VERSION}_SHA256SUMS > ${TOOL}_${VERSION}_${EDITION}_SHA256SUMS

# Verify the SHASUM matches the binary.
shasum -a 256 -c "${TOOL}_${VERSION}_${EDITION}_SHA256SUMS"

unzip "${TOOL}_${VERSION}_linux_amd64.zip"
rm "${TOOL}_${VERSION}_linux_amd64.zip"
rm "${TOOL}_${VERSION}_SHA256SUMS"
rm "${TOOL}_${VERSION}_${EDITION}_SHA256SUMS"
rm "${TOOL}_${VERSION}_SHA256SUMS.sig"

"${TOOL}" --version
