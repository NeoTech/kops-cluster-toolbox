# Management cluster provisoning

Will provision a KOPS based cluster onto AWS using a small and locked down VPC created with the use of Terraform

* Uses CircleCI for provisioning terraform and kops setup: Why?.
    * This allows us todo multiple things in the provisioning at once with the tool that was intended to be used.
    * This allows us todo smoke tests of the infrastructure once its up and running before proceeding with next steps.
    * This will allow us to bootstrap the k8s cluster with the necessary helm charts, roles, network policies and rights that is needed.
* Makes use of KOPS for provisioning k8s cluster: Why?.
    * This will give us a standard styled kubernetes cluster without a provider specific opionion on how it should be run.
    * Gives us easy tools for dealing with these clusters in a templated fashion.
    * Do not rely on a managed service like EKS so we can run workloads like Rancher Manager that requires it to not be managed due to how it uses ETCD for storage.
* Makes use of Terraform for initial VPC: Why?.
    * Will allow us to create a network setup and rules that locks the VPC down rather than letting everything sit public from the start.
    * The terraform part is not necessary as KOPS can create its own but alot like Rancher setting up an EKS cluster the security policies would be left wide open.
* Include are:
    * A small go based workload that can be built and deployed and just echoes a version number. A CI pipeline test can be done by just updating the version and rebuild it.
    * A docker image for CircleCI that provides the necessary tooling for running the setup in CircleCI.
    * Helm charts for deploying Addons to Rancher manager.
    * A config.dummy thats needed for a CI step. Which is an inert kubecfg file.
