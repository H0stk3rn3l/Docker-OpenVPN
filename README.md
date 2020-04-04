# Setup and configuration of the container

1. Build the docker image from Github
```
docker build github.com/H0stk3rn3l/Docker-OpenVPN -t <image-tag>
```
2. Create the container with the image previously built
```
docker run -it --cap-add=NET_ADMIN -v /keys:/var/volume -p 1194:1194/udp -e HOST_ADDR=<Public IpAddress> <image-tag>
```
3. Inside the container, we need to change the configuration file called base.conf in /etc/openssh/base.conf adding the real IP of the machine "
```
remote <my-server-1> 1194"
```
4. Execute the .configure.sh file in /etc/openvpn/client_configs
```
/etc/openvpn/client_configs/configure.sh
```
5. Execute te following commands:
```
ufw allow OpenSSH
ufw allow 1194/udp
ufw disable
ufw enable
```
6. Copy all the keys needed in /etc/openvpn/keys/. A volume is already mounted in /var/volume
7. Create the .ovpn file. It shall have the same name of the keys created for the machine.
```
/etc/openvpn/client_configs/make_config.sh <name-file>
```
8. Restart openvpn service
```
/etc/init.d/openvpn restart
```
9. move thes file contained in /var/volume in the client that will use it

