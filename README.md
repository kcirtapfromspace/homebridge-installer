# Install Homebridge Docker Container on Firewalla Gold or Purple

This is a "1.0" script for installing the [Homebridge docker container](https://github.com/oznu/docker-homebridge) on Firewalla Gold or Purple. It should get you up and running. It is based on the [Firewalla tutorial](https://help.firewalla.com/hc/en-us/articles/360053184374-Guide-Install-HomeBridge-on-Firewalla-).

To install, [learn how to ssh into your firewalla](https://help.firewalla.com/hc/en-us/articles/115004397274-How-to-access-Firewalla-using-SSH-) if you don't know how already.

Next, copy the line below and paste into the Firewalla shell. 

 ```
 curl -s -L -C- https://raw.githubusercontent.com/mbierman/unifi-installer/main/unifi_docker_install.sh | cat <(cat <(bash))
```

**Standard disclaimer:** I can not be responsible for any issues that may result. Nothing in the script should in any way, affect firewalla as a router or comprimise security. Happy to answer questions though if I can. :)

# Uninstalling

If you need to reset the container (stop and remove and try again) run the following commands. 

WARNING: if you use these commands you are stopping and removing the container. Don't do this unless you are sure that you don't mind potentially losing stuff. If you haven't managed to get the Controller running then there is probably no harm in going forward. Otherwise, only do this if you know at least a little bit about what you are doing. 

```
sudo docker container stop unifi && sudo docker container rm unifi
rm /home/pi/.firewalla/config/post_main.d/start_unifi.sh
rm ~/.firewalla/config/dnsmasq_local/unifi
rm -rf /home/pi/.firewalla/run/docker/unifi
```

There are lots of UniFi communities on [Reddit](https://www.reddit.com/r/Ubiquiti/) and [Facebook](https://www.facebook.com/groups/586080611853291). If you have UniFi questions, please check there. 
