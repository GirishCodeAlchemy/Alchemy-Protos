.PHONY: all install-protoc install-plugins clean generate-protos

black:
	black .

# test:
# 	coverage run -m pytest tests && coverage html && open htmlcov/index.html

type-check:
	mypy .

protofiles = $(wildcard protos/**/**/*.proto)

install-protoc:
	# Check and install protoc depending on the platform
	@if [ "$(OS)" = "Windows_NT" ]; then \
		echo "Detected Windows"; \
		choco install protoc; \
	elif [ "$(shell uname)" = "Darwin" ]; then \
		echo "Detected macOS"; \
		brew install protobuf; \
	elif [ "$(shell uname)" = "Linux" ]; then \
		echo "Detected Linux"; \
		PROTOC_ZIP=protoc-21.12-linux-x86_64.zip; \
		curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v21.12/$${PROTOC_ZIP}; \
		sudo unzip -o $${PROTOC_ZIP} -d /usr/local bin/protoc; \
		sudo unzip -o $${PROTOC_ZIP} -d /usr/local 'include/*'; \
		rm -f $${PROTOC_ZIP}; \
	else \
		echo "Unsupported OS"; \
		exit 1; \
	fi

install-plugins:
	go install github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@latest
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

generate: clean-dir gen-dir gen-protos

clean: clean-dir

clean-dir:
	-rm -rf gen

gen-dir:
	@mkdir -p gen/java
	@mkdir -p gen/go
	@mkdir -p gen/python

gen-protos-java:
	@for proto in $(protofiles); do \
	protoc --proto_path=. --java_out=gen/java $$proto; \
	done

gen-protos-python:
	@for proto in $(protofiles); do \
	echo $$proto; \
	protoc --python_out=gen/python $$proto; \
	done

gen-protos-go:
	@for proto in $(protofiles); do \
	echo $$proto; \
	protoc $$proto -I=. \
	--plugin=protoc-gen-go=$(HOME)/go/bin/protoc-gen-go \
	--plugin=protoc-gen-go-grpc=$(HOME)/go/bin/protoc-gen-go-grpc \
	--go_out=gen/go --go_opt=paths=source_relative \
	--go-grpc_out=gen/go --go-grpc_opt=paths=source_relative; \
	done


gen-protos: gen-dir gen-protos-java gen-protos-python gen-protos-go

all: install-plugins clean gen-protos
