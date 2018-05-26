#!/bin/bash

ln -sf $(pwd)/tmux/.tmux.conf ~/.tmux.conf
ln -sf $(pwd)/vim/.vimrc ~/.vimrc
ln -sf $(pwd)/zsh/.zshenv ~/.zshenv
ln -sf $(pwd)/zsh/.zshrc ~/.zshrc

ln -sf $(pwd)/osx-plist/localhost.add-sshagent.plist ~/Library/LaunchAgents/localhost.add-sshagent.plist
ln -sf $(pwd)/osx-plist/localhost.homebrew-upgrade.plist ~/Library/LaunchAgents/localhost.homebrew-upgrade.plist
ln -sf $(pwd)/osx-plist/localhost.anyenv-update.plist ~/Library/LaunchAgents/localhost.anyenv-update.plist
