# Update password
export MYSQL_ROOT_PASSWORD="password"
export MYSQL_DATABASE=mydatabase
# HTTPS keys need be updated every 90 days
# Need to figure out how to automate this
export TLSCERT=/etc/letsencrypt/live/nwhealthcareerpath.uw.edu/fullchain.pem
export TLSKEY=/etc/letsencrypt/live/nwhealthcareerpath.uw.edu/privkey.pem
# Environment variables
export REDISADDR=myredis:6379
export SESSIONKEY="key"
export SERVER2ADDR="http://organizations:5000"
export INTERNAL_PORT=:90
# export DBADDR=nwhcp-mongo:27017
# docker rm -f helloservertest;

# docker run -d --name myredis --network nwhcp-docker_default redis;

# docker rm -f nwhcp-sqldb;

# docker pull annaqzhou/nwhcp-sqldb;
# docker run -d \
# -p 3306:3306 \
# --name nwhcp-sqldb \
# --network nwhcp-docker_default \
# -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
# -e MYSQL_DATABASE=$MYSQL_DATABASE \
# annaqzhou/nwhcp-sqldb;

# docker pull annaqzhou/nwhcp-gateway; # pull image from dockerhub

GOOS=linux go build
docker build -t loibucket/nwhcp-gateway . # update to your username/nwhcp-gateway
docker rm -f gateway; # mostly for testing because have to remove docker img every time you redeploy

# Run server from docker img
docker run -p 443:443 \
-v /etc/letsencrypt:/etc/letsencrypt:ro \
-e TLSCERT=$TLSCERT \
-e TLSKEY=$TLSKEY \
-e SESSIONKEY=$SESSIONKEY \
-e REDISADDR=$REDISADDR \
-e SUMMARYADDR=$SUMMARYADDR \
-e DSN=root:$MYSQL_ROOT_PASSWORD@tcp\(nwhcp-sqldb:3306\)/$MYSQL_DATABASE \
-e SERVER2ADDR=$SERVER2ADDR \
-e INTERNAL_PORT=$INTERNAL_PORT \
--network nwhcp-docker_default \
--name gateway loibucket/nwhcp-gateway;