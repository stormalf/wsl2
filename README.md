# wsl2

some tips to have some tools working on WSL2 like cockpit or crc openshift using Distrod

## Distrod

Very powerful tool that brings some tools on Wsl that otherwise are not available fully like cockpit or crc openshift.
Some of these tools needs NetworkManager to work.

link to Distrod : https://github.com/nullpo-head/wsl-distrod

Example of usage :

    .\distrod_wsl_launcher.exe --help
    distrod-install 0.1.4

    USAGE:
        distrod_wsl_launcher.exe [OPTIONS] [SUBCOMMAND]

    FLAGS:
        -h, --help       Prints help information
        -V, --version    Prints version information

    OPTIONS:
        -d, --distro-name <distro-name>
        -l, --log-level <log-level>        Log level in the env_logger format. Simple levels: trace, debug, info(default),
                                        warn, error

    SUBCOMMANDS:
        config
        help       Prints this message or the help of the given subcommand(s)
        install
        run

distrod_wsl_launcher.exe -d Centos7

## cockpit

Cockpit link : https://cockpit-project.org/running
easy to install :
on Centos :

    sudo yum install cockpit
    sudo systemctl enable --now cockpit.socket
    sudo firewall-cmd --permanent --zone=public --add-service=cockpit
    sudo firewall-cmd --reload

    sudo systemctl start cockpit.socket

    check your localhost:9090 in your browser

## crc

Openshift code ready workspace link : https://developers.redhat.com/products/codeready-workspaces/overview
I tested and it works fine with Centos7. With other Centos8-stream and Centos9-stream I still have some issues.

### steps

sudo yum install nano
sudo yum install cockpit
sudo yum install xz
sudo yum install virt-install virt-viewer virt-manager
sudo yum install firewalld
sudo yum install net-tools
sudo yum install tar
sudo yum install python3
sudo systemctl start NetworkManager
sudo yum install openssh-server
sudo systemctl start sshd

Check if no internet access the following file :
cat /etc/resolv.conf
And put a valid nameserver it can be your box ip or DNS server like 8.8.8.8 for google.
Check if you can ping google.com

Very important to allow the port 22 for ssh if not crc start will fail after lots of tries.
sudo systemctl start firewalld
sudo firewall-cmd --add-port=22/tcp --permanent
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=6443/tcp --permanent
sudo firewall-cmd --add-port=443/tcp --permanent
sudo systemctl restart firewalld
