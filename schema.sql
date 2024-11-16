-- the main table in the db to which everything is tied
CREATE TABLE "conditions" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL UNIQUE,
    "type" TEXT NOT NULL,
    "description" TEXT NOT NULL
);

-- this table stores the organisations that might choose to use this db. Through this table scaling should be possible
CREATE TABLE "organisations" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL UNIQUE,
    "location" TEXT NOT NULL,
    "type" TEXT NOT NULL CHECK("type" IN('Emergency medical service', 'Private provider', 'Hopital provider', 'Fire Rescue', 'Other'))
);
-- table to store protocols
CREATE TABLE "protocols" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "resource_link" TEXT NOT NULL,
    "date_added" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- junction table to connect protocols to organisations and conditions
CREATE TABLE "protocols_connector" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "protocol_id" INTEGER NOT NULL,
    "organisation_id" INTEGER NOT NULL,
    "condition_id" INTEGER NOT NULL,
    "obsolete" INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY ("protocol_id") REFERENCES "protocols"("id"),
    FOREIGN KEY ("organisation_id") REFERENCES "organisations"("id"),
    FOREIGN KEY ("condition_id") REFERENCES "conditions"("id")
);
-- a table to store single pieces of equipment, devices and gadgets.
CREATE TABLE "equipment" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL UNIQUE,
    "type" TEXT NOT NULL CHECK ("type" IN ('transport', 'extrication', 'diagnostics', 'therapeutical', 'other', 'diagnostics/therapeutical')),
    "description" TEXT NOT NULL,
    "how_to_use" TEXT NOT NULL
);
-- a junction table connecting equipment to conditions and organisations
CREATE TABLE "equipment_connector" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "equipment_id" INTEGER NOT NULL,
    "organisation_id" INTEGER NOT NULL,
    "condition_id" INTEGER NOT NULL,
    "obsolete" INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY ("equipment_id") REFERENCES "equipment"("id"),
    FOREIGN KEY ("organisation_id") REFERENCES "organisations"("id"),
    FOREIGN KEY ("condition_id") REFERENCES "conditions"("id")
);
-- a table storing basic information about medications
CREATE TABLE "medications" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL UNIQUE,
    "active_ingredient" TEXT NOT NULL,
    "packaging_in_use" TEXT NOT NULL
);

-- this table stores dosages of specific medications which are meant for specific conditions and serves as a connector as well
CREATE TABLE "dosages" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "condition_id" INTEGER NOT NULL,
    "organisation_id" INTEGER NOT NULL,
    "medication_id" INTEGER NOT NULL,
    "dosage" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "cave" TEXT NOT NULL,
    "paediatric" INTEGER NOT NULL DEFAULT 0,
    "obsolete" INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY ("condition_id") REFERENCES "conditions"("id"),
    FOREIGN KEY ("organisation_id") REFERENCES "organisations"("id"),
    FOREIGN KEY ("medication_id") REFERENCES "medications"("id")
);

-- this table serves as a log
CREATE TABLE "logs" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" TEXT DEFAULT NULL,
    "action" TEXT CHECK("action" IN('delete', 'attempted_delete', 'soft_delete', 'update', 'insert', 'recovery')),
    "on_table" TEXT NOT NULL,
    "table_specific_id" INTEGER NOT NULL,
    "datetime" NUMERIC DEFAULT CURRENT_TIMESTAMP
);

-- no triggers were created for inserting, updating or deleting from the views since I would expect an application handling this database to fulfill that functionality.
-- these three views serve as the main infromation chanel for the user and through them, soft delete is supported
CREATE VIEW "current_medications" AS 
    SELECT "dosages"."id" AS "dosages_id", "conditions"."name" AS "condition_name", "dosages"."organisation_id" AS "organisation_id", "medications"."name", "dosages"."dosage", "dosages"."description", "dosages"."cave" FROM "medications"
    JOIN "dosages" ON "medications"."id" = "dosages"."medication_id"
    JOIN "conditions" ON "dosages"."condition_id" = "conditions"."id"
    WHERE "dosages"."obsolete" = 0;
    
CREATE VIEW "current_equipment" AS 
    SELECT "equipment"."id" AS "equipment_id", "conditions"."name" AS "condition_name", "equipment_connector"."organisation_id" AS "organisation_id", "equipment"."name", "equipment"."description", "equipment"."how_to_use" FROM "equipment"
    JOIN "equipment_connector" ON "equipment"."id" = "equipment_connector"."equipment_id"
    JOIN "conditions" ON "equipment_connector"."condition_id" = "conditions"."id"
    WHERE "equipment_connector"."obsolete" = 0;

CREATE VIEW "current_protocols" AS
    SELECT "protocols"."id" AS "protocol_id", "conditions"."name" AS "condition_name", "protocols_connector"."organisation_id" AS "organisation_id", "protocols"."name", "protocols"."description", "protocols"."resource_link" FROM "protocols"
    JOIN "protocols_connector" ON "protocols"."id" = "protocols_connector"."protocol_id"
    JOIN "conditions" ON "protocols_connector"."condition_id" = "conditions"."id"
    WHERE "protocols_connector"."obsolete" = 0;



-- indexes on names since there could be a ot of SELECT's based on names
CREATE INDEX "medication_names"
ON "medications" ("name");

CREATE INDEX "organisation_names"
ON "organisations" ("name");

CREATE INDEX "condition_names"
ON "conditions" ("name");

CREATE INDEX "protocol_names"
ON "protocols" ("name");

CREATE INDEX "equipment_names"
ON "equipment" ("name");


-- triggers for underlying tables preventing users from changing them directly, mainly preventing hard deletes
CREATE TRIGGER "prevent_delete_medications"
BEFORE DELETE ON "medications"
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('attempted_delete', 'medications', OLD."id");

    SELECT RAISE(FAIL, 'Deletes from this table are not allowed!');
END;

CREATE TRIGGER "prevent_delete_conditions"
BEFORE DELETE ON "conditions"
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('attempted_delete', 'conditions', OLD."id");

    SELECT RAISE(FAIL, 'Deletes from this table are not allowed!');
END;

-- These following triggers serve to enable soft delete and create a logs row.
CREATE TRIGGER "soft_delete_protocols"
BEFORE DELETE ON "protocols"
BEGIN
    UPDATE "protocols_connector" SET "obsolete" = 1
    WHERE "protocol_id" = OLD."id";
    
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('soft_delete', 'protocols', OLD."id");

    SELECT RAISE(FAIL, 'Soft delete performed');
END;    

CREATE TRIGGER "soft_delete_equipment"
BEFORE DELETE ON "equipment"
BEGIN
    UPDATE "equipment_connector" SET "obsolete" = 1
    WHERE "equipment_id" = OLD."id";

    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('soft_delete', 'equipment', OLD."id");

    SELECT RAISE(FAIL, 'Soft delete performed');
END;

CREATE TRIGGER "soft_delete_dosages"
BEFORE DELETE ON "dosages"
BEGIN
    UPDATE "dosages" SET "obsolete" = 1
    WHERE "id" = OLD."id";

    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('soft_delete', 'dosages', OLD."id");

    SELECT RAISE(FAIL, 'Soft delete performed');
END;


-- triggers for logging purposes only
CREATE TRIGGER "conditions_update_log"
AFTER UPDATE ON "conditions"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('update', 'conditions', NEW."id");
END;

CREATE TRIGGER "organisations_update_log"
AFTER UPDATE ON "organisations"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('update', 'organisations', NEW."id");
END;

CREATE TRIGGER "protocols_update_log"
AFTER UPDATE ON "protocols"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('update', 'protocols', NEW."id");
END;

CREATE TRIGGER "equipment_update_log"
AFTER UPDATE ON "equipment"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('update', 'equipment', NEW."id");
END;

CREATE TRIGGER "medications_update_log"
AFTER UPDATE ON "medications"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('update', 'medications', NEW."id");
END;

CREATE TRIGGER "dosages_update_log"
AFTER UPDATE ON "dosages"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('update', 'dosages', NEW."id");
END;


-- insert logs
CREATE TRIGGER "conditions_insert_log"
AFTER INSERT ON "conditions"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('insert', 'conditions', NEW."id");
END;

CREATE TRIGGER "organisations_insert_log"
AFTER INSERT ON "organisations"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('insert', 'organisations', NEW."id");
END;

CREATE TRIGGER "protocols_insert_log"
AFTER INSERT ON "protocols"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('insert', 'protocols', NEW."id");
END;

CREATE TRIGGER "equipment_insert_log"
AFTER INSERT ON "equipment"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('insert', 'equipment', NEW."id");
END;

CREATE TRIGGER "medications_insert_log"
AFTER INSERT ON "medications"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('insert', 'medications', NEW."id");
END;

CREATE TRIGGER "dosages_insert_log"
AFTER INSERT ON "dosages"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('insert', 'dosages', NEW."id");
END;

-- junction table update, insert and delete triggers for logging.
CREATE TRIGGER "equipment_connector_insert_log"
AFTER INSERT ON "equipment_connector"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('insert', 'equipment_connector', NEW."id");
END;

CREATE TRIGGER "equipment_connector_update_log"
AFTER UPDATE ON "equipment_connector"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('update', 'equipment_connector', NEW."id");
END;

CREATE TRIGGER "equipment_connector_delete_log"
AFTER DELETE ON "equipment_connector"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('delete', 'equipment_connector', OLD."id");
END;

CREATE TRIGGER "protocols_connector_insert_log"
AFTER INSERT ON "protocols_connector"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('insert', 'protocols_connector', NEW."id");
END;

CREATE TRIGGER "protocols_connector_update_log"
AFTER UPDATE ON "protocols_connector"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('update', 'protocols_connector', NEW."id");
END;

CREATE TRIGGER "protocols_connector_delete_log"
AFTER DELETE ON "protocols_connector"
FOR EACH ROW
BEGIN
    INSERT INTO "logs" ("action", "on_table", "table_specific_id")
    VALUES ('delete', 'protocols_connector', OLD."id");
END;

-- insert triggers that recognize if something already exists in the database and was only soft deleted - particularly protocols and equipment
CREATE TRIGGER "insert_equipment_connector_when_exists"
BEFORE INSERT ON "equipment_connector"
FOR EACH ROW  
WHEN EXISTS(
    SELECT "equipment_id", "organisation_id", "condition_id", "obsolete" FROM "equipment_connector" 
    WHERE "equipment_id" = NEW."equipment_id" AND "organisation_id" = NEW."organisation_id" 
    AND "condition_id" = NEW."condition_id" AND "obsolete" = 1
    )
BEGIN
    UPDATE "equipment_connector" SET "obsolete" = 0
    WHERE "equipment_id" = NEW."equipment_id"
    AND "condition_id" = NEW."condition_id"
    AND "organisation_id" = NEW."organisation_id";

    SELECT RAISE(FAIL, 'Recovered from soft deleted row.');
END;


CREATE TRIGGER "insert_protocols_connector_when_exists"
BEFORE INSERT ON "protocols_connector"
FOR EACH ROW  
WHEN EXISTS(
    SELECT "protocol_id", "organisation_id", "condition_id", "obsolete" FROM "protocols_connector" 
    WHERE "protocol_id" = NEW."protocol_id" AND "organisation_id" = NEW."organisation_id" 
    AND "condition_id" = NEW."condition_id" AND "obsolete" = 1
    )
BEGIN
    UPDATE "protocols_connector" SET "obsolete" = 0
    WHERE "protocol_id" = NEW."protocol_id"
    AND "condition_id" = NEW."condition_id"
    AND "organisation_id" = NEW."organisation_id";

    SELECT RAISE(FAIL, 'Recovered from soft deleted row.');
END;

-- this trigger is a bit different as it checks the contents of the new dosage being inputed. If there is any difference in the dosage, it should be inserted in a normal way becase the 
-- specific dosage might have changed and the user chose to delete and insert instead of update.
CREATE TRIGGER "insert_dosages_when_exists"
BEFORE INSERT ON "dosages"
FOR EACH ROW
WHEN EXISTS (
    SELECT "medication_id", "organisation_id", "condition_id", "dosage","description", "cave", "obsolete" FROM "dosages"
    WHERE "medication_id" = NEW."medication_id" AND "organisation_id" = NEW."organisation_id"
    AND "condition_id" = NEW."condition_id" AND "obsolete" = 1
    AND "dosage" = NEW."dosage" AND "description" = NEW."description"
    AND "cave" = NEW."cave"
    )
BEGIN
    UPDATE "dosages" SET "obsolete" = 0
    WHERE "medication_id" = NEW."medication_id" 
    AND "organisation_id" = NEW."organisation_id"
    AND "condition_id" = NEW."condition_id";

    SELECT RAISE (FAIL, 'Recovered from soft deleted row.');
END;