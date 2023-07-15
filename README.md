# wsl2

some tips to have some tools working on WSL2 like cockpit or crc openshift using Distrod

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

Tested successfully on VMWARE workstation player. But some issues on wsl2.

Openshift code ready workspace link : https://developers.redhat.com/products/codeready-workspaces/overview
I tested and it works fine with Centos7. With other Centos8-stream and Centos9-stream I still have some issues.

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
    
    I removed firewalld and after it works better
    
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
