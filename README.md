# Auzia-conky

Auzia is a conky theme that displays system resources usage in rings.

## Screenshots

### For dark themes

##### monochrome dark

![monochrome dark](.github/monochrome_dark.jpg)

##### blue dark

![blue dark](.github/blue_dark.jpg)

***

### For light themes

##### monochrome light

![monochrome light](.github/monochrome_light.jpg)


##### blue light

![blue light](.github/blue_light.jpg)



More colors schemes are available. Choose a color from the `settings.lua` file and restart conky to take effect.

***

## Download and Launch Auzia

```
sudo dnf install conky # Fedora
sudo apt install conky # Debian
cd /tmp
git clone https://github.com/prasanthc41m/auzia-conky.git
cd auzia-conky
sudo chmod +x install.sh
./install.sh
cd && rm -rf /tmp/auzia-conky
```
After ```reboot``` you can see the conky.
```

Edit `settings.lua` to choose your network interface, Internet speed and other settings.

***

## Dependencies

- Conky 1.10+
- cairo
- imlib2

