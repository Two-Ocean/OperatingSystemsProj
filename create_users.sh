#!/bin/bash

# Log file setup
LOGFILE="user_creation.log"
exec > >(tee -i $LOGFILE)
exec 2>&1

# Function to print usage
usage() {
  echo "Usage: $0 <file|url>"
  exit 1
}

# Function to create user
create_user() {
  local username=$1
  local email=$2
  local birthdate=$3
  local groups=$4
  local sharedFolder=$5

  if id "$username" &>/dev/null; then
    echo "User $username already exists, skipping..."
    return 1
  fi

  # Create user
  password=$(date -d "$birthdate" +"%m%Y")
  useradd -m -s /bin/bash "$username"
  echo "$username:$password" | chpasswd
  chage -d 0 "$username"

  # Create groups if they don't exist and add user to groups
  IFS=',' read -ra group_array <<< "$groups"
  for group in "${group_array[@]}"; do
    if [ -n "$group" ]; then
      getent group "$group" >/dev/null || groupadd "$group"
      usermod -aG "$group" "$username"
    fi
  done

  # Create shared folder and set permissions
  if [ -n "$sharedFolder" ]; then
    mkdir -p "$sharedFolder"
    chown :$username "$sharedFolder"
    chmod 770 "$sharedFolder"
    ln -s "$sharedFolder" "/home/$username/shared"
  fi

  # Create alias for sudo users
  if id -nG "$username" | grep -qw "sudo"; then
    echo "alias myls='ls -la'" >> "/home/$username/.bash_aliases"
  fi

  echo "User $username created successfully."
}

# Main script logic
if [ $# -ne 1 ]; then
  usage
fi

input=$1
if [[ $input =~ ^https?:// ]]; then
  wget -q -O users.csv "$input"
  input="users.csv"
fi

if [ ! -f "$input" ]; then
  echo "File not found!"
  exit 1
fi

echo "Processing file: $input"
total_users=$(($(wc -l < "$input") - 1))
echo "Number of users to add: $total_users"

read -p "Do you want to proceed? (y/n): " proceed
if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

tail -n +2 "$input" | while IFS=';' read -r email birthdate groups sharedFolder; do
  username="${email%@*}"
  username="${username/./}"
  create_user "$username" "$email" "$birthdate" "$groups" "$sharedFolder"
done

echo "User creation process completed."
