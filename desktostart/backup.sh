#!/bin/bash

backup_dir="${HOME}/backup_user";
config_dir="${HOME}";


# Crear carpeta de respaldo si no existe
if [ ! -d "$backup_dir" ]; then
    mkdir -p "$backup_dir";
fi

# Archivo de respaldo comprimido
backup_file="$backup_dir/config_backup_$(date +%Y%m%d_%H%M%S).tar.gz"

# Lista de archivos y carpetas de configuración a respaldar
config_files=(
    "${config_dir}/.bashrc"
    "${config_dir}/.profile"
    "${config_dir}/.vimrc"
    "${config_dir}/.ssh"
    "${config_dir}/.config/deluge"
    "${config_dir}/.config/dolphin-emu"
    "${config_dir}/.config/gtk-3.0"
    "${config_dir}/.config/gtk-4.0"
    "${config_dir}/.config/KDE"
    "${config_dir}/.config/kde.org"
    "${config_dir}/.config/kdedefaults"
    "${config_dir}/.config/menus"
    "${config_dir}/.config/plasma-workspace"
    "${config_dir}/.config/remmina"
    "${config_dir}/.config/solaar"
    "${config_dir}/.config/touchegg"
    "${config_dir}/.config/xsettingsd"
    "${config_dir}/.config/dolphinrc"
    "${config_dir}/.config/gtkrc"
    "${config_dir}/.config/gtkrc-2.0"
    "${config_dir}/.config/gwenviewrc"
    "${config_dir}/.config/katerc"
    "${config_dir}/.config/katerc"
    "${config_dir}/.config/kdeglobals"
    "${config_dir}/.config/kglobalshortcutsrc"
    "${config_dir}/.config/khotkeysrc"
    "${config_dir}/.config/plasmarc"
    "${config_dir}/.docker/"
    "${config_dir}/.vim/"
    "${config_dir}/.gnome/"
    "${config_dir}/.gitconfig"
    "${config_dir}/.gtkrc-2.0"
    "${config_dir}/.vscode-cli/"
    "${config_dir}/.local/share/applications"
    "${config_dir}/.local/share/kservices5"
    "${config_dir}/.local/share/konsole"
)

# Crear una copia de seguridad comprimida de los archivos y carpetas de configuración
tar -zcf "$backup_file" "${config_files[@]}";

echo "Copia de seguridad completada: $backup_file"

