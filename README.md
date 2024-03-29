# wsl2

some tips to have some tools working on WSL2 like cockpit or distrod or crc openshift running on WSL2

## Distrod

Very powerful tool that brings some tools on Wsl.

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

Note that with the support of systemd in wsl you can now cockpit fully working on wsl.

![cockpit](https://github.com/stormalf/wsl2/blob/main/wsl2_cockpit.png)

## Code Ready Workspaces (CRC) OpenShift Redhat

Tested successfully on VMWARE workstation player and now also in WSL2!

Openshift code ready workspace link : https://developers.redhat.com/products/codeready-workspaces/overview

I tested and it works fine with Centos8.

### steps

tools/packages needed :

    sudo yum install nano
    sudo yum install cockpit
    sudo yum install xz
    sudo yum install virt-install virt-viewer virt-manager
    sudo yum install net-tools
    sudo yum install tar
    sudo yum install python3
    sudo systemctl start NetworkManager
    sudo yum install openssh-server
    sudo systemctl start sshd
    sudo yum install firefox

Check if no internet access the following file :
cat /etc/resolv.conf
And put a valid nameserver it can be your box ip or DNS server like 8.8.8.8 for google.
Check if you can ping google.com

WSL2 now takes in charge the systemd see more information on https://devblogs.microsoft.com/commandline/systemd-support-is-now-available-in-wsl/

In my centos version I had two issues :

issue with systemctl --user : 

    time="2023-07-15T11:20:31+02:00" level=debug msg="Setting up crc-http.socket"
    time="2023-07-15T11:20:31+02:00" level=debug msg="Creating /home/stormalf/.config/systemd/user/crc-http.socket"
    time="2023-07-15T11:20:31+02:00" level=debug msg="Running 'systemctl --user daemon-reload'"
    time="2023-07-15T11:20:31+02:00" level=debug msg="Command failed: exit status 1"
    time="2023-07-15T11:20:31+02:00" level=debug msg="stdout: "
    time="2023-07-15T11:20:31+02:00" level=debug msg="stderr: Failed to connect to bus: No such file or directory\n"
    time="2023-07-15T11:20:31+02:00" level=debug msg="Running 'systemctl --user status crc-http.socket'"
    time="2023-07-15T11:20:31+02:00" level=debug msg="Command failed: exit status 1"
    time="2023-07-15T11:20:31+02:00" level=debug msg="stdout: "
    time="2023-07-15T11:20:31+02:00" level=debug msg="stderr: Failed to connect to bus: No such file or directory\n"
    time="2023-07-15T11:20:31+02:00" level=debug msg="Could not get crc-http.socket  status: Executing systemctl action failed:  exit status 1: Failed to connect to bus: No such file or directory\n"
    time="2023-07-15T11:20:31+02:00" level=debug msg="Starting crc-http.socket"
    time="2023-07-15T11:20:31+02:00" level=debug msg="Running 'systemctl --user enable crc-http.socket'"
    time="2023-07-15T11:20:31+02:00" level=debug msg="Command failed: exit status 1"
    time="2023-07-15T11:20:31+02:00" level=debug msg="stdout: "
    time="2023-07-15T11:20:31+02:00" level=debug msg="stderr: Failed to connect to bus: No such file or directory\n"
    
    solved by sudo systemctl restart user@1000


issue with network creation

    time="2023-07-15T12:52:12+02:00" level=debug msg="stderr: error: Failed to start network crc\nerror: error from service: changeZoneOfInterface: COMMAND_FAILED: 'python-nftables' failed: internal:0:0-0: Error: Could not process rule: No such file or directory\n\ninternal:0:0-0: Error: Could not process rule: No such file or directory\n\ninternal:0:0-0: Error: Could not process rule: No such file or directory\n\ninternal:0:0-0: Error: Could not process rule: No such file or directory\n\ninternal:0:0-0: Error: Could not process rule: No such file or directory\n\ninternal:0:0-0: Error: Could not process rule: No such file or directory\n\ninternal:0:0-0: Error: Could not process rule: No such file or directory\n\ninternal:0:0-0: Error: Could not process rule: No such file or directory\n\n\nJSON blob:\n{\"nftables\": [{\"metainfo\": {\"json_schema_version\": 1}}, {\"insert\": {\"rule\": {\"family\": \"inet\", \"table\": \"firewalld\", \"chain\": \"filter_INPUT_ZONES\", \"expr\": [{\"match\": {\"left\": {\"meta\": {\"key\": \"iifname\"}}, \"op\": \"==\", \"right\": \"crc\"}}, {\"goto\": {\"target\": \"filter_IN_libvirt\"}}]}}}, {\"insert\": {\"rule\": {\"family\": \"inet\", \"table\": \"firewalld\", \"chain\": \n"
    
    I reinstalled firewalld and after it, it works better.
    
After that the crc setup is completed successfully.

I had also three issues with crc start :

failed to initialize kvm:

    2023-07-15T11:27:07.595997Z qemu-kvm: failed to initialize KVM: Permission denied'
    
    Solved by chown root:kvm /dev/kvm

Error starting machine: Error in driver during machine start: Unable to determine VM's IP address, did it fail to boot?

    But perhaps it takes too time to start. After a ./crc stop and ./crc start the ip 192.168.130.11 is ok
    PING 192.168.130.11 (192.168.130.11) 56(84) bytes of data.
    64 bytes from 192.168.130.11: icmp_seq=1 ttl=64 time=0.303 ms
    64 bytes from 192.168.130.11: icmp_seq=2 ttl=64 time=0.848 ms
    64 bytes from 192.168.130.11: icmp_seq=3 ttl=64 time=0.505 ms
    64 bytes from 192.168.130.11: icmp_seq=4 ttl=64 time=0.309 ms
    64 bytes from 192.168.130.11: icmp_seq=5 ttl=64 time=2.12 ms
^
Error renewing certificates :

    INFO Kubelet client certificate has expired, renewing it... [will take up to 8 minutes]
    Failed to renew TLS certificates: please check if a newer CRC release is available: Temporary error: certificate /var/lib/kubelet/pki/kubelet-client-current.pem still expired (x59)
    
    This is caused by an old crc used. Downloading the last version from  https://developers.redhat.com/content-gateway/file/pub/openshift-v4/clients/crc/2.23.0/crc-linux-amd64.tar.xz
 
After executing crc setup from crc-linux-2.23.0-amd64, the certificates expired issue is solved: 

    WARN Cannot add pull secret to keyring: The name org.freedesktop.secrets was not provided by any .service files
    INFO Updating SSH key to machine config resource...
    INFO Waiting until the user's pull secret is written to the instance disk...
    INFO Changing the password for the kubeadmin user
    INFO Updating cluster ID...
    INFO Updating root CA cert to admin-kubeconfig-client-ca configmap...
    INFO Starting openshift instance... [waiting for the cluster to stabilize]
    INFO 6 operators are progressing: dns, image-registry, ingress, network, openshift-controller-manager, ...
    ...
    Log in as user:
      Username: developer
      Password: developer
    
    Use the 'oc' command line interface:
      $ eval $(crc oc-env)
      $ oc login -u developer https://api.crc.testing:6443
    
Finally we succeeded to have openshift Code ready containers running on wsl2!

Note that sometimes crc cleanup fails to remove network in libvirt.
In this case, I'm doing the following : 

    sudo ip link show
    sudo ifconfig crc down
    sudo ip link delete crc-nic type bridge
    sudo ip link delete crc type bridge
    sudo virsh
    net-list --all
    net-undefine crc


![crc setup](https://github.com/stormalf/wsl2/blob/main/wsl2_crc_setup.png)
![crc start](https://github.com/stormalf/wsl2/blob/main/wsl2_crc_start.png)

![crc running](https://github.com/stormalf/wsl2/blob/main/wsl2_crc_openshift_running.png)



## localstack

Very useful to be able to test some terraform stuff on localhost.
Link : https://github.com/localstack/localstack.git

## rdp

using remote desktop connection to connect to WSL2.
It installs using apt-get required packages and updates the config files after backup them and it starts the xrdp service.
execute :

        ./rdp/xrdp.sh

![rdp](https://github.com/stormalf/wsl2/blob/main/rdp/wsl2_xrdp.png)


For installing xrdp on centos8 : https://linuxize.com/post/how-to-install-xrdp-on-centos-8/ 

Note that in centos8 i didn't succeed to use xterm correctly I replaced by icewm that works better in my case : 

    in /etc/X11/xinit/Xclients looks for PREFERRED and add the path to icewm-session
    PREFERRED=/bin/icewm-session


## wsl kernel customization 

Sometimes some kernel modules are required like for openstack vswitch.

Like always before doing anything be sure to have a backup (of content of C:\Windows\System32\lxss\tools, a backup of wsl ext4.vhdx).

To custom WSL2, you need to follow these steps :  (source from https://github.com/kevin-doolaeghe/wsl-kernel-modules)

    sudo apt install bash-completion build-essential gcc g++ avr-libc avrdude default-jre default-jdk git clang make nano xz-utils wget
    source .bashrc
    sudo apt install flex bison libssl-dev libelf-dev git dwarves bc
    wget https://github.com/microsoft/WSL2-Linux-Kernel/archive/refs/tags/linux-msft-wsl-$(uname -r | cut -d- -f 1).tar.gz
    tar -xvf linux-msft-wsl-$(uname -r | cut -d- -f 1).tar.gz
    cd WSL2-Linux-Kernel-linux-msft-wsl-$(uname -r | cut -d- -f 1)
    cat /proc/config.gz | gunzip > .config
    make prepare modules_prepare -j $(expr $(nproc) - 1)
    make menuconfig -j $(expr $(nproc) - 1)

now you need to find network and to select the vswitch module (navigate into the menu and save your changes).
When it's done.

    make modules -j $(expr $(nproc) - 1)
    sudo make modules_install
    make -j $(expr $(nproc) - 1)
    sudo make install

the new kernel image is called vmlinux.

    cp vmlinux /mnt/c/Users/YOUR_USER/

create or modify your .wslconfig file in c:\users\YOUR_USER\.wslconfig

    nano /mnt/c/Users/YOUR_USER/.wslconfig
    
    [wsl2]
    kernel=C:\\Users\\YOUR_USER\\vmlinux

shutdown WSL2 

    wsl --shutdown

Start a terminal with administrator rights :

    Restart-Service LxssManager

Normally if it works well, you can restart wsl and go to /lib/modules to check if you see something like : 

    cat /proc/modules
        openvswitch 176128 3 - Live 0x0000000000000000
        nsh 16384 1 openvswitch, Live 0x0000000000000000


If your kernel seems to not load, check the content of C:\Windows\System32\lxss\tools and rename the old kernel to kernel.old and copy the new kernel vmlinux to this location and rename it to kernel. (Do it only if your kernel seems to be not loaded and be careful, it's not the recommended way).

## openstack

To be able to install openstack on WSL2 you need to custom WSL2 and add a module required by openstack called vswitch (see previous paragraph). 

If all is ok, you can now install openstack by following the information from https://www.digitalocean.com/community/tutorials/install-openstack-ubuntu-devstack 

    sudo apt update -y && sudo apt upgrade -y
    sudo adduser --shell /bin/bash --home /opt/stack stack
    echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
    su - stack
    sudo apt install git -y
    git clone https://git.openstack.org/openstack-dev/devstack
    cd devstack

create a local.conf :

    nano local.conf

copy the following replacing by your password and your ip address (ip a or ipconfig or ip addr): 

    [[local|localrc]]

    # Password for KeyStone, Database, RabbitMQ and Service
    ADMIN_PASSWORD=StrongAdminSecret
    DATABASE_PASSWORD=$ADMIN_PASSWORD
    RABBIT_PASSWORD=$ADMIN_PASSWORD
    SERVICE_PASSWORD=$ADMIN_PASSWORD
    
    # Host IP - get your Server/VM IP address from ip addr command
    HOST_IP=xxx.xxx.xxx.xxx

And execute the installation :
    
    ./stack.sh

it takes long time perhaps more than 15 minutes and if all is ok you will find at the end something like that :
    
=========================
DevStack Component Timing
 (times are in seconds)
=========================
wait_for_service      16
async_wait           164
osc                  227
apt-get               58
test_with_retry        5
dbsync                11
pip_install          123
apt-get-update         2
run_process           28
git_timed            218
-------------------------
Unaccounted time     149
=========================
Total runtime        1001

=================
 Async summary
=================
 Time spent in the background minus waits: 432 sec
 Elapsed time: 1001 sec
 Time if we did everything serially: 1433 sec
 Speedup:  1.43157


Post-stack database query stats:
+------------+-----------+-------+
| db         | op        | count |
+------------+-----------+-------+
| keystone   | SELECT    | 35246 |
| keystone   | INSERT    |    93 |
| neutron    | SELECT    |  4701 |
| neutron    | CREATE    |   251 |
| neutron    | SHOW      |    28 |
| neutron    | INSERT    |  4114 |
| neutron    | UPDATE    |   183 |
| neutron    | ALTER     |    93 |
| neutron    | DROP      |    47 |
| neutron    | DELETE    |    26 |
| placement  | SELECT    |    48 |
| placement  | INSERT    |    56 |
| placement  | SET       |     1 |
| nova_api   | SELECT    |   114 |
| nova_cell1 | SELECT    |   131 |
| nova_cell0 | SELECT    |    78 |
| nova_cell0 | INSERT    |     6 |
| nova_cell0 | UPDATE    |     8 |
| placement  | UPDATE    |     3 |
| nova_cell1 | INSERT    |     4 |
| nova_cell1 | UPDATE    |    24 |
| cinder     | SELECT    |   115 |
| cinder     | INSERT    |     5 |
| cinder     | UPDATE    |     1 |
| glance     | SELECT    |    49 |
| glance     | INSERT    |     6 |
| glance     | UPDATE    |     2 |
| nova_api   | INSERT    |    20 |
| nova_api   | SAVEPOINT |    10 |
| nova_api   | RELEASE   |    10 |
| cinder     | DELETE    |     1 |
+------------+-----------+-------+


![openstack](https://github.com/stormalf/wsl2/blob/main/wsl2_openstack.png)