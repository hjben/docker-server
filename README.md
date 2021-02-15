# hadoop
### Introduction
Hadoop image based on hjben/centos-systemd:latest

### Usage
#### 1. Pull image
- Pull docker image from the DockerHub, or build the image with Dockerfile.
- Docker image tag is related to the version of hadoop.
  - docker pull hjben/hadoop:{hadoop_version}
  - eg. docker pull hjben/hadoop:3.2.0

#### 2. Create docker subnet
- Create subnet network for hadoop cluster.
  - docker network create --subnet {subnet_ip} {network_name}
  - eg. docker network create --subnet 10.0.2.0/24 hadoop-cluster
  
#### 3. Run slave node container (Optional)
- When you create slave, add all static ip and host information to use at the slave container.
- Also add the subnet network information.
- Repeat running the command until the number of slave is satisfied.
- Command to run slave container is below.
  - docker run -d --privileged --name {slave_container_name} -v /sys/fs/cgroup:/sys/fs/cgroup --network {network_name} --ip {ip} --add-host={master_host}:{master_ip} --add-host={slave_hosts}:{slave_ips} hjben/hadoop3-centos:{hadoop_version}
  - eg. docker run -d --privileged --name slave1 -v /sys/fs/cgroup:/sys/fs/cgroup -v /tmp/hadoop:/usr/local/hadoop -v /tmp/hadoop_logs/logs:/opt/hadoop/logs --network hadoop-cluster --ip 10.0.2.3 --add-host=master:10.0.2.2 --add-host=slave1:10.0.2.3 hadoop-centos:3.2.0
- Command Description
  - -d: Run with daemon (background) mode
  - --name {slave_container_name}: Set container name to {slave_container_name}
  - -v /sys/fs/cgroup:/sys/fs/cgroup: Share the disk volume between host and container, to access host cgroup from the container
{host_directory_for_hadoop_log}
  - --network {network_name}: Add the container into subnet network, named by {network_name}
  - --ip {ip}: Set container static ip to {ip}
  - --add-host={host}:{ip}: Add host information to /etc/hosts

#### 4. Run master node container
- When you create master, add network informations at the master container, like slave container.
- Some volume mount option added for backup and logging.
- Command to run master container is below.
  - docker run -d --privileged --name {master_container_name} -v /sys/fs/cgroup:/sys/fs/cgroup  -v /tmp/hadoop:{host_directory_for_hdfs} -v /tmp/hadoop_logs/logs:{host_directory_for_hadoop_log} --network {network_name} -p {port_for_cluster_manager}:8088 -p {port_for_hdfs_manager}:9870 --ip {ip} --add-host={master_host}:{master_ip} --add-host={slave_hosts}:{slave_ips} hjben/hadoop:{hadoop_version}
  - eg. docker run -d --privileged --name master -v /sys/fs/cgroup:/sys/fs/cgroup --network hadoop-cluster -p 8088:8088 -p 9870:9870 --ip 10.0.2.2 --add-host=master:10.0.2.2 --add-host=slave1:10.0.2.3 hjben/hadoop:3.2.0
- Command Description
  - -d: Run with daemon (background) mode
  - --name {master_container_name}: Set container name to {master_container_name}
  - -v /sys/fs/cgroup:/sys/fs/cgroup: Share the disk volume between host and container, to access host cgroup from the container
  - -v /tmp/hadoop:{host_directory_for_hdfs}: Share the disk volume between host and container, to save hdfs system file on {host_directory_for_hdfs} for backup
  - -v /tmp/hadoop_logs/logs:{host_directory_for_hadoop_log}: Share the disk volume between host and container, to save hadoop logs on {host_directory_for_hadoop_log}
  - --network {network_name}: Add the container into subnet network, named by {network_name}
  - -p {port_for_cluster_manager}:8088: Expose the port for cluster manager as {port_for_cluster_manager}, and the port is to be forwarded to 8088 in container
  - --ip {ip}: Set container static ip to {ip}
  - --add-host={host}:{ip}: Add host information to /etc/hosts

#### 5. Revise workers information
- Before starting the hadoop service, workers information in containers must be revised.
- Revise the file "$HADOOP_HOME/etc/hadoop/workers" to your worker list (include master).
- This job is not only vaild for master container, but slave(s).
- The way to access container is in chapter 7.
- Reference is in the file. File content as default is for cluster with 1 master and 3 slaves, and their host name(container name) is master, slave1, slave2 and slave3.
  - vi $HADOOP_HOME/etc/hadoop/workers

#### 6. Start Hadoop service
- In master container shell, run the command "/start-all.sh". Then the Hadoop service will be started.
- If you're in host shell and not in container shell, command below may be work for you.
  - docker exec {master_container_name} /bin/bash -c "/start-all.sh"
  - eg. docker exec master /bin/bash -c "/start-all.sh"
- If you stoped the cluster before and want to restart cluster service, run the command "/restart-all.sh".
- "/start-all.sh" contains some linux command to format and clean HDFS. 
  
#### 7. Access to container BASH shell (With Another CLI)
- You can access to the container by typing "docker exec" command.
  - docker exec -it {container_name} bash
  - eg. docker exec -it master bash
  
#### 8. Hadoop service test
- Hadoop sample job is in the master container, you can execute the job with the command below in the container shell
  - yarn jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-{hadoop_version}.jar pi 2 5
  - eg. yarn jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.0.jar pi 2 5
- You can access to cluster manager web page on: http://localhost:{port_for_cluster_manager}
- Or if you want to see hdfs manager web page, access to http://localhost:{port_for_hdfs_manager}

### Usage (with docker-compose)
If your machine has docker-compose, you may use the docker-compose.yml file. Using docker-compose.yml, hadoop container will be automatically set with 1 master and 3 slaves.

#### 1. Docker-compose service up
- Set your current directory to where the docker-compose.yml placed.
- Then, all preparations are done. Just run the command below.
  - docker-compose up -d
- You can start the hadoop service with the command.
  - docker exec master /bin/bash -c "/start-all.sh" or
  - docker exec master /bin/bash -c "/restart-all.sh" (use this in case of re-starting)
  
#### 2. Docker-compose service stop
- If you want to stop the hadoop cluster, just run the command below with the current directory be set to where the docker-compose.yml placed.
  - docker-compose stop
- The hadoop containers are just stopped, so you can start the containers anytime with "start" command.
  - docker-compose start
  
#### 3. Docker-compose service down 
- Stop command will stop all hadoop containers, but not remove. If you're planning to delete the containers, too, use the 'down' command.
  - docker-compose down
