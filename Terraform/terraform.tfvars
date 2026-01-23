# AWS Configuration
aws_region = "us-west-2"

# Project Configuration
project_name = "my-web-server"
environment  = "dev"

# Instance Configuration
instance_type = "t2.medium"

# Network Configuration
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"

# Security Configuration
allowed_ssh_cidr = ["0.0.0.0/0"]

# SSH Key Configuration
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLdJp87MS1WQEhsv3aEZbzJAdzPaZ0IlCbkkncn0UrUA3crT1bpx9uD68FSEfL26nVZMICQUOxx0KCrLHLXp21/X4EvWJ3ZDODyXfCTXGGJWuQ/+cPzJ35dQhplCvFirHTfLunLzcPj0+McgXqZdVB+oXVHFJJIfITA+LuvAOrHIZ1Tb36BUL7dM4LXs+ULccfV5tNUDNFOa6qZvOYZRhOx6k2Yv6jytng1a96jtsAapqdXNC/yeOImoUkQK9p0EQ/kPPySIi3oxxrMOszsSxM/Ud9zCuB6/9XhQnGV8FdDn82EIx3ucgjShCkNk5XlymtSeGZsizVUMDEG9CAC2eSpqNQh6k9SbVCnXQRGD61KYCyeIwQpXGA3AAFowxfDv7xpVDCb+Ruipby/CITWQnAv7jUP2QfJlGQ+OD9Kbt1VumS/9iHIk3w2J3n5dNYBs4D3MKCh9QSf164LlajCp5yDddQu1/lqPFTQ2TF+UXuu9bj1dnEJKCw5w/2gw92N7m98nD1NSyF2nepkNWNTWZHpWPXZJSOCVvVIuiK+XP7feexM87yqbOcUx8AFoTOMHQ9eknTOjQ8rU4I9/05Y2ALA7BzLV6YCtlPLJ9DTxr26fGLy2TLe6q4pYrWooZrmmFWI8lP1sYESXnQVLnSkelX5Gu17xj0+1V+B1bD0d5ZsQ== timi@Timis-MacBook-Pro.local"

# Storage Configuration
root_volume_size = 20