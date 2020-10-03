# hadoop3-centos
### Introduction
Hadoop-3.2.0 image based on hjben/centos8-systemd:latest

### Usage
#### 1. Pull image
- Pull latest docker image from the DockerHub, or build the image with Dockerfile.
  - docker pull hjben/hadoop3-centos:3.2.0

#### 2. Create docker subnet
- Create subnet network for hadoop cluster.
  - docker network create --subnet {subnet_ip} {network_name}
  - eg. docker network create --subnet 10.0.2.0/24 hadoop-cluster
  
#### 3. Run slave node container (Optional)
- When you create slave, add all static ip and host information to use at the slave container.
- Also add the subnet network information.
- Repeat running the command until the number of slave is satisfied.
- Command to run slave container is below.
  - docker run -d --privileged --name {slave_container_name} -v /sys/fs/cgroup:/sys/fs/cgroup --network {network_name} --ip {ip} --add-host={master_host}:{master_ip} --add-host={slave_hosts}:{slave_ips} hjben/hadoop3-centos:3.2.0 /bin/bash -c "init"
  - eg. docker run -d --privileged --name slave1 -v /sys/fs/cgroup:/sys/fs/cgroup --network hadoop-cluster --ip 10.0.2.3 --add-host=master:10.0.2.2 --add-host=slave1:10.0.2.3 hadoop3-centos:3.2.0 /bin/bash -c "init"
- Command Description
  - -d: Run with daemon (background) mode
  - --name {slave_container_name}: Set container name to {slave_container_name}
  - -v /sys/fs/cgroup:/sys/fs/cgroup: Share the disk volume between host and container, to access host cgroup from the container
  - --network {network_name}: Add the container into subnet network, named by {network_name}
  - --ip {ip}: Set container static ip to {ip}
  - --add-host={host}:{ip}: Add host information to /etc/hosts
  - /bin/bash -c "init": Run systemd init command when the container started

#### 4. Run master node container
- When you create master, add network informations at the master container, like slave container.
- Command to run master container is below.
  - docker run -d --privileged --name {master_container_name} -v /sys/fs/cgroup:/sys/fs/cgroup --network {network_name} -p {port_for_cluster_manager}:8088 --ip {ip} --add-host={master_host}:{master_ip} --add-host={slave_hosts}:{slave_ips} hjben/hadoop3-centos:3.2.0 /bin/bash -c "init"
  - eg. docker run -d --privileged --name master -v /sys/fs/cgroup:/sys/fs/cgroup --network hadoop-cluster -p 12345:8088 --ip 10.0.2.2 --add-host=master:10.0.2.2 --add-host=slave1:10.0.2.3 hjben/hadoop3-centos:3.2.0 /bin/bash -c "init"
- Command Description
  - -d: Run with daemon (background) mode
  - --name {master_container_name}: Set container name to {master_container_name}
  - -v /sys/fs/cgroup:/sys/fs/cgroup: Share the disk volume between host and container, to access host cgroup from the container
  - --network {network_name}: Add the container into subnet network, named by {network_name}
  - -p {port_for_cluster_manager}:8088: Expose the port for cluster manager as {port_for_cluster_manager}, and the port is to be forwarded to 8088 in container
  - --ip {ip}: Set container static ip to {ip}
  - --add-host={host}:{ip}: Add host information to /etc/hosts
  - /bin/bash -c "init": Run systemd init command when the container started

#### 5. Revise workers information
- Before starting the hadoop service, workers information in containers must be revised.
- Revise the file "$HADOOP_HOME/etc/hadoop/workers" to your worker list (include master).
- This job is not only vaild for master container, but slave(s).
- The way to access container is in chapter 7.
- Reference is in the file. File content as default is for cluster with 1 master and 3 slaves, and their host name(container name) is master, slave1, slave2 and slave3.
  - vi $HADOOP_HOME/etc/hadoop/workers

#### 6. Start Hadoop service
- In master container shell, run the command "/start-all.sh". then the Hadoop service will be started.
- If you're in host shell, command below may be work for you.
  - docker exec {master_container_name} /bin/bash -c "/start-all.sh"
  - eg. docker exec master /bin/bash -c "/start-all.sh"
  
#### 7. Access to container BASH shell (With Another CLI)
- You can access to the container by typing "docker exec" command.
  - docker exec -it {container_name} bash
  - eg. docker exec -it master bash
  
#### 8. Hadoop service test
- Hadoop sample job is in the master container, you can execute the job with the command below in the container shell
  - yarn jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.0.jar pi 2 5
- You can access to cluster manager web page on: http://localhost:{port_for_cluster_manager}

#### 9. Enjoy your Hadoop cluster!
