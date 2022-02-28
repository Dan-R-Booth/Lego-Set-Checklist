drop table if exists SetsOwnedList;

create table SetsOwnedList (
	setsOwnedListId int not null,
    setListId int not null,
    email varchar(320) not null,
    foreign key (setListId) references SetLists (setListId),
    foreign key (email) references Accounts (email),
    primary key (setsOwnedListId)
);