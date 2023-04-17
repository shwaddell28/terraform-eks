# terraform-eks

Automatically create an EKS cluster and deploy a simple Nest API with a single command.

### Prerequisites

1. Install [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. Create an AWS account
   1. It is recommended to create an IAM user with `AmazonEKSClusterPolicy` and `AdministratorAccess` permissions.
3. Set the following environment variables:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Deploy

To create the cluster and deploy the app, run the following script from the project directory:

```
$ sh deploy.sh
```

This script will initialize and auto apply the two terraform modules present in the project. Two separate terraform modules are used in order to ensure the cluster creation is complete before attempting to create any kubernetes resources.

The following resources will be created:

- An EKS cluster
- EKS required resources including Auto Scaling Groups, security groups, and IAM Roles and Policies
- A single EKS managed node group with one node
- A VPC with 3 private subnets and 3 public subnets
- A kubernetes namespace, service, and deployment with the simple-nest-api app

### Cleanup

To delete the cluster and all associated resources, run:

```
$ sh cleanup.sh
```

This script will execute terraform destroy commands in order to ensure that the kubernetes resources are removed first before destroying the cluster and associated resources.
