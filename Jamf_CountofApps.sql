CREATE TEMPORARY TABLE IF NOT EXISTS TEMP1 AS 
(
select DISTINCT
a.computer_name,
a.last_ip,
a.mac_address,
a.computer_id,
c.application_name,
c.application_version,
c.application_path,
a.operating_system_version,
a.last_report_date_epoch,
max(c.report_id) AS Report_id
from reports b
INNER JOIN applications c
ON b.report_id=c.report_id
INNER JOIN computers_denormalized a
ON b.computer_id=a.computer_id
GROUP BY a.computer_name, a.last_ip, 
a.mac_address, c.application_name, c.application_version, 
c.application_path, a.operating_system_version,a.last_report_date_epoch, a.computer_id
ORDER BY c.application_name , c.application_version , a.computer_name 
);

CREATE TEMPORARY TABLE IF NOT EXISTS TEMP2 AS 
(
select computer_id ,
max(report_id) as max_report_id from TEMP1 
GROUP BY computer_id
);


select count(a.computer_id), a.application_name from TEMP1 a
INNER JOIN TEMP2 b
ON a.computer_id=b.computer_id 
AND a.report_id=b.max_report_id
GROUP BY a.application_name
ORDER BY COUNT(a.computer_id) DESC ;

DROP TEMPORARY TABLE TEMP1;

DROP TEMPORARY TABLE TEMP2;
