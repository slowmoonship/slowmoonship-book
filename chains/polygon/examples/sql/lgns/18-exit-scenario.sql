-- 复算旧结果的AMM情景
-- STATUS: STATIC_CHECKED
-- EXECUTION: BLOCKED_READ_ONLY_ACCOUNT; NOT_EXECUTED_THIS_RUN
-- Grain: 旧Query8390372固定截止的一种假设仓位
-- Units: LGNS、DAI、无量纲费率
-- No remote objects created or modified.

WITH historical_input(lgns,reserve_lgns,reserve_dai,token_fee,amm_factor) AS (
VALUES (41424.219251297975e0,55903905.54370488e0,72735513.93924864e0,0.05e0,0.997e0)
)
SELECT lgns, lgns*(1-token_fee) AS net_input_lgns,
reserve_dai*lgns*(1-token_fee)*amm_factor /
(reserve_lgns+lgns*(1-token_fee)*amm_factor) AS modeled_dai_out
FROM historical_input;
