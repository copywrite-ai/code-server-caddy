# Usage: bash trust-ca.sh [user@remote-host]
REMOTE_HOST=$1

# Extract Caddy Root CA
if [ -z "$REMOTE_HOST" ]; then
    echo "Extracting Caddy Root CA from local Docker..."
    docker exec caddy-proxy cat /data/caddy/pki/authorities/local/root.crt > ./caddy-root-ca.crt
else
    echo "Extracting Caddy Root CA from remote host $REMOTE_HOST..."
    ssh "$REMOTE_HOST" "docker exec caddy-proxy cat /data/caddy/pki/authorities/local/root.crt" > ./caddy-root-ca.crt
fi

if [ ! -s ./caddy-root-ca.crt ]; then
    echo "Error: Could not extract root.crt. Ensure the container 'caddy-proxy' is running."
    exit 1
fi

echo "Adding Caddy Root CA to macOS Keychain..."
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./caddy-root-ca.crt

echo "Done! Please restart your browser for the changes to take effect."
rm ./caddy-root-ca.crt
