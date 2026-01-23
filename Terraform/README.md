# AWS EC2 Web Server Terraform Configuration

This Terraform configuration creates a complete AWS infrastructure for hosting a web server on EC2 with industry-standard best practices.

## Architecture

- **VPC**: Custom VPC with DNS support
- **Subnet**: Public subnet with internet gateway
- **Security Group**: Configured for HTTP (80), HTTPS (443), and SSH (22) access
- **EC2 Instance**: t2.medium instance with Ubuntu 22.04 LTS
- **Elastic IP**: Static public IP address
- **EBS Volume**: Encrypted root volume
- **Auto-configuration**: Apache web server setup via user data

## Prerequisites

1. **AWS CLI configured** with appropriate credentials
2. **Terraform installed** (version >= 1.0)
3. **SSH key pair** for instance access

## Quick Start

1. **Clone and navigate to the directory**
   ```bash
   cd terraform-aws-ec2
   ```

2. **Generate SSH key pair**
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/my-web-server-key
   ```

3. **Configure variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

4. **Deploy infrastructure**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

5. **Access your server**
   - Web: `http://<public-ip>`
   - SSH: `ssh -i ~/.ssh/my-web-server-key ubuntu@<public-ip>`

## Configuration Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `aws_region` | AWS region | `us-west-2` | No |
| `project_name` | Project name prefix | `web-server` | No |
| `environment` | Environment name | `dev` | No |
| `instance_type` | EC2 instance type | `t2.medium` | No |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` | No |
| `public_subnet_cidr` | Public subnet CIDR | `10.0.1.0/24` | No |
| `allowed_ssh_cidr` | SSH access CIDR blocks | `["0.0.0.0/0"]` | No |
| `public_key` | SSH public key content | - | **Yes** |
| `root_volume_size` | Root volume size (GB) | `20` | No |

## Security Features

- **Encrypted EBS volumes**
- **Security groups** with minimal required access
- **SSH key-based authentication**
- **Configurable SSH access restrictions**
- **Latest Ubuntu 22.04 LTS AMI**

## Outputs

After deployment, you'll receive:
- Instance ID and IP addresses
- SSH connection command
- VPC and subnet IDs
- Security group ID

## Customization

### Different Instance Types
```hcl
instance_type = "t3.large"  # or t2.small, t3.medium, etc.
```

### Restrict SSH Access
```hcl
allowed_ssh_cidr = ["YOUR_IP/32"]  # Replace with your IP
```

### Custom User Data
Modify `user_data.sh` to install additional software or configurations.

## Cost Optimization

- Uses GP3 EBS volumes (cost-effective)
- Configurable instance types
- Minimal infrastructure footprint
- Elastic IP for consistent access

## Cleanup

```bash
terraform destroy
```

## Troubleshooting

### Common Issues

1. **SSH Key Error**: Ensure your public key is correctly formatted in `terraform.tfvars`
2. **Permission Denied**: Check AWS credentials and IAM permissions
3. **Instance Not Accessible**: Verify security group rules and network ACLs

### Useful Commands

```bash
# Check instance status
aws ec2 describe-instances --instance-ids <instance-id>

# View instance logs
aws ec2 get-console-output --instance-id <instance-id>

# SSH with verbose output
ssh -v -i ~/.ssh/my-web-server-key ubuntu@<public-ip>
```
