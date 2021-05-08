FROM inertiaorg/nucleus-client-rpi:raspbian-buster-lite-base-03202021

#RUN /bin/sh -c sudo apt-get update
# remove the pi user and add two users "admin" and "guest" and have the password set as "linuxpassword"
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
COPY ./source/usr/local/bin/ /usr/local/bin/