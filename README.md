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

![distrod](https://github.com/stormalf/wsl2/blob/main/wsl2_distrod.png)
![linux distributions](https://github.com/stormalf/wsl2/blob/main/wsl2_distrod_linux_distributions.png)
![centos distributions](https://github.com/stormalf/wsl2/blob/main/wsl2_distrod_centos.png)
![centos7](https://github.com/stormalf/wsl2/blob/main/wsl2_distrod_centos7.png)
![create an user](https://github.com/stormalf/wsl2/blob/main/wsl2_distrod_user.png)

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

![cockpit](https://github.com/stormalf/wsl2/blob/main/wsl2_cockpit.png)

## Code Ready Workspaces (CRC) OpenShift Redhat

Tested successfully on VMWARE workstation player. But some issues on wsl2.

Openshift code ready workspace link : https://developers.redhat.com/products/codeready-workspaces/overview
I tested and it works fine with Centos7. With other Centos8-stream and Centos9-stream I still have some issues.

### steps

tools/packages needed :

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

It seems that on wsl2 the crc setup replaces the content of /etc/resolv.conf with the following : nameserver 127.0.0.1

Very important to allow the port 22 for ssh if not crc start will fail after lots of tries.

    sudo systemctl start firewalld
    sudo firewall-cmd --add-port=22/tcp --permanent
    sudo firewall-cmd --add-port=80/tcp --permanent
    sudo firewall-cmd --add-port=6443/tcp --permanent
    sudo firewall-cmd --add-port=443/tcp --permanent
    sudo systemctl restart firewalld

![crc setup](https://github.com/stormalf/wsl2/blob/main/wsl2_crc_setup.png)
![crc start](https://github.com/stormalf/wsl2/blob/main/wsl2_crc_start.png)

for now some issue with crc during starting on certificates renewing step.
In case of issue you can find more information in cat /home/{your_user}/.crc/crc.log
![crc issue](https://github.com/stormalf/wsl2/blob/main/wsl2_crc_issue.png)

## localstack

Very useful to be able to test some terraform stuff on localhost.
Link : https://github.com/localstack/localstack.git

## rdp

using remote desktop connection to connect to WSL2.
It installs using apt-get required packages and updates the config files after backup them and it starts the xrdp service.
execute :

        ./rdp/xrdp.sh

![rdp](https://github.com/stormalf/wsl2/blob/main/rdp/wsl2_xrdp.png)
