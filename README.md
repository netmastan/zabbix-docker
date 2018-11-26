Docker Zabbix - Platform Monitoring
==================================

## Platform Monitoring Container 

A simple all in one Container:

* A *Zabbix Server* at port 10051.
* A *Zabbix Web UI* at port 80 (e.g. `http://$container_ip/zabbix` ) user name: admin, Password: zabbix
* A *Zabbix Agent*.
* A MySQL supporting *Zabbix*, user is `zabbix` and password is `zabbix`.

## Building the Docker Zabbix Repository.

```
# CD into the docker container code.
cd /docker-zabbix
# Build the contaienr code.
docker build -t zabbix .
# Run it!
docker run --name zabbix -dit -p 80:80 -p 10051:10051 zabbix
```


## Exploring the Docker Zabbix Container

```
# docker exec -it containerid bash

```
# Ansible example - Creating Host in Zabbix and Downloading Template
```
Login to container  then run the following command 

To add Host - 'ansible-playbook add_host.yml'
To download Template - 'ansible-playbook download_template.yml' ( the template will in / d)
