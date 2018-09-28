INSERT INTO role (name, display_name) VALUES ('caseworker-bulkscan', 'Case Worker Bulk Scan');

INSERT INTO user_group(name, default_url, display_name, level_of_access, login_by_pin_enabled, operational_user_type, send_welcome_email, service,
  subsequent_login_enabled, create_users_of_group, uplift_to_group_name, uplift_to_role_name)
VALUES
  ('caseworker-bulkscan', 'https://localhost:9000/poc/ccd', 'Case Worker Bulk scan', 1, FALSE, 'INTERNAL', FALSE, 'CCD',
   TRUE, NULL, NULL, NULL);

INSERT INTO user_group_roles(user_group_name, roles_name)
VALUES
  ('caseworker-bulkscan', 'caseworker-bulkscan');

INSERT INTO registered_user (id, account_locked, continue_url, forename, surname, login_failures, email, password, 
   activation_date, user_group_name, level_of_access, password_change_date) 
VALUES
  (640, false, 'https://localhost:9000/poc/ccd', 'Bulkscan', 'Caseworker', 0, 'bulkscan+ccd@gmail.com', '$2a$11$N.a2/zooO/OhURAe8RlBauBAhsGqT.7P1n27uoO4Ama/6V171weai',
   '2018-01-01', 'caseworker-bulkscan', 1, '2018-01-01 00:01:00');

INSERT INTO registered_user_roles (user_id, roles_name) 
VALUES
  (640, 'caseworker-bulkscan');

INSERT INTO registered_user_roles (user_id, roles_name) 
VALUES
  (640, 'caseworker');

COMMIT;

