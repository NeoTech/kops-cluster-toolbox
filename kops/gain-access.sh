read -p "Cluster DNS name: " CLUSTERNAME
export NAME=$CLUSTERNAME
export KOPS_STATE_STORE=s3://agrium-k8-kops-state-store
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

kops export -v 9 --kubeconfig config.kops kubecfg $NAME
