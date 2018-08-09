#!/bin/sh
set -x

gradle clean

#Fang-Yu: the directory of ~/dynamometer/dynamometer-infra/src/main/lib does not exist initially
#so we need to create one for the first execution
mkdir -p ~/dynamometer/dynamometer-infra/src/main/lib

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
-fs_image_dir hdfs:///user/systest/dyno/fsimage \
--block_list_path hdfs:///user/systest/dyno/blocks \
-master_memory_mb 8192 \
-datanode_memory_mb 4096 \
-namenode_memory_mb 51200 \
-datanode_vcores 1 \
-namenode_vcores 4 \
-datanode_launch_delay 10s
