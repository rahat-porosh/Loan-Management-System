drop table payments;
DROP TABLE lender;
DROP TABLE loan;
DROP TABLE customer;
CREATE TABLE customer(
    cid NUMBER(5),
    cname VARCHAR2(30),
    caddress VARCHAR2(40),
    mobile NUMBER(10),
    email VARCHAR2(30),
    PRIMARY KEY (cid)
);

CREATE TABLE loan(
    lo_id NUMBER(5),
    cus_id NUMBER(5),
    amount NUMBER(7),
    interest_rate NUMBER(2),
    given_date DATE DEFAULT sysdate,
    deadline date,
    PRIMARY KEY (lo_id),
    FOREIGN KEY (cus_id) REFERENCES customer (cid) ON DELETE CASCADE
);

CREATE TABLE lender(
    le_id NUMBER(5),
    lname VARCHAR2(30),
    email VARCHAR2(30) ,
    mobile  NUMBER(10) ,
    PRIMARY KEY (le_id)
);

 CREATE TABLE payments(
     pay_id NUMBER(5),
     loan_id NUMBER(5),
     amount NUMBER(7),
     due NUMBER(7),
     pay_date date DEFAULT sysdate,
     cur_date date DEFAULT sysdate,
     PRIMARY KEY (pay_id),
     FOREIGN KEY (loan_id) REFERENCES loan (lo_id) ON DELETE CASCADE
 );

 CREATE TABLE lender_loan(
     lender_id  NUMBER(5),
     loan_id NUMBER(5),
     FOREIGN KEY (lender_id) REFERENCES lender(le_id) ON DELETE CASCADE,
     FOREIGN KEY (loan_id) REFERENCES loan (lo_id) ON DELETE CASCADE
  );

--  customer
INSERT INTO customer VALUES (40001, 'Misbah Uddin', 'Baridhara, Dhaka', 1787207461, 'sagor@gmail.com');
INSERT INTO customer VALUES (40002, 'Abdullah Al Jayed', 'Dokkhigao, Sabujbag, Dhaka', 1521402247, 'jayed@yahoo.com');
INSERT INTO customer VALUES (40003, 'Dipto Shourav', 'Hemayetpur, Pabna', 1521422161, 'sourav@gmail.com');
INSERT INTO customer VALUES (40004, 'Ashikur Rahman', 'Badda, Dhaka', 1878695261, 'ashik@gmail.com');
INSERT INTO customer VALUES (40005, 'Faisal Ahmed', 'Stadium Road, Gopalganj', 1623155000, 'bijoy@gmail.com');

-- loan
INSERT INTO loan VALUES (50001,40003,50000,10,'15-APR-15', '15-JUN-19');
INSERT INTO loan VALUES (50002,40005,120000,8,'17-AUG-18','24-FEB-21');
INSERT INTO loan VALUES (50003,40001,100000,7,'11-FEB-17','13-JUL-20');
INSERT INTO loan VALUES (50004,40002,500000,13,'22-NOV-18','31-DEC-23');
INSERT INTO loan VALUES (50005,40004,170000,9,'15-JAN-17','14_FEB-20');

-- lender
INSERT INTO lender VALUES (60001, 'Navid Bin Hassan','navid@gmail.com',1675464466);
INSERT INTO lender VALUES (60002, 'Nafis Ibtida','sami@gmail.com',1521402347);

-- payment
INSERT INTO payments (pay_id,loan_id,amount,pay_date) VALUES (70001,50001,20000,'16-JUN-17');
INSERT INTO payments (pay_id,loan_id,amount,pay_date) VALUES (70002,50003,50000,'16-MAY-18');
INSERT INTO payments (pay_id,loan_id,amount,pay_date) VALUES (70003,50005,40000,'15-NOV-17');
INSERT INTO payments (pay_id,loan_id,amount,pay_date) VALUES (70004,50005,60000,'12-MAR-18');

INSERT INTO lender_loan VALUES (60001,50001);
INSERT INTO lender_loan VALUES (60001,50004);
INSERT INTO lender_loan VALUES (60001,50005);
INSERT INTO lender_loan VALUES (60002,50002);
INSERT INTO lender_loan VALUES (60002,50003);

SELECT * FROM customer;
SELECT * FROM loan;
SELECT * FROM lender;
SELECT * FROM payments;
SELECT * FROM lender_loan;
UPDATE customer set mobile=1787207471 where cid=40001;
DELETE from customer where cid=40002;
-- viewing data from multiple table

SELECT lender_loan.lender_id, lender_loan.loan_id, lender.lname, loan.amount FROM lender_loan,lender,loan 
WHERE lender_loan.lender_id=lender.le_id AND lender_loan.loan_id=loan.lo_id;

SELECT loan.lo_id,loan.cus_id,customer.cname,loan.amount FROM loan JOIN customer ON loan.cus_id=customer.cid;

-- aggregate function

SELECT max(amount) from loan;
SELECT sum(amount) FROM loan;
SELECT count(cid) FROM customer;


-- pl/sql
SET SERVEROUTPUT ON
DECLARE
    CURSOR c_given_date is SELECT given_date FROM loan; 
    ir loan.interest_rate%type;
    type date_diff is varray(6) of number(7);
    d date_diff:=date_diff();
    to_be_paid payments.due%type;
    loan_amount loan.amount%type;
    i INTEGER:=0;
BEGIN
    for n in c_given_date loop
        i:=i+1;
        d.extend;
        d(i):=sysdate-n.given_date;
        DBMS_OUTPUT.PUT_LINE(d(i));
    END loop;
END;
/
CREATE OR REPLACE TRIGGER check_amount BEFORE INSERT OR UPDATE ON employees
FOR EACH ROW
DECLARE
   a_min constant number(7) := 40000
   a_max constant number(7) := 1000000;
BEGIN
  IF :new.amount > a_max OR :new.amount < a_min THEN
  RAISE_APPLICATION_ERROR(-20000,'New amount is too small or large');
END IF;
END;
/
INSERT INTO loan VALUES (50006,40004,170000,9,'15-JAN-18','14_FEB-21');
