// database name is 'pgdemo'
// create database pgdemo;
// \l      # check database list
// \c pgdemo    ＃ switch database


CREATE TABLE tasks (
    id SERIAL NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    PRIMARY KEY (id)
);

insert into tasks (name, created_at, updated_at) values ('Fist task', current_timestamp, current_timestamp);
insert into tasks (name, created_at, updated_at) values ('Second task', current_timestamp, current_timestamp);
insert into tasks (name, created_at, updated_at) values ('Third task', current_timestamp, current_timestamp;
insert into tasks (name, created_at, updated_at) values ('Fourth task', current_timestamp, current_timestamp);
