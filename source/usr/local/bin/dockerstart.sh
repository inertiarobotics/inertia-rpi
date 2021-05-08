#!/bin/sh
echo "===== Starting keycloak importing realm ===="
/usr/local/bin/keycloak-13.0.0/bin/standalone.sh -b 0.0.0.0 -Dkeycloak.import=/usr/local/bin/keycloak-opts/inertia-rpi-realm.json &
# Sleep 30 seconds to wait for keycloak to start up in standalone mode
sleep 120



echo "====== Turn off SSL for master realm to allow access to containerized keycloak on cloud hosts====== "
# Log into http://localhost:8080/auth as user admin of realm master 
/usr/local/bin/keycloak-13.0.0/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user admin --password password
sleep 10
/usr/local/bin/keycloak-13.0.0/bin/kcadm.sh  update realms/master -s sslRequired=NONE
# Sleep 2 seconds to wait for keycloak to start up in standalone mode
sleep 10


# echo "=== export realm:inertia-rpi-realm into a file"
# /usr/local/bin/keycloak-13.0.0/bin/standalone.sh \
# -b 0.0.0.0
# -Dkeycloak.migration.action=export \
# -Dkeycloak.migration.provider=singleFile \
# -Dkeycloak.migration.realmName=inertia-rpi-realm \
# -Dkeycloak.migration.file=/tmp/inertia-rpi-realm.json
# -Djboss.socket.binding.port-offset=99
# #sleep 30 seconds
# sleep 30