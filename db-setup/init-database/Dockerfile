FROM debian:buster-slim

RUN apt-get update && apt-get install -y postgresql-client
WORKDIR /db-setup
COPY ./ .

CMD [ "bash", "./create-database.bash" ]
