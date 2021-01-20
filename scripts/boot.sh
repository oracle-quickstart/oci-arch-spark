#!/bin/bash
LOG_FILE="/var/log/spark-OCI-initialize.log"
log() { 
	echo "$(date) [${EXECNAME}]: $*" >> "${LOG_FILE}" 
}
spark_master_fqdn=`curl -L http://169.254.169.254/opc/v1/instance/metadata/spark_master`
local_fqdn=`hostname -f`
spark_master_ip=`host $spark_master_fqdn | gawk '{print $4}'`
fqdn_fields=`echo -e $spark_master_fqdn | gawk -F '.' '{print NF}'`
cluster_domain=`echo -e $spark_master_fqdn | cut -d '.' -f 3-${fqdn_fields}`
hadoop_version=`curl -L http://169.254.169.254/opc/v1/instance/metadata/hadoop_version`
build_mode=`curl -L http://169.254.169.254/opc/v1/instance/metadata/build_mode`
use_hive=`curl -L http://169.254.169.254/opc/v1/instance/metadata/use_hive`
if [ $local_fqdn = $spark_master_fqdn ]; then 
	block_volume_count="0"
else
	block_volume_count=`curl -L http://169.254.169.254/opc/v1/instance/metadata/block_volume_count`
fi
log "->Debug: Host FQDN: $local_fqdn"
log "->Debug: Spark Master FQDN: $spark_master_fqdn"
log "->DEBUG: BV Count $block_volume_count"
EXECNAME="TUNING"
log "->TUNING START"
sed -i.bak 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0
EXECNAME="JAVA"
log "->INSTALL"
yum install java-1.8.0-openjdk.x86_64 -y >> $LOG_FILE
EXECNAME="TUNING"
log "->OS"
echo never | tee -a /sys/kernel/mm/transparent_hugepage/enabled
echo "echo never | tee -a /sys/kernel/mm/transparent_hugepage/enabled" | tee -a /etc/rc.local
echo vm.swappiness=0 | tee -a /etc/sysctl.conf
echo 0 | tee /proc/sys/vm/swappiness
echo net.ipv4.tcp_timestamps=0 >> /etc/sysctl.conf
echo net.ipv4.tcp_sack=1 >> /etc/sysctl.conf
echo net.core.rmem_max=4194304 >> /etc/sysctl.conf
echo net.core.wmem_max=4194304 >> /etc/sysctl.conf
echo net.core.rmem_default=4194304 >> /etc/sysctl.conf
echo net.core.wmem_default=4194304 >> /etc/sysctl.conf
echo net.core.optmem_max=4194304 >> /etc/sysctl.conf
echo net.ipv4.tcp_rmem="4096 87380 4194304" >> /etc/sysctl.conf
echo net.ipv4.tcp_wmem="4096 65536 4194304" >> /etc/sysctl.conf
echo net.ipv4.tcp_low_latency=1 >> /etc/sysctl.conf
sed -i "s/defaults        1 1/defaults,noatime        0 0/" /etc/fstab
ulimit -n 262144
log "->FirewallD"
systemctl stop firewalld
systemctl disable firewalld
# Disk Setup Functions
vol_match() {
case $i in
        1) disk="oraclevdd";;
        2) disk="oraclevde";;
        3) disk="oraclevdf";;
        4) disk="oraclevdg";;
        5) disk="oraclevdh";;
        6) disk="oraclevdi";;
        7) disk="oraclevdj";;
        8) disk="oraclevdk";;
        9) disk="oraclevdl";;
        10) disk="oraclevdm";;
        11) disk="oraclevdn";;
        12) disk="oraclevdo";;
        13) disk="oraclevdp";;
        14) disk="oraclevdq";;
        15) disk="oraclevdr";;
        16) disk="oraclevds";;
        17) disk="oraclevdt";;
        18) disk="oraclevdu";;
        19) disk="oraclevdv";;
        20) disk="oraclevdw";;
        21) disk="oraclevdx";;
        22) disk="oraclevdy";;
        23) disk="oraclevdz";;
        24) disk="oraclevdab";;
        25) disk="oraclevdac";;
        26) disk="oraclevdad";;
        27) disk="oraclevdae";;
        28) disk="oraclevdaf";;
        29) disk="oraclevdag";;
esac
}
iscsi_detection() {
	iscsiadm -m discoverydb -D -t sendtargets -p 169.254.2.$i:3260 2>&1 2>/dev/null
	iscsi_chk=`echo -e $?`
	if [ $iscsi_chk = "0" ]; then
		iqn[${i}]=`iscsiadm -m discoverydb -D -t sendtargets -p 169.254.2.${i}:3260 | gawk '{print $2}'`
		log "-> Discovered volume $((i-1)) - IQN: ${iqn[${i}]}"
		continue
	else
		volume_count="${#iqn[@]}"
		if [ -z $volume_count ]; then 
			volume_count=0
		fi
		log "--> Discovery Complete - ${#iqn[@]} volumes found"
		detection_done="1"
	fi
}
iscsi_setup() {
        log "-> ISCSI Volume Setup - Volume ${i} : IQN ${iqn[$n]}"
        iscsiadm -m node -o new -T ${iqn[$n]} -p 169.254.2.${n}:3260
        log "--> Volume ${iqn[$n]} added"
        iscsiadm -m node -o update -T ${iqn[$n]} -n node.startup -v automatic
        log "--> Volume ${iqn[$n]} startup set"
        iscsiadm -m node -T ${iqn[$n]} -p 169.254.2.${n}:3260 -l
        log "--> Volume ${iqn[$n]} done"
}
EXECNAME="DISK DETECTION"
log "->Begin Block Volume Detection Loop"
detection_flag="0"
while [ "$detection_flag" = "0" ]; do
        detection_done="0"
        log "-- Detecting Block Volumes --"
        for i in `seq 2 33`; do
                if [ $detection_done = "0" ]; then
			iscsi_detection
		fi
        done;
        if [ "$block_volume_count" = 0 ]; then 
		log "-- No Block Volumes Configured, Skipping Setup --"
		detection_flag="1"
		continue
        elif [ "$volume_count" != "$block_volume_count" ]; then
                log "-- Sanity Check Failed - $volume_count Volumes found, $block_volume_count expected.  Re-running --"
                sleep 15
                continue
        elif [ "$volume_count" = "$block_volume_count" ]; then
                log "-- Setup for ${#iqn[@]} Block Volumes --"
                for i in `seq 1 ${#iqn[@]}`; do
                        n=$((i+1))
                        iscsi_setup
                done;
                detection_flag="1"
        else
                log "-- Repeating Detection --"
                continue
        fi
done;

EXECNAME="DISK PROVISIONING"
data_mount () {
  log "-->Mounting /dev/$disk to /data$dcount"
  mkdir -p /data$dcount
  mount -o noatime,barrier=1 -t ext4 /dev/$disk /data$dcount
  UUID=`lsblk -no UUID /dev/$disk`
  echo "UUID=$UUID   /data$dcount    ext4   defaults,noatime,discard,barrier=0 0 1" | tee -a /etc/fstab
}

block_data_mount () {
  log "-->Mounting /dev/oracleoci/$disk to /data$dcount"
  mkdir -p /data$dcount
  mount -o noatime,barrier=1 -t ext4 /dev/oracleoci/$disk /data$dcount
  UUID=`lsblk -no UUID /dev/oracleoci/$disk`
  echo "UUID=$UUID   /data$dcount    ext4   defaults,_netdev,nofail,noatime,discard,barrier=0 0 2" | tee -a /etc/fstab
}
EXECNAME="DISK SETUP"
log "->Checking for disks..."
dcount=0
for disk in `ls /dev/ | grep nvme | grep n1`; do
        log "-->Processing /dev/$disk"
        mke2fs -F -t ext4 -b 4096 -E lazy_itable_init=1 -O sparse_super,dir_index,extent,has_journal,uninit_bg -m1 /dev/$disk
        data_mount
        dcount=$((dcount+1))
done;
if [ ${#iqn[@]} -gt 0 ]; then
for i in `seq 1 ${#iqn[@]}`; do
        n=$((i+1))
        dsetup="0"
        while [ $dsetup = "0" ]; do
                vol_match
                log "-->Checking /dev/oracleoci/$disk"
                if [ -h /dev/oracleoci/$disk ]; then
                        case $disk in
                                *)
                                mke2fs -F -t ext4 -b 4096 -E lazy_itable_init=1 -O sparse_super,dir_index,extent,has_journal,uninit_bg -m1 /dev/oracleoci/$disk
                                block_data_mount
                                dcount=$((dcount+1))
                                ;;
                        esac
                        /sbin/tune2fs -i0 -c0 /dev/oracleoci/$disk
			unset UUID
                        dsetup="1"
                else
                        log "--->${disk} not found, running ISCSI again."
                        log "-- Re-Running Detection & Setup Block Volumes --"
			detection_done="0"
			log "-- Detecting Block Volumes --"
			for i in `seq 2 33`; do
				if [ $detection_done = "0" ]; then
		                        iscsi_detection
                		fi
		        done;
			for i in `seq 1 ${#iqn[@]}`; do
				n=$((i+1))
	                        iscsi_setup
			done
                fi
        done;
done;
fi
EXECNAME="Spark Install"
log "->Download Spark master from github"
cd /opt
wget https://github.com/apache/spark/archive/master.zip
unzip master.zip 
cd spark-master/
log "->Install Maven"
yum install maven -y >> $LOG_FILE
log "->Build Spark with Maven"
export MAVEN_OPTS="-Xmx4g -XX:ReservedCodeCacheSize=1g"
if [ $build_mode = "Hadoop" ]; then
	log "-->Building with Hadoop compatability"
	if [ $use_hive = "true" ]; then 
		log "--->Hive Integration Enabled"
		if [ $hadoop_version = "2.6.x" ]; then 
			log "---->Hadoop Version 2.6.x chosen"
			./build/mvn -Pyarn -Phive-thriftserver -DskipTests clean package >> $LOG_FILE
		else
			log "---->Hadoop Version 2.7.x chosen"
			./build/mvn -Pyarn -Phadoop-2.7 -Dhadoop,version=2.7.3 -Phive-thriftserver -DskipTests clean package >> $LOG_FILE
		fi
	else
		if [ $hadoop_version = "2.6.x" ]; then
                        log "---->Hadoop Version 2.6.x chosen"
                        ./build/mvn -Pyarn -DskipTests clean package >> $LOG_FILE
                else
                        log "---->Hadoop Version 2.7.x chosen"
                        ./build/mvn -Pyarn -Phadoop-2.7 -Dhadoop,version=2.7.3 -DskipTests clean package >> $LOG_FILE
                fi
	fi
elif [ $build_mode = "Kubernetes" ]; then 
        log "-->Building with Kubernetes compatability"
        ./build/mvn -Pkubernetes -DskipTests clean package >> $LOG_FILE
elif [ $build_mode = "Mesos" ]; then 
        log "-->Building with Mesos compatability"
        if [ $use_hive = "true" ]; then
                log "--->Hive Integration Enabled"
                ./build/mvn -Pmesos -Phive -Phive-thriftserver -DskipTests clean package >> $LOG_FILE
        else
                ./build/mvn -Pmesos -DskipTests clean package >> $LOG_FILE
        fi	
else
	log "-->Building Stand-Alone Spark Cluster"
	./build/mvn -DskipTests clean package >> $LOG_FILE
fi
log "->Spark Build Complete"
EXECNAME="PySpark Install"
log "->Install Python & Pip"
sudo yum install python python-pip -y >> $LOG_FILE
sudo pip install --upgrade pip >> $LOG_FILE
log "->Install PySpark"
sudo pip install pyspark >> $LOG_FILE
EXECNAME="Spark Worker Start"
if [ $local_fqdn = $spark_master_fqdn ]; then 
	log "->Start Spark Master"
	./sbin/start-master.sh >> $LOG_FILE
else
	master_detected=1
	while [ $master_detected != 0 ]; do
		timeout 1 bash -c "cat < /dev/null > /dev/tcp/${spark_master_ip}/7077"
		master_detected=`echo -e $?`
		sleep 15
	done;
	log "->Start Spark Worker"
	./sbin/start-slave.sh ${spark_master_ip}:7077 >> $LOG_FILE
fi
EXECNAME="END"
log "->DONE"
