# Cheatsheet

## temporarily add current directory to executable path

`PATH="$(pwd):$PATH"`

## temporarily change editor for commands

`EDITOR=nano crontab -e`

## Increase fontsize in tty terminals

On high dpi monitors raw tty views might be too small to read and without provided / providing font files you can not adjust font size on the fly. But you can at least always double the fontsize (once) with `setfont -d`.

## Look at the previous boot's logs from the end

- `journalctl -b -1 -e` might be able to find a reason for unsuspected shutdown / reboot
- if `last reboot` shows "still running" the system probably crashed

## SDDM (with KWin and Wayland)

- multiple monitors -> both greet and lock screens get seemingly duplicated but have different inputs that get synced, leads to various weird behaviours
  - solution:
    - KDE System Settings / Colors & Themes / Login Screen ->  "Apply Plasma Settings"
    - or manually copy and overwrite `~/.config/kwinoutputconfig.json` to `/var/lib/sddm/.config/kwinoutputconfig.json`
- scaling in first login screen:
  - create `/etc/sddm.conf/hidpi.conf`
  - add:
    ```
    [Wayland]
    EnableHiDPI=true
    
    [X11]
    EnableHiDPI=true
        
    [General]
    GreeterEnvironment=QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192
    ```
 
## KDE

- most settings are in `~/.config/`
- some settings, espeically UI (toolbar) configurations are done via KDE's XML-based GUI system, kxmlgui, and are located at `~/.local/share/kxmlgui5`

### Decrease delay to show tooltips on hover
- `kwriteconfig6 --file ~/.config/plasmarc --group PlasmaToolTips --key Delay 1`
- or: add this to ~/.config/plasmarc:
  ```
  [PlasmaToolTips]
  Delay=1
  ```
- in both cases, the Delay is set in milliseconds

### Krunner

#### Increase font size

- You can override the system wide fontsetting
- Add this to `~/.config/krunnerrc`
  ```
  [General]
  font=Noto Sans,12,-1,5,50,0,0,0,0,0
  ```

#### Change position / size of krunner window
TODO

#### Dim / Blur rest of screen when opening krunner
TODO

## Qt

### Qfont

- https://code.qt.io/cgit/qt/qtbase.git/tree/src/gui/text/qfont.cpp#n2130
- example: font=Noto Sans,12,-1,5,50,0,0,0,0,0
- structure:
  - Font family
  - Point size
  - Pixel size
  - Style hint
  - Font weight
  - Font style
  - Underline
  - Strike out
  - Fixed pitch
  - Always \e{0}
  - Capitalization
  - Letter spacing
  - Word spacing
  - Stretch
  - Style strategy
  - Font style (omitted when unavailable) 

## VSCode

### Restore all windows and open / unsaved editors

You want this:

```json
"files.hotExit": "onExitAndWindowClose",
"window.restoreWindows": "preserve",
```

Default: Only restore last active window and all it's editors. Lose everything else, including unsaved editors in all other windows!

```json
"files.hotExit": "onExit",
"window.restoreWindows": "all",
```

## FIREFOX

Add `media.cubeb.backend` with value `alsa` to avoid jumping volume on application streams with pulseaudio on pipewire.

Disable resource hogging bullshit sandbox: Set `media.rdd-process.enabled` to `false`.

### Shortcuts to remember

- (Ctrl+L) / Enter adress bar and type `% ` to search all open tabs
- Ctrl+Shift+T to reopen closed tab

## BTOP

- Install system package `libcap-progs`
- Enable GPU monitoring in user mode: `sudo setcap cap_perfmon=+ep /usr/local/bin/btop`
- TODO: This only adds gpu name and clock speed to both cpu (1) and gpu (5) modules. Still missing, compared to btop as superuser:
  - Package Temperature
  - Load Percentage
  - Power Draw (Watts)

## KVM, QEMU, virt manager on openSUSE Tumbleweed

### setup

0. check hardware virtualization:  grep -E -c '(vmx|svm)' /proc/cpuinfo
1. install tools: zypper install patterns-server-kvm_server patterns-server-kvm_tools
2. install kvm: zypper install qemu libvirt virt-manager
3. enable kvm: sudo systemctl enable libvirtd (start on every startup)
4. start kvm: sudo systemctl start libvirtd (start now)
5. add network bridge: nmcli con add type bridge con-name br0 ifname br0
6. add network bridge: nmcli con add type bridge-slave con-name eth0-slave ifname eth0 master br0
7. activate network bridge: nmcli con up br0
8. firewall add libvirtd to allowed devices: firewall-cmd --permanent --zone=public --add-service=libvirt
9. firewall apply / restart: firewall-cmd --reload

### Error "Network 'default' is not active" when starting vm

1. Does network default exist? `sudo virsh net-list --all`
2. Start network default
    1. once `sudo virsh net-start default`
    2. from now on `sudo virsh net-autostart default`

### configuration in Virtual Machine Manager

#### Video Virtio

```xml
<video>
  <model type="virtio" heads="1" primary="yes">
    <acceleration accel3d="yes"/>
    <resolution x="2880" y="1920"/>
  </model>
  <address type="pci" domain="0x0000" bus="0x00" slot="0x01" function="0x0"/>
</video>
```

#### Display Spice

```xml
<graphics type="spice">
  <listen type="none"/>
  <image compression="off"/>
  <gl enable="yes" rendernode="/dev/dri/by-path/pci-0000:00:02.0-render"/>
</graphics>
```

## WAYLAND

### Screen sharing

- needs pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-kde6
- this lets you share any (wayland!) application from kde and flatpak
- maybe additionally you need xdg-desktop-portal-gtk xdg-desktop-portal-wlr
- for x11 applications running on xwayland you need to setup <https://invent.kde.org/system/xwaylandvideobridge>

### scaling and dpi considerations

180% goldilocks in between 14/16 and dpi? also 180% has roughly fhd@15.6 dpi. this was used everywhere for almost a decade.

200% mbp dpi, everything smaller makes it slightly tiresome and active to read / identify details. Maybe Apple is on to something here...

Considering dpi: Apple pairs 127dpi MBP with 216-218dpi (= effective 108-109dpi at 200%) Studio / Pro displays.

```plaintext
framework 13.5 2880x1920
1440x 960   (2.00)   128dpi    mbp dpi
1477x 985   (1.95)   132dpi    
1516x1011   (1.90)   135dpi    mbp 14 space
1557x1038   (1.85)   139dpi    
1600x1067   (1.80)   142dpi
1646x1097   (1.75)   147dpi
1694x1130   (1.70)   151dpi    mbp 16 space

framework 16.0 2560x1600
1280x 800   (2.00)    94dpi
1313x 821   (1.95)    97dpi
1347x 842   (1.90)    99dpi
1384x 865   (1.85)   102dpi
1422x 889   (1.80)   105dpi
1463x 914   (1.75)   108dpi
1506x 941   (1.70)   111dpi    mbp 14 space
1552x 970   (1.65)   114dpi
1600x1000   (1.60)   118dpi
1652x1032   (1.55)   122dpi
1707x1067   (1.50)   126dpi    mbp dpi + mbp 16 space
1766x1103   (1.45)   130dpi
1829x1143   (1.40)   135dpi
1896x1185   (1.35)   140dpi
1969x1231   (1.30)   145dpi

mbp 14.2 3024x1964
1512x982    (2.00)   127dpi

mbp 16.2 3456x2234
1728x1117   (2.00)   127dpi
```

```plaintext
generic 16.0 2560x1600
1280x 800   (2.00)    94dpi    standard monitor dpi (94-98)
1313x 821   (1.95)    97dpi
1347x 842   (1.90)    99dpi
1384x 865   (1.85)   102dpi
1422x 889   (1.80)   105dpi
1463x 914   (1.75)   108dpi

ASUS ProArt PA348CGV 34.0 3440x1440
2991x1252   (1.15)    95dpi
3127x1309   (1.10)   100dpi
3276x1371   (1.05)   105dpi
3440x1440   (1.00)   110dpi

Eizo FlexScan S2134 21.3 1600x1200
1600x1200   (1.00)    94dpi 

apple pro display
3013x1692   (2.00)   108dpi
```

### Display Settings KDE

In any case: Allow screen tearing in fullscreen windows for better gaming performance and no drawbacks on the desktop via the .config/kwinrc setting:

```shell
[Compositing]
AllowTearing=false
```

Also: Adaptive Sync: Never!

#### How to deal with X11 applications

- Option 1: Apply scaling themselves, if they can do that. **No scaling otherwise.** Provide a scaling factor that matches your global scaling (180% = 1.8) for the Xwayland server in .config/kwinrc:

  ```shell
  [Xwayland]
  Scale=1.8
  ```

- Option 2: Always Scaled by the system. **Blurry per default.**
  - Workarounds:
    - Chrome / Chromium: Go to chrome://flags/ and set "Preferred Ozone platform" flag to "Wayland".
    - Visual Studio Code / Codium: Pass command line argument on startup `--ozone-platform=wayland`. Sadly, this is not yet possible internally and permanently / allowed via argv.json
  - Problems:
    - VLC has no workaround
    - Steam has no workaround

### Locked out of session

The old KDE / sddm bug where you sometimes are locked out of your running user session still persists.

Sometimes the old way of solving it still works:

- Log in as root
- `loginctl unlock-session "ID"`

Under Wayland you sometimes also need to restart the display manager after that:

- `systemctl restart sddm.service`

### Changing mouse cursor themes over xwayland / gtk applications

Add 

```
[Icon Theme]
Inherits=Breeze_Snow
```

to these files (or crete them with this content should they not exist)

- `./local/share/icons/default/index.theme`
- `./icons/default/index.theme`
- `/usr/share/icons/default/index.theme`

See [this commit](https://github.com/robert-ulrich-hofmann/dotfiles/commit/646831979f2a20e69d41414ed17addd9c9d06931) for further details.

### Changing mouse cursor size over xwwayland / gtk applications

As of June 2025: No easy fix, no global fix.

See: https://blogs.kde.org/2024/10/09/cursor-size-problems-in-wayland-explained/
