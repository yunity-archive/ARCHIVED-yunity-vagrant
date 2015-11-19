.PHONY: update

run-in-vm = vagrant ssh -- 'cd yunity && sudo $(1)'

update:
	@git pull
	@make update-vm

update-backend:
	@git pull
	@make update-backend-vm

update-vm:
	$(call run-in-vm,make update)
	$(call run-in-vm,pm2 kill)
	$(call run-in-vm,pm2 start pm2.json)

update-backend-vm:
	$(call run-in-vm,make update-backend)
	$(call run-in-vm,pm2 restart all)

recreate-db:
	$(call run-in-vm,pm2 stop django)
	$(call run-in-vm,make recreate-db)

start:
	$(call run-in-vm,pm2 start pm2.json)

restart:
	$(call run-in-vm,pm2 restart all)
