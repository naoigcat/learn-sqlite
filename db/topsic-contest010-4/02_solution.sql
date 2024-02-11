-- https://topsic-contest.jp/contests/contest010/editorial
WITH SUB1 AS (
    -- SESSION_ID ごとに EX_TIMESTAMP 順にランクづけし、STEP N と RANK M を一覧にする
    SELECT
        SESSION_ID
        , PROCESS_ID
        , RANK() OVER (PARTITION BY SESSION_ID ORDER BY EX_TIMESTAMP) AS RANK
    FROM
        PROCESS_LOG
    ORDER BY
        SESSION_ID ASC
        , EX_TIMESTAMP ASC
)
, SUB2 AS (
    -- STEP の番号 N とランク M が異なる MIN まではカウント対象
    SELECT
        SESSION_ID
        , MIN(RANK) AS MIN
    FROM
        SUB1
    WHERE
        CAST(SUBSTR(SUB1.PROCESS_ID, 5, 1) AS INT) != RANK
    GROUP BY
        SESSION_ID
)
SELECT
    PROCESS_ID AS PROCESS
    -- SUB2 を外部結合し、MIN 未満の STEP を数え上げる
    -- このとき、MIN が NULL の場合は存在する STEP を全て数え上げる
    , COUNT(
        DISTINCT CASE
            WHEN CAST(SUBSTR(SUB1.PROCESS_ID, 5, 1) AS INT) < SUB2.MIN
            OR SUB2.MIN IS NULL
                THEN SUB1.SESSION_ID
            END
    ) AS CNT
FROM
    SUB1
    LEFT OUTER JOIN SUB2
        ON SUB1.SESSION_ID = SUB2.SESSION_ID
GROUP BY
    PROCESS_ID
ORDER BY
    PROCESS_ID;
