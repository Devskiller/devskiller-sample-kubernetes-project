#!/bin/bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

#  manually initiate the init directory with a script and a manifest file
mkdir /init

cat <<EOF > /init/kube-init.sh
#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install db bitnami/mysql
EOF

chmod +x /init/kube-init.sh

# create a deployment manifest
kubectl create deployment web -r 3 --image=nginx:1.21 -oyaml --dry-run > /init/kube-init.yaml

# mark the task initialization as completed
touch /etc/devskiller/.task-init-complete
