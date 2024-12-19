-----------------------------
-- Hotel Bookings Analysis --
-----------------------------
CREATE TABLE hotel_bookings (
    hotel VARCHAR(255),
    is_canceled INT,
    lead_time INT,
    arrival_date_year INT,
    arrival_date_month VARCHAR(20),
    arrival_date_week_number INT,
    arrival_date_day_of_month INT,
    stays_in_weekend_nights INT,
    stays_in_week_nights INT,
    adults INT,
    children INT,
    babies INT,
    meal VARCHAR(20),
    country VARCHAR(3),
    market_segment VARCHAR(50),
    distribution_channel VARCHAR(50),
    is_repeated_guest INT,
    previous_cancellations INT,
    previous_bookings_not_canceled INT,
    reserved_room_type VARCHAR(10),
    assigned_room_type VARCHAR(10),
    booking_changes INT,
    deposit_type VARCHAR(20),
    agent INT,
    company INT,
    days_in_waiting_list INT,
    customer_type VARCHAR(50),
    adr FLOAT,
    required_car_parking_spaces INT,
    total_of_special_requests INT,
    reservation_status VARCHAR(20),
    reservation_status_date DATE
);

-------------------
-- Load the Data --
-------------------

-- 1. Total Number of Bookings by Hotel Type
-- Total bookings for each hotel type
SELECT hotel, COUNT(*) AS total_bookings
FROM hotel_bookings
GROUP BY hotel;

-- 2. Total Cancellations by Hotel Type
-- Total cancellations for each hotel type
SELECT hotel, SUM(is_canceled) AS total_cancellations
FROM hotel_bookings
GROUP BY hotel;

-- 3. Average Lead Time by Hotel Type
-- Lead time is the difference between the booking and the day of arrival
-- Average lead time for each hotel type
SELECT hotel, AVG(lead_time) AS avg_lead_time
FROM hotel_bookings
GROUP BY hotel;

-- 4. Average Stay Duration by Hotel Type
-- Average number of nights stayed (weekend + week) for each hotel type
SELECT hotel, AVG(stays_in_weekend_nights + stays_in_week_nights) AS avg_stay_duration
FROM hotel_bookings
GROUP BY hotel;

-- 5. Booking Status by Hotel Type
-- Count of reservations filtered by status (Canceled, Check-Out, No-Show) for each hotel type
SELECT hotel, reservation_status, COUNT(*) AS status_count
FROM hotel_bookings
GROUP BY hotel, reservation_status;

-- 6. Average Number of Adults and Children per Booking
-- Average number of adults and children for each booking
SELECT AVG(adults) AS avg_adults, AVG(children) AS avg_children
FROM hotel_bookings;

-- 7. Total Bookings by Country
-- Total number of bookings by country
SELECT country, COUNT(*) AS total_bookings
FROM hotel_bookings
GROUP BY country
ORDER BY total_bookings DESC;

-- 8. Cancellations by Month and Year
-- Total of cancellations over different months and years
SELECT arrival_date_year, arrival_date_month, SUM(is_canceled) AS total_cancellations
FROM hotel_bookings
GROUP BY arrival_date_year, arrival_date_month
ORDER BY arrival_date_year, arrival_date_month; -- We can see that in summer months is when there ar more cancellations

-- 9. Repeat Guests vs. New Guests
-- Number of repeated guests vs. new guests
SELECT hotel, 
       SUM(is_repeated_guest) AS repeat_guests, 
       COUNT(*) - SUM(is_repeated_guest) AS new_guests
FROM hotel_bookings
GROUP BY hotel;

-- 10
-- This query calculates the total number of cancelled and non-cancelled bookings for each hotel.
SELECT hotel,
       SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS total_canceled,
       SUM(CASE WHEN is_canceled = 0 THEN 1 ELSE 0 END) AS total_not_canceled
FROM hotel_bookings
GROUP BY hotel;

-- 11
-- This query calculates the average number of nights stayed based on the customer type and hotel.
SELECT hotel,
       customer_type,
       AVG(stays_in_weekend_nights + stays_in_week_nights) AS avg_nights_stayed
FROM hotel_bookings
GROUP BY hotel, customer_type
ORDER BY avg_nights_stayed DESC;

-- 12
-- This query shows the number of repeated guests (is_repeated_guest = 1) per country.
SELECT country,
       COUNT(*) AS repeated_guests
FROM hotel_bookings
WHERE is_repeated_guest = 1
GROUP BY country
ORDER BY repeated_guests DESC;

-- 13
-- Creating View to analyze cancellations by hotel type and lead time
-- for later visualizations
CREATE VIEW CancellationsByHotelType AS
SELECT 
    hotel, 
    AVG(lead_time) AS avg_lead_time, 
    COUNT(*) AS total_bookings, 
    SUM(is_canceled) AS total_cancellations, 
    (SUM(is_canceled) / COUNT(*)) * 100 AS cancellation_rate
FROM hotel_bookings
GROUP BY hotel
ORDER BY cancellation_rate DESC;

SELECT * FROM CancellationsByHotelType;














