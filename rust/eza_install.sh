#!/bin/bash
# eza installation script with if-else structure

# Define color codes
GREEN='\033[1;32m'  # Bold and green
NC='\033[0m'        # No Color

# Detect operating system
if [[ "$(uname)" == "Darwin" ]]; then
    echo -e "${GREEN}macOS detected, installing eza via Homebrew...${NC}"
    if command -v brew &> /dev/null; then
        brew install eza
    else
        echo -e "${GREEN}Homebrew not found. Installing Homebrew first...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install eza
    fi
elif [[ "$(uname)" == "Linux" ]]; then
    echo -e "${GREEN}Linux detected. Checking installation methods...${NC}"
    
    # Check if Rust/Cargo is available
    if command -v cargo &> /dev/null; then
        echo -e "${GREEN}Rust environment detected, installing eza via cargo...${NC}"
        cargo install eza
    else
        echo -e "${GREEN}Rust not found. Attempting to install via package repositories...${NC}"
        
        # Check distribution
        if command -v apt &> /dev/null; then
            echo -e "${GREEN}Debian/Ubuntu detected, installing via apt...${NC}"
            
            # First make sure you have gpg
            sudo apt update
            sudo apt install -y gpg wget
            
            # Then install eza via repository
            sudo mkdir -p /etc/apt/keyrings
            wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
            echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
            sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
            sudo apt update
            sudo apt install -y eza
        elif command -v dnf &> /dev/null; then
            echo -e "${GREEN}Fedora/RHEL detected, installing via dnf...${NC}"
            sudo dnf install -y eza
        elif command -v pacman &> /dev/null; then
            echo -e "${GREEN}Arch Linux detected, installing via pacman...${NC}"
            sudo pacman -S eza
        else
            echo -e "${GREEN}Unable to determine package manager. Installing Rust and then eza via cargo...${NC}"
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
            source "$HOME/.cargo/env"
            cargo install eza
        fi
    fi
else
    echo "Unsupported operating system. Please install eza manually."
    echo "Visit: https://github.com/eza-community/eza#installation"
    exit 1
fi

echo -e "${GREEN}eza installation completed. You can now use 'eza' command instead of 'ls'.${NC}"
echo -e "${GREEN}Try: eza --long --header --git${NC}"
