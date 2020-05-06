#!/bin/bash

sudo pacman -S snapd

sudo systemctl enable --now snapd

sudo ln -s /var/lib/snapd/snap /snap