# nginx-gosted

A Docker image based on Nginx 1.29.1 with OpenSSL GOST engine support, enabling GOST cryptographic algorithms for secure communication compliant with Russian cryptographic standards.

![alt text](https://img.shields.io/badge/OpenSSL-GOSTengine-blue.svg 'openssl and gost engine included')
![alt text](https://img.shields.io/badge/NGINX-1.29.1-blue.svg 'based on nginx:1.29.1 docker image')
![alt text](https://img.shields.io/badge/ГОСТ-2012-green.svg 'openssl ciphers:GOST2012-GOST8912-GOST8912')
![alt text](https://img.shields.io/badge/MAGMA-green.svg 'openssl ciphers:GOST2012-MAGMA-MAGMAOMAC')
![alt text](https://img.shields.io/badge/KUZNYECHIK-green.svg 'openssl ciphers:GOST2012-KUZNYECHIK-KUZNYECHIKOMAC')
![alt text](https://img.shields.io/badge/ГОСТ-2001-red.svg 'openssl ciphers:GOST2001-GOST89-GOST89 for compatibility')

## Features

- **Nginx 1.29.1** - Latest stable version of Nginx web server
- **OpenSSL GOST Engine** - Full support for GOST cryptographic algorithms
- **GOST 2012 Ciphers** - Modern GOST cryptographic standards:
  - GOST2012-KUZNYECHIK-KUZNYECHIKOMAC
  - GOST2012-MAGMA-MAGMAOMAC
  - GOST2012-GOST8912-GOST8912
- **GOST 2001 Compatibility** - Legacy GOST2001-GOST89-GOST89 support
- **Multi-architecture** - Supports both AMD64 and ARM64 platforms
- **Production Ready** - Optimized Docker image with proper logging configuration

## Prerequisites

- Docker Engine 20.10+ or Docker Desktop
- Docker Compose v2.0+ (optional, for docker-compose usage)
- GOST-compatible SSL certificates (for HTTPS)

## Quick Start

### Using Docker Compose (Recommended)

1. Clone the repository:
```bash
git clone <repository-url>
cd nginx-gosted
```

2. Place your GOST certificates in the `certs/` directory:
   - `my-site.crt` - Your SSL certificate (GOST-compatible) - example filename for self-generated certificates
   - `my-site.key` - Your SSL private key (GOST-compatible) - example filename for self-generated certificates
   
   **Note**: The filenames `my-site.crt` and `my-site.key` are examples. You can use your own certificate filenames, but make sure to update the paths in `nginx/nginx.conf` accordingly. Ensure your certificates are generated using GOST algorithms. Standard RSA/ECDSA certificates will not work with GOST ciphers. For testing purposes, you can generate self-signed GOST certificates using `openssl` with the GOST engine enabled.

3. Edit `nginx/nginx.conf` to match your domain and requirements

4. Start the container:
```bash
docker compose up -d
```

### Using Docker Run

```bash
docker run -d \
  --name nginx-gosted \
  -p 80:80 \
  -p 443:443 \
  -v $(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
  -v $(pwd)/certs:/etc/nginx/certs:ro \
  netskol/nginx-gosted:latest
```

## Verifying GOST Engine

Run the following commands to verify that the GOST engine is enabled and GOST ciphers are supported:

```bash
# Check if GOST engine is loaded
docker run --rm -i netskol/nginx-gosted openssl engine

# List all available GOST ciphers
docker run --rm -i netskol/nginx-gosted openssl ciphers | tr ":" "\n" | grep GOST
```

Expected output:
```
GOST2012-MAGMA-MAGMAOMAC
GOST2012-KUZNYECHIK-KUZNYECHIKOMAC
LEGACY-GOST2012-GOST8912-GOST8912
IANA-GOST2012-GOST8912-GOST8912
GOST2001-GOST89-GOST89
```

## Configuration

### Nginx Configuration

The default `nginx.conf` includes:
- HTTP to HTTPS redirect on port 80
- HTTPS server on port 443 with GOST cipher configuration
- SSL certificate paths: `/etc/nginx/certs/my-site.crt` and `/etc/nginx/certs/my-site.key`

**Important**: GOST ciphers must be explicitly declared in your nginx configuration:

```nginx
ssl_ciphers GOST2012-KUZNYECHIK-KUZNYECHIKOMAC:GOST2012-GOST8912-GOST8912;
ssl_protocols TLSv1.2;
ssl_prefer_server_ciphers on;
```

### Available GOST Cipher Suites

- `GOST2012-KUZNYECHIK-KUZNYECHIKOMAC` - GOST 2012 with Kuznyechik cipher
- `GOST2012-MAGMA-MAGMAOMAC` - GOST 2012 with Magma cipher
- `GOST2012-GOST8912-GOST8912` - GOST 2012 standard cipher suite
- `GOST2001-GOST89-GOST89` - Legacy GOST 2001 (for compatibility)

### Environment Variables

- `TZ` - Timezone (default: Europe/Amsterdam in docker-compose.yaml)

### Volume Mounts

- `/etc/nginx/nginx.conf` - Nginx configuration file
- `/etc/nginx/certs` - Directory containing SSL certificates

## Building from Source

To build the Docker image locally:

```bash
docker build -t nginx-gosted:local .
```

To build for multiple architectures:

```bash
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t nginx-gosted:local .
```

## Docker Image Tags

- `netskol/nginx-gosted:latest` - Latest stable version
- `netskol/nginx-gosted:1.29.1` - Specific version tag

## Usage Examples

### Basic HTTPS Server

```nginx
server {
    listen 443 ssl;
    server_name example.com;
    
    ssl_certificate /etc/nginx/certs/my-site.crt;
    ssl_certificate_key /etc/nginx/certs/my-site.key;
    ssl_ciphers GOST2012-KUZNYECHIK-KUZNYECHIKOMAC:GOST2012-GOST8912-GOST8912;
    ssl_protocols TLSv1.2;
    
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
```

### Testing GOST Connection

Test your GOST-enabled server:

```bash
# Using OpenSSL with GOST support
openssl s_client -connect your-domain.com:443 -cipher GOST2012-KUZNYECHIK-KUZNYECHIKOMAC

# Check available ciphers
openssl s_client -connect your-domain.com:443 -cipher 'GOST:*'
```

## Troubleshooting

### GOST Engine Not Loading

If GOST ciphers are not available, verify the engine is loaded:
```bash
docker exec <container-name> openssl engine gost
```

### Certificate Issues

Ensure your certificates are GOST-compatible and properly formatted:
```bash
docker exec <container-name> openssl x509 -in /etc/nginx/certs/my-site.crt -text -noout
```

### View Logs

Access nginx logs:
```bash
# Access logs
docker logs <container-name>

# Error logs
docker exec <container-name> tail -f /var/log/nginx/error.log
```

## Architecture Support

This image is built for multiple architectures:
- `linux/amd64` - Intel/AMD 64-bit
- `linux/arm64` - ARM 64-bit (Apple Silicon, ARM servers)

## License

See [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please ensure that:
- All versions are updated consistently across files
- Docker image builds successfully
- GOST engine functionality is verified

## Related Resources

- [Nginx Documentation](https://nginx.org/en/docs/)
- [OpenSSL GOST Engine](https://github.com/gost-engine/engine)
- [GOST Cryptographic Standards](https://www.tc26.ru/)
- [Debian Package: libengine-gost-openssl](https://packages.debian.org/libengine-gost-openssl)

