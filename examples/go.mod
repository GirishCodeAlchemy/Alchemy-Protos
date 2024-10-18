module protos-example

go 1.21.0

replace gen/go/protos/v1/simplemessage/simplemessagepb => ../gen/go/protos/v1/simplemessage/simplemessagepb

require google.golang.org/protobuf v1.35.1
