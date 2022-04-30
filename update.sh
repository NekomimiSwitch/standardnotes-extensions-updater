#!/bin/bash
set -Eeuo pipefail

cd "$( dirname "${BASH_SOURCE[0]}" )"/build

# update
git clone --recurse-submodules --depth=1 https://github.com/iganeshk/standardnotes-extensions.git

pushd standardnotes-extensions
cat >> .env <<EOF
github:
  username: ${GH_USERNAME}
  token: ${GH_TOKEN}

# EXTENSION PUBLICATION DOMAIN
domain: ${DEPLOY_BASE_URL}

# EXTENSIONS DIRECTORY
extensions_dir: extensions

# EXTENSIONS PUBLICATION DIRECTORY
public_dir: public

# STANDARD HOSTS EXTENSIONS LIST
stdnotes_extensions_list: standardnotes-extensions-list.txt
EOF

pip3 install -r requirements.txt
python3 build_repo.py

pushd public

# write robots.txt
cat > robots.txt <<EOF
User-agent: *
Disallow: /
EOF

# write timestamp
date +%s | tee last_updated
