# IPRange.sh

IPRange is a fast and efficient tool to scan your Local Area Network.<br />
Once your network scanned, iprange helps you SSH into connected devices or map their ports.<br />
(The script relies on ICMP, SSH and IMAP, do not block those protocols on your LAN.)


<img align="right" src="http://puu.sh/k4hFm/a45745c7f4.png">
### Usage :
> If the first two bytes of your IP address are not 192.168, please don't forget to change the value of 'network_bytes' at the top of iprange.sh.

By default the beginning of the IP address is set to 192.168 and is stored in $network_bytes.
* The first parameter provided will be the third byte of the address.
* The second will be the number of address you want to scan.
* The third and last parameter will be weither you want a fast and sloppy scan or a longer and more precise one. Accepts 1 or 0.(takes around 13 seconds vs 2 minutes)

```sh
#  Let's say you are on 192.168.0.0/24 and want to scan quickly 
#+ all of the possible addresses:
$ ./iprange.sh 0 254 1
```

You can also call iprange.sh without any parameters, you will be asked for them.




### Installation

```sh
$ git clone https://github.com/Limezest/IPRange.git
$ chmod u+x iprange.sh
```
You can eventually add a link to iprange.sh in your $PATH if you want to make it accessible from anywhere:
```sh
# From the root directory of the project:
$ ln -s `pwd`/iprange.sh /usr/bin/iprange
```

### Todo's

* Clean code
* Test user inputs
* Lots of things
