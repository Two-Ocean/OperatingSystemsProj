# User and Backup Management Scripts

## Author Details
- **Name**: [Siavash Sharifirad]
- **Student ID**: [1000116939]
- **Last Updated**: [26/5/2024]

### Summary
The `create_users.sh` script automates the creation of users and configuration of their environments on an Ubuntu system. It processes a CSV file containing user information to create users, set passwords, assign groups, create shared folders, and set aliases.

### Pre-requisites
- Ubuntu Linux system
- `wget` installed for downloading files
- Root or sudo privileges

### Usage
```bash
./create_users.sh http://10.0.0.24/users.csv

./backup.sh /path/to/directory
