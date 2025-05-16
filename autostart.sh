#!/bin/sh 
#sleep 10
cd $HOME/.config/conky/ 
#conky -q -d -c conky2.conf
#pkill conky
#conky -q -d -c conky2.conf
conky -q -d -c conky.conf 
conky -q -d -c conky_date_time.conf

