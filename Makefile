.PHONY: tf
tf:
	docker run --rm -ti \
		-v ${PWD}:/app \
		-w /app \
		--name terraform \
		--entrypoint "" \
		--env-file=.env \
		hashicorp/terraform:0.13.7 sh
