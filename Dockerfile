FROM ubuntu:latest

RUN \
    apt update && \
    apt upgrade -y && \
    apt install openvpn -y && \
    cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/ && \
    gzip -d /etc/openvpn/server.conf.gz && \
    echo "\nauth SHA256" >> /etc/openvpn/server.conf && \
    sed -i "s|dh dh2048.pem|dh dh.pem|g" /etc/openvpn/server.conf && \
    sed -i "s|;user nobody|user nobody|g" /etc/openvpn/server.conf && \
    sed -i "s|;group nogroup|group nogroup|g" /etc/openvpn/server.conf && \
    sed -i "s|;push "redirect-gateway def1 bypass-dhcp"|push "redirect-gateway def1 bypass-dhcp"|g" /etc/openvpn/server.conf && \
    sed -i "s|;push "dhcp-option DNS 208.67.222.222"|push "dhcp-option DNS 208.67.222.222"|g" /etc/openvpn/server.conf && \
    sed -i "s|;push "dhcp-option DNS 208.67.222.220"|push "dhcp-option DNS 208.67.222.220"|g" /etc/openvpn/server.conf

# Expose ports.
EXPOSE 80

CMD ["openvpn"]

