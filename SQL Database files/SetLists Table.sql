drop table if exists SetLists;

create table SetLists (
	setListId int not null,
    email varchar(320) not null,
    listName varchar(50) not null,
    foreign key (email) references Accounts (email),
    primary key (setListId)
);