# Programs to install

## Windows (chocolatey)

+ 360 total security (360ts for chocolatey)
+ malwarebytes
+ eclipse
+ Visual Studio Code
+ git
+ subversion
+ chrome
+ firefox
+ notepad++

## MSYS2

+ geany and geany plugins
+ clang
+ base-devel
+ git
+ subversion
+ python (both of them)
+ lldb
+ gdb
+ lld
+ vim (usually installed)
+ ninja
+ cmake
+ cppcheck

## Linux

+ eclipse
+ visual studion code
+ geany and geany plugins
+ clang
+ base-devel
+ git
+ subversion
+ lldb
+ gdb
+ cppcheck
+ wine
+ rust?
+ lld
+ vim (maybe installed)
+ ninja
+ cmake

##### Not as crucial

+ Photo editing : Gimp
+ Video editing : Shotcut
+ Audio editing : Audacity

# Firefox

go to  `about:config` and set
`browser.link.open_newwindow` = 3
and `browser.link.open_newwindow.restriction` = 0
and set `services.sync.prefs.X` with X as the service name to sync that setting.

# Linux tweaks

## Preferred keybinds

 + Win + Enter starts terminal
 + Win + arrow key tiles windows
 + Win + q closes a program
 + Win + d opens a menu to search for programs
 + Win + i opens a web browser
 + Win + f opens a file manager.
 + Win + s can do another type of program search
 + Win + 1,2,3 goes to workspace 1,2,3
 + Win + Shift + 1,2,3 moves a window to workspace 1,2,3

## Openbox

### Changing keybinds

Change `.config/openbox/lxqt-rc.xml`

Run `openbox --reconfigure` to apply settings.

OR 

Download and install Obkey.

### Screen tearing

Autostart compton (install it first) with the flags `--backend glx --paint-on-overlay --vsync opengl-swc`

## File Open dialog is too big

Change the `GeometryWidth` and `Geom:etryHeight` entries in `.config/gtk-2.0/gtkfilechooser.ini`

## Changing gtk themes on LXQt

Install lxappearance and use it. (lightest option I found that works)

## Input

### Touchpad tap to Click

Make a file: `/etc/X11/xorg.conf.d/30-touchpad.conf`

Paste this in it:
```
Section "InputClass"
    Identifier "devname"
    Driver "libinput"
    Option "Tapping" "on"
EndSection
```

### Disable touch screen on boot

find this section in `/usr/share/X11/xorg.conf.d/10-evdev.conf` 

```
Section "InputClass"
        Identifier "evdev touchscreen catchall"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection
```
and change it to this

```
Section "InputClass"
    	Identifier "evdev touchscreen catchall"
        MatchIsTouchscreen "on"
        Driver "evdev"
	Option "Ignore" "true"
EndSection
```

### makepkg flags/settings (arch-specific)

Go to `/etc/makepkg.conf` and change `makeflags` to `-j4` and C and CXX flags to `-march=native` and `-mtune=native` 

# Linux optimizations

### Lower boot time

Disable services on startup. The fedora section has my personal list

### Speed up shutdown

Change these settings in `/etc/systemd/system.conf`
```
DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s
```
### Change I/O scheduler

To see the sceduler (for /dev/sda): `cat /sys/block/sda/queue/scheduler`
The bracketed option is the current scheduler.

To change the scheduler, use `su` to get superuser status.
Then do: `echo scheduler-name > /sys/block/sda/queue/scheduler`

#### Enable multi-queue schedulers

Add `GRUB_CMDLINE_LINUX="scsi_mod.use_blk_mq=1"` to `/etc/default/grub` and do `sudo grub-mkconfig -o /boot/grub/grub.cfg` or `sudo update-grub` or `sudo grub2-mkconfig -o /boot/grub2/grub.cfg`.

#### Change Scheduler permanently

Add a `elevator=schedulername` entry to the `GRUB_CMDLINE_LINUX_DEFAULT=` line.

#### Permanently change scheduler

Create udev rule in `/etc/udev/rules.d/60-schedulers.rules` and paste in this in that file:
```
# set scheduler for rotating disks
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

#set scheduler for non-rotating disks
ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*|nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
```

## Useful Commands/tools

See if fsck was run `sudo tune2fs -l /dev/sda6 | grep Last\ c`

List loaded services `systemctl list-unit-files | grep enabled`

### Disabling Services

Use `systemctl disable service-name.service`

Masking (stronger disable) `sudo systemctl mask service-name.service`

### Enabling services

Enable: `sudo systemctl enable service-name.service` 

Unmasking: `sudo systemctl unmask service-name.service`

OR

reinstall service/package or delete symlink `/lib/systemd/system/service-name.service`
Then run sudo systemctl `daemon-reload`
To check is symlink goes to /dev/null sudo file `/lib/systemd/system/service-name.service`

### Boot analysis

Display time to load each service `systemd-analyze blame`

Show last boot times and stats `systemd-analyze`

Plot service load times `systemd-analyze plot > boot.svg`

Show dependencies and delay relationships `systemd-analyze critical-chain`

## Fedora-specific tweaks

Get rid of old kernels. `dnf remove $(dnf repoquery --installonly --latest-limit 2 -q)`

The number is the number of kernels that should be left.

OR

Set kernel limit in `/etc/dnf/dnf.conf` as such `installonly_limit=2`

### Set up qemu-kvm

Install libvirt qemu-kvm and virt-manager 

Start the libvirtd service and enable it.

Use virt-manager to make the machine.

Add `intel_iommu=on` to `GRUB_CMDLINE_LINUX` in `/etc/default/grub`.

Update grub (fedora) `grub2-mkconfig -o /boot/grub2/grub.cfg`

Add a PCI device in virt-manager.

#### File sharing Linux host Windows Guest.

Go to the folder that you want to share on your guest and go to its properties and share it to everyone. 

Then get the IP address of your Windows guest from control panel. 

Then use `smb://ip-of-guest/foldername` in your file manager on Linux to access that folder.

### Install broadcom-wl (Fedora 27/28) 

`sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm`

`sudo dnf update`

`sudo dnf install broadcom-wl`

### Install rawhide package

`sudo dnf install fedora-repos-rawhide`

`sudo dnf  install --enablerepo rawhide`

#### Upgrade from rawhide

`sudo dnf --enablerepo rawhide upgrade package-name`

### Install google chrome

`sudo dnf install fedora-workstation-repositories`

`sudo dnf config-manager --set-enabled google-chrome`

`sudo dnf install google-chrome-stable`

### Boot time reduction (Fedora-specific)

Consider removing `/var/log/journal` or renaming it.

Disable plymouth boot screen `sudo dnf remove plymouth`

Please note that not all these options were tested.

Services I disabled (I am not responsible for you FUBARing your system):

+ dkms.servce
+ ModemManager.service
+ akms.service
+ NetworkManager-wait-online.service
+ lvm2-monitor.service
+ fedora-readonly.service
+ livesys-late.service
+ livesys.service

Services you might not want to disable/mask (but I did anyway)

+ firewalld.service (dynamic firewall)
+ rtkit-daemon.service (not much benefit disabling)
+ systemd-journal-flush.service
+ gssproxy.service  (security?, can be uninstalled)
+ udisks2.service (external drive automounting)
+ systemd-rfkill.service (disabling radios)
+ systemd-modules-load.service (it was failing anyway)
+ mlocate-updatedb.service (you can remove by removing mlocate package)


### Arch Specific 

Change makepkg flags (especially MAKEFLAGS) in `/etc/makepkg.conf`

Masked for boot:

+ lvm2-monitor.service

Disabled for boot:

+ ModemManager.service
+ bluetooth.service
