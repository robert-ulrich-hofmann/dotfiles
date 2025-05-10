# Cheatsheet

## temporarily add current directory to executable path

PATH="$(pwd):$PATH"

## temporarily change editor for commands

EDITOR=nano crontab -e

## FIREFOX

Add `media.cubeb.backend` with value `alsa` to avoid jumping volume on application streams with pulseaudio on pipewire.

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
