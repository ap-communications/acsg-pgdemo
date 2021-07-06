FROM flyway/flyway:7.11-alpine

WORKDIR /migrate
COPY ./ .

ENTRYPOINT [ "/bin/ash" ]
CMD [ "migrate.sh" ]
