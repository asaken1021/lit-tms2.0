#!/bin/bash
echo "TMS 2.0用の環境構築(1)を開始します。"
cd
sudo apt update
sudo apt -y upgrade
sudo apt install apt-transport-https ca-certificates curl software-properties-common git
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
sudo add-apt-repository "deb [arch=amb64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt -y install docker-ce
sudo adduser $(whoami) docker
sudo systemctl enable docker
echo PCを再起動してください。再起動後、env_install2.shを実行してください。
