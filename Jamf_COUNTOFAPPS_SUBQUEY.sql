select X.application_name, count(X.computer_id) AS 'Count' 
from 
(
select DISTINCT
a.computer_name,
a.last_ip,
a.mac_address,
a.computer_id as computer_id,
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
a.mac_address, c.application_name, c.application_version, a.computer_id,
c.application_path, a.operating_system_version,a.last_report_date_epoch
) AS X
INNER JOIN 
(
SELECT MAX(B.Report_id) as Report_id,B.computer_id FROM reports A
INNER JOIN (
select DISTINCT
a.computer_name,
a.last_ip,
a.mac_address,
a.computer_id ,
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
a.mac_address, c.application_name, c.application_version, a.computer_id,
c.application_path, a.operating_system_version,a.last_report_date_epoch
) AS B
ON A.Report_id=B.Report_id
GROUP BY B.computer_id
) AS Y
ON X.computer_id=Y.computer_id 
AND X.report_id=Y.report_id
GROUP BY X.application_name
ORDER BY count(X.computer_id) DESC
