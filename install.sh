#!/bin/sh
#
sudo dnf install conky -y
sudo apt install conky -y
cd /tmp/ && rm -rf auzia-conky && /tmp/conky-start.desktop && /usr/share/applications/conky-start.desktop && /usr/share/applications/conky-start.desktop
git clone https://github.com/prasanthc41m/auzia-conky.git
cd auzia-conky
mv $HOME/.config/conky conky-bak
mkdir $HOME/.config/conky
mkdir -p ~/.local/share/fonts
cp assets/* ~/.local/share/fonts
#
echo -e "[Desktop Entry] 
Type=Application
Exec=$HOME/.config/conky/autostart.sh 
Name=ConkyRound
Icon=$HOME/.config/conky/c41m.png
Categories=System;Monitor;
Terminal=false 
StartupNotify=true" > /tmp/conky-start.desktop
sudo mv /tmp/conky-start.desktop /usr/share/applications/
ln -s /usr/share/applications/conky-start.desktop  $HOME/.config/autostart/
#
mv * $HOME/.config/conky/
sudo chmod +x $HOME/.config/conky/autostart.sh
#
