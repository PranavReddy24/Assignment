select * from booking_commercials;
INSERT INTO booking_commercials 
(id, booking_id, bill_id, bill_date, item_id, item_quantity)
VALUES (
    '134lr-oyfo8-3qk4',
    'bk-q034-q4o',
    'bl-34qhd-r7h8',
    '2021-09-23 12:05:37',
    'itm-w978-23u4',
    0.5
);

INSERT INTO bookings (booking_id, booking_date, room_no, user_id)
VALUES (
    'bk-q034-q4o',
    '2021-09-23 07:36:48',
    'rm-bhf9-aerjn',
    '21wrcxuy-67erfn'
);
CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10,2)
);
INSERT INTO items (item_id, item_name, item_rate)
VALUES (
    'itm-a9e8-q8fu',
    'Tawa Paratha',
    18
);
INSERT INTO items (item_id, item_name, item_rate)
VALUES (
    'itm-a07vh-aer8',
    'Mix Veg',
    89
);

