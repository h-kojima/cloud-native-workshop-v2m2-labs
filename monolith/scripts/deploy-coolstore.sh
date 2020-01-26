#!/bin/bash

USERXX=$1

if [ -z $USERXX ]
  then
    echo "Usage: Input your username like deploy-boolstore.sh user1"
    exit;
fi

echo Your username is $USERXX

echo Deploy coolstore project........

oc new-project $USERXX-coolstore-dev
oc new-app https://raw.githubusercontent.com/h-kojima/aro-handson/master/coolstore-monolith-binary-build.yml

cd /projects/cloud-native-workshop-v2m2-labs/monolith/
MAVEN_OPTS="-Xmx1024M -Xss128M -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=1024M -XX:+CMSClassUnloadingEnabled" mvn clean package -Popenshift
oc start-build coolstore --from-file=deployments/ROOT.war
oc rollout status -w dc/coolstore
