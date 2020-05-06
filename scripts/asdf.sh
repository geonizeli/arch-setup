#!/bin/bash

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.8

echo ".\$HOME/.asdf/asdf.sh" >> .zshrc
echo ".\$HOME/.asdf/asdf.sh" >> .bashrc