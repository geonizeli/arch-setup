#!/bin/bash

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/denysdovhan/spaceship-prompt.git "\$ZSH_CUSTOM/themes/spaceship-prompt"

ln -s "\$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "\$ZSH_CUSTOM/themes/spaceship.zsh-theme"

echo 'ZSH_THEME="spaceship"' >> .zshrc