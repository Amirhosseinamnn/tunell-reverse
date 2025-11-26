#!/bin/bash

echo "Downloading amirhossein.zip ..."
curl -L -o amirhossein.zip https://raw.githubusercontent.com/Amirhosseinamnn/amirhossein-reverse-tunell/main/amirhossein.zip

echo "Unzipping..."
unzip -o amirhossein.zip -d /root/amirhossein

echo "Running setup.sh ..."
chmod +x /root/amirhossein/setup.sh
bash /root/amirhossein/setup.sh

echo "Preparing config.toml ..."
mkdir -p /root/c
if [ ! -f /root/c/config.toml ]; then
  echo "# Empty config file" > /root/c/config.toml
fi

echo "Opening config.toml ..."
nano /root/c/config.toml
