DROP PROCEDURE IF EXISTS GetOrbitingBodies;
DROP PROCEDURE IF EXISTS GetOrbitBody;
DROP PROCEDURE IF EXISTS GetMissionSatellites;
DROP PROCEDURE IF EXISTS GetMissionsFromAgency;
DROP PROCEDURE IF EXISTS GetSatellitesFromMission;
DROP PROCEDURE IF EXISTS GetAgencyEmployees;
DROP PROCEDURE IF EXISTS GetEmployeeMissions;

DELIMITER //

# Get all orbiting celestial bodies from a celestial body's identifier.
CREATE PROCEDURE GetOrbitingBodies(identifier VARCHAR(15))
BEGIN
    SELECT cb.*
	FROM CelestialBody cb
	JOIN CelestialOrbit co ON cb.celestial_id = co.celestial_id
	WHERE co.orbiting_id = (SELECT cb.celestial_id FROM CelestialBody cb WHERE cb.identifier = identifier);
END //

# Get the celestial body a celestial body is orbiting from its identifier.
CREATE PROCEDURE GetOrbitBody(identifier VARCHAR(15))
BEGIN
    SELECT cb.*
	FROM CelestialBody cb
	JOIN CelestialOrbit co ON cb.celestial_id = co.orbiting_id
	WHERE co.celestial_id = (SELECT cb.celestial_id FROM CelestialBody cb WHERE cb.identifier = identifier);
END //

# Get every mission that an agency has done from its acronym.
CREATE PROCEDURE GetMissionsFromAgency(acronym VARCHAR(10))
BEGIN
    SELECT la.mission_id
	FROM Launches la
	JOIN Agency ag ON la.agency_id = ag.agency_id
	WHERE la.agency_id = (SELECT ag.agency_id FROM Agency ag WHERE ag.acronym = acronym);
END //

# Get every satellite that is part of a mission from its ID.
CREATE PROCEDURE GetSatellitesFromMission(mission_id VARCHAR(8))
BEGIN
    SELECT sa.*
	FROM Satellite sa
	JOIN Mission mi ON sa.mission_id = mi.mission_id
	WHERE sa.mission_id = mission_id;
END //

# Get every employee belonging to an agency from its acronym.
CREATE PROCEDURE GetAgencyEmployees(acronym VARCHAR(10))
BEGIN
    SELECT em.*
	FROM Employee em
	JOIN Agency ag ON em.agency_id = ag.agency_id
	WHERE em.agency_id = (SELECT ag.agency_id FROM Agency ag WHERE ag.acronym = acronym);
END //

# Get every mission that an employee has participated in.
CREATE PROCEDURE GetEmployeeMissions(employee_id VARCHAR(8))
BEGIN
    SELECT mi.*
	FROM Mission mi
	JOIN Participates pa ON pa.mission_id = mi.mission_id
	WHERE pa.employee_id = employee_id;
END //

DELIMITER ;

# Example usage
#CALL GetOrbitingBodies('Sun');
#CALL GetOrbitBody('Charon');
#CALL GetMissionsFromAgency('Roscosmos');
#CALL GetSatellitesFromMission('00000003')
#CALL GetAgencyEmployees('NASA')
CALL GetEmployeeMissions('00000074')