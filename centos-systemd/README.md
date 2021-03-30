# centos-systemd
### Introduction
CentOS base image with systemd(systemctl command)-enabled and some utilities

### Usage
#### 1. Pull image
- Pull docker image from the DockerHub with latest tag, or build the image with Dockerfile.
  - docker pull hjben/centos-systemd:latest
  
#### 2. Run container
- Command to run centos container is below.
  - docker run -d --privileged --name {container_name} -v /sys/fs/cgroup:/sys/fs/cgroup hjben/centos-systemd:latest
  - eg. docker run -d --privileged --name centos -v /sys/fs/cgroup:/sys/fs/cgroup hjben/centos-systemd:latest
- Command Description
  - -d: Run with daemon (background) mode
  - --privileged: Share the host permission with container
  - --name {container_name}: Set container name to {container_name}
  - -v /sys/fs/cgroup:/sys/fs/cgroup: Share the disk volume between host and container, to access host cgroup from the container
  
#### 3. Access to container BASH shell
- You can access to the container by typing the "docker exec" command.
  - docker exec -it {container_name} bash
  - eg. docker exec -it centos bash
  
#### 4. Then, enjoy your CentOS!
