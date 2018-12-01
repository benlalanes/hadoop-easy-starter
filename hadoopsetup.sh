#!/bin/bash

# Java 8 JDK installation
sudo add-apt-repository universe
sudo apt-get update -y
sudo apt install openjdk-8-jre-headless -y
sudo apt install ssh -y

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

# HBase installation
cd ~/hadoop
wget http://apache.claz.org/hbase/2.1.0/hbase-2.1.0-bin.tar.gz
tar xzvf hbase-2.1.0-bin.tar.gz
rm hbase-2.1.0-bin.tar.gz
mv hbase-2.1.0/ hbase

echo "export HBASE_HOME=/home/$USER/hadoop/hbase" >> ~/.bashrc
echo 'export PATH=$PATH:$HBASE_HOME/bin' >> ~/.bashrc

echo 'export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64' | tee -a /home/$USER/hadoop/hbase/conf/hbase-env.sh
echo "<configuration><property><name>hbase.cluster.distributed</name><value>true</value></property><property><name>hbase.rootdir</name><value>hdfs://localhost:9000/hbase</value></property><property><name>hbase.zookeeper.property.dataDir</name><value>/home/$USER/hadoop/hbase-zookeeper</value></property></configuration>" > /home/$USER/hadoop/hbase/conf/hbase-site.xml

# Apache Pig instllation
cd ~/hadoop
wget https://archive.apache.org/dist/pig/pig-0.16.0/pig-0.16.0.tar.gz
tar zxvf pig-0.16.0.tar.gz
rm pig-0.16.0.tar.gz
mv pig-0.16.0/ pig/

echo "export PIG_HOME=/home/$USER/hadoop/pig" >> ~/.bashrc
echo 'export PATH=$PATH:$PIG_HOME/bin' >> ~/.bashrc
echo 'export PIG_CLASSPATH=$HADOOP_HOME/conf' >> ~/.bashrc

echo -e "\n"
echo "Installation Finished!"
echo "Run the following commands to format and run HDFS and run YARN:"
echo '$ source ~/.bashrc'
echo '$ hdfs namenode -format'
echo '$ start-dfs.sh'
echo '$ start-yarn.sh'
echo -e "\nRun the following to get started with HBase:"
echo '$ start-hbase.sh'
echo '$ hbase shell'
echo -e "\nRun the following to get started with Pig:"
echo '$ pig -x local'