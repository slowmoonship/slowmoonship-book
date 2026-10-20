-- 三乘四Join陷阱与修正
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: 合成演示一个交易
-- Units: 行数
-- No remote objects created or modified.

WITH traces(tx,id) AS (VALUES (1,1),(1,2),(1,3)),
logs(tx,id) AS (VALUES (1,1),(1,2),(1,3),(1,4)),
bad AS (SELECT COUNT(*) AS rows FROM traces t JOIN logs l ON t.tx=l.tx),
ta AS (SELECT tx, COUNT(*) AS traces FROM traces GROUP BY 1),
la AS (SELECT tx, COUNT(*) AS logs FROM logs GROUP BY 1)
SELECT b.rows AS naive_rows, ta.traces, la.logs, 1 AS corrected_transaction_rows
FROM ta JOIN la ON ta.tx=la.tx CROSS JOIN bad b;
