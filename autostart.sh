#!/bin/sh 
#sleep 10
cd $HOME/.config/conky/ 
conky -q -d -c conky2.conf 
conky -q -d -c conky.conf 
bash autostart-rss.sh
