DROP DATABASE IF EXISTS airlineDB;
CREATE DATABASE IF NOT EXISTS airlineDB;

USE airlineDB;

CREATE TABLE nonmember_booker
	( email VARCHAR(20) NOT NULL PRIMARY KEY, 
	  country_code VARCHAR(10) NOT NULL, 
	  phone_no varchar(20) NOT NULL,
	  language_ VARCHAR(20) NOT NULL) ; 

CREATE TABLE member
	( skypass_number VARCHAR(20) NOT NULL PRIMARY KEY, 
      email varchar(20) NOT NULL , 
	  last_name VARCHAR(10) NOT NULL, 
	  first_name VARCHAR(10) NOT NULL,
	  gender VARCHAR(20) NOT NULL,
      date_of_birth VARCHAR(30) NOT NULL,
      ID VARCHAR(20) NOT NULL,
      passwords VARCHAR(20) NOT NULL,
      member_level VARCHAR(20) NOT NULL,
      mileage INT(20),
	  country_code INT NOT NULL, 
	  phone_no varchar(20) NOT NULL,
	  language_ VARCHAR(20) NOT NULL,
      family_skypass_number VARCHAR(20)
      ); 
      
 ALTER TABLE member 
	ADD FOREIGN KEY (family_skypass_number) 
	REFERENCES member(skypass_number) ;

CREATE TABLE all_ticket 
	( ticket_number VARCHAR(20) NOT NULL PRIMARY KEY);

CREATE TABLE nonmember_booked_ticket
	( ticket_number VARCHAR(20) NOT NULL PRIMARY KEY, 
	  booking_reference  VARCHAR(20) NOT NULL, 
	  selected_seat VARCHAR(10),
	  class CHAR(13) NOT NULL,
	  baggage INT NOT NULL,
      fare_basis VARCHAR(10) NOT NULL,
      validity VARCHAR(20) NOT NULL,
      skypass_miles INT NOT NULL,
      reserved_date VARCHAR(10) NOT NULL,
      booked_email VARCHAR(20),
      organized_flight_name VARCHAR(10), 
      reserved_passport_number VARCHAR(10),
      FOREIGN KEY(ticket_number) REFERENCES all_ticket(ticket_number) ON UPDATE CASCADE ON DELETE CASCADE,
      FOREIGN KEY(booked_email) REFERENCES nonmember_booker(email) ON UPDATE CASCADE ON DELETE SET NULL
      ); 

CREATE TABLE member_booked_ticket
	( ticket_number VARCHAR(20) NOT NULL PRIMARY KEY, 
	  booking_reference  VARCHAR(20) NOT NULL, 
	  selected_seat VARCHAR(10),
	  class CHAR(13) NOT NULL,
	  baggage INT NOT NULL,
      fare_basis VARCHAR(10) NOT NULL,
      validity VARCHAR(20) NOT NULL,
      skypass_miles INT NOT NULL,
      reserved_date VARCHAR(10) NOT NULL,
      booked_skypass_number VARCHAR(20) NOT NULL,
      organized_flight_name VARCHAR(10), 
      reserved_passport_number VARCHAR(10),
      FOREIGN KEY(ticket_number) REFERENCES all_ticket(ticket_number) ON UPDATE CASCADE ON DELETE CASCADE,
      FOREIGN KEY(booked_skypass_number) REFERENCES member(skypass_number)    
        ON UPDATE CASCADE ON DELETE CASCADE
      ); 

CREATE TABLE passenger 
	(passport_number VARCHAR(10) NOT NULL PRIMARY KEY,
     skypass_number VARCHAR(20),
      last_name VARCHAR(10) , 
	  first_name VARCHAR(10) ,
	  gender VARCHAR(20) ,
      date_of_birth VARCHAR(30) ,
      nationality VARCHAR(20) NOT NULL,
	  passenger_type VARCHAR(20) NOT NULL,
      mileage_carrier VARCHAR(20),
      membership_number VARCHAR(10),
      boarding_aircraft_ID VARCHAR(10),
      reserved_ticket_number VARCHAR(20),
      FOREIGN KEY(skypass_number) REFERENCES member(skypass_number)
		ON UPDATE CASCADE ON DELETE CASCADE,
	  FOREIGN KEY(reserved_ticket_number) REFERENCES all_ticket(ticket_number)    
        ON UPDATE CASCADE ON DELETE CASCADE
    );

ALTER TABLE nonmember_booked_ticket ADD FOREIGN KEY (reserved_passport_number) 
	REFERENCES passenger(passport_number)    
	ON UPDATE CASCADE ON DELETE SET NULL; 

ALTER TABLE member_booked_ticket ADD FOREIGN KEY (reserved_passport_number) 
	REFERENCES passenger(passport_number)    
	ON UPDATE CASCADE ON DELETE SET NULL; 


CREATE TABLE flight
	( flight_name VARCHAR(10) NOT NULL PRIMARY KEY, 
	  flight_from VARCHAR(10) NOT NULL, 
	  flight_to VARCHAR(10) NOT NULL,
	  departure_time DATETIME NOT NULL,
      landing_time DATETIME NOT NULL,
      departure_terminal INT NOT NULL,
      arrival_terminal INT NOT NULL,
      flight_time VARCHAR(10) NOT NULL,
      aircraft_ID VARCHAR(10)
      );
      
ALTER TABLE nonmember_booked_ticket ADD FOREIGN KEY (organized_flight_name) 
	REFERENCES flight(flight_name) 
	ON UPDATE CASCADE ON DELETE SET NULL;       
ALTER TABLE member_booked_ticket ADD FOREIGN KEY (organized_flight_name) 
	REFERENCES flight(flight_name) 
	ON UPDATE CASCADE ON DELETE SET NULL;             

CREATE TABLE aircraft
	( aircraft_id VARCHAR(10) NOT NULL PRIMARY KEY, 
	  age INT NOT NULL,
      flying_range INT NOT NULL,
      model_name VARCHAR(10)
      );
ALTER TABLE flight ADD FOREIGN KEY (aircraft_ID) 
	REFERENCES aircraft(aircraft_id)   
	ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE passenger ADD FOREIGN KEY (boarding_aircraft_ID) 
	REFERENCES aircraft(aircraft_id)     
	ON UPDATE CASCADE ON DELETE SET NULL; 	

CREATE TABLE aircraft_model
	( model_name VARCHAR(10) NOT NULL PRIMARY KEY, 
	  manufacturer VARCHAR(10) NOT NULL,
      cruising_speed VARCHAR(10) NOT NULL,
      no_of_engines INT NOT NULL,
      wing_span VARCHAR(10) NOT NULL,
      wing_area VARCHAR(10) NOT NULL,
      tail_length VARCHAR(10) NOT NULL,
      tail_width VARCHAR(10) NOT NULL,
      overall_length VARCHAR(10) NOT NULL,
      overall_width VARCHAR(10) NOT NULL ,
      overall_height VARCHAR(10) NOT NULL,
      cabin_length VARCHAR(10) NOT NULL
	  );
      
ALTER TABLE aircraft ADD FOREIGN KEY (model_name) 
	REFERENCES aircraft_model(model_name) 
	ON UPDATE CASCADE ON DELETE SET NULL; 
    

CREATE TABLE boarding_ticket
	( ticket_number VARCHAR(20) NOT NULL PRIMARY KEY, 
	  boarding_time DATETIME NOT NULL, 
	  extra_service VARCHAR(20),
	  boarding_gate VARCHAR(10) NOT NULL,
	  seat_no VARCHAR(10) NOT NULL
      );

CREATE TABLE flight_fare
	( flight_name VARCHAR(10), 
	  fare VARCHAR(10) NOT NULL, 
	  constraint aircraft_fare primary key(flight_name,fare),
      FOREIGN KEY(flight_name) REFERENCES flight(flight_name) ON UPDATE CASCADE ON DELETE CASCADE
	  ); 

CREATE TABLE aircraft_seat
	( aircraft_ID VARCHAR(10), 
	  aircraft_seat_no VARCHAR(4) NOT NULL, 
	  constraint aircraft_seat primary key(aircraft_ID, aircraft_seat_no),
      FOREIGN KEY(aircraft_ID) REFERENCES aircraft(aircraft_ID) ON UPDATE CASCADE ON DELETE CASCADE
      ); 

CREATE TABLE flight_seat
	( flight_name VARCHAR(10), 
	  flight_seat_no CHAR(4) NOT NULL, 
      constraint flight_seat primary key(flight_name, flight_seat_no),
      FOREIGN KEY(flight_name) REFERENCES flight(flight_name) ON UPDATE CASCADE ON DELETE CASCADE
      ); 
      
CREATE TABLE check_in
	( reserved_ticket_number VARCHAR(20), 
	  passport_number VARCHAR(10), 
	  boarding_ticket_number VARCHAR(20),
      constraint check_in primary key(reserved_ticket_number, passport_number, boarding_ticket_number),
      FOREIGN KEY(reserved_ticket_number) REFERENCES passenger(reserved_ticket_number) ON UPDATE CASCADE ON DELETE CASCADE,
      FOREIGN KEY(passport_number) REFERENCES passenger(passport_number) ON UPDATE CASCADE ON DELETE CASCADE,  
      FOREIGN KEY(boarding_ticket_number) REFERENCES boarding_ticket(ticket_number) ON UPDATE CASCADE ON DELETE CASCADE
      );

SHOW DATABASES;

SELECT database();
SHOW TABLES;

#################   데이터 입력    #################



# 비회원 예매자 정보 입력


INSERT INTO nonmember_booker
VALUES ('jihyun@naver.com','+82','10-8296-5678','Korean');
INSERT INTO nonmember_booker
VALUES ('minjun@gmail.com','+82','10-5319-7204','Korean');
INSERT INTO nonmember_booker
VALUES ('sooji@naver.com','+82','10-8642-0975','Korean');
SELECT * FROM nonmember_booker;


# 회원 정보 입력


INSERT INTO member
VALUES ('KE12341234', 'jiwon@naver.com', 'Choi','Ji-won','female', '1995-07-10','jw123', 'wldnjs1234','general',2000,'+82','10-7029-5146','Korean', NULL);
INSERT INTO member
VALUES ('KE23456789', 'hyoo@gmail.com', 'Kim','Hyun-woo','male', '1997-02-21','HWW111', 'gusdn123!','general',1000,'+82','10-4087-2659','Korean', NULL);
INSERT INTO member
VALUES ('KE44445555', 'godnjsdk@naver.com', 'Song','Seung-jae','male', '1990-10-23','thdthd', 'tmdwodi!','general',3000,'+82','10-2351-5021','Korean', NULL);




#송승재와 강은지는 부부로 서로 가족회원ID에 서로의 ID가 입력된다.
INSERT INTO member
VALUES ('KE34567890', 'dmswl123@naver.com', 'Kang','Eun-ji','female', '1990-11-07','dms12dms', 'dmswldmswl','MorningCalmClub',30000,
		'+82','10-9846-5021','Korean', 'KE44445555');
UPDATE member 
SET family_skypass_number = 'KE34567890'
WHERE skypass_number = 'KE44445555';




# 항공편 정보 입력


INSERT INTO flight
VALUES('KE1111', 'GMP', 'PUS', '2023-06-04 09:00:00', '2023-06-04 10:05:00', 1, 1, '1h5m',  NULL);
INSERT INTO flight
VALUES('KE2222', 'GMP', 'PUS', '2023-12-30 07:00:00', '2023-12-30 08:05:00', 1, 1, '1h5m',  NULL);
INSERT INTO flight
VALUES('KE3333', 'ICN', 'BKK', '2023-06-05 16:40:00', '2023-06-05 20:35:00', 1, 2, '5h55m',  NULL);




# 항공기 기종 정보 입력


INSERT INTO aircraft_model
VALUES('BE787-9', 'Boeing', '912km/h', 2, '60m', '377m^2', '17.0m', '23.6 m','62.8m', '5.77m','5.94m', '5.49m');
INSERT INTO aircraft_model
VALUES('BE747', 'Boeing', '912km/h', 4, '64.4m', '511m^2', '23.5m', '32m', '70.6m', '64.4m', '19.4m', '6.1m');



# 항공기 정보 입력


INSERT INTO aircraft
VALUES('BE787-9A', 10, 12592, 'BE787-9');
INSERT INTO aircraft
VALUES('BE747A', 13, 13602, 'BE747');
INSERT INTO aircraft
VALUES('BE747B', 19, 13602, 'BE747');



# 항공편 테이블에 항공기_ID 정보 삽입


UPDATE flight
SET aircraft_ID = 'BE787-9A'
WHERE flight_name = 'KE1111';
UPDATE flight
SET aircraft_ID = 'BE787-9A'
WHERE flight_name = 'KE2222';
UPDATE flight
SET aircraft_ID = 'BE747B'
WHERE flight_name = 'KE3333';



# 티켓 정보 입력


INSERT INTO all_ticket
VALUES('9876543210987');
INSERT INTO all_ticket
VALUES('9876543210988');
INSERT INTO all_ticket
VALUES('8642097531092');
INSERT INTO all_ticket
VALUES('4087265913802');
INSERT INTO all_ticket
VALUES('6172839405678');
INSERT INTO all_ticket
VALUES('6172839405679');

INSERT INTO nonmember_booked_ticket
VALUES ('9876543210987',	'82955678',	NULL, 'S', 20, 'SLWD', '-19MAY2024', 215, ' 17MAY2023', 'jihyun@naver.com','KE1111',  NULL );
INSERT INTO nonmember_booked_ticket
VALUES ('9876543210988',	'82955678',	NULL, 'S', 20, 'SLWD', '-19MAY2024', 215, ' 17MAY2023', 'jihyun@naver.com','KE1111',  NULL);
INSERT INTO nonmember_booked_ticket
VALUES ('8642097531092',	'53197204',	NULL, 'Y', 20, 'YLWD', '-30DEC2024', 215, ' 10MAY2023', 'minjun@gmail.com','KE2222',  NULL);
INSERT INTO member_booked_ticket
VALUES ('4087265913802',	'70295146',	NULL, 'L', 20, 'LLWD', '-30JUL2024', 215, ' 16MAY2023', 'KE12341234','KE1111',  NULL);
INSERT INTO member_booked_ticket
VALUES ('6172839405678',	'40872659',	'49A', 'B', 20, 'BLWD', '-30MAY2024', 315, ' 23MAY2023', 'KE23456789','KE3333',  NULL);
INSERT INTO member_booked_ticket
VALUES ('6172839405679',	'40872659',	'49B', 'B', 20, 'BLWD', '-30MAY2024', 315, ' 23MAY2023', 'KE23456789','KE3333',  NULL);



# 탑승객 정보 입력
INSERT INTO passenger
VALUES('M1234567', NULL, 'Park', 'Ji-eun', 'female', '1979-12-05', 'South Korea', 'A', NULL, NULL, 'BE787-9A', '9876543210987');
INSERT INTO passenger
VALUES('M9876543', NULL, 'Kim', 'Sang-hoon', 'male', '1971-07-26', 'South Korea', 'A', NULL, NULL,'BE787-9A', '9876543210988');
INSERT INTO passenger
VALUES('M2468135', NULL, 'Park', 'Min-jun', 'male', '1988-09-03', 'South Korea', 'A', NULL, NULL,'BE787-9A', '8642097531092');
INSERT INTO passenger
VALUES('M7854321', 'KE12341234', NULL, NULL, NULL, NULL, 'South Korea', 'A', NULL, NULL, 'BE787-9A', '4087265913802');
INSERT INTO passenger
VALUES('M5319720', 'KE23456789', NULL, NULL, NULL, NULL, 'South Korea', 'A', NULL, NULL, 'BE747B', '6172839405678');
INSERT INTO passenger
VALUES('M5823196', NULL, 'Ahn', 'Joon-ho', 'male', '1997-06-19', 'South Korea', 'A', 'Hawaiian Airlines', 'HA8642097', 'BE747B', '6172839405679');



# 티켓 정보의 여권 정보를 탑승객의 여권 정보로 삽입
UPDATE nonmember_booked_ticket as T, passenger as P
SET T.reserved_passport_number = P.passport_number
WHERE T.ticket_number = P.reserved_ticket_number;

UPDATE member_booked_ticket as T, passenger as P
SET T.reserved_passport_number = P.passport_number
WHERE T.ticket_number = P.reserved_ticket_number;

# 탑승권 정보 입력

INSERT INTO boarding_ticket
VALUES('105', '2023-06-04 08:30:000', NULL, 'D', '70A');
INSERT INTO boarding_ticket
VALUES('106', '2023-06-04 08:30:000', NULL, 'D', '70B');
INSERT INTO boarding_ticket
VALUES('30', '2023-06-04 08:30:000', NULL, 'D', '30D');

# 체크인 정보 입력

INSERT INTO check_in 
VALUES ('9876543210987', 'M1234567', '105');
INSERT INTO check_in 
VALUES ('9876543210988', 'M9876543', '106');
INSERT INTO check_in 
VALUES ('4087265913802', 'M7854321', '30');



#################   쿼리    #################

# 상황 1: 비회원인 'jihyun@naver.com'이 비회원 탑승객 두 명의 티켓을 예매 함. 
#쿼리 1: 비회원 예매 확인- 예매번호로 항공권 정보 검색 (한 명이 여러개 예매한 것 보여주기)

SELECT *
FROM nonmember_booked_ticket
WHERE booking_reference = '82955678';


#쿼리 2: 비회원 예매 확인 - 예매 번호로 예약한 두 비회원 탑승객의 여권 번호를 알아냄. 
SELECT passenger.passport_number 
FROM nonmember_booked_ticket INNER JOIN passenger
WHERE nonmember_booked_ticket.booking_reference = '82955678' 
	AND nonmember_booked_ticket.ticket_number = passenger.reserved_ticket_number;
    
     
# 쿼리 2: 회원의 이름으로 ‘김현우’의 회원번호 알아내기
SELECT skypass_number
FROM member
WHERE last_name = 'Kim' AND first_name = 'Hyun-woo';

#쿼리 3: 회원 예매 확인 - ‘김현우’의 회원번호 ‘KE23456789’ 로 예매한 항공권 티켓의 항공권 번호, 여권번호, 사전선택 좌석을 알아내기 
SELECT ticket_number, reserved_passport_number, selected_seat
FROM member_booked_ticket
WHERE booked_skypass_number = 'KE23456789'; 


#쿼리 4: 회원 예매 취소- 회원번호 'KE23456789’가 예매한 티켓 정보 삭제 
DELETE all_ticket, member_booked_ticket
FROM all_ticket INNER JOIN member_booked_ticket  
ON all_ticket.ticket_number = member_booked_ticket.ticket_number
WHERE member_booked_ticket.booked_skypass_number = 'KE23456789';

#쿼리 5: ‘BE747’ 항공기 기종의 모든 항공기 ID 검색하기
SELECT aircraft.aircraft_ID
FROM aircraft JOIN aircraft_model
WHERE aircraft_model.model_name = 'BE747' AND aircraft_model.model_name = aircraft.model_name;

#쿼리 6: 항공권 번호 '8642097531092'의 탑승객이 탑승하는 항공편의 출발지, 도착지, 출발 시각, 도착 시간, 항공기 ID  검색
SELECT flight_from, flight_to, departure_time, landing_time, aircraft_ID
FROM flight
WHERE flight.flight_name = (
	SELECT nonmember_booked_ticket.organized_flight_name
	FROM nonmember_booked_ticket 
	WHERE  nonmember_booked_ticket.ticket_number = '8642097531092'
	UNION
	SELECT member_booked_ticket.organized_flight_name
	FROM member_booked_ticket 
	WHERE member_booked_ticket.ticket_number = '8642097531092' 
);

#쿼리 7: 여권번호가 'M1234567'인 비회원 승객의 여권번호로 탑승권 번호, 좌석번호 검색

SELECT check_in.boarding_ticket_number, boarding_ticket.seat_no 
FROM check_in JOIN boarding_ticket
WHERE check_in.passport_number = 'M1234567' 
	AND check_in.boarding_ticket_number = boarding_ticket.ticket_number;


#쿼리 8: 여권번호가 'M7854321'인 회원 승객의 여권번호와 항공권 번호로 탑승권 번호 검색

SELECT check_in.boarding_ticket_number, boarding_ticket.seat_no 
FROM check_in JOIN boarding_ticket
WHERE check_in.passport_number =  'M7854321' 
	AND check_in.boarding_ticket_number = boarding_ticket.ticket_number;

#쿼리 9:'KE3333' 항공편에 배정된 항공권 모두 검색

(SELECT *
FROM member_booked_ticket 
WHERE member_booked_ticket.organized_flight_name = 'KE3333' )
UNION
(SELECT *
FROM nonmember_booked_ticket
WHERE nonmember_booked_ticket.organized_flight_name = 'KE3333' );


#쿼리 10: 'KE1111' 항공편에 체크인한 모든 회원, 비회원 탑승객의 여권번호와 탑승권 번호 검색

SELECT check_in.passport_number,check_in.boarding_ticket_number
FROM check_in JOIN member_booked_ticket
WHERE member_booked_ticket.organized_flight_name = 'KE1111' 
	AND check_in.reserved_ticket_number = member_booked_ticket.ticket_number 
UNION
SELECT check_in.passport_number, check_in.boarding_ticket_number
FROM check_in JOIN nonmember_booked_ticket
WHERE nonmember_booked_ticket.organized_flight_name = 'KE1111' 
	AND check_in.reserved_ticket_number = nonmember_booked_ticket.ticket_number ;



#쿼리 11:  6월 4일에 출발하는 항공편 검색
SELECT * 
FROM flight
WHERE departure_time LIKE '2023-06-04%'