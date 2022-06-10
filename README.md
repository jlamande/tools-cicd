# Tools CICD

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

You can access the Tools EC2 instance through SSH with one of the following commands : 

```sh
ssh -i ./id_rsa ubuntu@ec2-34-251-116-64.eu-west-1.compute.amazonaws.com
# or
ssh -i ./id_rsa ubuntu@34.251.116.64
```

### Jenkins

Access to Jenkins UI :

 - http://ec2-34-251-116-64.eu-west-1.compute.amazonaws.com:8080
 - http://34.251.116.64:8080

On fresh install :

- wait for a few minutes after terraform ended to apply
- you will need to retrieve the admin password on the EC2 in the `/var/lib/jenkins/secrets/initialAdminPassword` file*
