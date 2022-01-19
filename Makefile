ZOOKEEPER_PACKAGE=apache-zookeeper-3.5.9-bin

.ONESHELL:

.PHONY: install
install:
ifndef SERVER_FILE
	@echo "IS NULL";
	exit 1
else
	@
	SERVER_LIST=()
	while read SERVER_IP
	do
		SERVER_LIST+=($${SERVER_IP})
	done < $$SERVER_FILE

	wget https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.5.9/${ZOOKEEPER_PACKAGE}.tar.gz \
		--no-check-certificate --no-verbose \
		-O ./${ZOOKEEPER_PACKAGE}.tar.gz; \
	tar -xf ./${ZOOKEEPER_PACKAGE}.tar.gz; \

	echo "tickTime=2000"                        > ./${ZOOKEEPER_PACKAGE}/conf/zoo.cfg
	echo "initLimit=10"                        >> ./${ZOOKEEPER_PACKAGE}/conf/zoo.cfg
	echo "syncLimit=5"                         >> ./${ZOOKEEPER_PACKAGE}/conf/zoo.cfg
	echo "dataDir=/var/lib/zookeeper"          >> ./${ZOOKEEPER_PACKAGE}/conf/zoo.cfg
	echo "clientPort=2181"                     >> ./${ZOOKEEPER_PACKAGE}/conf/zoo.cfg

	for SERVER_INDEX in "$${!SERVER_LIST[@]}"
	do
		echo "server.$$(($$SERVER_INDEX+1))=$${SERVER_LIST[$$SERVER_INDEX]}:2888:3888" \
			>> ./${ZOOKEEPER_PACKAGE}/conf/zoo.cfg
	done

	for SERVER_INDEX in "$${!SERVER_LIST[@]}"
	do
		echo $$(($$SERVER_INDEX+1)) $${SERVER_LIST[$$SERVER_INDEX]}
		rsync -a ./${ZOOKEEPER_PACKAGE}/ root@$${SERVER_LIST[$$SERVER_INDEX]}:/opt/zookeeper
		ssh root@$${SERVER_LIST[$$SERVER_INDEX]} \
			"mkdir -p /var/lib/zookeeper;
			 echo '$$(($$SERVER_INDEX+1))' >> /var/lib/zookeeper/myid;
			 sh /opt/zookeeper/bin/zkServer.sh start;"; \
	done

	rm -rf ./${ZOOKEEPER_PACKAGE}.tar.gz;
	rm -rf ./${ZOOKEEPER_PACKAGE};
endif

.PHONY: clean
clean:
ifndef SERVER_FILE
	@echo "IS NULL";
	exit 1
else
	@
	SERVER_LIST=()
	while read SERVER_IP
	do
		SERVER_LIST+=($${SERVER_IP})
	done < $$SERVER_FILE

	for SERVER_INDEX in "$${!SERVER_LIST[@]}"
	do
		echo $$(($$SERVER_INDEX+1)) $${SERVER_LIST[$$SERVER_INDEX]}
		ssh root@$${SERVER_LIST[$$SERVER_INDEX]} \
			'sh /opt/zookeeper/bin/zkServer.sh stop;
			 rm -rf /opt/zookeeper;
			 rm -rf /var/lib/zookeeper;'
	done
endif
