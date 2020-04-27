#！/bin/bash
#脚本第一次运行前需要根据现场环境修改MYSQL_HOME\USER\HOST\PORT\PASSWORD等参数

MYSQL_HOME=/usr/local/mysql

USER=root

HOST=127.0.0.1

PORT=3306

PASSWORD=root.2011

datename=$(date +%Y%m%d-%H%M%S) 

database=$2

table=$3

DATABASEFILE=$2

filename=$3
if [ ! -d "bak_dir" ]; then
mkdir bak_dir
fi
BAK_DIR=./bak_dir

single_database(){
if [ ! -n "$database" ] ;then
echo "输入导出失败，请输入选导出的数据库 :$0 single_database  dbname "
else
$MYSQL_HOME/bin/mysqldump  -u$USER -p$PASSWORD -h$HOST -P$PORT --set-gtid-purged=OFF   --default-character-set=utf8mb4 --single-transaction  --flush-logs --hex-blob --triggers --routines --events  -B  $database >$BAK_DIR/$database-$datename.sql
fi
}


all_databases(){

    $MYSQL_HOME/bin/mysqldump  -u$USER -p$PASSWORD -h$HOST -P$PORT --set-gtid-purged=OFF   --default-character-set=utf8mb4 --single-transaction  --flush-logs --hex-blob --triggers --routines --events  -B  --all-databases  >$BAK_DIR/all-databases-$datename.sql
 	
	    }


table(){
if [ ! -n "$database" ] ;then
    echo "导出失败，请输入选导出的数据库 数据表 $0 table  dbname  tablename"
    else 
	if [ ! -n "$table" ] ;then  
	echo "导出失败，请输入选导出的数据库 数据表 $0 table  dbname  tablename"
    else
    $MYSQL_HOME/bin/mysqldump  -u$USER -p$PASSWORD -h$HOST -P$PORT --default-character-set=utf8mb4 --single-transaction --flush-logs --set-gtid-purged=off --hex-blob  --tables $database $table  > $BAK_DIR/$database-$table-$datename.sql
       fi
       fi
}


imp(){
	if [ ! -n "$database" ] ;then
        echo "导入失败，请输需要导入的数据库 ：$0 imp dbname filename"
    else
	    if [ ! -n "$filename" ] ;then    
            echo "导入，请输入选导入的sql文件 ：$0 imp dbname filename"
          else
  # $MYSQL_HOME/bin/mysql  -u$USER -p$PASSWORD -h$HOST -P$PORT   $database   < $filename
    $MYSQL_HOME/bin/mysql  -u$USER -p$PASSWORD -h$HOST -P$PORT  $database    < $filename
  
 fi	  
 fi
  }

imp_db(){
# $MYSQL_HOME/bin/mysql  -u$USER -p$PASSWORD -h$HOST -P$PORT   $database   < $filename  
    $MYSQL_HOME/bin/mysql   -u$USER -p$PASSWORD -h$HOST -P$PORT    < $DATABASEFILE
    
    }


  help(){
     echo "Usage: $0 {single_database dbname |all_databases|table dbname tablename |imp dbname filename |--help }"
     echo "导出单个库：$0 single_database  dbname"
     echo "导出所有的库：$0 single_database"
     echo "导出单表：$0 table dbname tablename"
     echo "导出数据：$0  imp dbname filename"
     echo "导入整库数据：$0  imp_db filename"

  }



case "$1" in
	   'database')
        single_database
	    ;;
        'all_databases')
         all_databases
	    ;;
        'table')
	    table
	    ;;
	   'imp')
	    imp
	    ;;
        'imp_db')
	    imp_db
	    ;;
        '--help')
	    help
	    ;;
             *)
 echo "Usage: $0 {database dbname |all_databases|table dbname tablename |imp dbname filename |imp_db file|--help }"
 echo "导出单个库：$0 database  dbname"
 echo "导出所有的库：$0 all_databases"
 echo "导出单表：$0 table dbname tablename"
 echo "导入数据：$0  imp dbname filename"
 echo "导入整库数据：$0  imp_db filename"

 exit 1
  ;;
esac
exit 0
