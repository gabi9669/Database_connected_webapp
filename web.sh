#!/bin/bash
# Create your provisioning script here

sudo apt-get update
sudo apt-get install -y openjdk-11-jre-headless

sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat

cd /tmp
sudo yes | cp -rf /vagrant/apache-tomcat-9.0.41.tar.gz ./

sudo mkdir /opt/tomcat
sudo tar xzvf apache-tomcat-*tar.gz -C /opt/tomcat --strip-components=1

cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat

sudo chmod -R g+r conf
sudo chmod g+x conf
sudo  chown -R tomcat webapps/ work/ temp/ logs/

sudo yes | cp -rf /vagrant/tomcat_files/tomcat.service /etc/systemd/system/tomcat.service

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

sudo yes | cp -rf /vagrant/setenv.sh /opt/tomcat/bin/setenv.sh

sudo cp /vagrant/web.war /opt/tomcat/webapps/ROOT.war

rm -r /opt/tomcat/webapps/ROOT

sudo yes | cp -rf /vagrant/tomcat_files/tomcat-users.xml /opt/tomcat/conf/
sudo yes | cp -rf /vagrant/tomcat_files/context.xml /opt/tomcat/webapps/manager/META-INF/
sudo yes | cp -rf /vagrant/tomcat_files/context.xml /opt/tomcat/webapps/host-manager/META-INF/

sudo systemctl restart tomcat