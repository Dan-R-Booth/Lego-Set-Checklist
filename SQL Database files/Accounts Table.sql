drop table if exists Accounts;

create table Accounts (
	email varchar(320) not null,
    password varchar(100) not null,
    primary key (email)
);