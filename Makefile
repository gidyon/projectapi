API_IN_PATH := api/proto
API_OUT_PATH := pkg/api
OPENAPI_OUT_PATH := api/openapiv2

setup_dev: ## Sets up a development environment for the emrs project
	@cd deployments/compose/dev &&\
	docker-compose up -d

setup_redis:
	@cd deployments/compose/dev &&\
	docker-compose up -d redis

teardown_dev: ## Tear down development environment for the emrs project
	@cd deployments/compose/dev &&\
	docker-compose down

redis_console:
	@docker run --rm -it --network bridge-rupa-backend redis redis-cli -h redis

JWT_KEY := hDI0eBv11TbuboZ01qpnOuYRYLh6gQUOQhC9Mfagzv9l3gJso7CalTt7wGzJCVwbeDIfOX6fwS79pnisW7udhQ
API_BLOCK_KEY := 9AI8o4ta02gdqWsVhYe0r276z7my6yDwY78rCsrcofT7pCNq4WwnRoW93hn8WFJM0HheZHDYPc4tD+tUXVNEGw
API_HASH_KEY := 73H/I3+27Qp3ZETqMzbYa/EGT826Zxx2821cmHUl7fTX/DmkIWPJatczkxN3p8RHbdOGWT/HDRAf7gqhZcZOow
FIREBASE_CREDENTIALS_FILE := /Users/jessegitaka/go/src/github.com/gidyon/antibug/service-accout.json
CONFIGS_DIR := /Users/jessegitaka/go/src/github.com/gidyon/services/configs
TEMPLATES_DIR := /Users/jessegitaka/go/src/github.com/gidyon/services/templates/account
ACTIVATION_URL := https://google.com

protoc_project: ## Protoc compile the API
	@protoc -I=$(API_IN_PATH) -I=third_party --go-grpc_out=$(API_OUT_PATH)/project --go-grpc_opt=paths=source_relative --go_opt=paths=source_relative --go_out=$(API_OUT_PATH)/project project.proto
	@protoc -I=$(API_IN_PATH) -I=third_party --grpc-gateway_out=logtostderr=true,paths=source_relative:$(API_OUT_PATH)/project project.proto
	@protoc -I=$(API_IN_PATH) -I=third_party --openapiv2_out=logtostderr=true,repeated_path_param_separator=ssv:$(OPENAPI_OUT_PATH) project.proto

protoc_all: protoc_project

run_project: ## Run project 
	cd cmd && make run

build_project: ## Build a project
	cd cmd && sudo build_service

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
