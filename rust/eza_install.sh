#!/bin/bash
# eza installation script with if-else structure

# Detect operating system
if [[ "$(uname)" == "Darwin" ]]; then
    echo "macOS detected, installing eza via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install eza
    else
        echo "Homebrew not found. Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew install eza
    fi
elif [[ "$(uname)" == "Linux" ]]; then
    echo "Linux detected. Checking installation methods..."
    
    # Check if Rust/Cargo is available
    if command -v cargo &> /dev/null; then
        echo "Rust environment detected, installing eza via cargo..."
        cargo install eza
    else
        echo "Rust not found. Attempting to install via package repositories..."
        
        # Check distribution
        if command -v apt &> /dev/null; then
            echo "Debian/Ubuntu detected, installing via apt..."
            
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
            echo "Fedora/RHEL detected, installing via dnf..."
            sudo dnf install -y eza
        elif command -v pacman &> /dev/null; then
            echo "Arch Linux detected, installing via pacman..."
            sudo pacman -S eza
        else
            echo "Unable to determine package manager. Installing Rust and then eza via cargo..."
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

echo "eza installation completed. You can now use 'eza' command instead of 'ls'."
echo "Try: eza --long --header --git"
