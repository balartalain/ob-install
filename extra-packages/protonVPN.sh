#!/bin/bash

#https://protonvpn.com/support/official-linux-vpn-ubuntu?srsltid=AfmBOopHlZQJyG15nhmv3tZlGFKpJ2DwYmEpkMAPSbDVOFkBEshzZcLa
echo "############ Installing ProtonVPN ###########"
wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.6_all.deb
sudo dpkg -i ./protonvpn-stable-release_1.0.6_all.deb && sudo apt update
sudo apt install proton-vpn-gnome-desktop
sudo apt install libayatana-appindicator3-1 gir1.2-ayatanaappindicator3-0.1 gnome-shell-extension-appindicator
