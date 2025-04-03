#!/bin/sh
#
git clone https://github.com/prasanthc41m/auzia-conky.git
cd auzia-conky
mkdir $HOME/.config/conky
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
gsettings set org.gnome.desktop.background picture-uri file:$HOME/.config/conky/spiderman.jpg
gsettings set org.gnome.desktop.background picture-uri-dark file:$HOME/.config/conky/spiderman.jpg
