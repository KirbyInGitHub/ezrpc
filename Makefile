

swift_plugins=--plugin=./Plugin/protoc-gen-swift-grpc --plugin=./Plugin/protoc-gen-swift
kt_plugins=--plugin=./Plugin/protoc-gen-kotlin-grpc

options=--swift_opt=Visibility=Public \
--swift_opt=FileNaming=PathToUnderscores  \

swift_out=--swift-grpc_out=./Sources/Example/EchoModel --swift_out=./Sources/Example/EchoModel
kt_out=--kotlin-grpc_out=./Sources/Example/EchoModel

default: build-swift

build-swift:
	swift build --product protoc-gen-swift -c release
	swift build --product protoc-gen-swift-grpc -c release
	cp .build/release/protoc-gen-swift ./Plugin
	cp .build/release/protoc-gen-swift-grpc ./Plugin
	
build-kotlin:
	swift build --product rotoc-gen-kotlin-grpc -c release
	cp .build/release/rotoc-gen-kotlin-grpc ./Plugin
	
build-ezrpc:
	rm ./Plugin/ezrpc
	swift build --product ezrpc -c release
	cp .build/release/ezrpc ./Plugin
	
build-client:
#	rm ./Plugin/client
	arch -x86_64 swift build --product client -c release
	cp .build/release/client ./Plugin

gen:
	./Plugin/protoc ./Sources/Example/EchoModel/common_public.proto --proto_path=./Sources/Example/ $(swift_plugins) $(options) $(swift_out)
	./Plugin/protoc ./Sources/Example/EchoModel/address.proto --proto_path=./Sources/Example/ $(swift_plugins) $(options) $(swift_out)

#	./Plugin/protoc ./Sources/Example/EchoModel/payment.proto --proto_path=./Sources/Example/ $(swift_plugins) $(swift_out)
#	./Plugin/protoc ./Sources/Example/EchoModel/cashdesk.proto --proto_path=./Sources/Example/ $(swift_plugins) $(swift_out)
	
genkt:

	./Plugin/protoc ./Sources/Example/EchoModel/echo.proto --proto_path=./Sources/Example/ $(kt_plugins) $(kt_out)
	
clear : 
	rm -f ./Example/EchoModel/echo.pb.swift
	rm -f ./Example/EchoModel/echo.pb.client.swift

clean : 
	rm -rf protoc-gen-swiftgrpc Packages .build protoc-gen-swift Package.pins
	rm -rf Package.resolved

install:
	brew tap grpc/grpc
	brew install protobuf

project:
	swift package generate-xcodeproj

swift5:
	https://download.developer.apple.com/Developer_Tools/Swift_5_Runtime_Support_for_Command_Line_Tools/Swift_5_Runtime_Support_for_Command_Line_Tools.dmg

copy:
	cp -r .build/checkouts/grpc-swift/Sources/protoc-gen-grpc-swift/. ./Sources/protoc-gen-swiftgrpc
