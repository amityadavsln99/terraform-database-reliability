INSERT INTO users (name, email)
VALUES
    ('Amit Sharma', 'amit.sharma@example.com'),
    ('Rahul Verma', 'rahul.verma@example.com'),
    ('Priya Singh', 'priya.singh@example.com'),
    ('Neha Gupta', 'neha.gupta@example.com'),
    ('Vikas Kumar', 'vikas.kumar@example.com');

INSERT INTO orders (
    user_id,
    order_number,
    status,
    total_amount,
    created_at
)
VALUES
    (1, 'ORD-1001', 'completed', 1499.00, '2026-09-01 10:15:00'),
    (1, 'ORD-1002', 'completed', 2499.00, '2026-09-05 11:30:00'),
    (2, 'ORD-1003', 'pending',    999.00, '2026-09-08 09:45:00'),
    (2, 'ORD-1004', 'completed', 3299.00, '2026-09-10 14:20:00'),
    (3, 'ORD-1005', 'cancelled',  799.00, '2026-09-12 16:10:00'),
    (3, 'ORD-1006', 'completed', 1899.00, '2026-09-15 12:05:00'),
    (4, 'ORD-1007', 'pending',   4599.00, '2026-09-18 15:40:00'),
    (5, 'ORD-1008', 'completed', 2199.00, '2026-09-20 17:25:00');