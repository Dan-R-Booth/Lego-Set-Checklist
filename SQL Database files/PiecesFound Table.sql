drop table if exists PiecesFound;

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