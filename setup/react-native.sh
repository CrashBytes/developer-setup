#!/bin/bash

# React Native Development Environment Setup for macOS
# This script installs all necessary tools for React Native development

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source common utilities
source "$SCRIPT_DIR/common.sh"

# Check if running on macOS
check_macos

echo -e "${GREEN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║          React Native Development Setup                  ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

print_info "This script will install the following:"
echo "  • Homebrew (package manager)"
echo "  • Node.js via nvm (JavaScript runtime)"
echo "  • Watchman (file watching service)"
echo "  • CocoaPods (iOS dependency manager)"
echo "  • Xcode Command Line Tools"
echo "  • Java JDK (for Android)"
echo "  • Android Studio (optional)"
echo "  • React Native CLI"
echo ""

if ! confirm "Continue with installation?"; then
    print_info "Installation cancelled"
    exit 0
fi

# ============================================================================
# Homebrew Installation
# ============================================================================
print_section "Homebrew"
install_homebrew || exit 1

# Update Homebrew
print_info "Updating Homebrew..."
brew update

# ============================================================================
# Xcode Command Line Tools
# ============================================================================
print_section "Xcode Command Line Tools"
if xcode-select -p >/dev/null 2>&1; then
    print_success "Xcode Command Line Tools already installed"
else
    print_info "Installing Xcode Command Line Tools..."
    xcode-select --install
    print_warning "Please complete the Xcode Command Line Tools installation and run this script again"
    exit 0
fi

# ============================================================================
# Node.js via nvm
# ============================================================================
print_section "Node.js (via nvm)"

if command_exists nvm; then
    print_success "nvm already installed"
else
    print_info "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    
    # Load nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    print_success "nvm installed successfully"
fi

# Install latest LTS Node.js
print_info "Installing Node.js LTS..."
nvm install --lts
nvm use --lts
nvm alias default node

NODE_VERSION=$(node --version)
print_success "Node.js $NODE_VERSION installed"

# ============================================================================
# Watchman
# ============================================================================
print_section "Watchman"
brew_install watchman

# ============================================================================
# CocoaPods
# ============================================================================
print_section "CocoaPods"
if command_exists pod; then
    print_success "CocoaPods already installed"
else
    print_info "Installing CocoaPods..."
    sudo gem install cocoapods
    print_success "CocoaPods installed successfully"
fi

# ============================================================================
# Java JDK
# ============================================================================
print_section "Java JDK"

if command_exists java; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    print_success "Java already installed: $JAVA_VERSION"
else
    print_info "Installing Java JDK..."
    brew_install openjdk@17
    
    # Create symlink for system Java
    sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
    
    # Add to PATH
    echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
    export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
    
    print_success "Java JDK installed successfully"
fi

# ============================================================================
# Android Studio (Optional)
# ============================================================================
print_section "Android Studio"

if [ -d "/Applications/Android Studio.app" ]; then
    print_success "Android Studio already installed"
else
    if confirm "Install Android Studio? (Required for Android development)"; then
        brew_install android-studio true
        
        print_warning "Android Studio installed - Additional setup required:"
        echo "  1. Open Android Studio"
        echo "  2. Go through the setup wizard"
        echo "  3. Install Android SDK (API 33 or latest)"
        echo "  4. Install Android SDK Platform-Tools"
        echo "  5. Install Android Virtual Device (AVD)"
        echo ""
        echo "  Then add to ~/.zshrc:"
        echo '    export ANDROID_HOME=$HOME/Library/Android/sdk'
        echo '    export PATH=$PATH:$ANDROID_HOME/emulator'
        echo '    export PATH=$PATH:$ANDROID_HOME/platform-tools'
    else
        print_info "Skipping Android Studio installation"
    fi
fi

# ============================================================================
# React Native CLI
# ============================================================================
print_section "React Native CLI"

if command_exists react-native; then
    print_success "React Native CLI already installed"
else
    print_info "Installing React Native CLI..."
    npm install -g react-native-cli
    print_success "React Native CLI installed successfully"
fi

# ============================================================================
# Additional Tools (Optional)
# ============================================================================
print_section "Additional Tools"

if confirm "Install VS Code? (Recommended code editor)"; then
    brew_install visual-studio-code true
fi

if confirm "Install iTerm2? (Better terminal)"; then
    brew_install iterm2 true
fi

# ============================================================================
# Verification
# ============================================================================
print_section "Verification"

echo "Installed versions:"
echo "  Node: $(node --version)"
echo "  npm: $(npm --version)"
echo "  Watchman: $(watchman --version)"
echo "  CocoaPods: $(pod --version)"

if command_exists java; then
    echo "  Java: $(java -version 2>&1 | head -n 1)"
fi

if command_exists react-native; then
    echo "  React Native CLI: $(react-native --version 2>&1 | head -n 1)"
fi

# ============================================================================
# Next Steps
# ============================================================================
print_section "Setup Complete!"

print_success "React Native development environment is ready!"
echo ""
print_info "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"

if [ ! -d "/Applications/Android Studio.app" ]; then
    echo "  2. Install Android Studio for Android development"
fi

echo "  3. For iOS development, install Xcode from the App Store"
echo "  4. Create your first app: npx react-native init MyApp"
echo "  5. Run on iOS: cd MyApp && npx react-native run-ios"
echo "  6. Run on Android: cd MyApp && npx react-native run-android"
echo ""
print_warning "Note: You may need to restart your terminal for all changes to take effect"
echo ""
