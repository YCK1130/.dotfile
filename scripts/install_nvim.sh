#!/bin/bash
# install_nvim.sh - Install neovim with minimal sudo privileges

set -e
echo "===> Starting neovim installation and configuration"

# Check and install nvim
if ! command -v nvim &> /dev/null; then
    echo "Installing neovim..."
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install neovim
    elif [[ "$(uname)" == "Linux" ]]; then
        # Provide options to the user
        echo "Please choose installation method:"
        echo "1) Use system package manager (may require sudo)"
        echo "2) Use AppImage (no sudo required)"
        read -p "Choose [1/2]: " install_choice
        
        if [ "$install_choice" == "1" ]; then
            sudo apt-get update
            sudo apt-get install -y neovim
        else
            # Use AppImage installation (no sudo needed)
            mkdir -p $HOME/local/bin
            cd $HOME/local/bin
            curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
            chmod u+x nvim.appimage
            
            # Use appimage-extract (if system supports it)
            if [[ "$(./nvim.appimage --version)" == "CANNOT"* ]]; then
                echo "Need to extract AppImage..."
                # Download AppImage tools
                if ! command -v appimagetool &> /dev/null; then
                    curl -LO https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
                    chmod u+x appimagetool-x86_64.AppImage
                fi
                
                # Extract AppImage
                ./nvim.appimage --appimage-extract
                rm nvim.appimage
                
                # Create symbolic link
                ln -sf $HOME/local/bin/squashfs-root/usr/bin/nvim $HOME/local/bin/nvim
            else
                # Create symbolic link
                ln -sf $HOME/local/bin/nvim.appimage $HOME/local/bin/nvim
            fi
            
            # Add to PATH
            echo 'export PATH="$HOME/local/bin:$PATH"' >> $HOME/.zshrc.local
        fi
    else
        echo "Unsupported operating system"
        exit 1
    fi
fi

# Set up nvim configuration directory
echo "Setting up neovim configuration..."
mkdir -p $HOME/.config

# Backup existing configuration (if exists)
if [ -d "$HOME/.config/nvim" ]; then
    echo "Backing up existing nvim configuration..."
    mv $HOME/.config/nvim $HOME/.config/nvim.backup.$(date +%Y%m%d%H%M%S)
fi

# Copy our nvim configuration
if [ -d "$HOME/.dotfile/nvim" ]; then
    echo "Copying nvim configuration files..."
    mkdir -p $HOME/.config/nvim
    cp -r $HOME/.dotfile/nvim/* $HOME/.config/nvim/
    
    # Ensure Packer.nvim is installed
    if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
        echo "Installing Packer.nvim..."
        git clone --depth 1 https://github.com/wbthomason/packer.nvim \
            $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi
    
    # Install all plugins
    echo "Installing nvim plugins..."
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' || true
    
    echo "Setting permissions..."
    chmod -R u+rw $HOME/.config/nvim
    chmod -R u+rw $HOME/.local/share/nvim
else
    echo "No nvim configuration found, installing NvChad as base configuration..."
    # Clone NvChad
    git clone https://github.com/NvChad/NvChad $HOME/.config/nvim --depth 1
    
    # Create custom configuration folder
    mkdir -p $HOME/.config/nvim/lua/custom
    
    # If custom configuration exists, use custom configuration
    if [ -d "$HOME/.dotfile/nvim/lua/custom" ]; then
        cp -r $HOME/.dotfile/nvim/lua/custom/* $HOME/.config/nvim/lua/custom/
    fi
    
    echo "Setting permissions..."
    chmod -R u+rw $HOME/.config/nvim
    chmod -R u+rw $HOME/.local/share/nvim || true
fi

# Install dependency tools (ripgrep, fd, etc.)
echo "Installing ripgrep, fd and other dependencies..."
if [[ "$(uname)" == "Darwin" ]]; then
    brew install ripgrep fd
elif [[ "$(uname)" == "Linux" ]]; then
    # Check if sudo privileges are available
    if sudo -v &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y ripgrep fd-find
    else
        # Installation method without sudo privileges
        mkdir -p $HOME/local/bin
        
        # Install ripgrep
        if ! command -v rg &> /dev/null; then
            echo "Installing ripgrep (no sudo)..."
            curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz
            tar -xzf ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz
            cp ripgrep-13.0.0-x86_64-unknown-linux-musl/rg $HOME/local/bin/
            chmod +x $HOME/local/bin/rg
            rm -rf ripgrep-13.0.0-x86_64-unknown-linux-musl*
        fi
        
        # Install fd
        if ! command -v fd &> /dev/null; then
            echo "Installing fd (no sudo)..."
            curl -LO https://github.com/sharkdp/fd/releases/download/v8.4.0/fd-v8.4.0-x86_64-unknown-linux-musl.tar.gz
            tar -xzf fd-v8.4.0-x86_64-unknown-linux-musl.tar.gz
            cp fd-v8.4.0-x86_64-unknown-linux-musl/fd $HOME/local/bin/
            chmod +x $HOME/local/bin/fd
            rm -rf fd-v8.4.0-x86_64-unknown-linux-musl*
        fi
        
        # Ensure PATH is set
        echo 'export PATH="$HOME/local/bin:$PATH"' >> $HOME/.zshrc.local
    fi
fi

echo "===> neovim installation complete!"
echo "You can run 'nvim' to start using your configuration"