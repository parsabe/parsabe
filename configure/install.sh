echo "Installing necessary packages..."


wget https://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2025.1_all.deb
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


sudo apt-get install winff
sudo apt-get install brasero
sudo apt-get install gpick
sudo apt install ffmpeg


sudo apt-get install php-xml
sudo apt-get install php-curl
sudo apt install nodejs npm
sudo apt install composer
sudo apt install obs-studio
sudo apt install xinput
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



sudo snap install kubectl --classic
sudo systemctl enable ssh
sudo systemctl start ssh
sudo apt -y --fix-broken install

sudo apt install openssh-server -y
sudo apt install ufw
sudo ufw allow ssh
sudo ufw enable



sudo mkdir /home/hounaar/.config/nvim
sudo cp -rf init.vim ~/.config/nvim/
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


cd /home/hounaar
python -m venv venv
echo 'source venv/bin/activate' >> ~/.zshrc
source ~/.zshrc

pip install numpy pandas scikit-learn matplotlib seaborn telert csvkit euporie tensor torch 


cd /home/hounaar/Desktop/parsabe/configure/xdm/
unrar x xdm.zip.part1
sudo ./install.sh


sudo apt install g++
sudo apt install gdb
sudo apt install build-essential
sudo apt install openmpi-bin openmpi-common libopenmpi-dev



sudo apt install firmware-linux-nonfree firmware-misc-nonfree
sudo apt install v4l-utils cheese guvcview
sudo apt install firmware-iwlwifi firmware-realtek firmware-atheros firmware-b43-installer
dmesg | grep -i error
journalctl -xe | grep -i firmware
sudo apt install nvidia-driver -y
sudo apt install linux-image-amd64



git config --global user.name "parsabe"
git config --global user.email "parsabe99@outlook.com"

sudo apt install git-lfs

python tubaf.py




