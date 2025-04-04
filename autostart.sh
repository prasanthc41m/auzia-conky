#!/bin/sh 
#sleep 5 
cd $HOME/.config/conky/ && conky -c conkyrc &>/dev/null
cd $HOME/.config/conky/ && conky -c conky.conf &>/dev/null
