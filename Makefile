.PHONY: update

run = vagrant ssh -- 'cd yunity && sudo $(1)'

update:
	@git pull
	@make update-vm

update-vm:
	$(call run,make update)
	$(call run,pm2 restart all)

start:
	$(call run,pm2 start pm2.json)

restart:
	$(call run,pm2 restart all)

