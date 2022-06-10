# Tools CICD

Sample infrastructure setup on AWS EC2 of :

- Ansible
- Packer
- Terraform
- Jenkins

## Setup

```
terraform init
terraform plan
terraform apply
```

**!!! When you are done with your instance, run **

```
terraform destroy
```

## Access

### SSH

To access the Tools EC2 instance through SSH, follow the instructions in the generated `NOTES.md` file.

### Jenkins

To access the Jenkins UI, follow the instructions in the generated `NOTES.md` file.

On a fresh install :

- wait for a few minutes after terraform ended to apply
- you will need to retrieve the admin password on the EC2 in the `/var/lib/jenkins/secrets/initialAdminPassword` file*
