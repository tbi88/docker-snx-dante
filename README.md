# docker-snx-dante
Container with Checkpoint SNX VPN and Dante Socks server (exposed on port 1080)

# Running:
docker run -p 127.0.0.1:1080:1080 --cap-add=ALL -v /lib/modules:/lib/modules -v /dev:/dev -e SNX_PASSWORD=YOUR_SNX_PASSWORD -e SNX_USER=YOUR_SNX_USERNAME -e SNX_SERVER=YOUR_SNX_SERVER -d -ti snx-dante

# Using:
SSH:
$ cat ~/.ssh/config
Host ssh-through-socks5
  ProxyCommand=nc --proxy localhost:1080 --proxy-type socks5 %h %p
