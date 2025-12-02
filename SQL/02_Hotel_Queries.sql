-- 1. For every user in the system, get the user_id and last booked room_no
select user_id , room_no 
from bookings
group by user_id
order by booking_date desc;

-- 2. Get booking_id and total billing amount of every booking created in November, 2021 
SELECT 
    bookings.booking_id,
    SUM(booking_commercials.item_quantity * items.item_rate) AS total_billing_amount
FROM bookings
JOIN booking_commercials  ON bookings.booking_id = booking_commercials.booking_id
JOIN items ON booking_commercials.item_id = items.item_id
WHERE bookings.booking_date >= '2021-11-01'
  AND bookings.booking_date < '2021-12-01'
GROUP BY bookings.booking_id;

-- 3.Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000
SELECT 
    booking_commercials.bill_id,
    SUM(booking_commercials.item_quantity * items.item_rate) AS bill_amount
FROM booking_commercials 
JOIN items  ON booking_commercials.item_id = items.item_id
WHERE booking_commercials.bill_date >= '2021-10-01'
  AND booking_commercials.bill_date < '2021-11-01'
GROUP BY booking_commercials.bill_id
HAVING SUM(booking_commercials.item_quantity * items.item_rate) > 1000;

-- 4.Determine the most ordered and least ordered item of each month of year 2021 
SELECT 
    YEAR(bc.bill_date) AS yr,
    MONTH(bc.bill_date) AS month,
    bc.item_id,
    i.item_name,
    SUM(bc.item_quantity) AS total_quantity
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021
GROUP BY YEAR(bc.bill_date), MONTH(bc.bill_date), bc.item_id;

-- 5.Find the customers with the second highest bill value of each month of year 2021 
WITH bill_totals AS (
    SELECT 
        bc.bill_id,
        bc.bill_date,
        bc.booking_id,
        SUM(bc.item_quantity * i.item_rate) AS bill_amount
    FROM booking_commercials bc
    JOIN items i 
        ON bc.item_id = i.item_id
    GROUP BY bc.bill_id, bc.bill_date, bc.booking_id
),

ranked_bills AS (
    SELECT 
        bt.bill_id,
        bt.bill_amount,
        bt.bill_date,
        b.user_id,
        MONTH(bt.bill_date) AS month,
        YEAR(bt.bill_date) AS year,
        DENSE_RANK() OVER (
            PARTITION BY YEAR(bt.bill_date), MONTH(bt.bill_date)
            ORDER BY bt.bill_amount DESC
        ) AS bill_rank
    FROM bill_totals bt
    JOIN bookings b 
        ON bt.booking_id = b.booking_id
    WHERE YEAR(bt.bill_date) = 2021
)

SELECT 
    month,
    user_id,
    bill_id,
    bill_amount
FROM ranked_bills
WHERE bill_rank = 2
ORDER BY month;
