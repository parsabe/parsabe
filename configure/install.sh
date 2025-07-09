echo "Installing necessary packages..."
# download
wget https://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2025.1_all.deb

# install
sudo dpkg -i kali-archive-keyring_2025.1_all.deb
sudo apt update
sudo apt -y install vlc
sudo apt -y install unrar
sudo apt -y install snapd
sudo systemctl start snapd
sudo systemctl enable snapd --now
sudo systemctl start snapd.apparmor.service
sudo systemctl enable --now snapd.apparmor.service
sudo snap install telegram-desktop

sudo apt update

sudo apt install leafpad
sudo apt-get install winff
sudo apt-get install brasero
sudo apt-get install gpick
sudo apt install ffmpeg

sudo apt install php8.2-fpm
sudo apt-get install php-xml
sudo apt-get install php-curl
sudo apt install nodejs npm
sudo apt install composer
sudo apt install obs-studio
sudo apt install xinput
sudo apt update
sudo apt install xserver-xorg-input-wacom
sudo apt install xournalpp
sudo apt install gimp





sudo apt install -y docker.io
sudo systemctl enable docker --now

sudo apt install apt-transport-https wget
wget -O- https://app.eduvpn.org/linux/v4/deb/app+linux@eduvpn.org.asc | gpg --dearmor | sudo tee /usr/share/keyrings/eduvpn-v4.gpg >/dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/eduvpn-v4.gpg] https://app.eduvpn.org/linux/v4/deb/ bullseye main" | sudo tee /etc/apt/sources.list.d/eduvpn-v4.list
sudo apt update
sudo apt install eduvpn-client


sudo apt update
sudo snap install kubectl --classic
sudo systemctl enable ssh
sudo systemctl start ssh
sudo apt -y --fix-broken install
sudo apt update


sudo apt update
sudo apt install openssh-server -y
sudo apt install ufw
sudo ufw allow ssh
sudo ufw enable



sudo mkdir /home/hounaar/.config/nvim
sudo cp -rf init.vim ~/.config/nvim/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

unzip ant.zip
sudo cp -rf Ant-Nebula /usr/share/themes


mkdir -p ~/.local/share/gnome-shell/extensions/
cp -rf window-list@gnome-shell-extensions.gcampax.github.com  ~/.local/share/gnome-shell/extensions/


python -m venv venv
echo 'source venv/bin/activate' >> ~/.zshrc
source ~/.zshrc

pip install numpy pandas scikit-learn matplotlib seaborn telert csvkit euporie tensor torch 

cd xdm/
unrar x xdm.zip.part1
sudo ./install.sh


sudo apt update
sudo apt install g++
sudo apt install gdb
sudo apt install build-essential
sudo apt update
sudo apt install openmpi-bin openmpi-common libopenmpi-dev



sudo apt update && sudo apt upgrade -y
sudo apt install firmware-linux-nonfree firmware-misc-nonfree
sudo apt install v4l-utils cheese guvcview
sudo apt install pulseaudio pavucontrol alsa-utils
pulseaudio --start
sudo apt install firmware-iwlwifi firmware-realtek firmware-atheros firmware-b43-installer
dmesg | grep -i error
journalctl -xe | grep -i firmware
sudo apt install nvidia-driver -y
sudo apt update && sudo apt upgrade -y
sudo apt install linux-image-amd64


tar ./xdm-installer.sh
sudo dpkg -i code.deb

#!/bin/bash

# === Variables ===
EMAIL="parsabe99@gmail.com"
USERNAME="parsabe"
KEY_FILE="$HOME/.ssh/id_ed25519"

# === Check if SSH key exists ===
if [ -f "$KEY_FILE" ]; then
  echo "✅ SSH key already exists at $KEY_FILE"
else
  echo "🔑 Generating new SSH key..."
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_FILE" -N ""
fi

# === Start ssh-agent ===
eval "$(ssh-agent -s)"

# === Add SSH key to agent ===
ssh-add "$KEY_FILE"

# === Set global Git config ===
git config --global user.name "$USERNAME"
git config --global user.email "$EMAIL"

# === Show Public Key ===
echo "📋 Your SSH Public Key:"
echo "--------------------------------------------"
cat "$KEY_FILE.pub"
echo "--------------------------------------------"
echo "🚀 Copy this key and add it to your GitHub → Settings → SSH and GPG keys → New SSH key"

# === Done ===

echo "✅ SSH and Git setup completed!"
echo "--------------------------------------------"
sudo apt install git-lfs



wget https://github.com/parsabe/parsabe/releases/download/Conda/conda.sh
bash conda.sh
source ~/.bashrc
source ~/.zshrc


# === Ask for reboot ===
read -p "🔄 Process is done. Should I reboot? (y/n): " answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
  echo "🚀 Rebooting now..."
  sudo reboot
else
  echo "👍 No reboot. You can continue working."
fi

python tubaf.py




