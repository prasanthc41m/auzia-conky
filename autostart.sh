#!/bin/sh 
sleep 15
cd $HOME/.config/conky/ && conky -c conkyrc &>/dev/null
cd $HOME/.config/conky/ && conky -c conky.conf &>/dev/null
