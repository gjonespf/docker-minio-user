FROM    minio/minio:latest
#FROM frolvlad/alpine-glibc

#ADD https://dl.minio.io/server/minio/release/linux-amd64/minio /usr/bin/minio
ADD https://github.com/tianon/gosu/releases/download/1.9/gosu-amd64 /usr/bin/gosu
RUN chmod +x /usr/bin/gosu

ADD entrypoint.sh /
RUN  chmod +x /entrypoint.sh

ENV     MINIO_USER=www-data
ENV     MINIO_GROUP=www-data
ENV     MINIO_UID=33
#This should probably default from UID...
#ENV     MINIO_GID=33
ENV     MINIO_HOMEDIR=/export

VOLUME      ["/export"]

CMD         ["server", "/export"]
ENTRYPOINT  ["/entrypoint.sh"]
