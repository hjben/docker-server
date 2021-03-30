hive2_pid=`pgrep -f org.apache.hive.service.server.HiveServer2`

    if [[ -n "$hive2_pid" ]]
    then
        echo "Found hivesevrer2 PID-- "$hive2_pid
        kill $hive2_pid
        # if process is still around, use kill -9
        if ps -p $hive2_pid > /dev/null ; then
            echo "Initial kill failed, killing with -9 "
            kill -9 $hive2_pid
        fi
    echo "Hive server2 stopped successfully"
    else
        echo "Hiveserver2 process not found , HIveserver2 is not running !!!"
    fi

    meta_pid=`pgrep -f org.apache.hadoop.hive.metastore.HiveMetaStore`

    if [[ -n "$meta_pid" ]]
    then
        echo "Found hivesevrer2 PID-- "$meta_pid
        kill $meta_pid
        # if process is still around, use kill -9
        if ps -p $meta_pid > /dev/null ; then
            echo "Initial kill failed, killing with -9 "
            kill -9 $meta_pid
        fi
    echo "Hive metastore stopped successfully"
    else
        echo "Hive metastore process not found , Hive metastore is not running !!!"
    fi
