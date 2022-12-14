CREATE INDEX organization_name_index ON organization(organization_name);
CREATE INDEX organization_phone_index ON organization(phone_number);
CREATE INDEX organization_email_index ON organization(email);
CREATE INDEX organization_address_index ON organization(address);
CREATE INDEX organization_postal_code_index ON organization(postal_code);
CREATE INDEX contact_person_full_name_index ON contact_person(full_name);
CREATE INDEX contact_person_phone_index ON contact_person(phone_number);
CREATE INDEX contact_person_email_index ON contact_person(email);
CREATE INDEX contact_person_address_index ON contact_person(address);
CREATE INDEX contact_person_postal_code_index ON contact_person(postal_code);