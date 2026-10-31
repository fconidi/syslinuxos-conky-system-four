#!/bin/bash
# Build the shared desktop menu used by SysLinuxOS Conky themes.
set -euo pipefail

PKG_NAME="syslinuxos-conky-menu"
PKG_VERSION="0.1.1"
WORKDIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="${1:-$WORKDIR}"
mkdir -p "$OUTPUT_DIR"
OUTPUT_DIR="$(cd "$OUTPUT_DIR" && pwd)"
STAGING="$(mktemp -d)"
trap 'rm -rf "$STAGING"' EXIT

cp -a "$WORKDIR/menu/files/." "$STAGING/"
mkdir -p "$STAGING/DEBIAN" "$STAGING/usr/share/doc/$PKG_NAME"
cp "$WORKDIR/files/usr/share/doc/syslinuxos-conky-window/copyright" \
   "$STAGING/usr/share/doc/$PKG_NAME/copyright"
sed -i "s/Upstream-Name: syslinuxos-conky-window/Upstream-Name: $PKG_NAME/" \
    "$STAGING/usr/share/doc/$PKG_NAME/copyright"
find "$STAGING" -type d -exec chmod 755 {} +
find "$STAGING" -type f -exec chmod 644 {} +
INSTALLED_SIZE=$(du -sk "$STAGING" --exclude=DEBIAN | cut -f1)
cat > "$STAGING/DEBIAN/control" <<EOF
Package: $PKG_NAME
Version: $PKG_VERSION
Section: x11
Priority: optional
Architecture: all
Depends: hicolor-icon-theme
Maintainer: Franco Conidi (edmond) <fconidi@gmail.com>
Homepage: https://github.com/fconidi/syslinuxos-conky-window
Installed-Size: $INSTALLED_SIZE
Description: Shared desktop submenu for SysLinuxOS Conky themes
 Groups Conky theme launchers under System Tools > Conky.
 Additional themes can use the X-SysLinuxOS-Conky desktop category.
EOF
echo "/etc/xdg/menus/applications-merged/syslinuxos-conky.menu" > "$STAGING/DEBIAN/conffiles"
(cd "$STAGING" && find . -type f -not -path './DEBIAN/*' -printf '%P\n' | sort | xargs -d '\n' md5sum > DEBIAN/md5sums)
dpkg-deb --root-owner-group --build "$STAGING" \
    "$OUTPUT_DIR/${PKG_NAME}_${PKG_VERSION}_all.deb"
