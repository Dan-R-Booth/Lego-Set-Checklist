drop table if exists SetsInSetList;

create table SetsInSetList (
	setInSetListId int not null,
    setNumber varchar(20) not null,
    setListId int not null,
    foreign key (setListId) references SetLists (setListId),
    primary key (setInSetListId)
);