#!/bin/sh

#We use the UID, don't care about the user name (because docker :/)
#user_exists=$(id -u ${MINIO_USER} > /dev/null 2>&1; echo $?) 
user_uid=$(id -u ${MINIO_USER} 2> /dev/null) 
uid_exists=$(getent passwd $MINIO_UID)

#Default GID to UID unless explicitly set
if [ ! "$MINIO_GID" ]; then
   MINIO_GID=$MINIO_UID
fi

#Default export dir to /export (which is default for minio)
if [ ! "$MINIO_HOMEDIR" ]; then
   MINIO_HOMEDIR=/export
fi

if [ "$uid_exists" ]; then
      echo "user exists"
# else
#    echo "user doesn't exist"
# fi
else
      echo "user does not exist, creating"
      addgroup -g ${MINIO_GID} ${MINIO_GROUP} \
          && adduser -u ${MINIO_UID} -G ${MINIO_GID} -s /bin/bash ${MINIO_USER} -D -h "${MINIO_HOMEDIR}" 
fi


env

#if [ ]; then
   mkdir -p $MINIO_HOMEDIR
#fi

#Minio perms hack, won't work without this...
mkdir -p /etc/X11 && chown -R ${MINIO_UID} /etc/X11 && chmod -R 777 /etc/X11

chown -R ${MINIO_UID}:${MINIO_GID} "${MINIO_HOMEDIR}"
export HOME="${MINIO_HOMEDIR}"
/usr/bin/gosu ${MINIO_UID} /go/bin/minio $@

