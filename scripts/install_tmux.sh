#!/bin/bash
# install_tmux.sh - Install tmux configuration without sudo privileges

set -e
echo "===> Starting tmux installation and configuration"

# Check and install tmux (using Homebrew or local installation)
if ! command -v tmux &> /dev/null; then
    echo "Installing tmux..."
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install tmux
    elif [[ "$(uname)" == "Linux" ]]; then
        # If user doesn't have sudo privileges, try local installation
        echo "Please choose installation method:"
        echo "1) Use system package manager (may require sudo)"
        echo "2) Compile locally (no sudo required)"
        read -p "Choose [1/2]: " install_choice
        
        if [ "$install_choice" == "1" ]; then
            sudo apt-get update
            sudo apt-get install -y tmux
        else
            # Local compilation
            mkdir -p $HOME/local
            cd $HOME/local
            
            # Install dependencies
            if ! command -v libevent-config &> /dev/null; then
                echo "Installing libevent..."
                wget https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
                tar -xzvf libevent-2.1.12-stable.tar.gz
                cd libevent-2.1.12-stable
                ./configure --prefix=$HOME/local
                make && make install
                cd ..
            fi
            
            # Install ncurses
            if [ ! -d "$HOME/local/include/ncurses" ]; then
                echo "Installing ncurses..."
                wget https://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.2.tar.gz
                tar -xzvf ncurses-6.2.tar.gz
                cd ncurses-6.2
                ./configure --prefix=$HOME/local
                make && make install
                cd ..
            fi
            
            # Install tmux
            echo "Installing tmux..."
            wget https://github.com/tmux/tmux/releases/download/3.2a/tmux-3.2a.tar.gz
            tar -xzvf tmux-3.2a.tar.gz
            cd tmux-3.2a
            ./configure --prefix=$HOME/local CFLAGS="-I$HOME/local/include" LDFLAGS="-L$HOME/local/lib"
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

# Install Oh My Tmux
echo "Installing Oh My Tmux..."
if [ -d "$HOME/.tmux" ]; then
    echo "Updating existing .tmux..."
    cd $HOME/.tmux
    git pull
else
    echo "Cloning .tmux repository..."
    git clone https://github.com/gpakosz/.tmux.git $HOME/.tmux
fi

# Create symbolic link
ln -sf $HOME/.tmux/.tmux.conf $HOME/.tmux.conf

# Copy our custom tmux.conf.local to the correct location or use default
if [ -f "$HOME/.dotfile/tmux/.tmux.conf.local" ]; then
    echo "Applying custom tmux configuration..."
    cp $HOME/.dotfile/tmux/.tmux.conf.local $HOME/
else
    echo "Using default .tmux.conf.local..."
    cp $HOME/.tmux/.tmux.conf.local $HOME/
    # Make sure directory exists
    mkdir -p "$HOME/.dotfile/tmux"
    cp $HOME/.tmux/.tmux.conf.local $HOME/.dotfile/tmux/
fi

echo "===> tmux installation complete!"
echo "You can restart your terminal to apply changes"