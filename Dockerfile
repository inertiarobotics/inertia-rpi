# Sample Build command
# sudo docker build --build-arg KEYCLOAK_ADMIN_USER=admin --build-arg  KEYCLOAK_ADMIN_PASWORD=password ./ -f Dockerfile --no-cache  -t inertia-rpi:buster
# Sample Run command 
# sudo docker run -it --entrypoint /bin/bash -p8080:8080 -p8081:8081 -p9990:9990 --name inertiarpi --cap-add=NET_ADMIN --privileged inertia-rpi:buster
FROM inertiaorg/nucleus-client-rpi:raspbian-buster-lite-base-03202021
ARG KEYCLOAK_ADMIN_USER=admin
ARG KEYCLOAK_ADMIN_PASWORD=password

RUN sudo apt-get update
#remove the pi user and add two users "admin" and "guest" and have the password set as "linuxpassword"
RUN deluser pi
RUN sudo -i
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/admin --gecos "Admin" admin
RUN echo "admin:linuxpassword" | chpasswd
RUN echo "root:linuxpassword"|chpasswd
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/guest --gecos "Guest" guest
RUN echo "guest:linuxpassword" | chpasswd
RUN chmod g+w /home/guest
RUN chmod o-rwx /home/*
#Add admin to sudo and guest groups
RUN usermod -a -G sudo admin
RUN usermod -a -G guest admin

# Install jdk - for keycloak
RUN sudo apt-get install default-jdk -y


COPY ./source/usr/local/bin/ /usr/local/bin/
# RUN /usr/local/bin/keycloak-13.0.0/bin/add-user-keycloak.sh -u admin -p password
RUN /usr/local/bin/keycloak-13.0.0/bin/add-user-keycloak.sh -u ${KEYCLOAK_ADMIN_USER} -p ${KEYCLOAK_ADMIN_PASWORD}
RUN chmod +x /usr/local/bin/dockerstart.sh
# Cannot turn off sslRequired on build because it needs a running keycloak server.
# RUN /usr/local/bin/keycloak-13.0.0/bin/kcadm.sh update realms/master -s sslRequired=NONE

# For development, run in interactive mode, start all programs manually inside container
# For automated testing run in detached more and use dockerstart.sh to set environment and launch test scripts
CMD /usr/local/bin/dockerstart.sh 