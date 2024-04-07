DROP FUNCTION IF EXISTS CalculateTotalSalaryForAgency;

DROP PROCEDURE IF EXISTS InsertMission;
DROP PROCEDURE IF EXISTS InsertLaunch;

DROP TRIGGER IF EXISTS AgencyBudgetTrigger;

DELIMITER //

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
#CalculateTotalSalaryForAgency(Agency)
#SELECT CalculateTotalSalaryForAgency('00000001') AS TotalSalaryForAgency;

#InsertMission (mission id, budget, date, launch location, status)
#CALL InsertMission('00000014', 79000000000, '2025-04-20', 'Launch Location', 'Ongoing');

#InsertLaunch (agency, mission)
#CALL InsertLaunch ('00000001', '00000014');


##########################
	#6. SQL DATA QUERIES
##########################
SELECT cb.*
FROM CelestialBody cb
JOIN CelestialOrbit co ON cb.celestial_id = co.celestial_id
WHERE co.orbiting_id = (SELECT cb.celestial_id FROM CelestialBody cb WHERE cb.identifier = 'Jupiter');


SELECT mi.*
FROM (
    SELECT *
    FROM Launches NATURAL JOIN Mission
) AS lami
JOIN Agency ag ON lami.agency_id = ag.agency_id
JOIN Mission mi ON lami.mission_id = mi.mission_id
WHERE ag.acronym = 'NASA' AND mi.status = 'Ongoing';


SELECT sa.*
FROM Satellite sa
JOIN Mission mi ON sa.mission_id = mi.mission_id
WHERE sa.mission_id = '00000003';

###########################
	#8. SQL TABLE MODIFICATION
###########################

UPDATE Mission set status =
    CASE
    WHEN launch_date < '2000-01-01' THEN 'Lost'
    ELSE 'Concluded'
    END
WHERE mission_id > '00000000';


DELETE FROM Mission WHERE NOT status = 'Ongoing' AND mission_id > '00000000';
