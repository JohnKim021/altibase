ALTER SESSION SET AUTOCOMMIT = TRUE;

DROP TABLE ORDERS;
DROP TABLE EMPLOYEES;
DROP TABLE DEPARTMENTS;
DROP TABLE CUSTOMERS;
DROP TABLE GOODS;

CREATE TABLE DEPARTMENTS (
DNO            SMALLINT     PRIMARY KEY, 
DNAME          CHAR(30)     NOT NULL, 
DEP_LOCATION   CHAR(15), 
MGR_NO         INTEGER );

CREATE TABLE EMPLOYEES (
ENO            INTEGER      PRIMARY KEY, 
E_LASTNAME     CHAR(20)     NOT NULL, 
E_FIRSTNAME    CHAR(20)     NOT NULL, 
EMP_JOB        VARCHAR(15), 
EMP_TEL        CHAR(15), 
DNO            SMALLINT, 
SALARY         NUMBER(10,2) DEFAULT 0, 
SEX            CHAR(1), 
BIRTH          CHAR(6),
JOIN_DATE      DATE,   
STATUS         CHAR(1)      DEFAULT 'H' );

CREATE TABLE CUSTOMERS (
CNO            BIGINT       PRIMARY KEY, 
C_LASTNAME     CHAR(20)     NOT NULL, 
C_FIRSTNAME    CHAR(20)     NOT NULL, 
CUS_JOB        VARCHAR(20), 
CUS_TEL        CHAR(15)     NOT NULL, 
SEX            CHAR(1), 
BIRTH          CHAR(6), 
POSTAL_CD      VARCHAR(9),
ADDRESS        VARCHAR(60) );

CREATE TABLE GOODS ( 
GNO            CHAR(10)     PRIMARY KEY, 
GNAME          CHAR(20)     UNIQUE NOT NULL, 
GOODS_LOCATION CHAR(9),
STOCK          INTEGER      DEFAULT 0, 
PRICE          NUMERIC(10,2) );

CREATE TABLE ORDERS (
ONO            BIGINT, 
ORDER_DATE     DATE,   
ENO            INTEGER      NOT NULL,
CNO            BIGINT       NOT NULL,
GNO            CHAR(10)     NOT NULL,
QTY            INTEGER      DEFAULT 1, 
ARRIVAL_DATE   DATE,   
PROCESSING     CHAR(1)      DEFAULT 'O', 
PRIMARY KEY(ONO, ORDER_DATE) );

CREATE INDEX EMP_IDX1 ON EMPLOYEES   (DNO ASC);
CREATE INDEX DEP_IDX1 ON DEPARTMENTS (MGR_NO ASC) INDEXTYPE IS BTREE;
CREATE INDEX ODR_IDX1 ON ORDERS      (ENO ASC)    INDEXTYPE IS BTREE;
CREATE INDEX ODR_IDX2 ON ORDERS      (CNO DESC)   INDEXTYPE IS BTREE;
CREATE INDEX ODR_IDX3 ON ORDERS      (GNO ASC);

INSERT INTO GOODS VALUES('A111100001', 'IM-300'  , 'AC0001', 1000 , 78000);  
INSERT INTO GOODS VALUES('A111100002', 'IM-310'  , 'DD0001', 100  , 98000);  
INSERT INTO GOODS VALUES('B111100001', 'NT-H5000', 'AC0002', 780  , 35800);  
INSERT INTO GOODS VALUES('C111100001', 'IT-U950' , 'FA0001', 35000, 7820.55);
INSERT INTO GOODS VALUES('C111100002', 'IT-U200' , 'AC0003', 1000 , 9455.21);
INSERT INTO GOODS VALUES('D111100001', 'TM-H5000', 'AC0004', 7800 , 12000);  
INSERT INTO GOODS VALUES('D111100002', 'TM-T88'  , 'BF0001', 10000, 72000);
INSERT INTO GOODS VALUES('D111100003', 'TM-L60'  , 'BF0002', 650  , 45100);  
INSERT INTO GOODS VALUES('D111100004', 'TM-U950' , 'DD0002', 8000 , 96200);  
INSERT INTO GOODS VALUES('D111100005', 'TM-U925' , 'AC0005', 9800 , 23000);  
INSERT INTO GOODS VALUES('D111100006', 'TM-U375' , 'EB0001', 1200 , 57400);  
INSERT INTO GOODS VALUES('D111100007', 'TM-U325' , 'EB0002', 20000, 84500);
INSERT INTO GOODS VALUES('D111100008', 'TM-U200' , 'AC0006', 61000, 10000);
INSERT INTO GOODS VALUES('D111100009', 'TM-U300' , 'DD0003', 9000 , 50000);  
INSERT INTO GOODS VALUES('D111100010', 'TM-U590' , 'DD0004', 7900 , 36800);  
INSERT INTO GOODS VALUES('D111100011', 'TM-U295' , 'FA0002', 1000 , 45600);  
INSERT INTO GOODS VALUES('E111100001', 'M-T245'  , 'AC0007', 900  , 2290.54);
INSERT INTO GOODS VALUES('E111100002', 'M-150'   , 'FD0001', 4300 , 7527.35);
INSERT INTO GOODS VALUES('E111100003', 'M-180'   , 'BF0003', 1000 , 2300.55);
INSERT INTO GOODS VALUES('E111100004', 'M-190G'  , 'CE0001', 88000, 5638.76);
INSERT INTO GOODS VALUES('E111100005', 'M-U310'  , 'CE0002', 11200, 1450.5); 
INSERT INTO GOODS VALUES('E111100006', 'M-T153'  , 'FD0002', 900  , 2338.62);
INSERT INTO GOODS VALUES('E111100007', 'M-T102'  , 'BF0004', 7890 , 966.99); 
INSERT INTO GOODS VALUES('E111100008', 'M-T500'  , 'EB0003', 5000 , 1000.54);
INSERT INTO GOODS VALUES('E111100009', 'M-T300'  , 'FA0003', 7000 , 3099.88);
INSERT INTO GOODS VALUES('E111100010', 'M-T260'  , 'AC0008', 4000 , 9200.5); 
INSERT INTO GOODS VALUES('E111100011', 'M-780'   , 'AC0009', 9800 , 9832.98);
INSERT INTO GOODS VALUES('E111100012', 'M-U420'  , 'CE0003', 43200, 3566.78);
INSERT INTO GOODS VALUES('E111100013', 'M-U290'  , 'FD0003', 12000, 1295.44);
INSERT INTO GOODS VALUES('F111100001', 'AU-100'  , 'AC0010', 10000, 100000); 

INSERT INTO DEPARTMENTS VALUES(1001, 'RESEARCH DEVELOPMENT DEPT 1', 'New York'      , 16);
INSERT INTO DEPARTMENTS VALUES(1002, 'RESEARCH DEVELOPMENT DEPT 2', 'Sydney'        , 13);
INSERT INTO DEPARTMENTS VALUES(1003, 'SOLUTION DEVELOPMENT DEPT'  , 'Osaka'         , 14);
INSERT INTO DEPARTMENTS VALUES(2001, 'QUALITY ASSURANCE DEPT'     , 'Seoul'         , 17);
INSERT INTO DEPARTMENTS VALUES(3001, 'CUSTOMERS SUPPORT DEPT'     , 'London'        , 4);
INSERT INTO DEPARTMENTS VALUES(3002, 'PRESALES DEPT'              , 'Peking'        , 5);
INSERT INTO DEPARTMENTS VALUES(4001, 'MARKETING DEPT'             , 'Brasilia'      , 8);
INSERT INTO DEPARTMENTS VALUES(4002, 'BUSINESS DEPT'              , 'Palo Alto'     , 7);

INSERT INTO EMPLOYEES VALUES(1 ,  'Moon'         ,  'Chan-seung'   , 'CEO'       , '01195662365', 3002, NULL, 'M', ''      , ''         , 'R');  
INSERT INTO EMPLOYEES VALUES(2 ,  'Davenport'    ,  'Susan'        , 'designer'  , '0113654540' , NULL, 1500, 'F', '721219', '18-NOV-09', 'H');
INSERT INTO EMPLOYEES VALUES(3 ,  'Kobain'       ,  'Ken'          , 'engineer'  , '0162581369' , 1001, 2000, 'M', '650226', '11-JAN-10', 'H');
INSERT INTO EMPLOYEES VALUES(4 ,  'Foster'       ,  'Aaron'        , 'PL'        , '0182563984' , 3001, 1800, 'M', '820730', ''         , 'H');
INSERT INTO EMPLOYEES VALUES(5 ,  'Ghorbani'     ,  'Farhad'       , 'PL'        , '01145582310', 3002, 2500, 'M', ''      , '20-DEC-09', 'H');
INSERT INTO EMPLOYEES VALUES(6 ,  'Momoi'        ,  'Ryu'          , 'programmer', '0197853222' , 1002, 1700, 'M', '790822', '09-SEP-10', 'H');
INSERT INTO EMPLOYEES VALUES(7 ,  'Fleischer'    ,  'Gottlieb'     , 'manager'   , '0175221002' , 4002, 500 , 'M', '840417', '24-JAN-04', 'H');
INSERT INTO EMPLOYEES VALUES(8 ,  'Wang'         ,  'Xiong'        , 'manager'   , '0178829663' , 4001, NULL, 'M', '810726', '29-NOV-09', 'H');
INSERT INTO EMPLOYEES VALUES(9 ,  'Diaz'         ,  'Curtis'       , 'planner'   , '0165293668' , 4001, 1200, 'M', '660102', '14-JUN-10', 'H');
INSERT INTO EMPLOYEES VALUES(10,  'Bae'          ,  'Elizabeth'    , 'programmer', '0167452000' , 1003, 4000, 'F', '710213', '05-JAN-10', 'H');
INSERT INTO EMPLOYEES VALUES(11,  'Liu'          ,  'Zhen'         , 'webmaster' , '0114553206' , 1003, 2750, 'M', ''      , '28-APR-11', 'H');
INSERT INTO EMPLOYEES VALUES(12,  'Hammond'      ,  'Sandra'       , 'sales rep' , '0174562330' , 4002, 1890, 'F', '810211', '14-DEC-09', 'H');
INSERT INTO EMPLOYEES VALUES(13,  'Jones'        ,  'Mitch'        , 'PM'        , '0187636550' , 1002, 980 , 'M', '801102', ''         , 'H');
INSERT INTO EMPLOYEES VALUES(14,  'Miura'        ,  'Yuu'          , 'PM'        , '0197664120' , 1003, 2003, 'M', ''      , ''         , 'H');
INSERT INTO EMPLOYEES VALUES(15,  'Davenport'    ,  'Jason'        , 'webmaster' , '0119556884' , 1003, 1000, 'M', '901212', ''         , 'H');
INSERT INTO EMPLOYEES VALUES(16,  'Chen'         ,  'Wei-Wei'      , 'manager'   , '0195562100' , 1001, 2300, 'F', '780509', ''         , 'H');
INSERT INTO EMPLOYEES VALUES(17,  'Fubuki'       ,  'Takahiro'     , 'PM'        , '0165293886' , 2001, 1400, 'M', '781026', '07-MAY-10', 'H');
INSERT INTO EMPLOYEES VALUES(18,  'Huxley'       ,  'John'         , 'planner'   , '01755231044', 4001, 1900, 'M', ''      , '30-OCT-07', 'H');
INSERT INTO EMPLOYEES VALUES(19,  'Marquez'      ,  'Alvar'        , 'sales rep' , '0185698550' , 4002, 1800, 'M', ''      , '18-NOV-10', 'H');
INSERT INTO EMPLOYEES VALUES(20,  'Blake'        ,  'William'      , 'sales rep' , '01154112366', 4002, NULL, 'M', ''      , '18-NOV-06', 'H');

INSERT INTO CUSTOMERS VALUES (BIGINT'1',  'Sanchez'       ,  'Estevan'      , 'engineer' , '0514685282', 'M', '720828', '90021'     , '2100 Exposition Boulevard Los Angeles USA');
INSERT INTO CUSTOMERS VALUES (BIGINT'2',  'Martin'        ,  'Pierre'       , 'doctor'   , '023242121' , 'M', '821215', 'V6T 1F2'   , '4712 West 10th Avenue Vancouver BC Canada');
INSERT INTO CUSTOMERS VALUES (BIGINT'3',  'Morris'        ,  'Gabriel'      , 'designer' , '023442542' , 'M', '811111', '75010'     , 'D914 Puteaux Ile-de-France France');
INSERT INTO CUSTOMERS VALUES (BIGINT'4',  'Park'          ,  'Soo-jung'     , 'engineer' , '022326393' , 'F', '840305', '609-735'   , 'Geumjeong-Gu Busan South Korea');
INSERT INTO CUSTOMERS VALUES (BIGINT'5',  'Stone'         ,  'James'        , 'webmaster', '0233452141', 'M', '821012', '6060'      , '142 Francis Street Western Australia AUS');
INSERT INTO CUSTOMERS VALUES (BIGINT'6',  'Dureault'      ,  'Phil'         , 'WEBPD'    , '025743215' , 'M', '810209', 'H1R-2W1'   , '1000 Rue Rachel Est Montreal Canada');
INSERT INTO CUSTOMERS VALUES (BIGINT'7',  'Lalani'        ,  'Yasmin'       , 'planner'  , '023143366' , 'F', '821225', '156772'    , '176 Robinson Road Singapore');
INSERT INTO CUSTOMERS VALUES (BIGINT'8',  'Kanazawa'      ,  'Tsubasa'      , 'PD'       , '024721114' , 'M', '730801', '141-0031'  , '2-4-6 Nishi-Gotanda Shinagawa-ku Tokyo JP');
INSERT INTO CUSTOMERS VALUES (BIGINT'9',  'Yuan'          ,  'Ai'           , 'designer' , '0512543734', 'F', '690211', '200020'    , '10th Floor No. 334 Jiujiang Road Shanghai');
INSERT INTO CUSTOMERS VALUES (BIGINT'10', 'Nguyen'        ,  'Anh Dung'     , ''         , '0516232256', 'M', '790815', '70000'     , '8A Ton Duc Thang Street District 1 HCMC Vietnam');
INSERT INTO CUSTOMERS VALUES (BIGINT'11', 'Sato'          ,  'Naoki'        , 'manager'  , '027664545' , 'M', '810101', '455-8205'  , '3-23 Oye-cho Minato-ku Nagoya Aichi Japan');
INSERT INTO CUSTOMERS VALUES (BIGINT'12', 'Rodriguez'     ,  'Aida'         , 'banker'   , '023343214' , 'F', '810905', '76152'     , '3484 Taylor Street Dallas TX USA');
INSERT INTO CUSTOMERS VALUES (BIGINT'13', 'White'         ,  'Crystal'      , 'engineer' , '022320119' , 'F', '801230', 'WC2B 4BM'  , '12th Floor Five Kemble Street London UK');
INSERT INTO CUSTOMERS VALUES (BIGINT'14', 'Kim'           ,  'Cheol-soo'    , 'banker'   , '024720112' , 'M', '660508', '135-740'   , '222-55 Samsung-dong Gangnam-gu Seoul Korea');
INSERT INTO CUSTOMERS VALUES (BIGINT'15', 'Fedorov'       ,  'Fyodor'       , 'manager'  , '0518064398', 'M', '750625', '50696'     , 'No 6 Leboh Ampang 50100 Kuala Lumpur Malaysia');
INSERT INTO CUSTOMERS VALUES (BIGINT'16', 'Lefebvre'      ,  'Daniel'       , 'planner'  , '027544147' , 'M', '761225', '21004'     , 'Chaussee de Wavre 114a 1050 Brussels Belgium');
INSERT INTO CUSTOMERS VALUES (BIGINT'17', 'Yoshida'       ,  'Daichi'       , ''         , '023543541' , 'M', '811001', '530-0100'  , '2-7 3-Chome-Kita Tenjinbashi Kita-ku Osaka');
INSERT INTO CUSTOMERS VALUES (BIGINT'18', 'Zhang'         ,  'Bao'          , 'engineer' , '024560207' , 'F', '840419', '100008'    , '2 Chaoyang Men Wai Street Chaoyang Beijing');
INSERT INTO CUSTOMERS VALUES (BIGINT'19', 'Pahlavi'       ,  'Saeed'        , ''         , '022371234' , 'M', '741231', '20037'     , '3300 L Street NW Washington DC USA');
INSERT INTO CUSTOMERS VALUES (BIGINT'20', 'Dubois'        ,  'Alisee'       , 'webmaster', '024560002' , 'F', '860405', '1357'      , 'Chemin de Messidor 7-6 CH-1006 Lausanne Suisse');
 
INSERT INTO ORDERS VALUES (0011290007, '29-NOV-11', 12, BIGINT'3',  'A111100002', 70   , '02-DEC-11', 'C');
INSERT INTO ORDERS VALUES (0011290011, '29-NOV-11', 12, BIGINT'17', 'E111100001', 1000 , '05-DEC-11', 'D');
INSERT INTO ORDERS VALUES (0011290100, '29-NOV-11', 19, BIGINT'11', 'E111100001', 500  , '07-DEC-11', 'D');
INSERT INTO ORDERS VALUES (0012100277, '10-DEC-11', 19, BIGINT'5',  'D111100008', 2500 , '12-DEC-11', 'C');
INSERT INTO ORDERS VALUES (0012300001, '01-DEC-11', 19, BIGINT'1',  'D111100004', 1000 , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300002, '29-DEC-11', 12, BIGINT'2',  'C111100001', 300  , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300003, '29-DEC-11', 20, BIGINT'14', 'E111100002', 900  , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300004, '30-DEC-11', 20, BIGINT'15', 'D111100002', 1000 , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300005, '30-DEC-11', 19, BIGINT'4',  'D111100008', 4000 , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300006, '30-DEC-11', 20, BIGINT'13', 'A111100002', 20   , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300007, '30-DEC-11', 12, BIGINT'7',  'D111100002', 2500 , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300008, '30-DEC-11', 20, BIGINT'11', 'D111100011', 300  , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300009, '30-DEC-11', 20, BIGINT'19', 'D111100003', 500  , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300010, '30-DEC-11', 19, BIGINT'16', 'D111100010', 2000 , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300011, '30-DEC-11', 20, BIGINT'15', 'C111100001', 1000 , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300012, '30-DEC-11', 12, BIGINT'3',  'E111100012', 1300 , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300013, '30-DEC-11', 20, BIGINT'6',  'C111100001', 5000 , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012300014, '30-DEC-11', 12, BIGINT'12', 'F111100001', 800  , '02-JAN-12', 'P');
INSERT INTO ORDERS VALUES (0012310001, '31-DEC-11', 20, BIGINT'15', 'A111100002', 50   , '09-DEC-11', 'O');
INSERT INTO ORDERS VALUES (0012310002, '31-DEC-11', 12, BIGINT'10', 'D111100008', 10000, '03-JAN-12', 'O');
INSERT INTO ORDERS VALUES (0012310003, '31-DEC-11', 20, BIGINT'18', 'E111100009', 1500 , '03-JAN-12', 'O');
INSERT INTO ORDERS VALUES (0012310004, '31-DEC-11', 19, BIGINT'5',  'E111100010', 5000 , '08-JAN-12', 'O');
INSERT INTO ORDERS VALUES (0012310005, '31-DEC-11', 20, BIGINT'14', 'E111100007', 940  , '03-JAN-12', 'O');
INSERT INTO ORDERS VALUES (0012310006, '31-DEC-11', 20, BIGINT'2',  'D111100004', 500  , '03-JAN-12', 'O');
INSERT INTO ORDERS VALUES (0012310007, '31-DEC-11', 12, BIGINT'19', 'E111100012', 1400 , '03-JAN-12', 'O');
INSERT INTO ORDERS VALUES (0012310008, '31-DEC-11', 19, BIGINT'1',  'D111100003', 100  , '03-JAN-12', 'O');
INSERT INTO ORDERS VALUES (0012310009, '31-DEC-11', 12, BIGINT'5',  'E111100013', 500  , '03-JAN-12', 'O');
INSERT INTO ORDERS VALUES (0012310010, '31-DEC-11', 20, BIGINT'6',  'D111100010', 1500 , '03-JAN-12', 'O');
INSERT INTO ORDERS VALUES (0012310011, '31-DEC-11', 19, BIGINT'15', 'E111100012', 10000, '03-JAN-12', 'O');
INSERT INTO ORDERS VALUES (0012310012, '31-DEC-11', 19, BIGINT'1',  'C111100001', 250  , '03-JAN-12', 'O');

DROP USER ALTITEST CASCADE;
CREATE USER ALTITEST IDENTIFIED BY ALTITEST;

CONNECT ALTITEST/ALTITEST;

CREATE TABLE ORDERS (
ONO            BIGINT,
ORDER_DATE     DATE,
ENO            INTEGER      NOT NULL,
CNO            BIGINT       NOT NULL,
GNO            CHAR(10)     NOT NULL,
QTY            INTEGER      DEFAULT 1,
ARRIVAL_DATE   DATE,
PROCESSING     CHAR(1)      DEFAULT 'O',
PRIMARY KEY(ONO, ORDER_DATE) );

CREATE INDEX ODR_IDX1 ON ORDERS (ENO ASC)  INDEXTYPE IS BTREE;
CREATE INDEX ODR_IDX2 ON ORDERS (CNO DESC) INDEXTYPE IS BTREE;
CREATE INDEX ODR_IDX3 ON ORDERS (GNO ASC);
