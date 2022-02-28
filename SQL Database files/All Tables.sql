drop table if exists Accounts, SetsInProgress, PiecesFound, SetLists, SetsInSetList, SetsOwnedList;

create table Accounts (
	email varchar(320) not null,
    password varchar(100) not null,
    primary key (email)
);

create table SetsInProgress (
	setsInProgressId int not null,
    email varchar(320) not null,
    setNumber varchar(20) not null,
    foreign key (email) references Accounts (email),
    primary key (setsInProgressId)
);

create table PiecesFound (
	pieceFoundId int not null,
    setsInProgressId int not null,
    pieceNumber varchar(20) not null,
    colourNumber varchar(20) not null,
    isSpare boolean not null,
    quantityFound int not null,
    foreign key (setsInProgressId) references SetsInProgress (setsInProgressId),
    primary key (pieceFoundId)
);

create table SetLists (
	setListId int not null,
    email varchar(320) not null,
    listName varchar(50) not null,
    foreign key (email) references Accounts (email),
    primary key (setListId)
);

create table SetsInSetList (
	setsInSetListId int not null,
    setNumber varchar(20) not null,
    setListId int not null,
    foreign key (setListId) references SetLists (setListId),
    primary key (setsInSetListId)
);

create table SetsOwnedList (
	setsOwnedListId int not null,
    setListId int not null,
    email varchar(320) not null,
    foreign key (setListId) references SetLists (setListId),
    foreign key (email) references Accounts (email),
    primary key (setsOwnedListId)
);