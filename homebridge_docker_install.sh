#!/bin/bash

path1=/data/homebridge
if [ ! -d "$path1" ]; then
        sudo mkdir $path1
fi

path2=/home/pi/.firewalla/run/docker/homebridge
if [ ! -d "$path2" ]; then
        mkdir $path2
fi

curl https://raw.githubusercontent.com/kcirtapfromspace/homebridge-installer/main/docker-compose.yaml > $path2/docker-compose.yaml


cd $path2
sudo systemctl start docker
sudo docker-compose up --detach

sudo docker ps

path3=/home/pi/.firewalla/config/post_main.d

if [ ! -d "$path3" ]; then
	mkdir $path3
fi	

echo "#!/bin/bash

sudo systemctl start docker
sudo systemctl start docker-compose@homebridge " > $path3/start_homebridge.sh
sudo chmod +x $path3/start_homebridge.sh
$path3/start_homebridge.sh

echo -n "Starting docker"
while [ -z "$(sudo docker ps | grep homebridge | grep Up)" ]
do
        echo -n "."
        sleep 2s
done

sudo docker container prune -f && sudo docker image prune -fa
# sudo docker container stop homebridge && sudo docker container rm homebridge && sudo docker image rm homebridge/homebridge

echo "Done"
echo -e "Done!\n\nYou can open http://fire.walla:$port in your favorite browser and set up your Homebridge.\n\n"
