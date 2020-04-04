FROM ubuntu:latest

RUN \
    apt update && \
    apt upgrade -y && \
    apt install ufw -y && \
    apt install openssh-server -y && \
    apt install openvpn -y && \
    apt install git -y && \
    git clone https://github.com/H0stk3rn3l/Docker-OpenVPN.git && \
    mkdir /etc/openvpn/client_configs/ && \
    mv Docker-OpenVPN/Config/server.conf /etc/openvpn/ && \
    mv Docker-OpenVPN/Config/base.conf /etc/openvpn/ && \
    mv Docker-OpenVPN/Config/make_config.sh /etc/openvpn/client_configs/ && \
    mv Docker-OpenVPN/Scripts/configure.sh /etc/openvpn/client_configs/ && \
    rm /etc/ufw/before.rules && \
    mv Docker-OpenVPN/Config/before.rules /etc/ufw/ && \
    rm -rf /Docker-OpenVPN && \
    sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf && \
    mkdir /etc/openvpn/keys && \
    cd /etc/openvpn/ && \
    openvpn --genkey --secret ta.key && \
    cp /etc/openvpn/ta.key /etc/openvpn/keys && \
    chmod 750 /etc/openvpn/client_configs/make_config.sh && \
    chmod 750 /etc/openvpn/client_configs/configure.sh && \
    # Client configuration infrastructure
    # Changing ufw rules 
    sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|g' /etc/default/ufw 
    #ufw allow OpenSSH && \
    #ufw allow 1194/udp &&\
    #ufw disable && \
    #ufw enable

VOLUME ["/var/volume"]



EXPOSE 1194/udp



# docker build github.com/H0stk3rn3l/Docker-OpenVPN -t openvpn-v0.1
# https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-18-04
# docker run -it --cap-add=NET_ADMIN -v /keys:/var/volume <image-name>