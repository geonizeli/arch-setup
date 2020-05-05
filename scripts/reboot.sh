#!/bin/bash

echo "Reboot is needed to enable zsh"
echo "Want you reboot now? [Y/n]"

read var

if [ $var = "n" ];
then
    echo "Ok..."
else
    reboot
fi
