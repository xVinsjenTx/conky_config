#!/bin/bash

# check user before sudo
user="$(whoami)"

# check prerequisites
if ! command -v conky >/dev/null; then
  echo "Warning conky is not installed. Aborting" >&2
  exit 1
fi

if ! command -v git >/dev/null; then
  echo "Warning git is not installed. Aborting" >&2
  exit 1
fi

if [ ! -d "/usr/share/fonts" ]; then
    echo "Warning directory /usr/share/fonts does not exists."
    exit 1
fi

dir="/tmp/conky_install"

if [ -d "$dir" ]; then
	rm -rf ${dir}
fi

set -e
# download required config files
git clone https://github.com/xVinsjenTx/conky_config.git "$dir"

# move the files to their locations
mkdir -p ${HOME}/.config/conky
mv ${dir}/conky.conf  ${HOME}/.config/conky/

mkdir -p /usr/share/fonts/
sudo mv ${dir}/ConkySymbols.ttf /usr/share/fonts/

#move startup script to the correct folder
chmod +x ${dir}/conky_start.sh
sudo mv ${dir}/conky_start.sh /etc/profile.d/

rm -rf ${dir}

# make sure the serial can be read
sudo dmidecode -s system-serial-number > "/home/${user}/.serial.txt"



echo "===finished==="
exit