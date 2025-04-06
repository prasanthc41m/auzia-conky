#!/bin/sh 
sleep 10
cd $HOME/.config/conky/ 
conky -c conkyrc &>/dev/null
conky -c conky.conf &>/dev/null
