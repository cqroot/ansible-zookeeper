# Zookeeper Ansible

## Installation

```bash
ansible-playbook -i hosts site.yml
```

```bash
ansible-playbook -i hosts site.yml --extra-vars "uninstall=true"
```

If port `8080` is occupied and zookeeper cannot be started, you can add the following content to `zoo.cfg`:

```
admin.serverPort=8888
```
