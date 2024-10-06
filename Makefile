.PHONY: run clean docs

black:
	black .

# test:
# 	coverage run -m pytest tests && coverage html && open htmlcov/index.html

type-check:
	mypy .

protofiles = $(wildcard protos/**/**/*.proto)

install-deps:
    go --version
    go install github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@latest
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
    protoc --python_out=pyi_out:new_gen protos/v1/alchemy_core.proto \
    done
    # python -m grpc_tools.protoc -I . --python_out=gen/python --grpc_python_out=gen/python $$proto; \

gen-protos-go:
    @for proto in $(protofiles); do \
    echo $$proto; \
    protoc $$proto -I=. --go_out=gen/go --go_opt=paths=source_relative; \
    done

gen-protos: gen-protos-java gen-protos-python gen-protos-go