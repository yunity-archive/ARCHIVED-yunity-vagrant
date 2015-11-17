.PHONY: update

run = vagrant ssh -- 'cd yunity && sudo $(1)'

update:
	@git pull
	@make update-vm

update-backend:
	@git pull
	@make update-backend-vm

update-vm:
	$(call run,make update)
	$(call run,pm2 restart all)

update-backend-vm:
	$(call run,make update-backend)
	$(call run,pm2 restart all)

start:
	$(call run,pm2 start pm2.json)

restart:
	$(call run,pm2 restart all)

