#!/bin/sh
set -x

gradle clean

#Fang-Yu: the directory of ~/dynamometer/dynamometer-infra/src/main/lib does not exist initially
#so we need to create one for the first execution
rm ~/dynamometer/dynamometer-infra/src/main/lib/dynamometer-infra-0.1.0-SNAPSHOT.jar
rm ~/dynamometer/dynamometer-infra/src/main/lib/dynamometer.jar

#Fang-Yu: we skip the test
gradle build -x test

cp ~/dynamometer/dynamometer-infra/build/libs/dynamometer-infra-0.1.0-SNAPSHOT.jar /home/systest/dynamometer/dynamometer-infra/src/main/lib

cp ~/dynamometer/dynamometer-infra/src/main/lib/dynamometer-infra-0.1.0-SNAPSHOT.jar ~/dynamometer/dynamometer-infra/src/main/lib/dynamometer.jar

#previously the memory was set to 1024 for each
./dynamometer-infra/src/main/bash/start-dynamometer-cluster.sh \
-hadoop_binary_path /home/systest/hadoop-2.6.0-cdh5.15.0.tar.gz \
-conf_path dyno_conf \
-fs_image_dir hdfs:///dyno/fsimage \
--block_list_path hdfs:///dyno/blocks \
-master_memory_mb 16384 \
-datanode_memory_mb 1024 \
-namenode_memory_mb 16384

