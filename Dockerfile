FROM ubuntu:latest

RUN \
    apt update && \
    apt upgrade -y && \
    apt install iptables sudo -y && \
    #apt install -y wget && \
    apt install ufw -y && \
    apt install openvpn -y && \
    apt install git -y && \
    # Download EasyRSA and configure
    # wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.4/EasyRSA-3.0.4.tgz && \
    # tar xvf EasyRSA-3.0.4.tgz && \
    # cd EasyRSA-3.0.4/ && \
    # ./easyrsa init-pki && \
    # ./easyrsa gen-req server nopass && \
    # sudo cp /pki/private/server.key /etc/openvpn/ && \
    # Clone the github folder to download conf.file and handle it
     git clone https://github.com/H0stk3rn3l/Docker-OpenVPN.git && \
     mv Docker-OpenVPN/Config/server.conf /etc/openvpn/ && \
    # gzip -d /etc/openvpn/server.conf.gz && \
    
    # Define openvpn configuration. Remember to call docker-server the .crt and .key
    #echo "\n \nauth SHA256" >> /etc/openvpn/server.conf && \
    #echo "\nca /etc/openvpn/keys/ca.crt" >> /etc/openvpn/server.conf && \   
    #echo "\ncert /etc/openvpn/keys/docker-server.crt" >> /etc/openvpn/server.conf && \   
    #echo "\nkey /etc/openvpn/keys/docker-server.key" >> /etc/openvpn/server.conf && \   
    #echo "\ndh /etc/openvpn/keys/dh.pem" >> /etc/openvpn/server.conf && \   
    # Continue the openvpn configuration
    #sed -i 's|dh dh2048.pem|dh dh.pem|g' /etc/openvpn/server.conf && \
    #sed -i 's|;user nobody|user nobody|g' /etc/openvpn/server.conf && \
    #sed -i 's|;group nogroup|group nogroup|g' /etc/openvpn/server.conf && \
    #sed -i 's|;push "redirect-gateway def1 bypass-dhcp"|push "redirect-gateway def1 bypass-dhcp"|g' /etc/openvpn/server.conf && \
    #sed -i 's|;log         /var/log/openvpn/openvpn.log|log         /var/log/openvpn/openvpn.log|g' /etc/openvpn/server.conf && \
    #sed -i 's|;log-append  /var/log/openvpn/openvpn.log|log-append  /var/log/openvpn/openvpn.log|g' /etc/openvpn/server.conf && \
    #sed -i 's|;push "dhcp-option DNS 208.67.222.222"|push "dhcp-option DNS 208.67.222.222"|g' /etc/openvpn/server.conf && \
    #sed -i 's|;push "dhcp-option DNS 208.67.220.220"|push "dhcp-option DNS 208.67.220.220"|g' /etc/openvpn/server.conf && \
    sed -i 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|g' /etc/sysctl.conf && \
    mkdir /etc/openvpn/keys && \
    cd /etc/openvpn/ && \
    openvpn --genkey --secret ta.key && \
    # Client configuration infrastructure
    mkdir -p ~/client-configs/ && \
    cp Docker-OpenVPN/Client_configuration/base.conf ~/client-configs/ && \
    cp Docker-OpenVPN/Client_configuration/make_config.sh ~/client-configs/ && \
    rm -rf /home/ubuntu/Docker-OpenVPN && \
    chmod 700 ~/client-configs/make_config.sh && \
    # Changing ufw rules 
    echo "START OPENVPN RULES \n# NAT table rules \n*nat \n:POSTROUTING ACCEPT [0:0] \n# Allow traffic from OpenVPN client to eth0 \n-A POSTROUTING -s 10.8.0.0/8 -o eth0 -j MASQUERADE \nCOMMIT \n# END OPENVPN RULES" >> /etc/ufw/before.rules && \
    sed -i 's|DEFAULT_FORWARD_POLICY="DROP"|DEFAULT_FORWARD_POLICY="ACCEPT"|g' /etc/default/ufw && \
    #ufw allow OpenSSH && \
    ufw allow 1194/udp 
    #ufw disable && \
    #ufw enable

VOLUME ["/var/volume"]

# docker build github.com/H0stk3rn3l/Docker-OpenVPN -t openvpn-v0.1
# https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-18-04
# docker run -it --cap-add=NET_ADMIN -v /keys:/var/volume <image-name>


