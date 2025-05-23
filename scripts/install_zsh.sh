#!/bin/bash
# install_zsh.sh - Install zsh and oh-my-zsh with minimal sudo privileges

set -e
echo "===> Starting zsh and oh-my-zsh installation"

# Check and install zsh
if ! command -v zsh &> /dev/null; then
    echo "Installing zsh..."
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install zsh
    elif [[ "$(uname)" == "Linux" ]]; then
        # Provide options to the user
        echo "Please choose installation method:"
        echo "1) Use system package manager (may require sudo)"
        echo "2) Compile locally (no sudo required)"
        read -p "Choose [1/2]: " install_choice
        
        if [ "$install_choice" == "1" ]; then
            sudo apt-get update
            sudo apt-get install -y zsh
        else
            # Local compilation
            mkdir -p $HOME/local
            cd $HOME/local
            
            # Install zsh
            echo "Compiling and installing zsh locally..."
            wget https://www.zsh.org/pub/zsh-5.8.tar.xz
            tar -xf zsh-5.8.tar.xz
            cd zsh-5.8
            ./configure --prefix=$HOME/local
            make && make install
            
            # Add to PATH
            echo 'export PATH="$HOME/local/bin:$PATH"' >> $HOME/.zshrc.local
            export PATH="$HOME/local/bin:$PATH"
        fi
    else
        echo "Unsupported operating system"
        exit 1
    fi
fi

# Create .zshrc.local if it doesn't exist
if [ ! -f "$HOME/.zshrc.local" ]; then
    touch $HOME/.zshrc.local
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed"
fi

# Install powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Installing powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install plugins
echo "Installing zsh plugins..."
# zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# zsh-history-substring-search
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search" ]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
fi

# Install common tools: try to avoid using sudo
# Install zoxide
if ! command -v zoxide &> /dev/null; then
    echo "Installing zoxide..."
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install zoxide
    elif [[ "$(uname)" == "Linux" ]]; then
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
fi

# Install eza (ls replacement)
if ! command -v eza &> /dev/null; then
    echo "Installing eza..."
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install eza
    elif [[ "$(uname)" == "Linux" ]]; then
        # Download precompiled binary
        mkdir -p $HOME/local/bin
        curl -sSL https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar -xz -C $HOME/local/bin
        echo 'export PATH="$HOME/local/bin:$PATH"' >> $HOME/.zshrc.local
    fi
fi

# Install bat (cat replacement)
if ! command -v bat &> /dev/null; then
    echo "Installing bat..."
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install bat
    elif [[ "$(uname)" == "Linux" ]]; then
        # Download precompiled binary
        mkdir -p $HOME/local/bin
        curl -sSL https://github.com/sharkdp/bat/releases/download/v0.18.3/bat-v0.18.3-x86_64-unknown-linux-gnu.tar.gz | tar -xz --strip-components=1 -C $HOME/local/bin bat-v0.18.3-x86_64-unknown-linux-gnu/bat
        chmod +x $HOME/local/bin/bat
    fi
fi

# Copy configuration files
echo "Setting up zsh configuration..."
cp $HOME/.dotfile/zsh/.zshrc $HOME/
# If .zshrc.local exists in .dotfile, copy it
if [ -f "$HOME/.dotfile/zsh/.zshrc.local" ]; then
    cp $HOME/.dotfile/zsh/.zshrc.local $HOME/
fi

# Set up p10k configuration
if [ -f "$HOME/.dotfile/zsh/.p10k.zsh" ]; then
    cp $HOME/.dotfile/zsh/.p10k.zsh $HOME/
elif [ ! -f "$HOME/.p10k.zsh" ]; then
    echo "p10k will be configured automatically on next login..."
fi

# Try to set zsh as default shell without using sudo
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "Setting zsh as default shell..."
    if command -v chsh &> /dev/null; then
        chsh -s $(which zsh)
    else
        echo "Cannot automatically set zsh as default shell. After installation, please run:"
        echo "chsh -s $(which zsh)"
    fi
fi

echo "===> zsh and oh-my-zsh installation complete!"
echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes"