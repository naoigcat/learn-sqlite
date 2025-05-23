# SQLiteの注意点

TOPSIC SQLでは、SQLの実行環境にSQLiteを使用しています。SQLite以外のRDBMSの文法を使用することはできません。
問題を解く際に注意すべきSQLiteの制約について、以下に記載してありますのでご確認下さい。

NUMERIC、INTEGER、REALは、自身のクラスへの変換が推奨されていますが、変換できなかった場合でも、そのまま格納されます。
新しくデータを追加した場合、既に格納されているデータの中で ROWID の値が最大のものを探し、それに1を加えた値が新しく追加されるデータの ROWID の値として保存されます。
外部結合は、左外部結合を行う LEFT OUTER JOIN 句のみ使用できます。
指定した日付と時刻のタイムゾーンはUTCとして扱われます。
日付関数や文字列関数については、SQLiteで固有の関数があります。
テーブル項目の論理名が「◯◯日」となっている場合は、日付項目の時分秒は設定されていません。論理名が「◯◯日時」となっている場合は、日付項目の時分秒まで設定されています。
「受注日」の場合は「2021-01-01」
「受注日時」の場合は「2021-01-01 15:15:15」
その他のSQLiteの制約については、SQLiteの公式ドキュメントをご確認ください。
また、ER図の読み方やSQLiteの関数および構文などについては、「[受験ルール・用語](topsic-contest-rules.md)」をご確認ください。
