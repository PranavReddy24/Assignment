-- 1. Find the revenue we got from each sales channel in a given year 
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021   -- change the year as needed
GROUP BY sales_channel;

-- 2. Find top 10 the most valuable customers for a given year 
SELECT 
    c.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021   -- change the year as needed
GROUP BY c.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;

-- 3. Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given year
SELECT
    MONTH(cs.datetime) AS month,
    COALESCE(SUM(cs.amount), 0) AS revenue,
    COALESCE(SUM(e.amount), 0) AS expense,
    COALESCE(SUM(cs.amount), 0) - COALESCE(SUM(e.amount), 0) AS profit,
    CASE 
        WHEN COALESCE(SUM(cs.amount), 0) - COALESCE(SUM(e.amount), 0) > 0 THEN 'Profitable'
        ELSE 'Not-Profitable'
    END AS status
FROM 
    (SELECT * FROM clinic_sales WHERE YEAR(datetime) = 2021) cs
LEFT JOIN 
    (SELECT * FROM expenses WHERE YEAR(datetime) = 2021) e
    ON MONTH(cs.datetime) = MONTH(e.datetime) AND cs.cid = e.cid
GROUP BY MONTH(cs.datetime)
ORDER BY MONTH(cs.datetime);

-- 4. For each city find the most profitable clinic for a given month 
WITH monthly_profit AS (
    SELECT
        c.cid,
        c.clinic_name,
        c.city,
        COALESCE(SUM(cs.amount), 0) AS revenue,
        COALESCE(SUM(e.amount), 0) AS expense,
        COALESCE(SUM(cs.amount), 0) - COALESCE(SUM(e.amount), 0) AS profit
    FROM clinics c
    LEFT JOIN clinic_sales cs 
        ON c.cid = cs.cid 
        AND YEAR(cs.datetime) = 2021 
        AND MONTH(cs.datetime) = 9       -- change year/month as needed
    LEFT JOIN expenses e 
        ON c.cid = e.cid 
        AND YEAR(e.datetime) = 2021 
        AND MONTH(e.datetime) = 9
    GROUP BY c.cid, c.clinic_name, c.city
)
SELECT mp.city, mp.clinic_name, mp.profit
FROM monthly_profit mp
JOIN (
    SELECT city, MAX(profit) AS max_profit
    FROM monthly_profit
    GROUP BY city
) AS city_max
ON mp.city = city_max.city AND mp.profit = city_max.max_profit
ORDER BY mp.city;

-- 5. For each state find the second least profitable clinic for a given month 
WITH monthly_profit AS (
    SELECT
        c.cid,
        c.clinic_name,
        c.state,
        COALESCE(SUM(cs.amount), 0) AS revenue,
        COALESCE(SUM(e.amount), 0) AS expense,
        COALESCE(SUM(cs.amount), 0) - COALESCE(SUM(e.amount), 0) AS profit
    FROM clinics c
    LEFT JOIN clinic_sales cs 
        ON c.cid = cs.cid 
        AND YEAR(cs.datetime) = 2021
        AND MONTH(cs.datetime) = 9          -- change year/month as needed
    LEFT JOIN expenses e 
        ON c.cid = e.cid 
        AND YEAR(e.datetime) = 2021
        AND MONTH(e.datetime) = 9
    GROUP BY c.cid, c.clinic_name, c.state
),
ranked_profit AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY state ORDER BY profit ASC) AS rn
    FROM monthly_profit
)
SELECT
    state,
    clinic_name,
    profit
FROM ranked_profit
WHERE rn = 2
ORDER BY state;

