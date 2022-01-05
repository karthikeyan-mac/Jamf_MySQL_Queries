# Packages and Policies

SELECT policies.policy_id AS 'Policy ID', policies.name AS 'Policy Name', policies.enabled AS 'Enabled', packages.package_id AS 'Package ID', packages.package_name AS 'Package Name' FROM policies JOIN policy_packages ON policies.policy_id=policy_packages.policy_id JOIN packages ON policy_packages.package_id=packages.package_id order by policies.policy_id;

# Packages, Policies & Scripts

SELECT distinct policies.policy_id AS 'Policy ID', policies.name AS 'Policy Name', policies.enabled AS 'Enabled', packages.package_id AS 'Package ID', packages.package_name AS 'Package Name', scripts.script_id AS 'Script ID', scripts.file_name AS 'Script Name' FROM policies LEFT JOIN policy_packages ON policies.policy_id=policy_packages.policy_id LEFT JOIN packages ON policy_packages.package_id=packages.package_id LEFT JOIN policy_scripts ON policies.policy_id=policy_scripts.policy_id LEFT JOIN scripts ON policy_scripts.script_id=scripts.script_id order by policies.policy_id;

# Packages, Policies, Smart Groups & Scripts

SELECT distinct policies.policy_id AS 'Policy ID', policies.name AS 'Policy Name', policies.enabled AS 'Enabled', packages.package_id AS 'Package ID', packages.package_name AS 'Package Name', scripts.script_id AS 'Script ID', scripts.file_name AS 'Script Name', computer_groups.computer_group_id AS 'Computer Group ID', computer_groups.computer_group_name AS 'Computer Group Name' FROM policies LEFT JOIN policy_packages ON policies.policy_id=policy_packages.policy_id LEFT JOIN packages ON policy_packages.package_id=packages.package_id LEFT JOIN policy_scripts ON policies.policy_id=policy_scripts.policy_id LEFT JOIN scripts ON policy_scripts.script_id=scripts.script_id LEFT JOIN policy_deployment ON policies.policy_id=policy_deployment.policy_id LEFT JOIN computer_groups ON policy_deployment.target_id=computer_groups.computer_group_id order by policies.policy_id;

# Including Selfservice

SELECT distinct policies.policy_id AS 'Policy ID', policies.name AS 'Policy Name', policies.enabled AS 'Enabled', policies.use_for_self_service AS 'Selfservice', packages.package_id AS 'Package ID', packages.package_name AS 'Package Name', scripts.script_id AS 'Script ID', scripts.file_name AS 'Script Name', computer_groups.computer_group_id AS 'Computer Group ID', computer_groups.computer_group_name AS 'Computer Group Name' FROM policies LEFT JOIN policy_packages ON policies.policy_id=policy_packages.policy_id LEFT JOIN packages ON policy_packages.package_id=packages.package_id LEFT JOIN policy_scripts ON policies.policy_id=policy_scripts.policy_id LEFT JOIN scripts ON policy_scripts.script_id=scripts.script_id LEFT JOIN policy_deployment ON policies.policy_id=policy_deployment.policy_id LEFT JOIN computer_groups ON policy_deployment.target_id=computer_groups.computer_group_id order by policies.policy_id;

# Applications



SELECT DISTINCT a.computer_name AS 'Computer', c.application_name AS 'Application', c.application_version AS 'Version', c.application_path AS 'Application Path', a.operating_system_version AS 'OS', a.last_contact_time_epoch AS 'CheckIn'
From computers_denormalized a INNER JOIN reports b ON a.computer_id = b.computer_id
INNER JOIN applications c ON b.report_id = c.report_id
WHERE c.application_name IN ('Adobe Acrobat.app') AND c.application_version IN ('15.007.20033', '15.007.10033', '15.008.10073', '15.008.10082')
ORDER BY c.application_name, c.application_version, a.computer_name, a.operating_system_version, a.last_contact_time_epoch

##

07-Aug-17 - Working

SELECT DISTINCT
    a.computer_name AS 'Computer',
    a.last_ip AS 'IP Address',
    a.mac_address AS 'MAC Address',
    c.application_name AS 'Application',
    c.application_version AS 'Version',
    c.application_path AS 'Application Path',
    a.operating_system_version AS 'OS',
    FROM_UNIXTIME(`last_report_date_epoch` / 1000) AS 'Reported'
FROM
    computers_denormalized a,
    reports b,
    applications c
WHERE
    a.computer_id = b.computer_id
        AND b.report_id = c.report_id
        AND c.application_name = 'Adobe Hub.app'
ORDER BY c.application_name , c.application_version , a.computer_name , c.application_version


        
#
# Applications with Reported date (OLD Method)

SELECT DISTINCT a.computer_name AS 'Computer', a.last_ip AS 'IP Address', a.mac_address AS 'MAC Address', c.application_name AS 'Application', c.application_version AS 'Version', c.application_path AS 'Application Path', a.operating_system_version AS 'OS', ADDTIME(FROM_UNIXTIME(`last_report_date_epoch`/1000), '07:00:00.000000') AS 'Reported'
From computers_denormalized a INNER JOIN reports b ON a.computer_id = b.computer_id
INNER JOIN applications c ON b.report_id = c.report_id
WHERE c.application_name IN ('Adobe Acrobat.app') AND c.application_version LIKE ('%15.%')
ORDER BY c.application_name, c.application_version, a.computer_name, c.application_version, a.last_report_date_epoch

########################################################################################################################################################################################################

Policy Logs with all Data

SELECT DISTINCT
    policies.policy_id AS 'Policy ID',
    computers_denormalized.computer_id AS 'Computer ID',
    computers_denormalized.computer_name AS 'Computer Name',
    computers_denormalized.username AS 'User Name',
    policies.enabled AS 'Policy Enabled',
    policies.name AS 'Policy Name',
    logs.log_id AS 'Log ID',
    logs.error AS 'Status(1 Failed, 0- Sucess)',
    log_actions.action AS 'Logs'
FROM
    policies
        LEFT JOIN
    policy_history ON policies.policy_id = policy_history.policy_id
        LEFT JOIN
    logs ON policy_history.log_id = logs.log_id
        LEFT JOIN
    log_actions ON logs.log_id = log_actions.log_id
        LEFT JOIN
    computers_denormalized ON logs.computer_id = computers_denormalized.computer_id
WHERE
    policies.policy_id IN ('46')
        AND log_actions.action LIKE '%"Configuration Complete"%'


########################################################################################################################################################################################################
Walkme
SELECT DISTINCT policies.policy_id AS 'Policy ID', computers.computer_id AS 'Computer ID', computers.computer_name AS 'Computer Name', policies.enabled AS 'Policy Enabled', policies.name AS 'Policy Name',  logs.log_id AS 'Log ID', logs.error AS 'Status(1 Failed, 0- Sucess)', log_actions.action AS 'Logs' FROM policies LEFT JOIN policy_history ON policies.policy_id=policy_history.policy_id LEFT JOIN logs on policy_history.log_id=logs.log_id LEFT JOIN log_actions on logs.log_id=log_actions.log_id  LEFT JOIN computers on logs.computer_id=computers.computer_id where policies.policy_id in ('366') and log_actions.action LIKE ('%Successfully installed WalkMe_Extensions_1.1.0.pkg.%')

secure config

SELECT DISTINCT policies.policy_id AS 'Policy ID', computers.computer_id AS 'Computer ID', computers.computer_name AS 'Computer Name', policies.enabled AS 'Policy Enabled', policies.name AS 'Policy Name',  logs.log_id AS 'Log ID', logs.error AS 'Status(1 Failed, 0- Sucess)', ADDTIME(FROM_UNIXTIME(`date_entered_epoch`/1000), '07:00:00.000000') AS 'Log Date' , log_actions.action AS 'Logs' FROM policies LEFT JOIN policy_history ON policies.policy_id=policy_history.policy_id LEFT JOIN logs on policy_history.log_id=logs.log_id LEFT JOIN log_actions on logs.log_id=log_actions.log_id  LEFT JOIN computers on logs.computer_id=computers.computer_id where policies.policy_id in ('377') and log_actions.action LIKE ('%SystemUIServer got an error: User canceled.%')


Username & Computer Name

SELECT DISTINCT computers_denormalized.computer_name, computers_denormalized.username, computers_denormalized.realname, computers_denormalized.operating_system_name, computers_denormalized.operating_system_version FROM JAMFSOFT.computers_denormalized where user_receipts.username in ('jehanson')


DATE CONVERT
SELECT `computer_name`, FROM_UNIXTIME(`last_contact_time_epoch`/1000,"%m/%d/%Y  %h:%i") AS 'last check-in',FROM_UNIXTIME(`last_report_date_epoch`/1000,"%m/%d/%Y  %h:%i") AS 'last inventory update'
FROM `computers_denormalized`
ORDER BY `last_contact_time_epoch` ASC

DATE EXACTLY

SELECT `computer_name`, ADDTIME(FROM_UNIXTIME(`last_report_date_epoch`/1000), '07:00:00.000000')
FROM `computers_denormalized`
ORDER BY `last_contact_time_epoch` ASC


Username and Computer Name

SELECT DISTINCT computers.computer_id AS 'Computer ID', user_receipts.computer_id AS 'Computer ID', computers.computer_name AS 'Computer Name', user_receipts.username AS 'Username', user_receipts.realname AS 'Real Name',user_receipts.home_directory AS 'Path'  FROM computers JOIN user_receipts ON computers.computer_id=user_receipts.computer_id 



prashanth

SELECT computer_id AS 'id', serial_number AS 'casper_serial_number', username AS 'user_name', computer_name AS 'casper_hostname', CONCAT(operating_system_name,' ',operating_system_version) AS 'casper_operating_system', model AS 'casper_system_type', FROM_UNIXTIME(`last_contact_time_epoch`/1000,"%m/%d/%Y") AS 'casper_last_contact' , FROM_UNIXTIME(`last_report_date_epoch`/1000,"%m/%d/%Y") AS 'updated_at', udid AS 'casper_guid' FROM computers_denormalized

Casper Imaging from Event Logs

SELECT * FROM JAMFPROPRD.event_logs where event_type="Imaging"

########################################################################################################################################################################################################

Configure My Mac Time Taken

SELECT DISTINCT
    policies.policy_id AS 'Policy ID',
    computers_denormalized.computer_id AS 'Computer ID',
    computers_denormalized.computer_name AS 'Computer Name',
    computers_denormalized.serial_number AS 'Serial Number',
    computers_denormalized.username AS 'User Name',
    policies.enabled AS 'Policy Enabled',
    policies.name AS 'Policy Name',
    FROM_UNIXTIME(`date_entered_epoch` / 1000) AS 'Log Date',
    date_entered_epoch AS 'Log Epoch',
    logs.log_id AS 'Log ID',
    logs.error AS 'Status(1 Failed, 0- Sucess)'
FROM
    policies
        LEFT JOIN
    policy_history ON policies.policy_id = policy_history.policy_id
        LEFT JOIN
    logs ON policy_history.log_id = logs.log_id
        LEFT JOIN
    log_actions ON logs.log_id = log_actions.log_id
        LEFT JOIN
    computers_denormalized ON logs.computer_id = computers_denormalized.computer_id
WHERE
    policies.policy_id IN ('46')
        AND log_actions.action LIKE '%"Configuration Complete"%'
ORDER BY logs.date_entered_epoch
	
########################################################################################################################################################################################################

# With Extension Attribute

SELECT DISTINCT
    policies.policy_id AS 'Policy ID',
    computers_denormalized.computer_id AS 'Computer ID',
    computers_denormalized.computer_name AS 'Computer Name',
    computers_denormalized.serial_number AS 'Serial Number',
    computers_denormalized.username AS 'User Name',
    policies.enabled AS 'Policy Enabled',
    policies.name AS 'Policy Name',
    FROM_UNIXTIME(logs.`date_entered_epoch` / 1000) AS 'Log Date',
    logs.date_entered_epoch AS 'Log Epoch',
    logs.log_id AS 'Log ID',
    logs.error AS 'Status(1 Failed, 0- Sucess)',
    extension_attributes.extension_attribute_id AS 'Extension Attribute ID',
    extension_attributes.display_name AS 'Extn Name',
    extension_attribute_values.value_on_client AS 'Extn Value'
FROM
    policies,
    policy_history,
    logs,
    log_actions,
    computers_denormalized,
    reports,
    extension_attribute_values,
    extension_attributes
WHERE
    policies.policy_id = policy_history.policy_id
        AND policy_history.log_id = logs.log_id
        AND logs.log_id = log_actions.log_id
        AND logs.computer_id = computers_denormalized.computer_id
        AND computers_denormalized.computer_id = reports.computer_id
        AND reports.report_id = extension_attribute_values.report_id
        AND extension_attribute_values.extension_attribute_id = extension_attributes.extension_attribute_id
        AND policies.policy_id IN ('46')
        AND log_actions.action LIKE '%Configuration Complete%'
        AND extension_attributes.extension_attribute_id = 104
ORDER BY logs.date_entered_epoch
	
####

# Extension Attribute
SELECT DISTINCT
    a.computer_name AS 'Computer',
    a.serial_number AS 'Serial Number',
    c.application_name AS 'Application',
    c.application_version AS 'Version',
    c.application_path AS 'Application Path',
    a.operating_system_version AS 'OS',
    a.last_contact_time_epoch AS 'CheckIn',
    MAX(b.report_id) AS 'Report ID'
FROM
    computers_denormalized a
        INNER JOIN
    reports b ON a.computer_id = b.computer_id
        INNER JOIN
    applications c ON b.report_id = c.report_id
WHERE
    c.application_name = 'Adobe Hub.app'
GROUP By
 c.application_name, c.application_version,  a.computer_name, a.serial_number, c.application_path, a.operating_system_version, a.last_contact_time_epoch, b.report_id
	


    
#####

###
Report
SELECT DISTINCT
    e.policy_id AS 'Policy ID',
    a.computer_id AS 'Computer ID',
    a.computer_name AS 'Computer Name',
    a.serial_number AS 'Serial Number',
    a.username AS 'User Name',
    e.enabled AS 'Policy Enabled',
    e.name AS 'Policy Name',
    d.display_name AS 'EA Name',
    c.value_on_client AS 'EA Value',
    FROM_UNIXTIME(g.`date_entered_epoch` / 1000) AS 'Log Date',
    g.date_entered_epoch AS 'Log Epoch',
    g.log_id AS 'Log ID',
    g.error AS 'Status(1 Failed, 0- Sucess)'
FROM
    computers_denormalized a,
    reports b,
    extension_attribute_values c,
    extension_attributes d,
    policies e,
    policy_history f,
    logs g,
    log_actions h
WHERE
    e.policy_id = f.policy_id
        AND f.log_id = g.log_id
        AND g.log_id = h.log_id
        AND g.computer_id = a.computer_id
        AND e.policy_id = 46
        AND h.action LIKE '%"Configuration Complete"%'
        AND a.computer_id = b.computer_id
        AND b.report_id = c.report_id
        AND c.extension_attribute_id = d.extension_attribute_id
        AND d.extension_attribute_id = 104
        AND c.value_on_client <> 'Not Configured'
        AND c.value_on_client <> ' '
###Hub

SELECT DISTINCT
    e.policy_id AS 'Policy ID',
    a.computer_id AS 'Computer ID',
    a.computer_name AS 'Computer Name',
    a.serial_number AS 'Serial Number',
    a.username AS 'User Name',
    e.enabled AS 'Policy Enabled',
    e.name AS 'Policy Name',
    FROM_UNIXTIME(g.`date_entered_epoch` / 1000) AS 'Log Date',
    g.date_entered_epoch AS 'Log Epoch',
    g.log_id AS 'Log ID',
    g.error AS 'Status(1 Failed, 0- Sucess)'
FROM
    computers_denormalized a,
    policies e,
    policy_history f,
    logs g,
    log_actions h
WHERE
    e.policy_id = f.policy_id
        AND f.log_id = g.log_id
        AND g.log_id = h.log_id
        AND g.computer_id = a.computer_id
        AND e.policy_id = 756
        AND h.action LIKE '%Successfully installed AdobeHub2.52.0.pkg%'

