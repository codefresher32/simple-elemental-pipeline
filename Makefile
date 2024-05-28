init:
	terraform init

plan:
	terraform plan

apply:
	terraform apply

destroy:
	terraform destroy

deploy: init apply

destroy: init destroy
