#! /bin/bash
# change aws credentials
#
# This expects
#
#   ~/.aws/credentials.$1
#
# to exist.  It is copied to ~/.aws/credentials

set -e; set -u

if [ "$#" -ne 1 ]; then
  echo need a username
  exit 1
fi

who="${1}"


creds="credentials.""${who}"

cd ~/.aws

if [ ! -f "${creds}"  ]; then
  echo file "${creds}" does not exist
  exit 2
fi

cd ~/.aws
cp "${creds}" credentials
