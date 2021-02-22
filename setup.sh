#!/bin/bash

# ------------------------------------
# Install updates:
# ------------------------------------
sudo apt update && sudo apt dist-upgrade -y

mkdir -p ~/Downloads
cd ~/Downloads

# ------------------------------------
# enable ssh:
# ------------------------------------
sudo apt install openssh-server

# ------------------------------------
# Install dev tools and some themes:
# ------------------------------------

sudo apt install -y \
python3-minimal \
build-essential \
apt-transport-https \
ca-certificates \
curl \
software-properties-common \
apache2-utils \
make \
gnome-tweak-tool \
python3-pip \
libgconf-2-4 \
code \
arc-theme

# ------------------------------------
# Tell apt to prefer System76 packages over standard Ubuntu packages
# ------------------------------------
echo "adding system76-apt-preferences to local apt repositories"

sudo cat <<-EOF > "/etc/apt/preferences.d/system76-apt-preferences"
Package: *
Pin: release o=LP-PPA-system76-dev-stable
Pin-Priority: 1001

Package: *
Pin: release o=LP-PPA-system76-dev-pre-stable
Pin-Priority: 1001
EOF

# ------------------------------------
# Install the System76 Display Drivers
# ------------------------------------
sudo apt-add-repository -y ppa:system76-dev/stable
sudo apt-get update
sudo apt-get install -y system76-driver

# ------------------------------------
# Install GO
# ------------------------------------
wget -O golang.tar.gz https://golang.org/dl/go1.14.6.linux-amd64.tar.gz
tar -C /usr/local -xzf golang.tar.gz
echo "export PATH=\$PATH:/usr/local/go/bin" | sudo tee -a /etc/profile 
echo "export GOROOT=/usr/local/go" | sudo tee -a /etc/profile 
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export PATH=$PATH:$GOPATH/bin" >> ~/.bashrc
echo "export PATH=$PATH:$GOROOT/bin" >> ~/.bashrc
echo "export GO111MODULE=on" >> ~/.bashrc
mkdir -p $HOME/go
echo "export GOPATH=$HOME/go" >> /home/erik/.zshrc
go get -u -v -tags v0.16.8 github.com/gobuffalo/buffalo/buffalo@v0.16.8

# ------------------------------------
# Install DisplayLink Driver
# ------------------------------------
sudo apt-get install dkms libdrm-dev

wget -O displaylink-5.2.zip https://www.displaylink.com/downloads/file?id=1576
unzip displaylink-5.2.zip
sudo chmod +x displaylink-driver-5.2.14.run
sudo ./displaylink-driver-5.2.14.run

# ------------------------------------
# Install NodeJS:
# ------------------------------------
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g npm
echo "fs.inotify.max_user_watches=10000000" | sudo tee -a /etc/sysctl.conf


# ------------------------------------
# Install .NET Core and turn off .NET Core telemetry:
# ------------------------------------
wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update && sudo apt install dotnet-sdk-3.1 -y
rm -f packages-microsoft-prod.deb
dotnet --version

echo "export DOTNET_CLI_TELEMETRY_OPTOUT=true" >> ~/.profile


# ------------------------------------
# Install Docker and Docker Compose:
# ------------------------------------
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

# Running "sudo apt-key fingerprint 0EBFCD88" should display:

# pub   rsa4096 2017-02-22 [SCEA]
#       9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
# uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
# sub   rsa4096 2017-02-22 [S]

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
docker --version

sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Important to know: running docker without requiring sudo is equivalent to running as root
# Docker Daemon Attack Surface details - https://docs.docker.com/engine/install/linux-postinstall/ 
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# a better alternative that isn't such a significant security issue:
# there is also docker rootless mode which is currently considered experimental: 
# https://docs.docker.com/engine/security/rootless/
curl -fsSL https://get.docker.com/rootless | sh

echo "export PATH=/home/erik/bin:\$PATH" >> .zshrc
echo "export DOCKER_HOST=unix:///run/user/1001/docker.sock" >> .zshrc



# ------------------------------------
# Install Postman:
# ------------------------------------
sudo apt install libgconf-2-4
cd ~/Downloads
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
sudo tar -xzf postman.tar.gz -C /opt
sudo ln -s /opt/Postman/Postman /usr/bin/postman

cat > ~/.local/share/ap
plications/postman.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL

sudo apt-get install zsh
sudo usermod -s /usr/bin/zsh $(whoami)
sudo chmod -R 755 /usr/local/share
sudo apt-get install zsh-syntax-highlighting
sudo apt-get install powerline10k fonts-powerline
echo "source /usr/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

curl https://sh.rustup.rs -sSf | sh -s -- -y
wget https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip -O exa.zip
unzip exa-linux-x86_64.zip
sudo mv exa-linux-x86_64 /usr/local/bin/exa
echo "alias ls='exa -bghHli'" >> /home/erik/.zshrc

# Install terraform as /usr/local/bin exe
wget https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip -O terraform.zip
unzip terraform.zip
sudo mv terraform /usr/local/bin

# Install aws cli2 - https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
echo "complete -C '/usr/local/aws/bin/aws_completer' aws" >> /home/erik/.zshrc

# Install Tilix, as gnome terminal replacement
# I've decided to go back to gnome terminal due to 
# far superior performance.  commenting this tilix 
# install out for now
# sudo apt-get install tilix
# cat >> ~/.zshrc <<EOL
# if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
#         source /etc/profile.d/vte.sh
# fi
# EOL
# ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh

cat >> /usr/bin/synergy.service <<EOL
#!/bin/bash

function silentkill () {
    /usr/bin/killall synergyc > /dev/null 2>&1
    sleep 1 > /dev/null
}

while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        v="${1/--/}"
        declare $v="$2"
   fi

  shift
done

SYNERGY_SERVER=${SYNERGY_SERVER:-192.168.1.81}

silentkill
/usr/bin/synergyc -n pop-os $SYNERGY_SERVER
EOL
sudo chmod 755 /usr/bin/synergy.service

# lenovo throtler fix
# https://github.com/erpalma/throttled
# 
# https://mensfeld.pl/2018/05/lenovo-thinkpad-x1-carbon-6th-gen-2018-ubuntu-18-04-tweaks/
#sudo apt install libdbus-glib-1-dev libgirepository1.0-dev libcairo2-dev python3-venv python3-wheel python-gobject
#git clone https://github.com/erpalma/lenovo-throttling-fix.git
#sudo ./lenovo-throttling-fix/install.sh

#https://github.com/erpalma/throttled

# always want this near the end of user_profile
echo "autoload compinit && compinit" >> /home/erik/.zshrc

cat >> /usr/bin/find_pid_cmd <<EOL
#!/bin/bash
pscmd () {
    echo "searching for $1"
    ps -aef | awk 'NR==1{print $1,$2,$8} /'$1'/{print $1, $2, $8}'
}

if [ -z "$1-unset" ] && [ "$1" != "/usr/bin/find_pid_cmd" ]; then
   pscmd "$1"
fi
EOL
echo "source /usr/bin/find_pid_cmd" >> ~/.zshrc

PATH=$PATH:~/opt/bin

# apparmor apport byobu cloud-guest-utils cloud-init
#   command-not-found ec2-hibinit-agent hibagent
#   landscape-common language-selector-common lsb-release
#   netplan.io networkd-dispatcher nplan open-vm-tools
#   pastebinit plymouth-theme-ubuntu-text snapd software-properties-common sosreport
#   ssh-import-id ubuntu-minimal ubuntu-release-upgrader-core
#   ubuntu-server ubuntu-standard ufw unattended-upgrades
#   update-manager-core update-notifier-common

# install yarn - https://classic.yarnpkg.com/en/docs/install/#debian-stable
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
