DROP PROCEDURE IF EXISTS GetOrbitingBodies;
DROP PROCEDURE IF EXISTS GetOrbitBody;
DROP PROCEDURE IF EXISTS GetMissionSatellites;
DROP PROCEDURE IF EXISTS GetMissionsFromAgency;

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

# Get the celestial body a celestial body is orbiting from its identifier.
CREATE PROCEDURE GetMissionSatellites(mission_id VARCHAR(8))
BEGIN
    SELECT sa.*
    FROM Satellite sa
    JOIN Mission ON sa.mission_id = mission_id;
END //

# Get every mission that an agency has done from its acronym.
CREATE PROCEDURE GetMissionsFromAgency(acronym VARCHAR(10))
BEGIN
    SELECT la.mission_id
	FROM Launches la
	JOIN Agency ag ON la.agency_id = ag.agency_id
	WHERE la.agency_id = (SELECT ag.agency_id FROM Agency ag WHERE ag.acronym = acronym);
END //

DELIMITER ;

# Example usage
#CALL GetOrbitingBodies('Sun');
#CALL GetOrbitBody('Charon');
#CALL GetMissionSatellites('00000000')
CALL GetMissionsFromAgency('NASA')