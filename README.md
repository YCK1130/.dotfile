# Personal Dotfiles

This repository contains my personal dotfiles for setting up a development environment with:

- **tmux**: Terminal multiplexer with [Oh My Tmux](https://github.com/gpakosz/.tmux)
- **zsh**: Shell with [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- **neovim**: Text editor with custom configuration

## 🔧 Quick Installation

Clone this repository to your home directory:

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfile
```

Run the installer:

```bash
cd ~/.dotfile
chmod +x ./scripts/install.sh
./scripts/install.sh
```

The installer will guide you through the setup process and let you choose which components to install.

## ✨ Features

### tmux Configuration
- Based on [Oh My Tmux](https://github.com/gpakosz/.tmux)
- Improved key bindings
- Enhanced status bar
- Mouse mode enabled
- Copy mode improvements

### zsh Configuration
- Powered by [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
- Useful plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - zsh-history-substring-search
  - zoxide for smart directory navigation
  - and more!

### neovim Configuration
- Modern Neovim setup with Lua configuration
- Carefully selected plugins for development
- LSP support for various languages
- Telescope for fuzzy finding
- Treesitter for better syntax highlighting
- Custom key mappings for improved workflow

## 📋 Manual Installation

If you prefer to install components individually:

### tmux
```bash
chmod +x ~/.dotfile/scripts/install_tmux.sh
~/.dotfile/scripts/install_tmux.sh
```

### zsh & Oh My Zsh
```bash
chmod +x ~/.dotfile/scripts/install_zsh.sh
~/.dotfile/scripts/install_zsh.sh
```

### neovim
```bash
chmod +x ~/.dotfile/scripts/install_nvim.sh
~/.dotfile/scripts/install_nvim.sh
```

## 🔍 Customization

### Local Configuration
- `~/.zshrc.local`: Add your custom zsh configurations here
- `~/.tmux.conf.local`: Customize your tmux settings
- For Neovim, modify files in `~/.dotfile/nvim/lua/custom/`

## 🛠 Requirements

### For macOS:
- Homebrew for package installation
- Git

### For Linux:
- Git
- Basic build tools if compiling locally (gcc, make)
- Alternatively, sudo access for package installation

## 📝 Notes

- The installation scripts provide options for installing without sudo privileges
- On Linux, you can choose between system packages or local compilation
- The installer will back up your existing configurations

## 🙏 Acknowledgements

- [Oh My Tmux](https://github.com/gpakosz/.tmux)
- [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)