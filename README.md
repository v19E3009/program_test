
Analyze_access_log
=======================

Oerview
=========================

Apacheログ用のアクセスログ解析プログラム
以下の観点から，アクセス件数を集計する
- 各時間帯毎のアクセス件数を知りたい
- リモートホスト別のアクセス件数:
アクセスの多いリモートホストの順にアクセス件数の一覧を表示する．

Requirement
===============================

スクリプトを使用するディレクトリにmonth_convを配置してください．

Usage
===========================

~~~
sh Analyze_access_log.sh <Input FILE...>
sh Analyze_access_log.sh [-t] (start_time-end_time) <Input FILE...>
~~~

コマンド例)

~~~
sh Analyze_access_log.sh /var/log/httpd/access_log*
sh Analyze_access_log.sh -t 01/1/2020:00:00:00-30/1/2020:00:00:00 /var/log/httpd/access_log*
~~~
