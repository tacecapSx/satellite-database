DROP DATABASE IF EXISTS satellitedb;
CREATE DATABASE satellitedb;
USE satellitedb;

DROP TABLE IF EXISTS Launches;
DROP TABLE IF EXISTS Participates;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Orbit;
DROP TABLE IF EXISTS Satellite;
DROP TABLE IF EXISTS Mission;
DROP TABLE IF EXISTS Agency;
DROP TABLE IF EXISTS CelestialOrbit;
DROP TABLE IF EXISTS CelestialBody;

CREATE TABLE CelestialBody
	(celestial_id			VARCHAR(8),
	 identifier				VARCHAR(15) NOT NULL,
	 mass					DECIMAL(31,0),
     diameter				DECIMAL(10,0),
     atmosphere_height		DECIMAL(10,0),
	 PRIMARY KEY(celestial_id)
	);

CREATE TABLE CelestialOrbit
	(celestial_id			VARCHAR(8),
     orbiting_id            VARCHAR(8),
     FOREIGN KEY(celestial_id) REFERENCES CelestialBody(celestial_id) ON DELETE SET NULL,
     FOREIGN KEY(orbiting_id)  REFERENCES CelestialBody(celestial_id) ON DELETE SET NULL
	);

CREATE TABLE Agency
	(agency_id				VARCHAR(8),
     agency_name            VARCHAR(60) NOT NULL,
     acronym                VARCHAR(10) NOT NULL,
     budget					DECIMAL(12,0),
     nationality			VARCHAR(20),
     PRIMARY KEY(agency_id)
	);

CREATE TABLE Mission
	(mission_id				VARCHAR(8),
     budget					DECIMAL(12,0),
     launch_date			DATE,
     launch_location		VARCHAR(20),
     status                 ENUM('Ongoing', 'Concluded', 'Lost'),
     PRIMARY KEY(mission_id)
	);

CREATE TABLE Satellite
	(satellite_id			VARCHAR(8),
     mission_id				VARCHAR(8),
     identifier				VARCHAR(60) NOT NULL,
     mass					DECIMAL(10,0),
     fuel					DECIMAL(5,0),
     satellite_type         ENUM('Observational', 'Communication', 'Weather', 'Navigation', 'Scientific', 'Rescue', 'Space Station'),
     PRIMARY KEY(satellite_id),
     FOREIGN KEY(mission_id) REFERENCES Mission(mission_id) ON DELETE SET NULL
    );

CREATE TABLE Orbit
	(satellite_id			VARCHAR(8),
     celestial_id			VARCHAR(8),
     FOREIGN KEY(satellite_id) REFERENCES Satellite(satellite_id) ON DELETE SET NULL,
     FOREIGN KEY(celestial_id) REFERENCES CelestialBody(celestial_id) ON DELETE SET NULL
    );

CREATE TABLE Employee
	(employee_id			VARCHAR(8),
     agency_id				VARCHAR(8),
	 employee_name			VARCHAR(60) NOT NULL,
     salary					DECIMAL(12,0),
     job_title				ENUM('Engineer', 'Technician', 'Researcher', 'Astrophysicist'),
     PRIMARY KEY(employee_id),
     FOREIGN KEY(agency_id) REFERENCES Agency(agency_id) ON DELETE SET NULL
	);

CREATE TABLE Participates
	(employee_id			VARCHAR(8),
     mission_id				VARCHAR(8),
     FOREIGN KEY(employee_id) REFERENCES Employee(employee_id) ON DELETE SET NULL,
     FOREIGN KEY(mission_id) REFERENCES Mission(mission_id) ON DELETE SET NULL
	);
    
CREATE TABLE Launches
	(agency_id				VARCHAR(8),
     mission_id				VARCHAR(8),
     FOREIGN KEY(agency_id) REFERENCES Agency(agency_id) ON DELETE SET NULL,
     FOREIGN KEY(mission_id) REFERENCES Mission(mission_id) ON DELETE SET NULL
	);

# Insert data!

INSERT CelestialBody VALUES
('00000000', 'Sun',     1989000000000000000000000000000, 1392700, null),
('00000001', 'Mercury', 328500000000000000000000,     4880,   null),
('00000002', 'Venus',   4867000000000000000000000,    12104,  350),
('00000003', 'Earth',   5972168000000000000000000,    12742,  10000),
('00000004', 'Mars',    639000000000000000000000,     6779,   230),
('00000005', 'Jupiter', 1898000000000000000000000000, 139820, 5000),
('00000006', 'Saturn',  568300000000000000000000000,  120536, null),
('00000007', 'Uranus',  86810000000000000000000000,   51118,  4000),
('00000008', 'Neptune', 102400000000000000000000000,  49244,  700),
('00000009', 'Pluto',   13090000000000000000000,      2377,   null),
('00000010', 'Ganymede', 148190000000000000000000, 5270, null),
('00000011', 'Titan',    134520000000000000000000, 5150, null),
('00000012', 'Callisto', 107593800000000000000000, 4820, null),
('00000013', 'Io',       89319000000000000000000, 3643, null),
('00000014', 'Moon',     73476730900000000000000, 3475, null),
('00000015', 'Europa',   47998400000000000000000, 3122, null),
('00000016', 'Triton',   21389000000000000000000, 2707, null),
('00000017', 'Titania',  3527000000000000000000, 1578, null),
('00000018', 'Rhea',     2306500000000000000000, 1529, null),
('00000019', 'Oberon',   3110400000000000000000, 1523, null),
('00000020', 'Iapetus',  1805650000000000000000, 1469, null),
('00000021', 'Charon',   1586000000000000000000, 1207, null),
('00000022', 'Umbriel',  1288500000000000000000, 1169, null),
('00000023', 'Ariel',    1270000000000000000000, 1158, null),
('00000024', 'Dione',    1050000000000000000000, 1125, null),
('00000025', 'Tethys',   617000000000000000000, 1063, null);

INSERT CelestialOrbit VALUES
# Planets, all orbiting the sun
('00000001', '00000000'),
('00000002', '00000000'),
('00000003', '00000000'),
('00000004', '00000000'),
('00000005', '00000000'),
('00000006', '00000000'),
('00000007', '00000000'),
('00000008', '00000000'),
('00000009', '00000000'),
# Moons
('00000010', '00000005'),
('00000011', '00000006'),
('00000012', '00000005'),
('00000013', '00000005'),
('00000014', '00000003'),
('00000015', '00000005'),
('00000016', '00000008'),
('00000017', '00000007'),
('00000018', '00000006'),
('00000019', '00000007'),
('00000020', '00000005'),
('00000021', '00000009'),
('00000022', '00000007'),
('00000023', '00000007'),
('00000024', '00000006'),
('00000025', '00000006');

INSERT Agency VALUES
('00000000', 'National Aeronautics and Space Administration', 'NASA', 22600000000, 'United States'),
('00000001', 'European Space Agency', 'ESA', 7800000000, 'European Union'),
('00000002', 'China National Space Administration', 'CNSA', 11940000000, 'China'),
('00000003', 'Russian Federal Space Agency', 'Roscosmos', 1920000000, 'Russia'),
('00000004', 'Japan Aerospace Exploration Agency', 'JAXA', 1024645440, 'Japan'),
('00000005', 'Indian Space Research Organisation', 'ISRO', 1503932416, 'India'),
('00000006', 'Canada Space Agency', 'CSA', 453703650, 'Canada'),
('00000007', 'Korean Comittee of Space Technology', 'KCST', null, 'North Korea');

INSERT Mission VALUES
('00000000', null, '1957-10-04', 'Baikonur', 'Concluded'),
('00000001', 150000000000, '1998-11-20', 'Baikonur', 'Ongoing'),
('00000002', 716600000, '2005-08-12', 'Cape Canaveral', 'Ongoing'),
('00000003', null, '2024-03-20', 'Wenchang', 'Ongoing'),
('00000004', 290000000, '2010-05-20', 'Tanegashima', 'Ongoing'),
('00000005', 700000000, '2011-08-05', 'Cape Canaveral', 'Ongoing'),
('00000006', 3260000000, '1997-11-15', 'Cape Canaveral', 'Concluded'),
('00000007', null, '1985-07-02', 'Guiana Space Centre', 'Concluded'),
('00000008', 650000000, '2013-02-11', 'Santa Barbara', 'Ongoing'),
('00000009', 952000000, '2002-05-04', 'Santa Barbara', 'Ongoing'),
('00000010', null, '2012-12-12', 'North Korea', 'Ongoing'),
('00000011', 8000000000, '2021-04-29', 'Wenchang', 'Ongoing'),
('00000012', 1300000000, '1999-12-18', 'Santa Barbara', 'Ongoing'),
('00000013', 648800100, '2013-07-25', 'Guinana Space Centre', 'Ongoing');

INSERT Satellite VALUES
('00000000', '00000000', 'Sputnik 1', 84, null, 'Scientific'),
('00000001', '00000001', 'International Space Station', 450000, null, 'Space Station' ),
('00000002', '00000002', 'Mars Reconnaissance Orbiter', 139, null, 'Scientific'),
('00000003', '00000003', 'Tiandu-1', 61, null, 'Communication'),
('00000004', '00000003', 'Tiandu-2', 15, null, 'Navigation'),
('00000005', '00000004', 'Akatsuki', 320, null, 'Scientific'),
('00000006', '00000005', 'Juno', 1593, null, 'Scientific'),
('00000007', '00000006', 'Cassini-Huygens', 2523, null, 'Scientific'),
('00000008', '00000007', 'Giotto', 960, 0, 'Observational'),
('00000009', '00000008', 'Landsat 8', 2623, 1111, 'Observational'),
('00000010', '00000009', 'Aqua', 3117, 0, 'Observational'),
('00000011', '00000010', 'Kwangmyongsong-3 Unit 2', 100, null, 'Observational'),
('00000012', '00000011', 'Tiangong-1', 8506, null, 'Space Station'),
('00000013', '00000012', 'Terra', 4864, null, 'Scientific'),
('00000014', '00000013', 'Inmarsat-4A F4', 6649, null, 'Communication');

INSERT Orbit VALUES
('00000001', '00000003'),
('00000002', '00000004'),
('00000003', '00000014'),
('00000004', '00000014'),
('00000005', '00000002'),
('00000006', '00000005'),
('00000008', '00000000'),
('00000009', '00000003'),
('00000010', '00000003'),
('00000011', '00000003'),
('00000012', '00000003'),
('00000013', '00000003'),
('00000014', '00000003');

INSERT Launches VALUES
('00000003', '00000000'),
('00000000', '00000001'),
('00000001', '00000001'),
('00000003', '00000001'),
('00000004', '00000001'),
('00000006', '00000001'),
('00000000', '00000002'),
('00000002', '00000003'),
('00000004', '00000004'),
('00000000', '00000005'),
('00000000', '00000006'),
('00000001', '00000006'),
('00000001', '00000007'),
('00000000', '00000008'),
('00000000', '00000009'),
('00000007', '00000010'),
('00000002', '00000011'),
('00000000', '00000012'),
('00000001', '00000013');

INSERT Employee VALUES
('00000000', '00000002', 'Lancelot Bristow', 16000, 'Technician'),
('00000001', '00000004', 'Marcus Haynes', 37500, 'Technician'),
('00000002', '00000005', 'Clement Osage', 6000, 'Researcher'),
('00000003', '00000006', 'Isla Berecraft', 22000, 'Engineer'),
('00000004', '00000006', 'Walter Dallingham', 37500, 'Engineer'),
('00000005', '00000000', 'Ellie Clarkeson', 17000, 'Astrophysicist'),
('00000006', '00000001', 'Charlotte Milns', 17000, 'Engineer'),
('00000007', '00000005', 'Ava Palmer', 30500, 'Researcher'),
('00000008', '00000001', 'Steven Bullocke', 1000, 'Astrophysicist'),
('00000009', '00000001', 'Mila Ballard', 20000, 'Researcher'),
('00000010', '00000004', 'Elizabeth Dormer', 17000, 'Astrophysicist'),
('00000011', '00000004', 'Violet Bain', 35500, 'Astrophysicist'),
('00000012', '00000000', 'Lily Cotterill', 48500, 'Astrophysicist'),
('00000013', '00000000', 'Daniel Crow', 44500, 'Engineer'),
('00000014', '00000001', 'James Jent', 15000, 'Astrophysicist'),
('00000015', '00000006', 'Lyonell Tickel', 25500, 'Researcher'),
('00000016', '00000003', 'Roland Croft', 30500, 'Researcher'),
('00000017', '00000003', 'Samuel Leynthall', 21000, 'Technician'),
('00000018', '00000003', 'Riley Brookes', 37500, 'Engineer'),
('00000019', '00000005', 'Camila Tresor', 35000, 'Technician'),
('00000020', '00000006', 'Ivy Liverich', 29500, 'Engineer'),
('00000021', '00000000', 'Violet Walster', 15500, 'Engineer'),
('00000022', '00000004', 'Roger Arrondayle', 2500, 'Technician'),
('00000023', '00000001', 'Edmund Parson', 42500, 'Researcher'),
('00000024', '00000006', 'Bryan Blakenhall', 1500, 'Technician'),
('00000025', '00000004', 'Edward Sherman', 18500, 'Astrophysicist'),
('00000026', '00000004', 'David Eliweloth', 16500, 'Astrophysicist'),
('00000027', '00000005', 'David Griffiths', 19500, 'Technician'),
('00000028', '00000000', 'James Eglisfeld', 36500, 'Researcher'),
('00000029', '00000000', 'Nova Sorensen', 28000, 'Researcher'),
('00000030', '00000003', 'Mila Ratclyff', 44500, 'Researcher'),
('00000031', '00000006', 'Bartholemew Coleman', 26500, 'Astrophysicist'),
('00000032', '00000006', 'Elena Polton', 9500, 'Technician'),
('00000033', '00000004', 'Jonathan Hardy', 10500, 'Technician'),
('00000034', '00000005', 'Ella Lave', 30000, 'Researcher'),
('00000035', '00000000', 'Evelyn Proudlock', 18000, 'Astrophysicist'),
('00000036', '00000004', 'James Wharton', 39500, 'Researcher'),
('00000037', '00000002', 'Willow Unton', 42500, 'Technician'),
('00000038', '00000006', 'Gregory Rufford', 15500, 'Researcher'),
('00000039', '00000006', 'Francis Stokey', 11000, 'Astrophysicist'),
('00000040', '00000006', 'Zoey Strickland', 26500, 'Technician'),
('00000041', '00000002', 'Henry Silvertop', 7000, 'Technician'),
('00000042', '00000002', 'Michael Joslin', 14000, 'Astrophysicist'),
('00000043', '00000000', 'Charles Hilderley', 34000, 'Engineer'),
('00000044', '00000000', 'Lawrence Sare', 28500, 'Researcher'),
('00000045', '00000005', 'Ava Knody', 48500, 'Researcher'),
('00000046', '00000003', 'Nova Edgell', 40500, 'Engineer'),
('00000047', '00000003', 'Eliana Weeks', 46500, 'Researcher'),
('00000048', '00000003', 'Harper Taplin', 42500, 'Technician'),
('00000049', '00000000', 'Ingram Marsh', 34500, 'Engineer'),
('00000050', '00000005', 'Marcus Spelman', 12500, 'Engineer'),
('00000051', '00000004', 'Violet Buchan', 21000, 'Technician'),
('00000052', '00000000', 'Ellie Williamson', 26500, 'Researcher'),
('00000053', '00000002', 'Edmund Warbulton', 5500, 'Researcher'),
('00000054', '00000003', 'Roland Aldane', 43000, 'Researcher'),
('00000055', '00000006', 'Willow Brownsmith', 12500, 'Researcher'),
('00000056', '00000002', 'George Willows', 10000, 'Technician'),
('00000057', '00000002', 'Mila Olingworth', 41000, 'Technician'),
('00000058', '00000005', 'Eleanor Thomas', 3000, 'Engineer'),
('00000059', '00000000', 'Aurora Kershaw', 32500, 'Astrophysicist'),
('00000060', '00000005', 'Madison Maler', 36000, 'Engineer'),
('00000061', '00000003', 'Naomi Goodluck', 2500, 'Astrophysicist'),
('00000062', '00000001', 'Archibald Frith', 19500, 'Engineer'),
('00000063', '00000002', 'Emilia Mugg', 47500, 'Technician'),
('00000064', '00000003', 'Jeffrey Bentley', 35500, 'Researcher'),
('00000065', '00000000', 'Violet Sinnott', 29500, 'Astrophysicist'),
('00000066', '00000000', 'Hazel Goodwine', 35500, 'Technician'),
('00000067', '00000000', 'Hazel Bacon', 49500, 'Engineer'),
('00000068', '00000001', 'Grace Broudester', 22500, 'Technician'),
('00000069', '00000002', 'Isaac Jenner', 27500, 'Engineer'),
('00000070', '00000000', 'Roger Tubney', 32000, 'Researcher'),
('00000071', '00000006', 'Hannah Saunterton', 44000, 'Researcher'),
('00000072', '00000002', 'Lillian Boyce', 47000, 'Technician'),
('00000073', '00000006', 'Layla Smollett', 13500, 'Astrophysicist'),
('00000074', '00000004', 'Andrew Molloy', 19000, 'Researcher'),
('00000075', '00000005', 'Nora Sacheverell', 40000, 'Engineer'),
('00000076', '00000000', 'Stella Longton', 47500, 'Engineer'),
('00000077', '00000002', 'Luke Sorensen', 28000, 'Engineer'),
('00000078', '00000006', 'Lawrence Mallett', 22000, 'Technician'),
('00000079', '00000000', 'Jacob Fielding', 39500, 'Engineer'),
('00000080', '00000006', 'Charlotte Semoore', 20500, 'Astrophysicist'),
('00000081', '00000001', 'Zoey Capron', 42500, 'Astrophysicist'),
('00000082', '00000004', 'Ella Midwood', 18500, 'Researcher'),
('00000083', '00000004', 'Mia Langford', 45000, 'Astrophysicist'),
('00000084', '00000000', 'Abraham Ratcliff', 15000, 'Engineer'),
('00000085', '00000006', 'Isabella Chard', 47000, 'Astrophysicist'),
('00000086', '00000006', 'Camila Marclew', 29000, 'Technician'),
('00000087', '00000005', 'Riley Ramsbottom', 23000, 'Researcher'),
('00000088', '00000004', 'Nora Trollope', 7000, 'Engineer'),
('00000089', '00000002', 'Ivy Scarlock', 13500, 'Engineer'),
('00000090', '00000000', 'Godfrey Hopwood', 24500, 'Astrophysicist'),
('00000091', '00000005', 'Anthony Isaac', 19500, 'Engineer'),
('00000092', '00000005', 'Camila Baker', 46000, 'Astrophysicist'),
('00000093', '00000005', 'Luke Brayles', 38000, 'Technician'),
('00000094', '00000006', 'Olivia Heaslewood', 47000, 'Technician'),
('00000095', '00000000', 'Ellie Stainer', 1500, 'Astrophysicist'),
('00000096', '00000002', 'Chloe Plummer', 46500, 'Astrophysicist'),
('00000097', '00000003', 'Luke Killers', 45500, 'Astrophysicist'),
('00000098', '00000001', 'Bartholemew Reddington', 21500, 'Astrophysicist'),
('00000099', '00000004', 'Humphrey Berwick', 26000, 'Astrophysicist'),
('00000100', '00000007', 'Mun Chin-sok', 15000, 'Engineer'),
('00000101', '00000007', 'Jo Pyong-so', 12000, 'Researcher'),
('00000102', '00000007', 'Paek In-nam', 10000, 'Astrophysicist'),
('00000103', '00000007', 'Byon Ju-song', 17000, 'Researcher'),
('00000104', '00000007', 'Ri Ku-hwan', 17000, 'Technician'),
('00000105', '00000007', 'Sin Sol-lan', 18000, 'Technician'),
('00000106', '00000007', 'Kang Gil-gyun', 13000, 'Astrophysicist'),
('00000107', '00000007', 'Son Ye-sun', 21000, 'Researcher'),
('00000108', '00000007', 'An Tong-rae', 19000, 'Astrophysicist'),
('00000109', '00000007', 'Li Ji-hae', 15000, 'Researcher'),
('00000110', '00000007', 'Hwang Su-ung', 16000, 'Technician'),
('00000111', '00000007', 'Jon Hye-hui', 11000, 'Engineer');

INSERT Participates VALUES
('00000093', '00000002'),
('00000080', '00000000'),
('00000086', '00000003'),
('00000094', '00000002'),
('00000098', '00000002'),
('00000041', '00000000'),
('00000075', '00000005'),
('00000090', '00000000'),
('00000070', '00000004'),
('00000089', '00000001'),
('00000070', '00000007'),
('00000062', '00000006'),
('00000052', '00000006'),
('00000000', '00000000'),
('00000028', '00000004'),
('00000002', '00000003'),
('00000070', '00000004'),
('00000016', '00000000'),
('00000022', '00000007'),
('00000046', '00000003'),
('00000090', '00000001'),
('00000099', '00000005'),
('00000028', '00000002'),
('00000091', '00000000'),
('00000013', '00000002'),
('00000065', '00000005'),
('00000048', '00000006'),
('00000080', '00000006'),
('00000044', '00000002'),
('00000026', '00000003'),
('00000046', '00000005'),
('00000037', '00000003'),
('00000039', '00000004'),
('00000022', '00000006'),
('00000069', '00000006'),
('00000007', '00000007'),
('00000039', '00000007'),
('00000074', '00000000'),
('00000074', '00000007'),
('00000082', '00000004'),
('00000100', '00000010'),
('00000101', '00000010'),
('00000102', '00000010'),
('00000103', '00000010'),
('00000104', '00000010'),
('00000105', '00000010'),
('00000106', '00000010'),
('00000107', '00000010'),
('00000108', '00000010'),
('00000109', '00000010'),
('00000110', '00000010'),
('00000111', '00000010');