#!/bin/bash
# Only accept Nebulon Prime images signed with our key (public half in
# system_files/usr/lib/pki/containers/nebulon-prime.pub; private half is the SIGNING_SECRET repo secret).

set -ouex pipefail

POLICY=/etc/containers/policy.json
tmp="$(mktemp)"
jq '.transports.docker["ghcr.io/nebulonprime"] = [{
        "type": "sigstoreSigned",
        "keyPath": "/usr/lib/pki/containers/nebulon-prime.pub",
        "signedIdentity": { "type": "matchRepository" }
    }]' "$POLICY" > "$tmp"
mv "$tmp" "$POLICY"
chmod 0644 "$POLICY"
