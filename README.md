# User and Backup Management Scripts

## Author Details
- **Name**: [Your Full Name]
- **Student Code**: [Your Student Code]
- **Last Updated**: [Date]

## Task 1: User Creation Script

### Summary
The `create_users.sh` script automates the creation of users and configuration of their environments on an Ubuntu system. It processes a CSV file containing user information to create users, set passwords, assign groups, create shared folders, and set aliases.

### Pre-requisites
- Ubuntu Linux system
- `wget` installed for downloading files
- Root or sudo privileges

### Usage
```bash
./create_users.sh <file|url>
