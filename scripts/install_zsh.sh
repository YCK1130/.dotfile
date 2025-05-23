#!/bin/bash
# install_zsh.sh - Install zsh and oh-my-zsh with minimal sudo privileges

set -e

# Define color codes
GREEN='\033[1;32m'  # Bold and green
YELLOW='\033[1;33m' # Bold and yellow
RED='\033[1;31m'    # Bold and red
NC='\033[0m'        # No Color

echo -e "${GREEN}===> Starting zsh and oh-my-zsh installation${NC}"

# Check and install zsh
if ! command -v zsh &> /dev/null; then
    echo -e "${GREEN}Installing zsh...${NC}"
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
            echo -e "${GREEN}Compiling and installing zsh locally...${NC}"
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
    echo -e "${GREEN}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}Oh My Zsh already installed${NC}"
fi

# Install powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo -e "${GREEN}Installing powerlevel10k theme...${NC}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install plugins
echo -e "${GREEN}Installing zsh plugins...${NC}"
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
    echo -e "${GREEN}Installing zoxide...${NC}"
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install zoxide
    elif [[ "$(uname)" == "Linux" ]]; then
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
fi

# Install eza (ls replacement)
if ! command -v eza &> /dev/null; then
    echo -e "${GREEN}Installing eza...${NC}"
    sh $HOME/.dotfile/rust/eza_install.sh
fi

# Install bat (cat replacement)
if ! command -v bat &> /dev/null; then
    echo -e "${GREEN}Installing bat...${NC}"
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
echo -e "${GREEN}Setting up zsh configuration...${NC}"
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
    echo -e "${GREEN}Setting zsh as default shell...${NC}"
    
    # First attempt with chsh
    if command -v chsh &> /dev/null; then
        echo -e "${YELLOW}Attempting to use chsh (you may be prompted for your password)...${NC}"
        if chsh -s $(which zsh); then
            echo -e "${GREEN}Successfully set zsh as default shell!${NC}"
        else
            echo -e "${RED}Failed to set zsh as default shell using chsh.${NC}"
            echo -e "${YELLOW}Alternative methods to set zsh as default shell:${NC}"
            
            # Check if we're on macOS
            if [[ "$(uname)" == "Darwin" ]]; then
                echo -e "1. Open System Preferences → Users & Groups → Right-click on your account → Advanced Options → Change login shell to $(which zsh)"
            fi
            
            echo -e "2. Add this line to your ~/.bash_profile or ~/.profile:"
            echo -e "   ${GREEN}[ -f $(which zsh) ] && exec $(which zsh) -l${NC}"
            
            # Create a setup file for alternative shell change
            echo "#!/bin/bash" > $HOME/.set_zsh_shell.sh
            echo "# This script will help you set zsh as your default shell" >> $HOME/.set_zsh_shell.sh
            echo "[ -f $(which zsh) ] && exec $(which zsh) -l" >> $HOME/.set_zsh_shell.sh
            chmod +x $HOME/.set_zsh_shell.sh
            
            echo -e "3. Run this command to try again with sudo (if you have sudo access):"
            echo -e "   ${GREEN}sudo chsh -s $(which zsh) $USER${NC}"
            
            echo -e "\nA helper script has been created at $HOME/.set_zsh_shell.sh"
            echo -e "You can add its contents to your ~/.bash_profile or ~/.profile"
        fi
    else
        echo "chsh command not found. Please set your default shell manually:"
        echo "1. Add the following line to your ~/.bash_profile or ~/.profile:"
        echo "   [ -f $(which zsh) ] && exec $(which zsh) -l"
    fi
fi

# Add zsh init to bash_profile for users who can't change their login shell
if [[ "$(uname)" == "Darwin" ]] && [[ "$SHELL" != *"zsh"* ]]; then
    echo -e "${YELLOW}Adding zsh initialization to .bash_profile as a fallback...${NC}"
    if [ -f "$HOME/.bash_profile" ]; then
        if ! grep -q "exec zsh" "$HOME/.bash_profile"; then
            echo -e "\n# Start zsh if it exists" >> "$HOME/.bash_profile"
            echo "[ -f $(which zsh) ] && exec $(which zsh) -l" >> "$HOME/.bash_profile"
        fi
    else
        echo "# Start zsh if it exists" > "$HOME/.bash_profile"
        echo "[ -f $(which zsh) ] && exec $(which zsh) -l" >> "$HOME/.bash_profile"
    fi
    echo -e "${GREEN}Added zsh initialization to .bash_profile${NC}"
fi

# Ensure zoxide initialization is in .zshrc
if ! grep -q "zoxide init" "$HOME/.zshrc"; then
    echo -e "${YELLOW}Adding zoxide initialization to .zshrc...${NC}"
    echo 'eval "$(zoxide init zsh)"' >> "$HOME/.zshrc"
    echo -e "${GREEN}Added zoxide initialization${NC}"
fi

echo -e "${GREEN}===> zsh and oh-my-zsh installation complete!${NC}"
echo -e "${GREEN}Please restart your terminal or run 'source ~/.zshrc' to apply changes${NC}"
if [[ "$SHELL" != *"zsh"* ]]; then
    echo -e "${YELLOW}To start using zsh right now, simply type: ${GREEN}zsh${NC}"
fi