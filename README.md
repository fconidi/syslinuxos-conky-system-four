# SysLinuxOS Conky System Four

Conky system-monitor panel for [SysLinuxOS](https://syslinuxos.com), docked on the right side of the desktop.

Shows system info, CPU (temperature, optional GPU/fan, per-core bars), top processes, memory, file system, a SYSLINUXOS status row (pending updates, failed units, snapshots when readable) and network (IPs, ISP, speed and totals, graphs).

## Features

- **Auto-scaling** of fonts, widths and bars to the screen resolution (reference 1920x1080). Override with `CONKY_SYSTEM_FOUR_SCALE=<n>`.
- **CPU bars adapt to the logical processor count**: individual bars up to 32 threads, then one aggregate bar so the panel remains within its width.
- **Network interface follows the default route**, re-detected every 10 seconds. Pin one with `CONKY_NET_INTERFACE=<iface>`. The two speed graphs stay on the interface detected at startup.
- **Single ROOT+HOME row** when `/` and `/home` are on the same file system (btrfs subvolumes).
- **Optional rows only when available**: GPU temperature (nvidia-smi or sensors), fan speed.
- **SYSLINUXOS row**: pending APT updates, failed systemd units, and the snapper snapshot count when `snapper list` is readable by the user.

## Install

From the SysLinuxOS APT repository:

```
sudo apt install syslinuxos-conky-system-four
```

or from a release `.deb`:

```
sudo apt install ./syslinuxos-conky-system-four_<version>_all.deb
```

Start and stop from **Menu > System Tools > Conky** (**Start Conky-System-Four** / **Stop Conky-System-Four**).

## Shared Conky menu

The `syslinuxos-conky-menu` dependency provides **System Tools > Conky** for
Ring, Window and other themes. Its sources are in `menu/files/`. Build it with
`bash build-menu-deb.sh`; install it alongside a downloaded theme package if
the SysLinuxOS APT repository is not configured. Upgrade both theme packages to move all their launchers into the submenu.

Additional themes should use `Categories=X-SysLinuxOS-Conky;` in their desktop
launchers and depend on `syslinuxos-conky-menu (>= 0.1.0)`.

## Build

```
bash build-deb.sh
```

Produces `syslinuxos-conky-system-four_<version>_all.deb` (no sudo, uses fakeroot).

## Author / License

**Franco Conidi** (aka *edmond*) — <fconidi@gmail.com> — <https://syslinuxos.com> — <https://francoconidi.it>

GPL-3.0+, see `files/usr/share/doc/syslinuxos-conky-system-four/copyright`.

## Renamed from syslinuxos-conky-window

Since 0.3.0 the package is called `syslinuxos-conky-system-four`. The old name is kept as an empty transitional package, so `apt upgrade` migrates existing installs and your edited `/etc/conky/conky-window.conf` is carried over to `/etc/conky/conky-system-four.conf`. Scripts are now `conky-system-four-start.sh` and `conky-system-four-stop.sh`. `CONKY_WINDOW_SCALE` is still honoured.
