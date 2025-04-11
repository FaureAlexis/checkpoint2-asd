#!/bin/bash

# Colors for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== WordPress Deployment Automation Setup ===${NC}"

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is required but not installed.${NC}"
    exit 1
fi

# Check for pip
if ! command -v pip3 &> /dev/null; then
    echo -e "${RED}Error: pip3 is required but not installed.${NC}"
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python3 -m venv .venv
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to create virtual environment. Please install python3-venv package.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Virtual environment created successfully.${NC}"
else
    echo -e "${GREEN}Virtual environment already exists.${NC}"
fi

# Activate virtual environment
echo -e "${YELLOW}Activating virtual environment...${NC}"
source .venv/bin/activate

# Install dependencies
echo -e "${YELLOW}Installing required dependencies...${NC}"
pip install -r requirements.txt

# Check if the WordPress package exists
if [ ! -f "roles/prepare_wordpress/files/wordpress-6.4.3-fr_FR.tar.gz" ]; then
    echo -e "${YELLOW}WordPress package not found, downloading...${NC}"
    mkdir -p roles/prepare_wordpress/files
    curl -o roles/prepare_wordpress/files/wordpress-6.4.3-fr_FR.tar.gz https://fr.wordpress.org/wordpress-6.4.3-fr_FR.tar.gz
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to download WordPress package.${NC}"
        exit 1
    fi
    echo -e "${GREEN}WordPress package downloaded successfully.${NC}"
else
    echo -e "${GREEN}WordPress package already exists.${NC}"
fi

# Ensure group_vars directory exists
if [ ! -d "group_vars/all" ]; then
    echo -e "${YELLOW}Creating group_vars directory structure...${NC}"
    mkdir -p group_vars/all
    echo -e "${GREEN}Group vars directory created.${NC}"
fi

# Check if inventory.yml exists
if [ ! -f "inventory.yml" ] && [ -f "inventory.example.yml" ]; then
    echo -e "${YELLOW}Creating inventory.yml from example...${NC}"
    cp inventory.example.yml inventory.yml
    echo -e "${GREEN}Created inventory.yml from template.${NC}"
    echo -e "${YELLOW}Make sure to update inventory.yml with your server details!${NC}"
fi

echo -e "${GREEN}Setup completed successfully!${NC}"
echo -e "${YELLOW}To start using this Ansible project:${NC}"
echo -e "1. Edit inventory.yml to configure your target hosts"
echo -e "2. Review and adjust default variables in the roles"
echo -e "3. For secure password management, edit and encrypt the vault file:"
echo -e "   vim group_vars/all/vault.yml"
echo -e "   ansible-vault encrypt group_vars/all/vault.yml"
echo -e "4. Run the playbook with one of the following methods:"
echo -e "   - With vault password prompt:"
echo -e "     ansible-playbook -i inventory.yml playbook.yml --ask-vault-pass"
echo -e "   - With sudo password prompt:"
echo -e "     ansible-playbook -i inventory.yml playbook.yml --ask-become-pass"
echo -e "   - With both prompts:"
echo -e "     ansible-playbook -i inventory.yml playbook.yml --ask-vault-pass --ask-become-pass"
echo
echo -e "${YELLOW}To activate the virtual environment in the future, run:${NC}"
echo -e "source .venv/bin/activate" 