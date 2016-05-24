#!/usr/bin/env bash
# Puppet Server Entry Point
# @author Vlad Ghinea

# Bash strict mode
set -euo pipefail
IFS=$'\n\t'

# VARs
SSLDIR='/etc/puppetlabs/puppet/ssl'
CSR_SIGN='/etc/puppetlabs/csr/sign'
R10K_DIR='/etc/puppetlabs/r10k'

# Fix SSL directory ownership
mkdir -p "$SSLDIR"
chown -R puppet:puppet "$SSLDIR"

# Configure puppet to use a certificate autosign script (if it exists)
if [[ -x "$CSR_SIGN" ]]; then
  puppet config set autosign "$CSR_SIGN" --section master
fi

# Deploy R10K environments (if a valid configuration file exists)
if [[ -d "$R10K_DIR" ]] && [[ -s "${R10K_DIR}/r10k.yaml" ]]; then
  r10k deploy environment --puppetfile --verbose
fi

exec "$@"
