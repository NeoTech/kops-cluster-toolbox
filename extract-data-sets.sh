mkdir -p data/{values,snippets}
cd terraform
terraform output nets > ../data/snippets/nets.yaml
terraform output kops-values > ../data/values/values.yaml
terraform output private-key > ../data/ssh-key
terraform output kops-id > ../data/kops-username
terraform output kops-secret > ../data/kops-password
terraform output build-toolbox-ecr > ../data/ecr.yaml
