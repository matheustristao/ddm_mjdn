Create table savings_accounts
(account numeric (6) primary key,
balance numeric (7,2));

insert into savings_accounts
values (3209, 2000);

Create table checking_accounts
(account numeric (6) primary key,
balance numeric (7,2));

insert into checking_accounts
values (3208, 2000);

select * from savings_accounts;

BEGIN TRANSACTION;
UPDATE savings_accounts
SET balance = balance - 500
WHERE account = 3209;

UPDATE checking_accounts
SET balance = balance + 500
WHERE account = 3208;

COMMIT;

BEGIN TRANSACTION;
UPDATE savings_accounts
SET balance = balance - 500
WHERE account = 3209;

UPDATE checking_accounts
SET balance = balance + 500
WHERE account = 3208;

ROLLBACK;