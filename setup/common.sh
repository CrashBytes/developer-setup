#!/bin/bash

# Common utilities for all setup scripts

# Colors for output
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export RED='\033[0;31m'
export BLUE='\033[0;34m'
export NC='\033[0m' # No Color

# Print functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_section() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS only"
        exit 1
    fi
}

# Install Homebrew if not present
install_homebrew() {
    if command_exists brew; then
        print_success "Homebrew already installed"
        return 0
    fi
    
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    if [ $? -eq 0 ]; then
        print_success "Homebrew installed successfully"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        return 0
    else
        print_error "Failed to install Homebrew"
        return 1
    fi
}

# Install Homebrew package
brew_install() {
    local package=$1
    local cask=${2:-false}
    
    if [ "$cask" = true ]; then
        if brew list --cask "$package" >/dev/null 2>&1; then
            print_success "$package already installed"
            return 0
        fi
        print_info "Installing $package..."
        brew install --cask "$package"
    else
        if brew list "$package" >/dev/null 2>&1; then
            print_success "$package already installed"
            return 0
        fi
        print_info "Installing $package..."
        brew install "$package"
    fi
    
    if [ $? -eq 0 ]; then
        print_success "$package installed successfully"
        return 0
    else
        print_error "Failed to install $package"
        return 1
    fi
}

# Confirm action
confirm() {
    local prompt="$1"
    local default="${2:-y}"
    
    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n] "
    else
        prompt="$prompt [y/N] "
    fi
    
    read -p "$prompt" -n 1 -r
    echo
    
    if [ "$default" = "y" ]; then
        [[ ! $REPLY =~ ^[Nn]$ ]]
    else
        [[ $REPLY =~ ^[Yy]$ ]]
    fi
}
