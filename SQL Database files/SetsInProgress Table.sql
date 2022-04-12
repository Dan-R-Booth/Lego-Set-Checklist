drop table if exists SetsInProgress;

create table SetsInProgress (
	setInProgressId int not null,
    email varchar(320) not null,
    setNumber varchar(20) not null,
    foreign key (email) references Accounts (email),
    primary key (setsInProgressId)
);