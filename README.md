# Code-Server with Caddy Proxy

This project provides a self-hosted `code-server` instance accessible over HTTPS with a local domain.

## Prerequisites

- Docker and Docker Compose installed.

## Setup Instructions

### 1. Host resolution

Add the following line to your `/etc/hosts` file (macOS/Linux):

```bash
127.0.0.1 code.local
```

### 2. Start the services

Run the following command in this directory:

```bash
docker compose up -d
```

### 3. Access

- **URL**: [https://code.local](https://code.local)
- **Password**: `admin` (configured in `docker-compose.yml`)

## Configuration Details

- **Code-Server**: Runs on port 8080 internally.
- **Caddy**: Acts as a reverse proxy, providing TLS via an internal self-signed certificate. Port 80 and 443 are exposed.
- **Persistence**: 
    - `./config`: Stores code-server configuration and extensions.
    - `./project`: The working directory for your projects.

## Security & Certificate Trust

By default, Caddy uses a self-signed internal certificate. To make your browser trust the connection (and enable Service Workers):

### For Local Docker
Run the trust script:
```bash
bash trust-ca.sh
```

### For Remote Docker
If your Docker service is running on a remote server, specify the SSH host:
```bash
bash trust-ca.sh user@remote-host
```

## Security Note

Caddy uses `tls internal`, which means your browser will show a certificate warning the first time you visit. You can safely "Proceed" or install the Caddy root CA to your system trust store.
