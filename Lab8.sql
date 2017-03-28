-- Michael Hercules Sirico Lab 8

--Part1 ERD: Please See PDF for ERD diagram

--Part2 Creation SQL

Create table Persons(
    PID text not null unique Primary Key,
    fName text not null,
    lName text not null,
    Spouse text references Persons(PID)
);
    
Create table Directors(
    PID text not null references Persons(PID),
    filmSchool text not null,
    dgAnniversary date,
    favLensManu text not null
);

Create table Actors(
    PID text not null references Persons(PID),
    birthday date not null,
    haircolor text not null,
    eyecolor text not null,
    favcolor text not null,
    inchHeight text not null,
    lbsWeight text not null,
    sagAnniversary date
);

Create table ZIPCode(
    ZIP int not null unique Primary Key,
    City text not null,
    State text not null
);

Create table Address(
    StreetAddress text not null unique Primary Key,
    ZIP int references ZIPCode(ZIP)
);

Create table Movies(
    MID text not null unique Primary Key,
    name text not null,
    year int not null,
    mpaanum int,
    domesticBOsalesUSD int,
    foreignBOsalesUSD int,
    dvdBluRaysalesUSD int
);

Create table PersonsMovieRelations(
    PID text not null references Persons(PID),
    MID text not null references Movies(MID),
    role text not null Check (role = 'Actor' OR role = 'Director')
);

/* Part3 Functional dependencies 

Persons) PID ->  First Name, Last Name, Address, Spouse

Directors) PID -> Film School, Directors Guild Anniversary Date, Favorite Lens Maker

Actors) PID -> Birth Date, Hair Color, Eye Color, Inch Height, Pounds Weight, Favorite Color, Screen Actors Guild Anniversary Date

Address) StreetAddress -> ZIP

ZIPCode) ZIP -> City, State

Movies) MID -> Name, Year Released, MPAA Number, Domestic Box Office Sales, Foreign Box Office Sales, DVD/Blu-Ray Sales

PersonsMovieRelations) MID, PID -> Role

*/

--Part4 QUERY:

Select *
 From Directors
  Inner Join Persons
   on Persons.PID=Directors.PID
    Where PID = (Select PID
                  From PersonsMovieRelations
                   Where MID = (Select MID 
                                 From PersonsMovieRelations
                                  Inner Join Persons on PersonsMovieRelations.PID = Persons.PID
                                   Where Persons.fName = 'Sean' AND Persons.lName = 'Connery'))
     AND Role = 'Director';
				




 