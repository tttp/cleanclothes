select civicrm_contact.id as cid, civicrm_contact.display_name, civicrm_case.id, status_id as status, subject, 
civicrm_case.created_date as date, case_type_id as type 
from civicrm_case 
left join civicrm_case_contact on case_id=civicrm_case.id 
join civicrm_contact on civicrm_case_contact.contact_id = civicrm_contact.id;
