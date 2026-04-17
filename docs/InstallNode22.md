``` Cách 1


sudo apt update
sudo apt install -y ca-certificates curl gnupg

curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
less nodesource_setup.sh
sudo bash nodesource_setup.sh

sudo apt install -y nodejs
node -v
npm -v



````


``` Cách 2

curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs


```