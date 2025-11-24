#!/bin/bash

backup_config() {
    local app=$1
    if [ -d "$HOME/.config/$app" ] && [ ! -L "$HOME/.config/$app" ]; then
        echo "Создаю бэкап $app..."
        mv "$HOME/.config/$app" "$HOME/.config/${app}.backup.$(date +%Y%m%d)"
    fi
}

CONFIG_SRC="../config"
CONFIG_DEST="$HOME/.config"

echo "Установка конфигураций NERV-OS..."

for app in dunst fastfetch hypr kitty nvim wofi; do
    if [ -d "$CONFIG_SRC/$app" ]; then
        backup_config "$app"
        echo "Копирую $app..."
        cp -r "$CONFIG_SRC/$app" "$CONFIG_DEST/"
    fi
done

echo "Установка завершена!"
