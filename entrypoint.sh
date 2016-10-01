#!/bin/sh

MINIO_USER=gjones
MINIO_UID=1000
user_exists=$(id -u ${MINIO_USER} > /dev/null 2>&1; echo $?) 
user_uid=$(id -u ${MINIO_USER}) 

if [ "$user_exists" ]; then
      echo "user exists"
      if [ "$MINIO_UID" == "$user_uid" ]; then
         echo "UIDs are same, not doing anything"
      else
         echo "Need to change UIDs..."
      fi
else
      echo "user does not exist, creating"
      addgroup -g ${MINIO_GID} ${MINIO_GROUP} \
          && adduser -u ${MINIO_UID} -G ${MINIO_GROUP} -s /bin/bash ${MINIO_USER} -D -h "${MINIO_HOMEDIR}" 
fi


env

#if [ ]; then
   mkdir -p $MINIO_HOMEDIR
#fi

mkdir -p /etc/X11 && chown -R ${MINIO_UID} /etc/X11 && chmod -R 777 /etc/X11

chown -R ${MINIO_UID}:${MINIO_GID} "${MINIO_HOMEDIR}"
/usr/bin/gosu ${MINIO_UID} /go/bin/minio server $@

