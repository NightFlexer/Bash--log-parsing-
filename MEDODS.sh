#!/bin/bash
echo "Скрипт запущен, производится загрузка файла из репозитория...  " && sleep 3
wget -q https://raw.githubusercontent.com/GreatMedivack/files/master/list.out 

FILED=_DATE_failed.out && RUNNING=_DATE_running.out && REPORT=_DATA_report.out
SERVER=$1
if [ -z "$SERVER" ];then SERVER=SERVER; fi
touch $SERVER$FILED | touch $SERVER$RUNNING | touch $SERVER$REPORT

if [ -z "$SERVER" ];then SERVER=1; fi
DATE=`date -I | sed "s/[-]/ /g" | awk '{print $3,$2,$1}'`
`cat list.out | grep "Error" | awk '{print $1}'|sed "s/[-]/ /g" | awk '{print $1,$2,$3}' > $SERVER$FILED`
`cat list.out | grep "Running" | awk '{print $1}'|sed "s/[-]/ /g" | awk '{print $1,$2,$3}' > $SERVER$RUNNING`
`touch SERVER_DATA_report.out | sudo chmod 777 SERVER_DATA_report.out`
(echo -n "Сервисов без ошибок :" && wc -l ./$SERVER$FILED | awk '{print $1}') > $SERVER$REPORT
(echo -n "Сервисов с ошибками :" && wc -l ./$SERVER$RUNNING | awk '{print $1}') >> $SERVER$REPORT
(echo -n ps -o user -p $$ | awk '{print $1}') >> $SERVER$REPORT
echo "Дата: " $DATE >> $SERVER$REPORT
#---------Оповещение----
echo "Созданы временные файлы: "
#---------Архивация----
tar cvzf SERVER_DATE.tar.gz $SERVER$FILED $SERVER$RUNNING $SERVER$REPORT
echo "Запущена архивация файлов ..." && sleep 3
#----------------------
path=`pwd` && name_ar=SERVER_DATE.tar.gz
if [ -e $path/$name_ar ];
  then echo "Архив найден"
    if ! tar tf ./test.tar &> /dev/null; then echo "Архив проверен"; else echo "Архив повреждён"; fi
      mkdir ./folder && mv $name_ar ./folder && echo "Архив перемещён в папку"
      rm $SERVER$FILED $SERVER$RUNNING $SERVER$REPORT list.out
      echo "Временныен файлы были удалены"
fi

