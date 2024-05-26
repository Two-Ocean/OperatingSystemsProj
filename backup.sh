#!/bin/bash

# Function to print usage
usage() {
  echo "Usage: $0 <directory>"
  exit 1
}

# Function to perform backup
perform_backup() {
  local dir=$1

  if [ ! -d "$dir" ]; then
    echo "Directory $dir not found!"
    exit 1
  fi

  tarball="${dir%/}.tar.gz"
  tar -czf "$tarball" -C "$(dirname "$dir")" "$(basename "$dir")"

  read -p "Enter remote server (IP or URL): " server
  read -p "Enter port number: " port
  read -p "Enter target directory on remote server: " target_dir

  scp -P "$port" "$tarball" "$server:$target_dir"
  if [ $? -eq 0 ]; then
    echo "Backup successful!"
  else
    echo "Backup failed!"
  fi
}

# Main script logic
if [ $# -ne 1 ]; then
  usage
fi

perform_backup "$1"
