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
     nationality			VARCHAR(20),
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
     PRIMARY KEY(satellite_id),
     FOREIGN KEY(celestial_id) REFERENCES CelestialBody(celestial_id) ON DELETE SET NULL
    );

CREATE TABLE Employee
	(employee_id			VARCHAR(8),
     agency_id				VARCHAR(8),
     salary					DECIMAL(12,0),
     employee_name			VARCHAR(20) NOT NULL,
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
('00000010', 'Ganymede', null, 5270, null),
('00000011', 'Titan',    null, 5150, null),
('00000012', 'Callisto', null, 4820, null),
('00000013', 'Io',       null, 3643, null),
('00000014', 'Moon',     null, 3475, null),
('00000015', 'Europa',   null, 3122, null),
('00000016', 'Triton',   null, 2707, null),
('00000017', 'Titania',  null, 1578, null),
('00000018', 'Rhea',     null, 1529, null),
('00000019', 'Oberon',   null, 1523, null),
('00000020', 'Iapetus',  null, 1469, null),
('00000021', 'Charon',   null, 1207, null),
('00000022', 'Umbriel',  null, 1169, null),
('00000023', 'Ariel',    null, 1158, null),
('00000024', 'Dione',    null, 1125, null),
('00000025', 'Tethys',   null, 1063, null);

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
('00000005', 'Indian Space Research Organisation', 'ISRO', 150393241659, 'India'),
('00000006', 'Canada Space Agency', 'CSA', 453703650, 'Canada');

INSERT Mission VALUES
('00000000', null, '1957-10-04', 'Baikonur'),
('00000001', 150000000000, '1998-11-20', 'Baikonur'),
('00000002', 716600000, '2005-08-12', 'Cape Canaveral'),
('00000003', null, '2024-03-20', 'Wenchang'),
('00000004', 290000000, '2010-05-20', 'Tanegashima'),
('00000005', 700000000, '2011-08-05', 'Cape Canaveral'),
('00000006', 3260000000, '1997-11-15', 'Cape Canaveral'),
('00000007', null, '1985-07-02', 'Guiana Space Centre');

INSERT Satellite VALUES
('00000000', '00000000', 'Sputnik 1', 84, null, 'Scientific'),
('00000001', '00000001', 'International Space Station', 450000, null, 'Space Station' ),
('00000002', '00000002', 'Mars Reconnaissance Orbiter', 139, null, 'Scientific'),
('00000003', '00000003', 'Tiandu-1', 61, null, 'Communication'),
('00000004', '00000003', 'Tiandu-2', 15, null, 'Navigation'),
('00000005', '00000004', 'Akatsuki', 320, null, 'Scientific'),
('00000006', '00000005', 'Juno', 1593, null, 'Scientific'),
('00000007', '00000006', 'Cassini-Huygens', 2523, null, 'Scientific'),
('00000008', '00000007', 'Giotto', 960, 0, 'Observational');

INSERT Orbit VALUES
('00000001', '00000003'),
('00000002', '00000004'),
('00000003', '00000014'),
('00000004', '00000014'),
('00000005', '00000002'),
('00000006', '00000005'),
('00000008', '00000000');

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
('00000001', '00000007');
