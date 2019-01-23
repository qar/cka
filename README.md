# Preparing for CKA Exam

### Day 1

1. Setup a vm environment through vagrant: [Vagrantfile](./Vagrantfile)

1. Install minikube in vm. follow instruction here: [Intall Minukube](https://kubernetes.io/docs/tasks/tools/install-minikube/#install-minikube)

    ```
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
    sudo cp minikube /usr/local/bin && rm minikube
    ```
1. Install kubectl [instruction](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

    ```
    sudo apt-get update && sudo apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
    ```

   Notes:

   `curls -s https://package.cloud.google.com/apt/doc/apt-key.gpg` no response. I have to mount a shared folder on vm and download this gpg key on host and manually add this key in vm. like:

    ```
    > cd /data/shared
    >cat apt-key.gpg | sudo apt-key add -
    OK
    ```

   `sudo apt-get update` took a very long time and not succeed. the output error is:

    ```
    Err https://apt.kubernetes.io kubernetes-xenial/main amd64 Packages
     Failed to connect to packages.cloud.google.com port 443: Connection timed out
    W: Failed to fetch https://apt.kubernetes.io/dists/kubernetes-xenial/main/binary-amd64/Packages  Failed to connect to packages.cloud.google.com port 443: Connection timedout
    E: Some index files failed to download. They have been ignored, or old ones used instead.
    ```

   After google this problem I found this: https://askubuntu.com/a/749733. Not sure if it will help though.

   Second thought, why not use `apt update` ?

   No, I give up, this wont work.

1. Try another way to install kubectl: [Instruction here](https://gist.github.com/osowski/adce22b01fadd6e2bc3331c066d7d612)

    ```
    wget https://storage.googleapis.com/kubernetes-release/release/v1.4.4/bin/linux/amd64/kubectl
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/kubectl
    ```

   The installation was successful. but `kubectl version` output was kind of strange:

    ```
    vagrant@vagrant-ubuntu-trusty-64:~$ kubectl version
    Client Version: version.Info{Major:"1", Minor:"4", GitVersion:"v1.4.4", GitCommit:"3b417cc4ccd1b8f38ff9ec96bb50a81ca0ea9d56", GitTreeState:"clean", BuildDate:"2016-10-21T02:48:38Z", GoVersion:"go1.6.3", Compiler:"gc", Platform:"linux/amd64"}
    The connection to the server localhost:8080 was refused - did you specify the right host or port?

    ```

    Oh... I missed this section: [Install kubectl binary using curl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-using-curl). This totally solved `apt-update` timeout problem.

1. Come back to minikube

    1. run `minikube start`
       Errors:
        `minikube failed to download iso`,  Retry util it finish downloading.
        `: VBoxManage not found. Make sure VirtualBox is installed and VBoxManage is in the path`
        because the default vm driver is `virtualbox` ?  trying `sudo apt-get install virtualbox` and it succeeded.

        `: This computer doesn't have VT-X/AMD-v enabled. Enabling it in the BIOS is mandatory`
        Assign two cpus will solve this ? No, it wont. because 'Currently VirtualBox is not supporting nesting VT-X. ', https://www.virtualbox.org/ticket/4032, solution: use a different hypervisor that does not support VT-X/AMD-v in nested virtualisation (like Xen, KVM, or VMware)

    2. use kvm2 driver: https://github.com/kubernetes/minikube/blob/master/docs/drivers.md#kvm2-driver
       Tips:
        - install `libvirt-bin` instead of `libvirt-clients` on this OS (ubuntu/trusty64)
        - use `libvirtd` groupd instead of `libvirt`

       `/usr/lib/libvirt.so.0: version `LIBVIRT_1.2.8' not found (required by /usr/local/bin/docker-machine-driver-kvm2)`


1. Give up, try to install minikube on host
  1. install minikube on macOS
    ```
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 \
    && chmod +x minikube

    sudo cp minikube /usr/local/bin && rm minikube
    ```
  1. install kubectl
  1. hang on `Starting cluster components...`
  1. use hyperkit driver, follow instruction: https://whatdafox.com/install-kubectl-and-minikube-on-mac-os-mojave-ece759f38411


----

### Day 2

1. Failed to download image k8s.gcr.io/xxxx
1. use docker hub to build k8s images then pull and re-tag them
1. `minikube start` not using local images. problems still remain.
1. `minukube ssh` and execute `pull-images.sh` seem working.. wait for result
1. Second thought: why not trying  `minikube --vm-driver=none` in virtualbox ?
1. Accidentally enabled kubernetes on docker for mac. Now it stucks on `kubernetes is starting ...`. 
1. Kuberntes on macos is a deadend, at least in China it is. (due to the network status)
1. Try minikube with `--vm-driver=none` on vagrant (VirtualBox)
1. skip minikube, try kubeadm, kubelet, kubectl. detroy preview vm first
1. install kubeadm, kubelet, kubectl with:
    ```
    cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
    deb http://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main
    EOF
    apt-get update
    apt-get install -y kubelet kubeadm kubectl
    apt-mark hold kubelet kubeadm kubectl
    ```
1. stuck on `kubelet : Depends: init-system-helpers (>= 1.18~) but 1.14ubuntu1 is to be installed `
  - download: http://launchpadlibrarian.net/173841617/init-system-helpers_1.18_all.deb
  - install `sudo dpkg -i ./init-system-helpers_1.18_all.deb`

1. all set. 
1. run `sudo kubeadm init`
   Errors and sulutions:

   Error: [ERROR FileContent--proc-sys-net-bridge-bridge-nf-call-iptables]: /proc/sys/net/bridge/bridge-nf-call-iptables does not exist
   Solution:
    upgrade OS Kernel version. use 18.04 box, then `modprobe br_netfilter`

   Error: [ERROR FileContent--proc-sys-net-ipv4-ip_forward]: /proc/sys/net/ipv4/ip_forward contents are not set to 1    
   Solution:
    install docker on ubuntu 18.04
      ```
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
      ```

1. install a pod network addon
1. use calico
    Doc:
      - For Calico to work correctly, you need to pass --pod-network-cidr=192.168.0.0/16 to kubeadm init or update the calico.yml file to match your Pod network.
      ```
      kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
      kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
      ```

