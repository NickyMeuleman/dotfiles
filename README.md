# Dotfiles

## Housekeeping

First, fixing the weird things that annoy me.
Ranging from things that don't work correctly by default to things that are straight up broken without some intervention.

### More software

Since I'm on Fedora, I enabled [RPM Fusion](https://rpmfusion.org/).
And I set up [Flathub](https://flathub.org/nl/setup/Fedora).

I then also did the multimedia steps the RMP Fusion site has.
Apparently Fedora doesn't ship some media codecs you need to play a lot of videofiles.
https://rpmfusion.org/Howto/Multimedia

At this point, update all the things!
`sudo dnf update && sudo dnf upgrade`

### Audio

The audio was popping every time a sound starts playing similar to the sound you hear when you first plug in headphones.

To fix, I turned off power saving for the audio on my motherboard.

```sh
echo `options snd-hda-intel power_save=0` > /etc/modprobe.d/alsa-base.conf
```

### Login screen

There are 3 screens plugged into this computer:

- 2 PC monitors
- 1 TV

Either I use the 2 monitors, or the single TV.
No matter what, it showed the login screen on the TV, even when it was off.

To fix it I deleted the `~/.config/monitors.xml` file.
Then set up my monitors with the graphical Gnome tool (right click on the desktop followed by Display Settings).

This created that file again.
Then I made GDM (that's Gnome's login manager, in other words it's the screen with the password input when you boot) to use that file.

I copied the file that setting up the monitors created and made sure the `gdm` user and group owned that file.

```sh
sudo cp -v ~/.config/monitors.xml /var/lib/gdm/.config/ 
sudo chown gdm:gdm /var/lib/gdm/.config/monitors.xml
```

### Browser

Sadly, in Firefox my cursor went invisible if I dare to watch a YouTube video.
So I fell into old habits and used Google Chrome.

But the text of tab titles was blurry.

In the browser I went to `chrome://flags` and set the `Preferred Ozone platform` to `Wayland`.

### Build requirements

Similar to how I installed `build-essential` on WSL Ubuntu, Fedora needs some installed packages that are needed to build various pieces of software.

`sudo dnf install make automake gcc gcc-c++ kernel-devel cmake`