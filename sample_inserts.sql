INSERT INTO "conditions" ("name", "type", "description")
VALUES
('heart attack', 'internal medicine', 'A heart attack, or myocardial infarction, happens when a coronary artery becomes blocked, reducing or stopping blood flow to a part of the heart muscle, causing it to become damaged or die. The patient typically experiences severe chest pain or discomfort that may radiate to the arm, neck, jaw, or back, along with shortness of breath, nausea, sweating, and lightheadedness. Upon examination, we might find the patient with cool, clammy skin, chest pain that worsens with exertion, labored or rapid breathing, oxygen saturation below normal levels, and ECG changes such as ST-segment elevation or depression, T-wave inversion, or new-onset left bundle branch block.'),
('major trauma', 'trauma', 'Major trauma refers to severe physical injuries sustained from high-energy events such as high-speed vehicle collisions, falls from significant heights, or penetrating injuries like gunshot or stab wounds, requiring immediate and specialized care. Typical signs include altered mental status, severe injuries such as open fractures or penetrating wounds, uncontrolled bleeding, and symptoms of shock, including pale or cool skin, rapid pulse, or low blood pressure. Examination may reveal decreased consciousness, labored or irregular breathing, low oxygen saturation, hypotension, weak or absent pulses, and multiple trauma indicators, such as chest or abdominal tenderness, pelvic instability, or fractures.');

INSERT INTO "organisations" ("name", "location", "type")
VALUES
('Emergency medical service test', 'Patagonia', 'Emergency medical service'),
('Fire rescue organisation', 'Berlin, Germany', 'Fire Rescue'),
('Interhospital transport Czechia', 'Karlovy Vary, Czechia', 'Private provider');

INSERT INTO "protocols" ("name", "description", "resource_link")
VALUES
('heart attack', 'The general management of a heart attack by a paramedic on scene includes performing a physical examination, taking the patient''s medical and pharmacological history, and measuring vital signs, including performing an ECG, which must be transmitted to an Emergency Medical Service (EMS) doctor for consultation. If advised by the EMS doctor, the paramedic must then consult with a doctor at the nearest or local cardiac center (a primary coronary intervention physician) to determine the appropriate treatment plan. The paramedic must administer medications as directed by the doctors, including Kardegic 500 mg intravenously, sufentanil for pain management, and heparin 1000 IU per 10 kg, but must confirm any hospital doctor''s orders with a follow-up call to the EMS doctor before administration.','https://www.heart.org/-/media/Files/Affiliates/MWA/North-Dakota/North-Dakota-Stroke-Cardiac-Conference/Cardiac-Indications-in-EMS.pdf'),
('major trauma', 'General management of a major trauma patient involves the crew performing a physical examination, taking into account the mechanism of injury and the energy involved, especially in cases of high-energy mechanisms of injury. The crew must approach the patient using the XABCDE algorithm and quickly determine whether the patient is trauma triage positive. If the patient is trauma triage positive, a Helicopter Emergency Medical Service (HEMS) may be called to the scene, though they may or may not be available. The patient must then be prepared for transport, which involves stabilizing their condition, such as stopping any bleeding, fully immobilizing the body, and transporting them to the nearest trauma center. The crew should ideally spend no more than ten minutes on scene, and the patient should be in the hospital within an hour of the injury.', 'https://emcmedicaltraining.com/wp-content/uploads/2020/02/phtls-9th-edition-prep-packets-2019a.pdf'),
('heart attack', 'Lorem Ipsum', 'www.dolor_sit_amet.com'),
('major trauma', 'Lorem Ipsum', 'www.dolot_sit_amet.com');

INSERT INTO "equipment" ("name", "type", "description", "how_to_use")
VALUES
('Nonin PalmSat 2500', 'diagnostics', 'A pulse oximeter is a non-invasive medical device that measures the oxygen saturation level of a patient''s blood and provides an indication of heart rate by using a sensor placed on a thin part of the body, like a fingertip or earlobe.','A pulse oximeter is used to quickly and non-invasively measure a patient''s blood oxygen saturation level and pulse rate by attaching a sensor to a thin body part, such as a fingertip or earlobe.'),
('Stair chair', 'transport', 'A stair chair is a foldable transport device with wheels and extendable rear tracks designed for safely moving patients up or down stairs.', 'To use it, the chair must be unpacked and set up, the patient securely strapped in, and the rear tracks pulled out to enable a rescuer to maneuver the chair down stairs single-handedly with stability and control.'),
('LIFEPAK 15', 'diagnostics/therapeutical', 'The LIFEPAK 15 is a rugged, portable monitor and defibrillator used by emergency medical personnel to assess vital signs, provide advanced cardiac monitoring, and deliver defibrillation or synchronized cardioversion.', 'It is used to monitor a patient''s heart rhythm, measure parameters like oxygen saturation and blood pressure, and deliver electrical shocks to restore a normal heart rhythm in cases of cardiac arrest or arrhythmias.' ),
('i.v. catheter', 'therapeutical', 'An IV catheter is a small, flexible tube inserted into a vein to provide direct access for delivering fluids, medications, or collecting blood samples.', 'When using an IV catheter, healthcare providers must exercise caution to avoid needlestick injuries and ensure personal protection by handling the sharp needle carefully, as it may be contaminated with potentially infectious agents.'),
('oxygen bottle', 'therapeutical', 'An oxygen pressure bottle is a portable, high-pressure cylinder filled with medical-grade oxygen for use in emergency and clinical settings', 'It is used to deliver supplemental oxygen to patients with respiratory distress or low blood oxygen levels through masks or nasal cannulas, helping maintain adequate oxygenation.'),
('Full body vacuum mattress', 'transport', 'A full-body vacuum mattress is a medical immobilization device that conforms to the patient''s body shape when air is evacuated, providing secure support and stabilization.', 'It is used to immobilize patients with potential spinal, pelvic, or multiple fractures during transport to prevent further injury and ensure safe handling.'),
('CAT tourniquette', 'therapeutical','A CAT (Combat Application Tourniquet) is a strap-and-windlass device designed to control severe bleeding from a limb by compressing the blood vessels to stop blood flow.', 'place the tourniquet above the bleeding site, pull the strap tightly, twist the windlass until bleeding stops, and secure it in place with the clip and strap, noting the application time.'),
('cervical spine collar', 'transport', 'A cervical spine collar is a rigid or semi-rigid medical device used to immobilize and support the neck to prevent further spinal injury.', 'carefully place the collar around the patient''s neck, ensuring it fits snugly under the chin and around the back of the head, while keeping the head and neck in a neutral, aligned position to stabilize the cervical spine until definitive medical care is provided.'),
('SAM pelvic splint', 'therapeutical', 'A SAM pelvic splint is a lightweight, adjustable device designed to stabilize and support a suspected pelvic fracture by compressing the pelvis to reduce internal bleeding and prevent further injury.', 'To use it, wrap the splint around the patient''s pelvis at the level of the greater trochanters, secure the strap tightly, and adjust the device to maintain gentle, even pressure until definitive care can be provided.');

INSERT INTO "medications" ("name", "active_ingredient", "packaging_in_use")
VALUES
('Isoket spray', 'isosorbidi dinitras', '375 mg / 15 ml'),
('Kardegic', 'lysini racemici acetylsalicylas', '500 mg'),
('Heparin', 'heparinum natricum', '50 000 iu / 10 ml'),
('Sufentanil', 'sufentanili citras', '10 μg / 2 ml');

