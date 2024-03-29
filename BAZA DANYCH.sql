-- MySQL Script generated by MySQL Workbench
-- Wed Nov 10 21:55:33 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema projekt_baza_danych
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema projekt_baza_danych
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `projekt_baza_danych` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Users` (
  `mail` VARCHAR(255) NOT NULL,
  `user_name` VARCHAR(45) NULL,
  `good_reports` INT UNSIGNED NULL,
  `Active_account` TINYINT(1) NULL,
  PRIMARY KEY (`mail`),
  UNIQUE INDEX `mail_UNIQUE` (`mail` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Pass`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pass` (
  `Users_mail` VARCHAR(255) NOT NULL,
  `level_of_authorization` INT UNSIGNED NULL,
  `Password` VARCHAR(60) NULL,
  PRIMARY KEY (`Users_mail`),
  INDEX `fk_Pass_Users_idx` (`Users_mail` ASC) VISIBLE,
  CONSTRAINT `fk_Pass_Users`
    FOREIGN KEY (`Users_mail`)
    REFERENCES `mydb`.`Users` (`mail`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`causes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`causes` (
  `cause_id` INT NOT NULL AUTO_INCREMENT,
  `cause_description` VARCHAR(300) NOT NULL,
  `amount_of_accidents` INT NULL,
  PRIMARY KEY (`cause_id`))
ENGINE = InnoDB;

USE `projekt_baza_danych` ;

-- -----------------------------------------------------
-- Table `projekt_baza_danych`.`lines`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projekt_baza_danych`.`lines` (
  `line` VARCHAR(45) NOT NULL,
  `agency_id` INT NOT NULL,
  `destination_1` VARCHAR(100) NOT NULL,
  `destination_2` VARCHAR(100) NULL DEFAULT NULL,
  `route_type_id` INT NOT NULL,
  PRIMARY KEY (`line`),
  UNIQUE INDEX `line_UNIQUE` (`line` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `projekt_baza_danych`.`accident_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projekt_baza_danych`.`accident_details` (
  `accident_id` VARCHAR(45) NOT NULL,
  `driver_id` INT NULL DEFAULT NULL,
  `hurt_passengers` INT NULL DEFAULT '0',
  `dead_passengers` INT NULL DEFAULT '0',
  `amount_of_other_vehicles_accessory` VARCHAR(45) NULL DEFAULT NULL,
  `amount_of_people_accessory` VARCHAR(45) NULL DEFAULT NULL,
  `affected_lines` VARCHAR(45) NOT NULL COMMENT 'Linie, które musiały zmienić trasę / stać w korku z powodu awariii',
  `amount_of_MPK_emplyees` INT NULL DEFAULT '0',
  `amount_of_dead_MPK_emplyees` INT NULL DEFAULT '0',
  `decription` VARCHAR(255) NULL,
  `edited_by_mail` VARCHAR(255) NULL,
  `accpted_by_mail` VARCHAR(255) NULL,
  `added_by_mail` VARCHAR(255) NULL,
  PRIMARY KEY (`accident_id`),
  INDEX `fk_accident_details_lines1_idx` (`affected_lines` ASC) VISIBLE,
  CONSTRAINT `fk_accident_details_lines1`
    FOREIGN KEY (`affected_lines`)
    REFERENCES `projekt_baza_danych`.`lines` (`line`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `projekt_baza_danych`.`accident_main`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projekt_baza_danych`.`accident_main` (
  `accident_id` INT NOT NULL AUTO_INCREMENT,
  `side_number` INT NOT NULL,
  `location_latitude` DOUBLE NOT NULL,
  `location_longitude` DOUBLE NOT NULL,
  `square_id` INT NULL,
  `line` VARCHAR(20) NULL DEFAULT NULL,
  `date` DATE NULL DEFAULT NULL,
  `cause_id` INT NOT NULL,
  PRIMARY KEY (`accident_id`),
  INDEX `fk_accident_main_causes1_idx` (`cause_id` ASC) VISIBLE,
  CONSTRAINT `fk_accident_main_accident_details1`
    FOREIGN KEY (`accident_id`)
    REFERENCES `projekt_baza_danych`.`accident_details` (`accident_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_accident_main_causes1`
    FOREIGN KEY (`cause_id`)
    REFERENCES `mydb`.`causes` (`cause_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `projekt_baza_danych`.`vehicle_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projekt_baza_danych`.`vehicle_type` (
  `vehicle_type_id` INT NOT NULL,
  `vehicle_type_name` VARCHAR(45) NOT NULL,
  `vehicle_type_description` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`vehicle_type_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `projekt_baza_danych`.`vehicles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projekt_baza_danych`.`vehicles` (
  `side_number` INT NOT NULL AUTO_INCREMENT,
  `vehicle_type_id` INT NOT NULL COMMENT '0 - tramway\\\\n1 - bus ',
  `agency_id` INT NOT NULL,
  `registration_number` VARCHAR(10) NOT NULL,
  `is_driving` TINYINT(1) NOT NULL,
  `is_roadworthy` TINYINT(1) NOT NULL,
  PRIMARY KEY (`side_number`),
  UNIQUE INDEX `side_number_UNIQUE` (`side_number` ASC) VISIBLE,
  UNIQUE INDEX `registration_number_UNIQUE` (`registration_number` ASC) VISIBLE,
  CONSTRAINT `fk_vehicles_vehicle_type1`
    FOREIGN KEY (`side_number`)
    REFERENCES `projekt_baza_danych`.`vehicle_type` (`vehicle_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vehicles_accident_main1`
    FOREIGN KEY (`side_number`)
    REFERENCES `projekt_baza_danych`.`accident_main` (`side_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `projekt_baza_danych`.`actual_position`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projekt_baza_danych`.`actual_position` (
  `side_number` INT NOT NULL,
  `actual_longitude` DOUBLE NOT NULL,
  `actual_latitude` DOUBLE NOT NULL,
  PRIMARY KEY (`side_number`),
  CONSTRAINT `fk_actual_position_vehicles1`
    FOREIGN KEY (`side_number`)
    REFERENCES `projekt_baza_danych`.`vehicles` (`side_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `projekt_baza_danych`.`drivers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projekt_baza_danych`.`drivers` (
  `driver_id` INT NOT NULL,
  `has_actual_medical_examination` TINYINT(1) NOT NULL COMMENT '1 - a driver has valid medical examination\\n0 - a driver DOES NOT HAVE valid medical examination',
  `has_actual_driving_license` TINYINT(1) NOT NULL COMMENT '1 - a driver has valid driving license\\n0 - a driver DOES NOT HAVE  valid driving license',
  `agency_id` INT NOT NULL,
  PRIMARY KEY (`driver_id`),
  UNIQUE INDEX `driver_id_UNIQUE` (`driver_id` ASC) VISIBLE,
  CONSTRAINT `fk_drivers_accident_details1`
    FOREIGN KEY (`driver_id`)
    REFERENCES `projekt_baza_danych`.`accident_details` (`driver_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `projekt_baza_danych`.`agency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projekt_baza_danych`.`agency` (
  `agency_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `website_address` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`agency_id`),
  UNIQUE INDEX `agency_id_UNIQUE` (`agency_id` ASC) VISIBLE,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  UNIQUE INDEX `website_address_UNIQUE` (`website_address` ASC) VISIBLE,
  CONSTRAINT `fk_agency_drivers1`
    FOREIGN KEY (`agency_id`)
    REFERENCES `projekt_baza_danych`.`drivers` (`agency_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `projekt_baza_danych`.`localisations_squares`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projekt_baza_danych`.`localisations_squares` (
  `square_id` INT NOT NULL,
  `max_y` DOUBLE NOT NULL,
  `min_y` DOUBLE NOT NULL,
  `max_x` DOUBLE NOT NULL,
  `min_x` DOUBLE NOT NULL,
  `tram_accidents` INT NULL,
  `bus_accidents` INT NULL,
  PRIMARY KEY (`square_id`),
  UNIQUE INDEX `square_id_UNIQUE` (`square_id` ASC) VISIBLE,
  CONSTRAINT `fk_localisations_squares_accident_main1`
    FOREIGN KEY (`square_id`)
    REFERENCES `projekt_baza_danych`.`accident_main` (`square_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
