.schema

SELECT * FROM "protocols";

SELECT * FROM "equipment";

SELECT * FROM "medications";

SELECT * FROM "current_protocols" WHERE "condition_name" = 'heart attack' 
AND "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = 'Emergency medical service test'
);

SELECT * FROM "current_equipment" WHERE "condition_name" = 'major trauma' 
AND "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = 'Emergency medical service test'
);

SELECT * FROM "current_medications" WHERE "condition_name" = 'heart attack' 
AND "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = 'Emergency medical service test'
);

SELECT * FROM "current_medications" WHERE "condition_name" = 'heart attack' 
AND "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = 'Fire resque organisationt'
);

INSERT INTO "conditions" ("name", "type", "description")
VALUES ('anaphylaxis', 'surgical', 'Anaphylactic reaction is a strong allergic reaction. It is a life threatening condition that requires immediate care');

INSERT INTO "medications" ("name", "active_ingredient", "packaging_in_use")
VALUES ('epinephrine', 'epinephrini hydrochloridum', '1 mg / 1 ml');

INSERT INTO "dosages" ("condition_id", "organisation_id", "medication_id", "dosage", "description", "cave", "paediatric")
VALUES ((SELECT "id" FROM "conditions" WHERE "name" = 'anaphylaxis'), (SELECT "id" FROM "organisations" WHERE "name" = 'Emergency medical service test'),
(SELECT "id" FROM "medications" WHERE "name" = 'epinephrine'), '0.5 mg intra muscular for an adult', 'Rapidly constricts blood vessels, relaxes airway muscles, and reduces swelling to counteract the life-threatening symptoms of anaphylaxis.', 
'increased heart rate (tachycardia), palpitations, anxiety, tremors, headache, dizziness, nausea, sweating, and, in rare cases, arrhythmias, high blood pressure, or chest pain',
0
);

UPDATE "conditions" SET "type" = 'internal' WHERE "name" = 'anaphylaxis';

SELECT * FROM "current_medications" WHERE "condition_name" = 'anaphylaxis' 
AND "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = 'Emergency medical service test'
);

SELECT * FROM "logs";

DELETE FROM "conditions" WHERE "name" = 'anaphylaxis';

DELETE FROM "medications" WHERE "name" = 'epinephrine';

DELETE FROM "dosages" WHERE "medication_id" = (
    SELECT "id" FROM "medications" WHERE "name" = 'epinephrine'
) AND "organisation_id" = (
    SELECT "id" FROM "organisations" WHERE "name" = 'Emergency medical service test'
) AND "condition_id" = (
    SELECT "id" FROM "conditions" WHERE "name" = 'anaphylaxis'
);

INSERT INTO "dosages" ("condition_id", "organisation_id", "medication_id", "dosage", "description", "cave", "paediatric")
VALUES ((SELECT "id" FROM "conditions" WHERE "name" = 'anaphylaxis'), (SELECT "id" FROM "organisations" WHERE "name" = 'Emergency medical service test'),
(SELECT "id" FROM "medications" WHERE "name" = 'epinephrine'), '0.5 mg intra muscular for an adult', 'Rapidly constricts blood vessels, relaxes airway muscles, and reduces swelling to counteract the life-threatening symptoms of anaphylaxis.', 
'increased heart rate (tachycardia), palpitations, anxiety, tremors, headache, dizziness, nausea, sweating, and, in rare cases, arrhythmias, high blood pressure, or chest pain',
0
);

SELECT * FROM "logs";




