# Break the scheduler control plane pod
sudo cp /etc/kubernetes/manifests/kube-scheduler.yaml ~/kube-scheduler.yaml.ORIG
sudo sed -i 's/image: registry.k8s.io\/kube-scheduler:/image: registry.k8s.io\/kube-cheduler:/' /etc/kubernetes/manifests/kube-scheduler.yaml
