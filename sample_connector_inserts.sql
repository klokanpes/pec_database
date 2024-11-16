INSERT INTO "protocols_connector" ("protocol_id", "organisation_id", "condition_id")
VALUES
(1, 1, 1),
(2, 1, 2),
(1, 2, 1),
(2, 2, 2),
(1, 3, 1),
(2, 3, 2);

INSERT INTO "equipment_connector" ("equipment_id", "organisation_id", "condition_id")
VALUES
(1, 1, 1),
(1, 1, 2),
(2, 1, 1),
(3, 1, 1),
(4, 1, 1),
(4, 1, 2),
(5, 1, 1),
(5, 1, 2),
(6, 1, 2),
(7, 1, 2),
(8, 1, 2),
(9, 1, 2),
(1, 2, 1),
(1, 2, 2),
(1, 3, 1),
(1, 3, 2);


INSERT INTO "dosages" ("condition_id", "organisation_id", "medication_id", "dosage", "description", "cave")
VALUES
(1, 1, 1, '1 - 2 sprays under the tongue while chest pain is present', 'Isoket is a vasodilatator. In case there is no direct blockage to the coronary artery and the pain is caused by ischemia of the artery, it should dilate the artery and ease the condition.', 'Since it dilates the blood vessels, it may cause hypotension.'),
(1, 1, 2, '500 miligrams i.v. for suspected myocardial infarction', 'Kardegic works similarly to ASA, Aspirin. It reduces further chance of clotting protecting the heart from subsequent blockages. It also helps to relieve the pain', 'Alergies to NSAID''s, liver or kidney disfunction, asthma.'),
(1, 1, 3, 'Approximately 1000 iu per 10 kg of patients body weight', 'Heparin is an anticoagulant medication that prevents the formation of blood clots by inhibiting clotting factors.', 'Liver or kidney disfunction, induced bleeding, serious hypertension'),
(1, 1, 4, 'Initial dose approximately 5 mcg (1 ml) per 50 kg of patient body weight. Titrate until pain relief is achieved.', 'Sufentanil is a potent opioid analgesic used to manage severe pain.', 'Respiratory arrest, induced hypotension'),
(2, 1, 4, 'Initial dose approximately 5 mcg (1 ml) per 50 kg of patient body weight. Titrate until pain relief is achieved.', 'Sufentanil is a potent opioid analgesic used to manage severe pain.', 'Respiratory arrest, induced hypotension'),
(1, 2, 4, 'Initial dose approximately 5 mcg (1 ml) per 50 kg of patient body weight. Titrate until pain relief is achieved.', 'Sufentanil is a potent opioid analgesic used to manage severe pain.', 'Respiratory arrest, induced hypotension'),
(2, 2, 4, 'Initial dose approximately 5 mcg (1 ml) per 50 kg of patient body weight. Titrate until pain relief is achieved.', 'Sufentanil is a potent opioid analgesic used to manage severe pain.', 'Respiratory arrest, induced hypotension'),
(1, 3, 4, 'Initial dose approximately 5 mcg (1 ml) per 50 kg of patient body weight. Titrate until pain relief is achieved.', 'Sufentanil is a potent opioid analgesic used to manage severe pain.', 'Respiratory arrest, induced hypotension'),
(2, 3, 4, 'Initial dose approximately 5 mcg (1 ml) per 50 kg of patient body weight. Titrate until pain relief is achieved.', 'Sufentanil is a potent opioid analgesic used to manage severe pain.', 'Respiratory arrest, induced hypotension');
