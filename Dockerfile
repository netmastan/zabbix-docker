FROM ubuntu:xenial

#Settings Some labels
LABEL org.opencontainers.image.title="zabbix-docker" \
      org.opencontainers.image.authors="paglasoft@gmail.com" \
      org.opencontainers.image.vendor="Syed M Rasel" \
      org.opencontainers.image.licenses="GPL 2.0" \
      org.opencontainers.image.url="" \
      org.opencontainers.image.ref.name="" \
      org.opencontainers.image.description="Docker Zabbix all in one container" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.source="https://github.com/paglasoft/zabbix-docker.git" \
      org.opencontainers.image.documentation="" 


#Update and install require tools
RUN apt-get update && \
     apt-get install sudo -y && \ 
     apt-get install wget -y


#Zabbix ubuntu packages missing database schema hence install directlty. Zabbix 4.0
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN cd /tmp  && \
     wget https://repo.zabbix.com/zabbix/4.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.0-2+xenial_all.deb && \ 
     dpkg -i zabbix-release_4.0-2+xenial*.deb && \ 
     apt-get update && \ 
     apt-get install zabbix-server-mysql zabbix-agent zabbix-frontend-php -y 


# MySQL settings
ADD ./mysql/my.cnf /etc/mysql/conf.d/my.cnf

#PHP settings
ADD ./php/php.ini /etc/php/7.0/apache2/php.ini

# Zabbix Conf Files
ADD ./zabbix/zabbix.ini 				/etc/php.d/zabbix.ini
ADD ./zabbix/httpd_zabbix.conf  		/etc/httpd/conf.d/zabbix.conf
ADD ./zabbix/zabbix.conf.php    		/etc/zabbix/web/zabbix.conf.php
ADD ./zabbix/zabbix_agentd.conf 		/etc/zabbix/zabbix_agentd.conf
ADD ./zabbix/zabbix_java_gateway.conf 	/etc/zabbix/zabbix_java_gateway.conf
ADD ./zabbix/zabbix_server.conf 		/etc/zabbix/zabbix_server.conf

RUN chmod 640 /etc/zabbix/zabbix_server.conf
RUN chown root:zabbix /etc/zabbix/zabbix_server.conf

#Install Ansible and PIP
RUN apt-get install python-pip -y && \ 
    pip install zabbix-api && \ 
    sudo pip install --upgrade ansible 

RUN mkdir /etc/ansible/ && \ 
    touch /etc/ansible/hosts && \ 
    chmod 777 /etc/ansible/hosts && \ 
    echo "localhost ansible_connection=local" >> /etc/ansible/hosts

ADD ./ansible/add_host.yml /add_host.yml
ADD ./ansible/download_template.yml /download_template.yml

# Startup script when container spin up
ADD ./scripts/start.sh /start.sh
RUN chmod 755 /start.sh

# zabbix server, web console
EXPOSE 10051 10052 80
VOLUME ["/var/lib/mysql", "/usr/lib/zabbix/alertscripts", "/usr/lib/zabbix/externalscripts", "/etc/zabbix/zabbix_agentd.d"]
ENTRYPOINT ["/start.sh"]
CMD ["/bin/bash"]
