# Developer Setup

Automated setup scripts for various development environments on macOS.

## Available Setups

### React Native
Complete React Native development environment including:
- Homebrew
- Node.js (via nvm)
- Watchman
- CocoaPods
- Xcode Command Line Tools
- Android Studio & SDK
- Java JDK
- React Native CLI

**Install:**
```bash
./setup/react-native.sh
```

## Quick Start

```bash
# Clone the repository
git clone git@github.com:MichaelEakins/developer-setup.git
cd developer-setup

# Make scripts executable
chmod +x setup/*.sh

# Run the setup you need
./setup/react-native.sh
```

## Coming Soon
- Web Development (Node, npm/yarn, modern tooling)
- Python Development
- Go Development
- Docker & Kubernetes
- iOS Development
- Android Development
- Full Stack (combination of multiple setups)

## Structure

```
developer-setup/
├── README.md
├── setup/
│   ├── common.sh           # Shared utilities
│   ├── react-native.sh     # React Native setup
│   └── [more setups...]
```

## Requirements

- macOS (tested on macOS 10.15+)
- Admin access (some installations require sudo)
- Internet connection

## Contributing

Feel free to add more development environment setups or improve existing ones!
