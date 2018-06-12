#!/usr/bin/env bash
echo -e "\e[33m==== Installing OpenShift Origin v3.9.0--191 locally ====\e[0m"
echo -e "\e[33m= Installing Docker... =\e[0m"
yum install docker -y
echo -e "\e[33m= Updating installed packages... =\e[0m"
yum update -y
echo -e "\e[33m= Downloading OpenShift Origin CLient Tools... =\e[0m"
wget https://github.com/openshift/origin/releases/download/v3.9.0/openshift-origin-client-tools-v3.9.0-191fece-linux-64bit.tar.gz
echo -e "\e[33m= Extracting OpenShift Origin CLient Tools... =\e[0m"
tar -xzf openshift-origin-client-tools-v3.9.0-191fece-linux-64bit.tar.gz && echo -e "\e[33m= Adding OpenShift Origin CLient Tools binary to path... =\e[0m" && echo $(PATH=$PATH:~/openshift-origin-client-tools-v3.9.0-191fece-linux-64bit/)
echo -e "\e[33m= Enabling Docker... =\e[0m"
systemctl enable docker && systemctl start docker
echo -e "\e[33m= Updating Docker configuration... =\e[0m"
cat << EOF > /etc/docker/daemon.json 
{
   "insecure-registries": [
     "172.30.0.0/16"
   ]
}
EOF
echo -e "\e[33m= Restarting Docker... =\e[0m"
systemctl daemon-reload && systemctl restart docker
echo -e "\e[33m= Updating firewall configuration... =\e[0m"
firewall-cmd --permanent --new-zone dockerc
firewall-cmd --permanent --zone dockerc --add-source 172.17.0.0/16
firewall-cmd --permanent --zone dockerc --add-port 8443/tcp
firewall-cmd --permanent --zone dockerc --add-port 53/udp
firewall-cmd --permanent --zone dockerc --add-port 8053/udp
firewall-cmd --reload
echo -e "\e[33m= Version Information =\e[0m"
docker version
oc version
echo -e "\e[32mDONE!\e[0m"
echo -e "Run \e[32moc cluster up \e[0m to start OpenShift. Don't forget to run \e[32moc cluster down \e[0m once you are done."
