#!/bin/bash

#read -p "Please Enter number of Users : " Users
#read -p "Please Enter Rampup duration : " Rampup
#read -p "Please Enter run duration : " duration
read -p "Please Enter report file Prefix Name : " ReportfileName

loopcount=1
dttime=`date +%d%b%Y_%H%M%S`
projectpath=/root/PT/projects/AuthNProxy/
ThinkTime=1000
filename="$ReportfileName"_"$dttime"
jmxfilename=AuthNProxy.jmx
JMETER_HOME=/root/PT/tools/apache-jmeter-5.1.1/

echo
echo " ------------------------- Run Setting -------------------"
echo "Report file :  " $filename
#echo "No of users : " $Users
#echo "Rampup duration : " $Rampup
#echo "Run duration : " $duration
#echo "Think Time : " $ThinkTime
echo "----------------------------------------------------------"
echo

read -p "You want to continue [Y/N] : " yesno

if [ $yesno == Y ]
then
        echo "Starting the run"

        JVM_ARGS="-Xms4G -Xmx4G -XX:NewSize=1G -XX:MaxNewSize=1G -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -Xloggc:$projectpath/logs/GC/GC_${dttime}.log -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9005 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.remote.ssl=false -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$projectpath/logs/GC"  && export JVM_ARGS && sh $JMETER_HOME/bin/jmeter -Jusers=$Users -Jrampup=$Rampup -Jloopcount=$loopcount -JThinkTime=$ThinkTime -Jduration=$duration -Jdirpath=$projectpath -n -t $projectpath/$jmxfilename -l $projectpath/results/$filename.jtl
	
	echo 
	echo "----------------------------------------------------------"
	echo "Execution is finished .... Preparing the Report"
	echo "----------------------------------------------------------"
	echo 

        $JMETER_HOME/bin/JMeterPluginsCMD.sh --tool Reporter --generate-csv $projectpath/results/$filename.csv --input-jtl $projectpath/results/$filename.jtl --plugin-type AggregateReport

else
        echo "Execution is skipped :) .. Bye Bye"
fi
