.PHONY: install
install:
	ansible-playbook -i hosts site.yml

.PHONY: uninstall
uninstall:
	ansible-playbook -i hosts site.yml --extra-vars "run_option=uninstall"

.PHONY: start
start:
	ansible-playbook -i hosts site.yml --extra-vars "run_option=start"

.PHONY: stop
stop:
	ansible-playbook -i hosts site.yml --extra-vars "run_option=stop"

.PHONY: restart
restart:
	ansible-playbook -i hosts site.yml --extra-vars "run_option=restart"

.PHONY: status
status:
	ansible-playbook -i hosts site.yml --extra-vars "run_option=status"
