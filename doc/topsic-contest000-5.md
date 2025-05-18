# [解説（練習用コンテスト）](https://web.archive.org/web/20250208220740/https://topsic-contest.jp/contests/practice/editorial)

## 【問題1】都道府県の人口

```sql
SELECT
    DISTRICT_NAME AS 都道府県名
    , TOTAL_AMT AS 総人口
FROM
    POPULATION
WHERE
    LVL = 2
ORDER BY
    TOTAL_AMT DESC;
```

## 【問題2】世帯入院率

```sql
SELECT
    HP.PF_CODE AS 都道府県コード
    , PF.PF_NAME AS 都道府県名
    , ROUND(
        -- 計算項目がINTEGER型なのでCAST関数でREAL型に変換して計算しています
        CAST(HP.INP_YES AS REAL) /
        CAST( (HP.INP_YES + HP.INP_NO + HP.UNIDENTIFIED) AS REAL )
        * 100
        , 1
    ) AS 入院率
FROM
    HOSPITALIZATION AS HP
    INNER JOIN PREFECTURE AS PF
        ON PF.PF_CODE = HP.PF_CODE
ORDER BY
    入院率 DESC
    , HP.PF_CODE ASC;
```

## 【問題3】人口増加率分析

```sql
SELECT
    PO.PF_CODE AS 都道府県コード
    , PF.PF_NAME AS 都道府県名
    , PO.TOTAL_AMT AS 総人口2015年
    , PO2020.TOTAL_AMT AS 総人口2020年
    , ROUND(
        -- 計算項目がINTEGER型なのでCAST関数でREAL型に変換して計算しています
        CAST(PO2020.TOTAL_AMT AS REAL) / CAST(PO.TOTAL_AMT AS REAL) * 100
    )  AS 人口増加率
FROM
    -- メインのクエリで、人口推移テーブルから2015年のデータを取得しています
    POPU_TRANSITION AS PO
    INNER JOIN PREFECTURE AS PF
        ON PF.PF_CODE = PO.PF_CODE
    -- 内部結合で同一テーブルの人口推移テーブルから、2020年のデータを取得しています
    INNER JOIN POPU_TRANSITION AS PO2020
        ON PO2020.PF_CODE = PO.PF_CODE
        AND PO2020.SURVEY_YEAR = 2020
WHERE
    PO.SURVEY_YEAR = 2015
    AND  PO2020.TOTAL_AMT >= PO.TOTAL_AMT
ORDER BY
    人口増加率 DESC
    , 都道府県コード ASC;
```

## 【問題4】年齢別睡眠時間分析

```sql
SELECT
    AGE_GRP.AGE_NAME AS 年齢階層,
    -- CASE句を用いて時間コードの値で場合分けし、対象人数を対応するカラムに振分けます
    -- 最後に、年齢コードでグルーピングを行い、振分けた値をサマリして表示します
    -- AS句で変更している表示項目名の先頭が数字なので、ダブルクォーテーションで項目名を囲っています
    SUM(CASE WHEN TIME_CODE = 120 THEN TARGET_POP ELSE 0 END) AS "5時間未満",
    SUM(CASE WHEN TIME_CODE = 130 THEN TARGET_POP ELSE 0 END) AS "5時間以上6時間未満",
    SUM(CASE WHEN TIME_CODE = 140 THEN TARGET_POP ELSE 0 END) AS "6時間以上7時間未満",
    SUM(CASE WHEN TIME_CODE = 150 THEN TARGET_POP ELSE 0 END) AS "7時間以上8時間未満",
    SUM(CASE WHEN TIME_CODE = 160 THEN TARGET_POP ELSE 0 END) AS "8時間以上9時間未満",
    SUM(CASE WHEN TIME_CODE = 170 THEN TARGET_POP ELSE 0 END) AS "9時間以上",
    SUM(CASE WHEN TIME_CODE = 180 THEN TARGET_POP ELSE 0 END) AS 不詳
FROM SLEEP_TIME_DTL
INNER JOIN AGE_GRP ON AGE_GRP.AGE_CODE = SLEEP_TIME_DTL.AGE_CODE
GROUP BY AGE_GRP.AGE_CODE
ORDER BY AGE_GRP.AGE_CODE;
```
