# Zookeeper Ansible

## Installation

```bash
make install
make uninstall
make start
make stop
make restart
make status
```

If port `8080` is occupied and zookeeper cannot be started, you can add the following content to `zoo.cfg`:

```
admin.serverPort=8888
```
