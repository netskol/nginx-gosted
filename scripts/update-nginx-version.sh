#!/bin/bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <nginx-version>"
    echo "Example: $0 1.29.2"
    exit 1
fi

NEW_VERSION="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Updating Nginx version to $NEW_VERSION..."

# Update Dockerfile
sed -i "" "s/FROM nginx:[0-9.]*-bookworm/FROM nginx:${NEW_VERSION}-bookworm/" "$REPO_ROOT/Dockerfile"
echo "✓ Updated Dockerfile"

# Update versions.yml
sed -i "" "s/version: '[0-9.]*'/version: '${NEW_VERSION}'/" "$REPO_ROOT/versions.yml"
echo "✓ Updated versions.yml"

# Update docker-compose.yaml
sed -i "" "s/image: netskol\/nginx-gosted:[0-9.]*/image: netskol\/nginx-gosted:${NEW_VERSION}/" "$REPO_ROOT/docker-compose.yaml"
echo "✓ Updated docker-compose.yaml"

# Update README.md badge
sed -i "" "s/NGINX-[0-9.]*/NGINX-${NEW_VERSION}/" "$REPO_ROOT/README.md"
echo "✓ Updated README.md"

echo ""
echo "Version update complete! Don't forget to:"
echo "1. Test the build: docker build -t nginx-gosted:test ."
echo "2. Review changes: git diff"
echo "3. Commit: git commit -am 'bump Nginx version to $NEW_VERSION'"
echo "4. Push and create PR"
