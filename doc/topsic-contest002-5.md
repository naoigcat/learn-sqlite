# [解説](https://web.archive.org/web/20250208220740/https://topsic-contest.jp/contests/contest002/editorial)

## 【問題1】地区名の更新

```sql
UPDATE POPULATION
SET
    DISTRICT_NAME = '不明'
WHERE
    NULLIF(DISTRICT_NAME, '') IS NULL;
```

## 【問題2】曖昧検索

```sql
SELECT
    DISTRICT_CODE AS CODE
    , DISTRICT_NAME AS NAME
    , TOTAL_AMT AS TOTAL
FROM
    POPULATION
WHERE
    TOTAL_AMT >= 100000
    AND DISTRICT_NAME LIKE '%東%'
ORDER BY
    TOTAL_AMT DESC
    , DISTRICT_CODE ASC;
```

## 【問題3】飲酒率

```sql
SELECT
    DH.PF_CODE AS CODE
    , PF.PF_NAME AS NAME
    , ROUND(
        100.0 * SUM(
            CASE DH.CATEGORY_CODE
                WHEN '120' THEN DH.AMT
                ELSE 0
                END
        ) / SUM(
            CASE DH.CATEGORY_CODE
                WHEN '110' THEN DH.AMT
                ELSE 0
                END
        )
        , 1
    ) AS PERCENTAGE
FROM
    DRINK_HABITS AS DH
    INNER JOIN PREFECTURE AS PF
        ON PF.PF_CODE = DH.PF_CODE
WHERE
    DH.GENDER_CODE IN ('2', '3')
GROUP BY
    DH.PF_CODE
ORDER BY
    PERCENTAGE DESC
    , DH.PF_CODE DESC;
```

## 【問題4】就学状況の表示変換

```sql
WITH SEQ_TBL AS (
    SELECT
        1 AS SEQ_NO
    UNION ALL
    SELECT
        SEQ_NO + 1
    FROM
        SEQ_TBL
    WHERE
        SEQ_NO < 6
)
SELECT
    ES_SUB.SURVEY_YEAR AS SV_YEAR
    , PF.PF_NAME AS PREFECTURE
    , ES_SUB.KIND AS KIND
    , SUM(ES_SUB.AMOUNT) AS AMT
FROM
    (
        SELECT
            ES.SURVEY_YEAR
            , ES.PF_CODE
            , ST.SEQ_NO
            , CASE ST.SEQ_NO
                WHEN 1 THEN '小学校'
                WHEN 2 THEN '中学校'
                WHEN 3 THEN '高校'
                WHEN 4 THEN '短大'
                WHEN 5 THEN '大学'
                WHEN 6 THEN '大学院'
                ELSE NULL
                END AS KIND
            , CASE ST.SEQ_NO
                WHEN 1 THEN ES.ELEMENTARY
                WHEN 2 THEN ES.MIDDLE
                WHEN 3 THEN ES.HIGH
                WHEN 4 THEN ES.JUNIOR_CLG
                WHEN 5 THEN ES.COLLEGE
                WHEN 6 THEN ES.GRADUATE
                ELSE NULL
                END AS AMOUNT
        FROM
            ENROLLMENT_STATUS AS ES
            CROSS JOIN SEQ_TBL AS ST
        WHERE
            ES.SURVEY_YEAR = 2020
    ) AS ES_SUB
    INNER JOIN PREFECTURE AS PF
        ON ES_SUB.PF_CODE = PF.PF_CODE
WHERE
    ES_SUB.AMOUNT IS NOT NULL
GROUP BY
    ES_SUB.SURVEY_YEAR
    , PF.PF_NAME
    , ES_SUB.KIND
ORDER BY
    ES_SUB.PF_CODE ASC
    , ES_SUB.SEQ_NO ASC;
```
