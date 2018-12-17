Docker Zabbix - Zabbix in a Single Container
==========================================

## Zabbix Container 

The container comes with the following component

* Zabbix Server* at port 10051.
* Zabbix Web UI* at port 80 (e.g. `http://$container_ip/zabbix` ) user name: admin, Password: zabbix
* Zabbix Agent*.
* A MySQL supporting Zabbix front-end, user is `zabbix` and password is `zabbix`.

## Building the Docker Zabbix Repository.

```
# Clone Repo 
$ git clone https://github.com/paglasoft/zabbix-docker.git

# CD into the docker container code.
$ cd /zabbix-docker

# Build the contaienr code.
$ docker build -t zabbix .

# Run it!
$ docker run --name zabbix -dit -p 80:80 -p 10051:10051 zabbix
```

## Access into Docker

```
$ docker exec -it containerid bash

```
# Ansible example - Creating Host in Zabbix and Downloading Template
```
Login to container  then run the following command 

To add Host - 'ansible-playbook add_host.yml'
To download Template - 'ansible-playbook download_template.yml' ( the template will in '/' directory)
