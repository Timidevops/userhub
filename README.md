# DevOps User Portal - CI/CD Case Study

> **A Java-based web application demonstrating enterprise-grade DevOps practices with automated CI/CD pipeline, containerization, and cloud infrastructure provisioning.**

> ⚠️ **Security Note**: Passwords are stored in plain text for demonstration purposes only. Never use this approach in production environments.

---

## 📋 Table of Contents
- [Project Overview](#-project-overview)
- [Architecture](#-architecture)
- [Technology Stack](#-technology-stack)
- [Infrastructure as Code](#-infrastructure-as-code)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Application Structure](#-application-structure)
- [Deployment Strategy](#-deployment-strategy)
- [Getting Started](#-getting-started)
- [Pipeline Workflow](#-pipeline-workflow)
- [Security & Best Practices](#-security--best-practices)

---

## 🎯 Project Overview

The **DevOps User Portal** is a full-stack Java web application built to showcase modern DevOps practices including:
- Automated CI/CD with GitHub Actions
- Infrastructure provisioning with Terraform
- Container orchestration with Kubernetes
- Multi-stage Docker builds
- Security scanning and code analysis
- Cloud-native deployment on AWS

### Key Features
- User registration and authentication system
- MySQL database integration
- Responsive Bootstrap UI
- Containerized deployment
- Auto-scaling Kubernetes deployment
- Automated security scanning

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Repository                        │
│                  (Source Code + Actions)                     │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                  GitHub Actions CI/CD                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │  Build   │→ │  Test    │→ │ Security │→ │  Deploy  │   │
│  │ & Analyze│  │          │  │   Scan   │  │          │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    AWS Cloud Infrastructure                  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Amazon ECR (Container Registry)                      │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Kubernetes Cluster (EKS/Self-Managed)               │  │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐     │  │
│  │  │   Pod 1    │  │   Pod 2    │  │  MySQL DB  │     │  │
│  │  │ (Tomcat)   │  │ (Tomcat)   │  │            │     │  │
│  │  └────────────┘  └────────────┘  └────────────┘     │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  LoadBalancer Service (Public Access)                │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Technology Stack

### Application Layer
| Technology | Version | Purpose |
|------------|---------|---------|
| **Java** | 17 | Backend programming language |
| **Maven** | 3.9.6 | Build automation and dependency management |
| **Tomcat** | 9.0.74 | Servlet container and web server |
| **JSP/Servlets** | 4.0.1 | Web application framework |
| **MySQL** | 8.0.33 | Relational database |
| **Bootstrap** | 5.3.2 | Frontend UI framework |

### DevOps & Infrastructure
| Tool | Purpose |
|------|---------|
| **GitHub Actions** | CI/CD automation |
| **Docker** | Containerization |
| **Kubernetes** | Container orchestration |
| **Terraform** | Infrastructure as Code (IaC) |
| **AWS ECR** | Container image registry |
| **AWS EC2** | Virtual machine hosting |
| **AWS VPC** | Network isolation |
| **Trivy** | Security vulnerability scanning |
| **SpotBugs** | Static code analysis |

---

## 🌍 Infrastructure as Code

### Terraform Configuration

The project uses **Terraform** to provision AWS infrastructure with the following components:

#### Network Infrastructure
- **VPC** with custom CIDR block (10.0.0.0/16)
- **Public Subnet** for internet-facing resources
- **Internet Gateway** for external connectivity
- **Route Tables** for traffic management

#### Compute Resources
- **EC2 Instance** (t2.medium) running Ubuntu 22.04 LTS
- **Elastic IP** for static public addressing
- **Security Groups** with controlled ingress/egress rules
  - Port 80 (HTTP)
  - Port 443 (HTTPS)
  - Port 22 (SSH)

#### Container Registry
- **Amazon ECR** repository with:
  - Image scanning on push
  - AES256 encryption
  - Mutable image tags

#### Automated Provisioning
The `user_data.sh` script automatically installs:
- Apache2 web server
- OpenJDK 11
- Maven 3.9.5
- kubectl (Kubernetes CLI)
- kops (Kubernetes operations)
- AWS CLI v2

**Key Files:**
- `Terraform/main.tf` - Main infrastructure definitions
- `Terraform/variables.tf` - Configurable parameters
- `Terraform/outputs.tf` - Output values
- `Terraform/user_data.sh` - EC2 initialization script

---

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

The pipeline consists of **4 parallel and sequential jobs** triggered on push to `main`/`develop` branches:

#### **Job 1: Build, Test & Analyze** 🔨
```yaml
Triggers: Push to main/develop, Pull requests
Runner: ubuntu-latest
```

**Steps:**
1. **Checkout Code** - Retrieves source code
2. **Setup JDK 17** - Configures Java environment
3. **Cache Maven Dependencies** - Speeds up builds
4. **Compile** - `mvn clean compile`
5. **Run Tests** - `mvn test` (continues on error)
6. **SpotBugs Analysis** - Static code analysis for bugs
7. **Package WAR** - Creates deployable artifact
8. **Upload Artifacts** - Stores build outputs

**Outputs:**
- `devops-userportal.war` file
- Test reports (Surefire)
- SpotBugs analysis results

---

#### **Job 2: Docker Build & Push** 🐳
```yaml
Depends on: build-test-analyze
Runner: ubuntu-latest
```

**Steps:**
1. **Configure AWS Credentials** - Authenticates with AWS
2. **Setup Docker Buildx** - Multi-platform build support
3. **Login to Amazon ECR** - Container registry authentication
4. **Build & Push Image** - Creates multi-arch images
   - Platforms: `linux/amd64`, `linux/arm64`
   - Tags: `latest` and `<git-sha>`

**Docker Multi-Stage Build:**
```dockerfile
Stage 1 (Build): Maven + JDK 17 → Compile & Package
Stage 2 (Runtime): Tomcat 9 + JDK 17 → Deploy WAR
```

**Benefits:**
- Reduced image size (build tools excluded from runtime)
- Faster deployments
- Better security (minimal attack surface)

---

#### **Job 3: Security Scan** 🔒
```yaml
Depends on: build-test-analyze
Runner: ubuntu-latest
```

**Steps:**
1. **Trivy Filesystem Scan** - Scans for:
   - Vulnerabilities in dependencies
   - Misconfigurations
   - Secrets in code
   - License compliance issues
2. **Upload Scan Results** - Stores security reports

**Scan Coverage:**
- Java dependencies (Maven)
- OS packages
- Configuration files
- Infrastructure as Code (Terraform)

---

#### **Job 4: Deploy to Kubernetes** 🚀
```yaml
Depends on: security-scan, docker-build-push
Condition: Only on main branch
Environment: devops
Runner: ubuntu-latest
```

**Steps:**
1. **Configure AWS Credentials**
2. **Install kubectl** (v1.28.0)
3. **Login to ECR**
4. **Configure kubeconfig** - Decodes base64 kubeconfig from secrets
5. **Deploy to Kubernetes**
   - Substitutes environment variables in deployment.yaml
   - Applies Kubernetes manifests
   - Monitors rollout status (5-minute timeout)

**Deployment Configuration:**
- **Replicas:** 2 pods for high availability
- **Image:** Latest from ECR with git SHA tag
- **Service Type:** LoadBalancer (public access)
- **Environment Variables:** Database connection details

---

## 📁 Application Structure

```
userhub/
├── .github/
│   └── workflows/
│       └── ci-cd.yml              # GitHub Actions pipeline
├── k8s/
│   └── deployment.yaml            # Kubernetes manifests
├── src/
│   └── main/
│       ├── java/com/userportal/
│       │   ├── LoginServlet.java  # Authentication logic
│       │   └── RegisterServlet.java # User registration
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── views/         # Error pages (404, 500)
│           │   └── web.xml        # Servlet configuration
│           ├── index.jsp          # Landing page
│           ├── login.jsp          # Login form
│           ├── register.jsp       # Registration form
│           └── dashboard.jsp      # User dashboard
├── Terraform/
│   ├── main.tf                    # AWS infrastructure
│   ├── variables.tf               # Input variables
│   ├── outputs.tf                 # Output values
│   ├── user_data.sh               # EC2 bootstrap script
│   └── terraform.tfvars           # Variable values
├── Dockerfile                     # Multi-stage container build
├── pom.xml                        # Maven configuration
└── README.md                      # This file
```

---

## 🚀 Deployment Strategy

### Kubernetes Deployment

**High Availability Configuration:**
- **2 replica pods** running simultaneously
- **LoadBalancer service** distributes traffic
- **Rolling updates** with zero downtime
- **Health checks** ensure pod readiness

**Database Connection:**
- MySQL service running in the same cluster
- Environment variables for configuration
- Connection pooling for performance

**Scaling Strategy:**
```bash
# Manual scaling
kubectl scale deployment/userportal --replicas=5

# Auto-scaling (HPA)
kubectl autoscale deployment userportal --min=2 --max=10 --cpu-percent=80
```

---

## 🏁 Getting Started

### Prerequisites
- AWS Account with appropriate permissions
- GitHub repository with Actions enabled
- Docker installed locally (for testing)
- kubectl configured for your cluster
- Terraform CLI (v1.0+)

### Local Development

1. **Clone the repository:**
```bash
git clone <repository-url>
cd userhub
```

2. **Build the application:**
```bash
mvn clean package
```

3. **Run with Docker:**
```bash
docker build -t userportal:local .
docker run -p 8080:8080 \
  -e DB_URL="jdbc:mysql://host.docker.internal:3306/userdb" \
  -e DB_USER="timi" \
  -e DB_PASS="rootpass" \
  userportal:local
```

4. **Access the application:**
```
http://localhost:8080
```

### Infrastructure Provisioning

1. **Configure Terraform variables:**
```bash
cd Terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

2. **Initialize and apply:**
```bash
terraform init
terraform plan
terraform apply
```

3. **Retrieve outputs:**
```bash
terraform output
```

### GitHub Actions Setup

**Required Secrets:**
- `AWS_ACCESS_KEY_ID` - AWS credentials
- `AWS_SECRET_ACCESS_KEY` - AWS credentials
- `DEVOPS` - Base64-encoded kubeconfig

**Required Variables:**
- `AWS_REGION` - AWS region (e.g., us-west-2)
- `ECR_REPOSITORY` - ECR repository name

---

## 📊 Pipeline Workflow

### Trigger Events
```yaml
✓ Push to main branch       → Full pipeline (build → scan → deploy)
✓ Push to develop branch    → Build and scan only
✓ Pull request to main      → Build and scan only
✓ Manual trigger            → Full pipeline
```

### Execution Flow
```
┌─────────────────────────────────────────────────────────┐
│  1. Code Push to GitHub                                 │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│  2. Build, Test & Analyze (5-7 minutes)                 │
│     • Compile Java code                                 │
│     • Run unit tests                                    │
│     • SpotBugs analysis                                 │
│     • Package WAR file                                  │
└────────────────┬────────────────────────────────────────┘
                 │
        ┌────────┴────────┐
        ▼                 ▼
┌──────────────┐  ┌──────────────┐
│ 3a. Docker   │  │ 3b. Security │
│     Build    │  │     Scan     │
│  (3-5 min)   │  │  (2-3 min)   │
└──────┬───────┘  └──────┬───────┘
       │                 │
       └────────┬────────┘
                ▼
┌─────────────────────────────────────────────────────────┐
│  4. Deploy to Kubernetes (2-3 minutes)                  │
│     • Update deployment with new image                  │
│     • Rolling update (zero downtime)                    │
│     • Verify rollout status                             │
└─────────────────────────────────────────────────────────┘
```

**Total Pipeline Duration:** ~12-18 minutes

---

## 🔐 Security & Best Practices

### Implemented Security Measures

✅ **Container Security**
- Multi-stage builds (reduced attack surface)
- Non-root user execution
- Image scanning with Trivy
- ECR encryption at rest (AES256)

✅ **Infrastructure Security**
- VPC isolation
- Security groups with least privilege
- Encrypted EBS volumes
- SSH key-based authentication

✅ **Application Security**
- Prepared statements (SQL injection prevention)
- Environment-based configuration
- No hardcoded credentials in code

✅ **CI/CD Security**
- GitHub Secrets for sensitive data
- AWS IAM role-based access
- Artifact signing and verification
- Automated security scanning

### Known Limitations (Demo Only)

⚠️ **Plain Text Passwords** - Use bcrypt/Argon2 in production
⚠️ **No HTTPS** - Implement TLS/SSL certificates
⚠️ **Permissive Security Groups** - Restrict SSH to specific IPs
⚠️ **No Database Backups** - Implement automated backup strategy
⚠️ **No Monitoring** - Add CloudWatch/Prometheus metrics

---

## 📈 Future Enhancements

- [ ] Implement HashiCorp Vault for secrets management
- [ ] Add Prometheus + Grafana monitoring
- [ ] Integrate SonarQube for code quality
- [ ] Implement blue-green deployment strategy
- [ ] Add integration tests with Selenium
- [ ] Configure AWS WAF for application firewall
- [ ] Implement centralized logging with ELK stack
- [ ] Add API documentation with Swagger
- [ ] Configure auto-scaling policies
- [ ] Implement disaster recovery procedures

---

## 📝 License

This project is for educational and demonstration purposes.

---

## 👤 Author

**DevOps Engineer**  
Demonstrating enterprise-grade CI/CD practices with modern cloud-native technologies.

---

## 🤝 Contributing

This is a demonstration project. For production use, please implement proper security measures and follow your organization's DevOps standards.

---

**Built with ❤️ using GitHub Actions, AWS, Kubernetes, and Terraform**
