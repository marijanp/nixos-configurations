#/bin/bash
sudo rsync -av --progress ./ /etc/nixos/ --exclude machines setup-host.sh
sudo rsync -av --progress ./machines/$0/* /etc/nixos/ --exclude setup-host.sh 