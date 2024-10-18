package main

import (
	"fmt"
	"log"

	// "github.com/girishcodelachemy/Alchemy-Protos/simplemessagepb"
	"gen/go/protos/v1/simplemessage/simplemessagepb"

	"google.golang.org/protobuf/proto"
)

func main() {
	// Create a new SimpleMessage instance
	message := &simplemessagepb.SimpleMessage{
		Name:     "Alchemy",
		Id:       "123",
		IsActive: true,
	}

	// Serialize the message to a binary format
	serializedMessage, err := proto.Marshal(message)
	if err != nil {
		log.Fatalf("Failed to serialize message: %v", err)
	}
	fmt.Printf("Serialized message: %x\n", serializedMessage)

	// Deserialize the message from the binary format
	newMessage := &simplemessagepb.SimpleMessage{}
	err = proto.Unmarshal(serializedMessage, newMessage)
	if err != nil {
		log.Fatalf("Failed to deserialize message: %v", err)
	}
	fmt.Printf("Deserialized message: name=%s, id=%d, is_active=%t\n", newMessage.Name, newMessage.Id, newMessage.IsActive)
}
