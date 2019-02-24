#!/bin/sh

curl -m 10 --fail http://localhost:9000/minio/health/live || exit 1
echo Live
curl -m 10 --fail http://localhost:9000/minio/health/ready || exit 1
echo Ready

echo OK
exit 0


