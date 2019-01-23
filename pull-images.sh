docker pull qiaoanran/kube-apiserver:v1.13.2
docker tag qiaoanran/kube-apiserver:v1.13.2 k8s.gcr.io/kube-apiserver:v1.13.2
docker rmi qiaoanran/kube-apiserver:v1.13.2

docker pull qiaoanran/kube-controller-manager:v1.13.2
docker tag qiaoanran/kube-controller-manager:v1.13.2 k8s.gcr.io/kube-controller-manager:v1.13.2
docker rmi qiaoanran/kube-controller-manager:v1.13.2

docker pull qiaoanran/kube-proxy:v1.13.2
docker tag qiaoanran/kube-proxy:v1.13.2 k8s.gcr.io/kube-proxy:v1.13.2
docker rmi qiaoanran/kube-proxy:v1.13.2

docker pull qiaoanran/pause:3.1
docker tag qiaoanran/pause:3.1  k8s.gcr.io/pause:3.1
docker rmi qiaoanran/pause:3.1

docker pull qiaoanran/etcd:3.2.24
docker tag qiaoanran/etcd:3.2.24 k8s.gcr.io/etcd:3.2.24
docker rmi qiaoanran/etcd:3.2.24

docker pull qiaoanran/coredns:1.2.6
docker tag qiaoanran/coredns:1.2.6 k8s.gcr.io/coredns:1.2.6
docker rmi qiaoanran/coredns:1.2.6

docker pull qiaoanran/kube-scheduler:v1.13.2
docker tag qiaoanran/kube-scheduler:v1.13.2 k8s.gcr.io/kube-scheduler:v1.13.2
docker rmi qiaoanran/kube-scheduler:v1.13.2
