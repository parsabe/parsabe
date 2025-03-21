echo "Installing necessary packages..."
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

gnome-extensions enable window-list@gnome-shell-extensions.gcampax.github.com
gnome-shell --replace &


sudo apt update -y
sudo apt upgrade -y
sudo apt-get upgrade -y

curl ifconfig.me





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


sudo reboot




