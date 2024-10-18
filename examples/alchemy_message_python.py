import sys

sys.path.append("../")
from gen.python.protos.v1.simplemessage.alchemy_message_pb2 import SimpleMessage

# Create an instance of the AlchemyMessage
message = SimpleMessage()
message.name = "Alchemy"
message.id = "123"
message.age = 30
message.is_active = True


# Serialize the message to a binary format
serialized_message = message.SerializeToString()
print(f"Serialized message: {serialized_message}")

# Deserialize the message from the binary format
new_message = SimpleMessage()
new_message.ParseFromString(serialized_message)
print(f"Deserialized message: name={new_message.name}, id={new_message.id}, is_active={new_message.is_active}")
