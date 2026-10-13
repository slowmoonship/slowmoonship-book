WITH ranked AS (
    SELECT
        date, -- 日期
        package, -- Package ID
        move_calls, -- 当日 Move Call 数量

        ROW_NUMBER() OVER (
            PARTITION BY date
            ORDER BY move_calls DESC
        ) AS package_rank, -- 当日 Package Move Call 排名

        SUM(move_calls) OVER (
            PARTITION BY date
        ) AS total_move_calls -- 当日全网 Move Call 总量
    FROM query_8348409
)

SELECT
    date, -- 日期

    100.0 * SUM(
        CASE WHEN package_rank <= 1 THEN move_calls ELSE 0 END
    ) / NULLIF(MAX(total_move_calls), 0)
        AS top_1_share_pct, -- Top 1 Package Move Call 占比

    100.0 * SUM(
        CASE WHEN package_rank <= 5 THEN move_calls ELSE 0 END
    ) / NULLIF(MAX(total_move_calls), 0)
        AS top_5_share_pct, -- Top 5 Packages Move Call 占比

    100.0 * SUM(
        CASE WHEN package_rank <= 10 THEN move_calls ELSE 0 END
    ) / NULLIF(MAX(total_move_calls), 0)
        AS top_10_share_pct, -- Top 10 Packages Move Call 占比

    COUNT(*) AS active_packages -- 当日有 Move Call 的 Package 数量
FROM ranked
GROUP BY 1
ORDER BY date;