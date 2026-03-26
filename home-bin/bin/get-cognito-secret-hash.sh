#!/bin/bash
USERNAME=$1
CLIENT_ID=$2
CLIENT_SECRET=$3

if [ -z "$USERNAME" ] || [ -z "$CLIENT_ID" ] || [ -z "$CLIENT_SECRET" ]; then
  echo "Usage: $0 <username> <client_id> <client_secret>"
  exit 1
fi

echo -n "$USERNAME$CLIENT_ID" | openssl dgst -sha256 -hmac "$CLIENT_SECRET" -binary | openssl enc -base64
