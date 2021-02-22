wget https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip -O terraform.zip

echo "alias install='sudo apt-get install -y'" >> ~/.bashrc
install -y zip unzip apt-transport-https ca-certificates curl software-properties-common

install build-essential
sudo adduser erik
sudo addgroup erik
sudo usermod -aG erik erik
sudo usermod -aG sudo erik

Edit sudoers file (this can be present in /etc/sudoers.d/file_name)
sudo visudo -f /etc/sudoers
Add line at the end of the file
usernameusedforlogin ALL=(ALL) NOPASSWD:ALL
Save file
esc :wq!

scp -r ~/.aws erik@35.165.154.200:/home/erik/


# since we probably don't want the toolchain packages all the time,
# ex: gcc-7.4.0, gcc-8.2.0, and python-3.6.8, you likely want to 
# remove the PPA
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/ppa
install python3.7
sudo add-apt-repository --remove -y ppa:ubuntu-toolchain-r/ppa
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.7 2
sudo update-alternatives --config python
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py --user
python -m pip install cffi

echo "PATH=\"$PATH:/opt/bin:/home/erik/.local/bin\"" >> ~/.bashrc
echo "export AWS_PROFILE=hyperion-prod" >> ~/.bashrc
echo "export AWS_REGION=us-west-2" >> ~/.bashrc
echo "export AWS_DEFAULT_REGION=us-west-2" >> ~/.bashrc
echo "export AWS_ADK_LOAD_CONFIG=1" >> ~/.bashrc

sudo apt-get install openssl libcurl4-openssl-dev libxml2 libssl-dev libxml2-dev pinentry-curses xclip cmake
sudo apt-get install lastpass-cli
gem install lastpass-api

install postgres-client-common # psql
install xclip
echo 'alias xclip="xclip -selection c"' >> ~/.bashrc
echo 'alias xpaste="xclip -selection clipboard -o"' >> ~/.bashrc
echo 'alias guid="python -c \"import sys,uuid; sys.stdout.write(uuid.uuid4().hex)\" | xcopy && xpaste && echo"' >> ~/.bashrc


source ~/.bashrc
