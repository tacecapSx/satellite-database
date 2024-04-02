DROP TABLE IF EXISTS Launches;
DROP TABLE IF EXISTS Participates;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Orbit;
DROP TABLE IF EXISTS Satellite;
DROP TABLE IF EXISTS Mission;
DROP TABLE IF EXISTS Agency;
DROP TABLE IF EXISTS Moon;
DROP TABLE IF EXISTS Planet;

CREATE TABLE Planet
	(planet_id				VARCHAR(8),
	 identifier				VARCHAR(15) NOT NULL,
	 mass					DECIMAL(30,0) NOT NULL,
     diameter				DECIMAL(10,0) NOT NULL,
     atmosphere_height		DECIMAL(10,0),
	 PRIMARY KEY(planet_id)
	);

CREATE TABLE Moon
	(moon_id				VARCHAR(8),
	 planet_id				VARCHAR(8),
	 identifier				VARCHAR(15) NOT NULL,
	 mass					DECIMAL(30,0) NOT NULL,
     diameter				DECIMAL(10,0) NOT NULL,
     atmosphere_height		DECIMAL(10,0),
	 PRIMARY KEY(moon_id),
     FOREIGN KEY(planet_id) REFERENCES Planet(planet_id) ON DELETE SET NULL
	);

CREATE TABLE Agency
	(agency_id				VARCHAR(8),
     budget					DECIMAL(12,0) NOT NULL,
     nationality			VARCHAR(20) NOT NULL,
     PRIMARY KEY(agency_id)
	);

CREATE TABLE Mission
	(mission_id				VARCHAR(8),
     agency_id				VARCHAR(8),
     budget					DECIMAL(12,0) NOT NULL,
     launch_date			DATE,
     nationality			VARCHAR(20) NOT NULL,
     PRIMARY KEY(mission_id),
     FOREIGN KEY(agency_id) REFERENCES Agency(agency_id) ON DELETE SET NULL
	);

CREATE TABLE Satellite
	(satellite_id			VARCHAR(8),
     mission_id				VARCHAR(8),
     identifier				VARCHAR(15) NOT NULL,
     mass					DECIMAL(5,0) NOT NULL,
     fuel					DECIMAL(5,0) NOT NULL,
     satellite_type         ENUM('Observational', 'Communication', 'Weather', 'Navigation', 'Scientific', 'Rescue'),
     PRIMARY KEY(satellite_id),
     FOREIGN KEY(mission_id) REFERENCES Mission(mission_id) ON DELETE SET NULL
    );

CREATE TABLE Orbit
	(orbit_id				VARCHAR(8),
     satellite_id			VARCHAR(8),
     PRIMARY KEY(orbit_id),
     FOREIGN KEY(satellite_id) REFERENCES Satellite(satellite_id) ON DELETE SET NULL
    );

CREATE TABLE Employee
	(employee_id			VARCHAR(8),
     agency_id				VARCHAR(8),
     salary					DECIMAL(12,0) NOT NULL,
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

INSERT Planet VALUES
('00000003', 'Earth',   5972168000000000000000000,    12742,  10000),
('00000004', 'Mars',    639000000000000000000000,     6779,   230),
('00000002', 'Venus',   4867000000000000000000000,    12104,  350),
('00000001', 'Mercury', 328500000000000000000000,     4880,   null),
('00000005', 'Jupiter', 1898000000000000000000000000, 139820, 5000),
('00000006', 'Saturn',  568300000000000000000000000,  120536, null),
('00000007', 'Uranus',  86810000000000000000000000,   51118,  4000),
('00000008', 'Neptune', 102400000000000000000000000,  49244,  700);