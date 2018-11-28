SHELL=/bin/bash

# Cross-platform realpath from 
# https://stackoverflow.com/a/18443300
# NOTE: Adapted for Makefile use
define BASH_FUNC_realpath%%
() {
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
}
endef
export BASH_FUNC_realpath%%

ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: help

.PHONY: docker-build
.PHONY: bash

.DEFAULT_GOAL := help

help: ## This help.
	@grep -E \
		'^[\/\.0-9a-zA-Z_-\+]+:.*?## .*$$' \
		$(MAKEFILE_LIST) \
		| grep -v '<HIDE FROM HELP>' \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; \
		       {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

docker-build: ## Builds the edit-embeddings docker image.
	@docker build \
		-t jjhenkel/edit-embeddings \
		-f ${ROOT_DIR}/Dockerfile \
		${ROOT_DIR}

bash: docker-build ## Opens an interactive session with a container based on jjhenkel/edit-embeddings.
	@docker run \
		-it \
		--rm \
		--network host \
		--volume ${ROOT_DIR}/mnt:/mnt \
		-w /mnt \
		jjhenkel/edit-embeddings
