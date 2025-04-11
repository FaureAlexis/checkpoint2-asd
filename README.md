# WordPress Deployment Automation

This Ansible project automates the deployment of a WordPress website on a Debian-based system using Docker for the database. It sets up a complete LAMP stack (Linux, Apache, MySQL/MariaDB, PHP) with WordPress.

## Project Overview

The automation includes:

- Docker installation for containerization
- MariaDB 11.2.2 running in a Docker container for the database
- Apache HTTP Server with HTTP/2 and rewrite modules
- PHP 8.2 with all extensions required by WordPress
- WordPress 6.4.3 (French version) deployment and configuration

## Requirements

- Debian-based target system (Proxmox LXC container with IPv6 support)
- Python 3.11 or higher
- pip 23.2.1 or higher
- SSH access to the target system

## Quick Start

1. Clone this repository
2. Run the setup script to prepare your environment:

```bash
./setup.sh
```

3. Create your inventory file from the example:

```bash
cp inventory.example.yml inventory.yml
```

4. Edit `inventory.yml` to configure your target hosts:

```yaml
wordpress:
  ansible_host: YOUR_IPV6_ADDRESS  # Replace with your server's IPv6 address
  ansible_user: YOUR_SSH_USER      # Replace with your SSH user
  ansible_ssh_private_key_file: /path/to/your/private/key
  ansible_become_password: YOUR_SUDO_PASSWORD  # Or use environment variable approach
```

5. Run the playbook:

```bash
# If using explicit password in inventory.yml
source .venv/bin/activate  # If not already activated
ansible-playbook -i inventory.yml playbook.yml

# Or provide sudo password via environment variable
source .venv/bin/activate  # If not already activated
export ANSIBLE_SUDO_PASS=your_sudo_password
ansible-playbook -i inventory.yml playbook.yml

# Or provide sudo password via command line prompt
source .venv/bin/activate  # If not already activated
ansible-playbook -i inventory.yml playbook.yml --ask-become-pass
```

## Manual Setup

If you prefer to set up manually instead of using the setup script:

1. Create a virtual environment:

```bash
python3 -m venv .venv/
```

2. Activate the virtual environment:

```bash
source .venv/bin/activate
```

3. Install required dependencies:

```bash
pip install -r requirements.txt
```

4. Ensure the WordPress package is available:

```bash
mkdir -p roles/prepare_wordpress/files
curl -o roles/prepare_wordpress/files/wordpress-6.4.3-fr_FR.tar.gz https://fr.wordpress.org/wordpress-6.4.3-fr_FR.tar.gz
```

## Role Descriptions

### prepare_docker

Installs Docker Engine and Docker Compose on the target system. Configures Docker to start on boot and sets up user permissions.

Key tasks:
- Install Docker prerequisites
- Add Docker repository and GPG key
- Install Docker Engine
- Install Docker Compose
- Add the current user to the docker group

### prepare_http_server

Installs and configures Apache HTTP Server with necessary modules for WordPress.

Key tasks:
- Install Apache2
- Enable required modules (rewrite, http2)
- Create and enable a virtual host for WordPress
- Configure PHP-FPM integration

### prepare_php

Installs PHP 8.2 and all extensions required by WordPress, configured for optimal performance.

Key tasks:
- Add Sury PHP repository
- Install PHP 8.2 and extensions
- Configure PHP settings for WordPress (memory limits, execution time, etc.)
- Set up PHP-FPM
- Configure Apache to use PHP-FPM

### prepare_db_server

Sets up a MariaDB 11.2.2 database server in a Docker container.

Key tasks:
- Create a Docker network for WordPress
- Create a Docker Compose configuration
- Start the MariaDB container
- Configure database credentials

### prepare_wordpress

Deploys WordPress and configures it to work with the database and web server.

Key tasks:
- Extract WordPress files
- Create wp-config.php with database settings
- Set proper file permissions
- Configure security keys

## Configuration

Each role has its own defaults that can be customized:

- `roles/*/defaults/main.yml` - Default variables for each role

Key configuration files:
- `inventory.yml` - Target host configuration
- `playbook.yml` - Main playbook orchestrating all roles

## Security Considerations

For production use, consider:

1. Changing all default passwords defined in the role defaults
2. Using environment-specific inventory files
3. Setting up SSL/TLS for secure connections
4. Implementing a firewall
5. Regularly updating all components

### Using Ansible Vault for Password Security

This project includes a sample vault file in `group_vars/all/vault.yml` that you should edit and encrypt:

1. Edit the file with your actual passwords:
```bash
vim group_vars/all/vault.yml
```

2. Encrypt the file:
```bash
ansible-vault encrypt group_vars/all/vault.yml
```

3. When running the playbook, provide the vault password:
```bash
ansible-playbook -i inventory.yml playbook.yml --ask-vault-pass
```

Alternatively, you can store the vault password in a file (don't commit this file to version control):
```bash
echo "your_vault_password" > .vault_pass
chmod 600 .vault_pass
ansible-playbook -i inventory.yml playbook.yml --vault-password-file=.vault_pass
```

## Troubleshooting

If you encounter issues:

1. Check connectivity to your target host
2. Verify that all prerequisites are installed
3. Look at the Apache and PHP logs on the target system
4. Check Docker container status with `docker ps` and `docker logs`

## License

This project is licensed under the MIT License - see the LICENSE file for details. 