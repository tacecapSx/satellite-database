DROP PROCEDURE IF EXISTS GetOrbitingBodies;
DROP PROCEDURE IF EXISTS GetOrbitBody;
DROP PROCEDURE IF EXISTS GetMissionSatellites;
DROP PROCEDURE IF EXISTS GetMissionsFromAgency;
DROP PROCEDURE IF EXISTS GetSatellitesFromMission;
DROP PROCEDURE IF EXISTS GetAgencyEmployees;
DROP PROCEDURE IF EXISTS GetEmployeeMissions;

DROP FUNCTION IF EXISTS CalculateTotalSalaryForAgency;

DROP PROCEDURE IF EXISTS InsertMission;
DROP PROCEDURE IF EXISTS InsertLaunch;

DROP TRIGGER IF EXISTS AgencyBudgetTrigger;

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

## FUNCTIONS, PROCEDURE AND TRIGGERS

#####################
	#FUNCTIONS
#####################

CREATE FUNCTION CalculateTotalSalaryForAgency(agency_id_parameter VARCHAR(8))
RETURNS DECIMAL(10, 0)
BEGIN
    DECLARE total_salary DECIMAL(12, 0);
    
    SELECT SUM(salary) INTO total_salary
    FROM Employee
    WHERE agency_id = agency_id_parameter;
    
    RETURN total_salary;
END//

#####################
	#PROCEDUREs
#####################

# insert mission
CREATE PROCEDURE InsertMission(
    IN pro_mission_id VARCHAR(8),
    IN pro_budget DECIMAL(12,0),
    IN pro_launch_date DATE,
    IN pro_launch_location VARCHAR(20),
    IN pro_status ENUM('Ongoing', 'Concluded', 'Lost')
)
BEGIN
    INSERT INTO Mission (mission_id, budget, launch_date, launch_location, status)
    VALUES (pro_mission_id, pro_budget, pro_launch_date, pro_launch_location, pro_status);
END//

# insert launch
CREATE PROCEDURE InsertLaunch(
    IN pro_agency_id VARCHAR(8),
    IN pro_mission_id VARCHAR(8)
)
BEGIN
    INSERT INTO Launches (agency_id, mission_id)
    VALUES (pro_agency_id, pro_mission_id);
END//

#####################
	#TRIGGERS
#####################

#check if budget of mission exceeds the agency budget
CREATE TRIGGER AgencyBudgetTrigger
BEFORE INSERT ON Launches
FOR EACH ROW
BEGIN
    DECLARE agency_budget DECIMAL(12,0);
    DECLARE mission_budget DECIMAL(12,0);
    
    SELECT budget INTO agency_budget FROM Agency WHERE agency_id = NEW.agency_id;
    SELECT budget INTO mission_budget FROM Mission WHERE mission_id = NEW.mission_id;
    
    IF mission_budget > agency_budget THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mission budget exceeds agency budget';
    END IF;
END;
//

DELIMITER ;

# Example usage
#CALL GetOrbitingBodies('Sun');
#CALL GetOrbitBody('Charon');
#CALL GetMissionsFromAgency('Roscosmos');
#CALL GetSatellitesFromMission('00000003')
#CALL GetAgencyEmployees('NASA')
#CALL GetEmployeeMissions('00000074')

#CalculateTotalSalaryForAgency(Agency)
#SELECT CalculateTotalSalaryForAgency('00000001') AS TotalSalaryForAgency;

#InsertMission (mission id, budget, date, launch location, status)
#CALL InsertMission('00000014', 79000000000, '2025-04-20', 'Launch Location', 'Ongoing');

#InsertLaunch (agency, mission)
#CALL InsertLaunch ('00000001', '00000014');

