# Cheatsheet

## temporarily add current directory to executable path

PATH="$(pwd):$PATH"

## temporarily change editor for commands

EDITOR=nano crontab -e

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

```plaintext
framework 13.5 2880x1920
1440x 960   (2.0)   128dpi
1516x1010   (1.9)   135dpi    14
1600x1067   (1.8)   142dpi
1694x1129   (1.7)   150dpi    16
1800x1200   (1.6)   160dpi

mbp 14.2 3024x1964
1512x982    (2.0)   127dpi

mbp 16.2 3456x2234
1728x1117   (2.0)   127dpi
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

### Changing mouse cursor size over xwwayland / gtk applications

As of June 2025: No easy fix, no global fix.

See: https://blogs.kde.org/2024/10/09/cursor-size-problems-in-wayland-explained/
