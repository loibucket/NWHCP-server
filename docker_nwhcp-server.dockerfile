FROM nginx
RUN apt-get update
RUN apt-get install python3-psycopg2 python3-pip python3-pandas -y

ENV AWS_PROFILE=default

#copy files
COPY ./ginx/nginx/ /etc/nginx/
COPY ./jango /usr/jango/
WORKDIR /usr/jango
RUN pip3 install -r requirements.txt

#startup commands
ENTRYPOINT ["sh","/usr/jango/entrypoint.sh"]
