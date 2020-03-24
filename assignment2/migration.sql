BEGIN;
--
-- Create model Address
--
CREATE TABLE "anticoagulation_monitoring_address" ("id" serial NOT NULL PRIMARY KEY, "street" varchar(255) NOT NULL UNIQUE, "city" varchar(255) NOT NULL, "province" varchar(255) NULL, "zip_code" varchar(6) NOT NULL);
--
-- Create model Anamnesis
--
CREATE TABLE "anticoagulation_monitoring_anamnesis" ("id" serial NOT NULL PRIMARY KEY);
--
-- Create model AnticoagulationRecord
--
CREATE TABLE "anticoagulation_monitoring_anticoagulationrecord" ("id" serial NOT NULL PRIMARY KEY, "target_inr" double precision NOT NULL, "treatment_start_date" date NOT NULL, "reason_for_treatment" text NOT NULL, "anamnesis_id" integer NOT NULL);
--
-- Create model Country
--
CREATE TABLE "anticoagulation_monitoring_country" ("id" serial NOT NULL PRIMARY KEY, "name" varchar(255) NOT NULL);
--
-- Create model Drug
--
CREATE TABLE "anticoagulation_monitoring_drug" ("id" serial NOT NULL PRIMARY KEY, "trade_name" varchar(255) NOT NULL, "iupac_name" text NULL);
--
-- Create model DrugDosageSchedule
--
CREATE TABLE "anticoagulation_monitoring_drugdosageschedule" ("id" serial NOT NULL PRIMARY KEY, "monday" integer NOT NULL, "tuesday" integer NOT NULL, "wednesday" integer NOT NULL, "thursday" integer NOT NULL, "friday" integer NOT NULL, "saturday" integer NOT NULL, "sunday" integer NOT NULL);
--
-- Create model Facility
--
CREATE TABLE "anticoagulation_monitoring_facility" ("id" serial NOT NULL PRIMARY KEY, "name" varchar(255) NOT NULL, "address_id" integer NOT NULL UNIQUE);
--
-- Create model GeneralPractitioner
--
CREATE TABLE "anticoagulation_monitoring_generalpractitioner" ("id" serial NOT NULL PRIMARY KEY, "first_name" varchar(255) NOT NULL, "last_name" varchar(255) NOT NULL, "middle_name" varchar(255) NULL, "gender" varchar(1) NOT NULL, "birth_date" date NOT NULL, "telephone" varchar(15) NULL UNIQUE, "mobile" varchar(15) NULL UNIQUE, "email" varchar(254) NULL UNIQUE, "address_id" integer NOT NULL, "employed_at_id" integer NULL);
--
-- Create model Patient
--
CREATE TABLE "anticoagulation_monitoring_patient" ("id" serial NOT NULL PRIMARY KEY, "first_name" varchar(255) NOT NULL, "last_name" varchar(255) NOT NULL, "middle_name" varchar(255) NULL, "gender" varchar(1) NOT NULL, "birth_date" date NOT NULL, "telephone" varchar(15) NULL UNIQUE, "mobile" varchar(15) NULL UNIQUE, "email" varchar(254) NULL UNIQUE, "address_id" integer NOT NULL, "general_practitioner_id" integer NULL);
--
-- Create model Nurse
--
CREATE TABLE "anticoagulation_monitoring_nurse" ("id" serial NOT NULL PRIMARY KEY, "first_name" varchar(255) NOT NULL, "last_name" varchar(255) NOT NULL, "middle_name" varchar(255) NULL, "gender" varchar(1) NOT NULL, "birth_date" date NOT NULL, "telephone" varchar(15) NULL UNIQUE, "mobile" varchar(15) NULL UNIQUE, "email" varchar(254) NULL UNIQUE, "address_id" integer NOT NULL, "employed_at_id" integer NULL);
--
-- Create model DrugDosage
--
CREATE TABLE "anticoagulation_monitoring_drugdosage" ("id" serial NOT NULL PRIMARY KEY, "strength" integer NOT NULL, "drug_id" integer NOT NULL);
--
-- Create model AnticoagulationRecordEntry
--
CREATE TABLE "anticoagulation_monitoring_anticoagulationrecordentry" ("id" serial NOT NULL PRIMARY KEY, "date" date NOT NULL, "inr_measured" double precision NOT NULL, "AnticoagulationRecord_id" integer NOT NULL, "drug_dosage_schedule_id" integer NOT NULL UNIQUE);
--
-- Add field drug to anticoagulationrecord
--
ALTER TABLE "anticoagulation_monitoring_anticoagulationrecord" ADD COLUMN "drug_id" integer NOT NULL CONSTRAINT "anticoagulation_moni_drug_id_2993a452_fk_anticoagu" REFERENCES "anticoagulation_monitoring_drug"("id") DEFERRABLE INITIALLY DEFERRED; SET CONSTRAINTS "anticoagulation_moni_drug_id_2993a452_fk_anticoagu" IMMEDIATE;
--
-- Add field treatment_facility to anticoagulationrecord
--
ALTER TABLE "anticoagulation_monitoring_anticoagulationrecord" ADD COLUMN "treatment_facility_id" integer NOT NULL CONSTRAINT "anticoagulation_moni_treatment_facility_i_d91ecef4_fk_anticoagu" REFERENCES "anticoagulation_monitoring_facility"("id") DEFERRABLE INITIALLY DEFERRED; SET CONSTRAINTS "anticoagulation_moni_treatment_facility_i_d91ecef4_fk_anticoagu" IMMEDIATE;
--
-- Add field patient to anamnesis
--
ALTER TABLE "anticoagulation_monitoring_anamnesis" ADD COLUMN "patient_id" integer NOT NULL UNIQUE CONSTRAINT "anticoagulation_moni_patient_id_c4308d50_fk_anticoagu" REFERENCES "anticoagulation_monitoring_patient"("id") DEFERRABLE INITIALLY DEFERRED; SET CONSTRAINTS "anticoagulation_moni_patient_id_c4308d50_fk_anticoagu" IMMEDIATE;
--
-- Add field country to address
--
ALTER TABLE "anticoagulation_monitoring_address" ADD COLUMN "country_id" integer NOT NULL CONSTRAINT "anticoagulation_moni_country_id_9d982f72_fk_anticoagu" REFERENCES "anticoagulation_monitoring_country"("id") DEFERRABLE INITIALLY DEFERRED; SET CONSTRAINTS "anticoagulation_moni_country_id_9d982f72_fk_anticoagu" IMMEDIATE;
CREATE INDEX "anticoagulation_monitoring_address_street_dd9dc855_like" ON "anticoagulation_monitoring_address" ("street" varchar_pattern_ops);
ALTER TABLE "anticoagulation_monitoring_anticoagulationrecord" ADD CONSTRAINT "anticoagulation_moni_anamnesis_id_09a8a4fe_fk_anticoagu" FOREIGN KEY ("anamnesis_id") REFERENCES "anticoagulation_monitoring_anamnesis" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "anticoagulation_monitoring_anamnesis_id_09a8a4fe" ON "anticoagulation_monitoring_anticoagulationrecord" ("anamnesis_id");
ALTER TABLE "anticoagulation_monitoring_facility" ADD CONSTRAINT "anticoagulation_moni_address_id_a2dbe411_fk_anticoagu" FOREIGN KEY ("address_id") REFERENCES "anticoagulation_monitoring_address" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "anticoagulation_monitoring_generalpractitioner" ADD CONSTRAINT "anticoagulation_moni_address_id_807dde4c_fk_anticoagu" FOREIGN KEY ("address_id") REFERENCES "anticoagulation_monitoring_address" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "anticoagulation_monitoring_generalpractitioner" ADD CONSTRAINT "anticoagulation_moni_employed_at_id_2419debc_fk_anticoagu" FOREIGN KEY ("employed_at_id") REFERENCES "anticoagulation_monitoring_facility" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "anticoagulation_monitori_telephone_d4d6cf18_like" ON "anticoagulation_monitoring_generalpractitioner" ("telephone" varchar_pattern_ops);
CREATE INDEX "anticoagulation_monitori_mobile_de5a97b5_like" ON "anticoagulation_monitoring_generalpractitioner" ("mobile" varchar_pattern_ops);
CREATE INDEX "anticoagulation_monitori_email_807972da_like" ON "anticoagulation_monitoring_generalpractitioner" ("email" varchar_pattern_ops);
CREATE INDEX "anticoagulation_monitoring_address_id_807dde4c" ON "anticoagulation_monitoring_generalpractitioner" ("address_id");
CREATE INDEX "anticoagulation_monitoring_employed_at_id_2419debc" ON "anticoagulation_monitoring_generalpractitioner" ("employed_at_id");
ALTER TABLE "anticoagulation_monitoring_patient" ADD CONSTRAINT "anticoagulation_moni_address_id_45601676_fk_anticoagu" FOREIGN KEY ("address_id") REFERENCES "anticoagulation_monitoring_address" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "anticoagulation_monitoring_patient" ADD CONSTRAINT "anticoagulation_moni_general_practitioner_0d5e4e76_fk_anticoagu" FOREIGN KEY ("general_practitioner_id") REFERENCES "anticoagulation_monitoring_generalpractitioner" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "anticoagulation_monitoring_patient_telephone_f2c56404_like" ON "anticoagulation_monitoring_patient" ("telephone" varchar_pattern_ops);
CREATE INDEX "anticoagulation_monitoring_patient_mobile_aed4964c_like" ON "anticoagulation_monitoring_patient" ("mobile" varchar_pattern_ops);
CREATE INDEX "anticoagulation_monitoring_patient_email_ee6c8748_like" ON "anticoagulation_monitoring_patient" ("email" varchar_pattern_ops);
CREATE INDEX "anticoagulation_monitoring_patient_address_id_45601676" ON "anticoagulation_monitoring_patient" ("address_id");
CREATE INDEX "anticoagulation_monitoring_general_practitioner_id_0d5e4e76" ON "anticoagulation_monitoring_patient" ("general_practitioner_id");
ALTER TABLE "anticoagulation_monitoring_nurse" ADD CONSTRAINT "anticoagulation_moni_address_id_f4665a64_fk_anticoagu" FOREIGN KEY ("address_id") REFERENCES "anticoagulation_monitoring_address" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "anticoagulation_monitoring_nurse" ADD CONSTRAINT "anticoagulation_moni_employed_at_id_10663bad_fk_anticoagu" FOREIGN KEY ("employed_at_id") REFERENCES "anticoagulation_monitoring_facility" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "anticoagulation_monitoring_nurse_telephone_154e77c1_like" ON "anticoagulation_monitoring_nurse" ("telephone" varchar_pattern_ops);
CREATE INDEX "anticoagulation_monitoring_nurse_mobile_0a9a4ab1_like" ON "anticoagulation_monitoring_nurse" ("mobile" varchar_pattern_ops);
CREATE INDEX "anticoagulation_monitoring_nurse_email_bbeb688f_like" ON "anticoagulation_monitoring_nurse" ("email" varchar_pattern_ops);
CREATE INDEX "anticoagulation_monitoring_nurse_address_id_f4665a64" ON "anticoagulation_monitoring_nurse" ("address_id");
CREATE INDEX "anticoagulation_monitoring_nurse_employed_at_id_10663bad" ON "anticoagulation_monitoring_nurse" ("employed_at_id");
ALTER TABLE "anticoagulation_monitoring_drugdosage" ADD CONSTRAINT "anticoagulation_moni_drug_id_2bf05f9a_fk_anticoagu" FOREIGN KEY ("drug_id") REFERENCES "anticoagulation_monitoring_drug" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "anticoagulation_monitoring_drugdosage_drug_id_2bf05f9a" ON "anticoagulation_monitoring_drugdosage" ("drug_id");
ALTER TABLE "anticoagulation_monitoring_anticoagulationrecordentry" ADD CONSTRAINT "anticoagulation_moni_AnticoagulationRecor_0b6e2213_fk_anticoagu" FOREIGN KEY ("AnticoagulationRecord_id") REFERENCES "anticoagulation_monitoring_anticoagulationrecord" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "anticoagulation_monitoring_anticoagulationrecordentry" ADD CONSTRAINT "anticoagulation_moni_drug_dosage_schedule_5b9131c5_fk_anticoagu" FOREIGN KEY ("drug_dosage_schedule_id") REFERENCES "anticoagulation_monitoring_drugdosageschedule" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "anticoagulation_monitoring_AnticoagulationRecord_id_0b6e2213" ON "anticoagulation_monitoring_anticoagulationrecordentry" ("AnticoagulationRecord_id");
CREATE INDEX "anticoagulation_monitoring_drug_id_2993a452" ON "anticoagulation_monitoring_anticoagulationrecord" ("drug_id");
CREATE INDEX "anticoagulation_monitoring_treatment_facility_id_d91ecef4" ON "anticoagulation_monitoring_anticoagulationrecord" ("treatment_facility_id");
CREATE INDEX "anticoagulation_monitoring_address_country_id_9d982f72" ON "anticoagulation_monitoring_address" ("country_id");
COMMIT;
