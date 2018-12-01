#!/bin/bash

# Java 8 JDK installation
add-apt-repository universe
apt-get update -y
apt install openjdk-8-jre-headless -y
apt install ssh -y
apt install wget -y

echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc

# enable SSH from localhost
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys

# download Hadoop
cd ~
mkdir hadoop
cd hadoop
wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.1/hadoop-2.7.1.tar.gz
tar xzf hadoop-2.7.1.tar.gz
rm hadoop-2.7.1.tar.gz
mv hadoop-2.7.1/ hadoop/

# set Hadoop env variables
echo "export HADOOP_HOME=/home/$USER/hadoop/hadoop" >> ~/.bashrc
echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export YARN_HOME=$HADOOP_HOME' >> ~/.bashrc
echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> ~/.bashrc
echo 'export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin' >> ~/.bashrc

echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64' | sudo tee -a /home/$USER/hadoop/hadoop/etc/hadoop/hadoop-env.sh
echo '<configuration><property><name>fs.default.name</name><value>hdfs://localhost:9000</value></property></configuration>' | sudo tee /home/$USER/hadoop/hadoop/etc/hadoop/core-site.xml
echo "<configuration><property><name>dfs.replication</name><value>1</value></property><property><name>dfs.name.dir</name><value>file:///home/$USER/hadoopinfra/hdfs/namenode</value></property><property><name>dfs.data.dir</name><value>file:///home/$USER/hadoopinfra/hdfs/datanode</value></property></configuration>" | sudo tee /home/$USER/hadoop/hadoop/etc/hadoop/hdfs-site.xml
echo '<configuration><property><name>yarn.resourcemanager.hostname</name><value>127.0.0.1</value></property><property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property></configuration>' | sudo tee /home/$USER/hadoop/hadoop/etc/hadoop/yarn-site.xml
echo '<configuration><property><name>mapreduce.framework.name</name><value>yarn</value></property></configuration>' | sudo tee /home/$USER/hadoop/hadoop/etc/hadoop/mapred-site.xml

echo -e "\n"
echo "Installation Finished!"
echo "Run the following commands to format and run HDFS and run YARN:"
echo '$ source ~/.bashrc'
echo '$ hdfs namenode -format'
echo '$ start-dfs.sh'
echo '$ start-yarn.sh'