#!/bin/bash

#test 
path1=/data/homebridge
if [ ! -d "$path1" ]; then
        sudo mkdir $path1
fi

path2=/home/pi/.firewalla/run/docker/homebridge
if [ ! -d "$path2" ]; then
        mkdir $path2
fi

curl https://raw.githubusercontent.com/mbierman/homebridge-installer/main/docker-compose.yaml \
> $path2/docker-compose.yaml

echo "What is your timezone? (see https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)"
echo -n "Enter your timezone and press [ENTER]: "
read TZ

sed "s|TZ.*|TZ=${TZ}|g" $path2/docker-compose.yaml > $path2/docker-compose.yaml.tmp && \
mv $path2/docker-compose.yaml.tmp $path2/docker-compose.yaml

echo -e  "\n\nWhat port do you want to run homebridge on? (8080 is the default)" 
echo -n "Enter the port you want to use and press [ENTER]: "
read port


sed "s|HOMEBRIDGE_CONFIG_UI_PORT.*|HOMEBRIDGE_CONFIG_UI_PORT=${port}|g" $path2/docker-compose.yaml > \ 
$path2/docker-compose.yaml.tmp && mv $path2/docker-compose.yaml.tmp $path2/docker-compose.yaml

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
$path3/start_homebridge.sh

echo -n "Starting docker"
while [ -z "$(sudo docker ps | grep homebridge | grep Up)" ]
do
        echo -n "."
        sleep 2s
done

sudo docker container prune -f && sudo docker image prune -fa
# sudo docker container stop homebridge && sudo docker container rm homebridge && sudo docker image rm oznu/homebridge

echo "Done"
echo -e "Done!\n\nYou can open http://fire.walla:$port in your favorite browser and set up your Homebridge.\n\n"
