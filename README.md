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
4. Execute the .configure.sh file in /etc/openvpn/client_config
```
./configure.sh
```
5. 