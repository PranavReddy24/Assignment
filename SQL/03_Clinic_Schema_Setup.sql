CREATE TABLE clinics (
    cid VARCHAR(20) PRIMARY KEY,
    clinic_name VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);
INSERT INTO clinics (cid, clinic_name, city, state, country)
VALUES 
('cnc-0100001', 'XYZ Clinic', 'Lorem', 'Ipsum', 'Dolor');
CREATE TABLE customer (
    uid VARCHAR(20) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    mobile VARCHAR(15)
);
INSERT INTO customer (uid, name, mobile)
VALUES 
('bk-09f3e-95hj', 'Jon Doe', '97XXXXXXXX');
CREATE TABLE clinic_sales (
    oid VARCHAR(30) PRIMARY KEY,
    uid VARCHAR(20) NOT NULL,
    cid VARCHAR(20) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    datetime DATETIME NOT NULL,
    sales_channel VARCHAR(50),

    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);
INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel)
VALUES 
(
    'ord-00100-00100',
    'bk-09f3e-95hj',
    'cnc-0100001',
    24999,
    '2021-09-23 12:03:22',
    'sodat'
);
CREATE TABLE expenses (
    eid VARCHAR(30) PRIMARY KEY,
    cid VARCHAR(20) NOT NULL,
    description VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL,
    datetime DATETIME NOT NULL,

    FOREIGN KEY (cid) REFERENCES clinics(cid)
);
INSERT INTO expenses (eid, cid, description, amount, datetime)
VALUES 
(
    'exp-0100-00100',
    'cnc-0100001',
    'first-aid supplies',
    557,
    '2021-09-23 07:36:48'
);
