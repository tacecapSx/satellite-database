DROP PROCEDURE IF EXISTS GetOrbitingBodies;
DROP PROCEDURE IF EXISTS GetOrbitBody;
DROP PROCEDURE IF EXISTS GetMissionSatellites;

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
CREATE PROCEDURE GetMissionSatellites(identifier VARCHAR(25))
BEGIN
    SELECT sa.*
    FROM Satellite sa
    JOIN Mission mi ON sa.mission_id = mi.mission_id;
END //

DELIMITER ;

# Example usage
CALL GetOrbitingBodies('Sun');
#CALL GetOrbitBody('Charon');
#CALL GetMissionSatellites('00000000')