#!/bin/bash
# Main installation script - Install all dotfiles configurations

set -e

# Define color codes
GREEN='\033[1;32m'  # Bold and green
NC='\033[0m'        # No Color

echo -e "${GREEN}===> Starting personal development environment setup...${NC}"

# Set directory
DOTFILE_DIR="$HOME/.dotfile"
cd $DOTFILE_DIR

# Ensure scripts have execution permissions
chmod +x $DOTFILE_DIR/scripts/install_tmux.sh
chmod +x $DOTFILE_DIR/scripts/install_zsh.sh
chmod +x $DOTFILE_DIR/scripts/install_nvim.sh

# Ask user which modules to install
echo -e "${GREEN}Please select which modules to install:${NC}"
echo "1) Install all (tmux, zsh/oh-my-zsh, neovim)"
echo "2) Install tmux only"
echo "3) Install zsh and oh-my-zsh only"
echo "4) Install neovim only"
read -p "Enter option [1-4]: " CHOICE

case $CHOICE in
    1)
        echo -e "${GREEN}Installing all modules...${NC}"
        $DOTFILE_DIR/scripts/install_tmux.sh
        $DOTFILE_DIR/scripts/install_zsh.sh
        $DOTFILE_DIR/scripts/install_nvim.sh
        ;;
    2)
        echo -e "${GREEN}Installing tmux only...${NC}"
        $DOTFILE_DIR/scripts/install_tmux.sh
        ;;
    3)
        echo -e "${GREEN}Installing zsh and oh-my-zsh only...${NC}"
        $DOTFILE_DIR/scripts/install_zsh.sh
        ;;
    4)
        echo -e "${GREEN}Installing neovim only...${NC}"
        $DOTFILE_DIR/scripts/install_nvim.sh
        ;;
    *)
        echo "Invalid option, exiting installation"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}===> Installation complete!${NC}"
echo -e "${GREEN}Please restart your terminal to apply all changes, or run 'source ~/.zshrc' to apply zsh configuration immediately.${NC}"
echo -e "${GREEN}Thank you for using this installer!${NC}"