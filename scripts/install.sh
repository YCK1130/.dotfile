#!/bin/bash
# Main installation script - Install all dotfiles configurations

set -e
echo "===> Starting personal development environment setup..."

# Set directory
DOTFILE_DIR="$HOME/.dotfile"
cd $DOTFILE_DIR

# Ensure scripts have execution permissions
chmod +x $DOTFILE_DIR/scripts/install_tmux.sh
chmod +x $DOTFILE_DIR/scripts/install_zsh.sh
chmod +x $DOTFILE_DIR/scripts/install_nvim.sh

# Ask user which modules to install
echo "Please select which modules to install:"
echo "1) Install all (tmux, zsh/oh-my-zsh, neovim)"
echo "2) Install tmux only"
echo "3) Install zsh and oh-my-zsh only"
echo "4) Install neovim only"
read -p "Enter option [1-4]: " CHOICE

case $CHOICE in
    1)
        echo "Installing all modules..."
        $DOTFILE_DIR/scripts/install_tmux.sh
        $DOTFILE_DIR/scripts/install_zsh.sh
        $DOTFILE_DIR/scripts/install_nvim.sh
        ;;
    2)
        echo "Installing tmux only..."
        $DOTFILE_DIR/scripts/install_tmux.sh
        ;;
    3)
        echo "Installing zsh and oh-my-zsh only..."
        $DOTFILE_DIR/scripts/install_zsh.sh
        ;;
    4)
        echo "Installing neovim only..."
        $DOTFILE_DIR/scripts/install_nvim.sh
        ;;
    *)
        echo "Invalid option, exiting installation"
        exit 1
        ;;
esac

echo ""
echo "===> Installation complete!"
echo "Please restart your terminal to apply all changes, or run 'source ~/.zshrc' to apply zsh configuration immediately."
echo "Thank you for using this installer!"