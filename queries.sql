-- This SQL file shows the expected typical queries run on the DB. Even though SQLite does not support stored procedures, they can be implemented via application backend logic like python. This approach
-- would be expected for such an application.

-- searching for medications that are used by certain organisation for a certain condition.
    -- generally speaking all organisations should use the same medication in the same dosages for a certain condition if some combination is deemed the most efective by the scientific comunity.
    -- However this is usually not the case. It can be caused by using the same functional ingredients made by different companies under different names
    -- or they can be using different medications alltogether for various reasons.
SELECT * FROM "current_medications" WHERE "condition_name" = ? 
AND "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = ?
);


-- searching for equipment that is used by a particular organisation and is connected to a certain condition.
SELECT * FROM "current_equipment" WHERE "condition_name" = ?
AND "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = ?
);

-- searching for a particular protocol that is appropriate for a specific condition and is connected with a specific organisation.
SELECT * FROM "current_protocols" WHERE "condition_name" = ? 
AND "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = ?
);

-- query to see all current medications and their dosages in use by an organisation
SELECT * FROM "current_medications" WHERE "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = ?
);

-- query to see all current protocols in use by an organisation
SELECT * FROM "current_protocols" WHERE "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = ?
);

-- query to see all current equipment in use by an organisation
SELECT * FROM "current_equipment" WHERE "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = ?
);

-- insert 
INSERT INTO "conditions" ("name", "type", "description")
VALUES (?, ?, ?);

INSERT INTO "organisations" ("name", "location", "type")
VALUES (?, ?, ?);

INSERT INTO "protocols" ("name", "description", "resource_link")
VALUES (?, ?, ?);

INSERT INTO "protocols_connector" ("protocol_id", "organisation_id", "condition_id")
VALUES (?, ?, ?);

INSERT INTO "equipment" ("name", "type", "description", "how_to_use")
VALUES (?, ?, ?, ?);

INSERT INTO "equipment_connector" ("equipment_id", "organisation_id", "condition_id")
VALUES (?, ?, ?);

INSERT INTO "medications" ("name", "active_ingredient", "packaging_in_use")
VALUES (?, ?, ?);

INSERT INTO "dosages" ("condition_id", "organisation_id", "medication_id", "dosage", "description", "cave", "paediatric")
VALUES ((SELECT "id" FROM "conditions" WHERE "name" = ?), (SELECT "id" FROM "organisations" WHERE "name" = ?), (SELECT "id" FROM "medications" WHERE "name" = ?), ?, ?, ?, ?/* 0 if not paediatric, 1 if it is*/);


-- update
UPDATE "conditions" SET ? = ? WHERE "name" = ?;

UPDATE "companies" SET ? = ? WHERE "name" = ?;

UPDATE "protocols" SET ? = ? WHERE "name" = ?;

UPDATE "equipment"  SET ? = ? WHERE "name" = ?;

UPDATE "medications" SET ? = ? WHERE "name" = ?;

UPDATE "dosages" SET ? = ? WHERE "name" = ?;

-- delete
    -- direct delete queries are disabled. Only soft delete is supported. The delete queries listed here only change a flag variable.
    -- even those are available only on a limited number of tables since protocols, equipment and medications may be used by multiple organisations and conditions should never be deleted once inside
    -- the db.
-- this is the only hard delete supported
DELETE FROM "companies" WHERE "name" = ?;

-- these deletes are soft deletes
DELETE FROM "dosages" WHERE "condition_id" = (SELECT "id" FROM "conditions" WHERE "name" = ? ) AND "organisation_id" = (SELECT "id" FROM "organisations" WHERE "name" = ?) 
AND "medication_id" = (SELECT "id" FROM "medications" WHERE "name" = ?) AND "paediatric" = ?; /* one or zero */

DELETE FROM "protocols" WHERE "id" = ? AND "organisation_id" = ?;

DELETE FROM "equipment" WHERE "id" = ? AND "organisation_id" = ?;

