#!/bin/bash
apt update -y
apt install -y apache2 openjdk-11-jdk curl wget unzip

# Start and enable Apache
systemctl start apache2
systemctl enable apache2

# Install Maven
cd /opt
wget https://archive.apache.org/dist/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz
tar xzf apache-maven-3.9.5-bin.tar.gz
ln -s apache-maven-3.9.5 maven
echo 'export MAVEN_HOME=/opt/maven' >> /etc/environment
echo 'export PATH=$PATH:$MAVEN_HOME/bin' >> /etc/environment

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install kops
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
mv kops /usr/local/bin/

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Create a simple index page
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to ${project_name}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 800px; margin: 0 auto; }
        .header { background-color: #232f3e; color: white; padding: 20px; border-radius: 5px; }
        .content { padding: 20px; background-color: #f9f9f9; border-radius: 5px; margin-top: 20px; }
        .tools { background-color: #e8f4fd; padding: 15px; border-radius: 5px; margin-top: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 ${project_name} DevOps Server</h1>
            <p>Your Ubuntu EC2 instance with DevOps tools is running successfully!</p>
        </div>
        <div class="content">
            <h2>Instance Information</h2>
            <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
            <p><strong>Instance Type:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-type)</p>
            <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
            <p><strong>Public IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)</p>
            <p><strong>Server Time:</strong> $(date)</p>
            <p><strong>OS:</strong> Ubuntu 22.04 LTS</p>
        </div>
        <div class="tools">
            <h2>Installed DevOps Tools</h2>
            <ul>
                <li><strong>Java:</strong> OpenJDK 11</li>
                <li><strong>Maven:</strong> 3.9.5</li>
                <li><strong>kubectl:</strong> Latest stable</li>
                <li><strong>kops:</strong> Latest release</li>
                <li><strong>AWS CLI:</strong> v2</li>
            </ul>
        </div>
    </div>
</body>
</html>
EOF

# Set proper permissions
chown www-data:www-data /var/www/html/index.html
chmod 644 /var/www/html/index.html

# Configure UFW firewall
ufw --force enable
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp

# Clean up
rm -f /opt/apache-maven-3.9.5-bin.tar.gz
rm -f awscliv2.zip
rm -rf aws
rm -f kubectl