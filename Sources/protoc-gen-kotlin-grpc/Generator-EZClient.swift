/*
 * Copyright 2018, gRPC Authors All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import SwiftProtobuf
import SwiftProtobufPluginLibrary

extension Generator {
  internal func printEZClient() {
    println()
    printServiceClientImplementation()
  }
    
  private func printServiceClientImplementation() {
    println("object \(clientClassName) {")
    println()
    indent()
    for method in service.methods {
      self.method = method
      switch streamingType(method) {
      case .unary:
        println("/// Asynchronous unary call to \(method.name).")
        println("///")
        printParameters()
        printRequestParameter()
        printCallOptionsParameter()
        println("/// - Returns: A `UnaryCall` with futures for the metadata, status and response.")
        println("fun \(methodFunctionName)(request: \(methodInputName), listener: EzbuyStreamObserver<\(methodOutputName)>) {")
        indent()
        println()
        println("val channel = TGrpc.getInstance().channel")
        println("val callOptions = TGrpc.getInstance().callOptions")
        println()
        println()
        println("val methodDescriptor = MethodDescriptor.create(MethodType.UNARY,")
        println("                          MethodDescriptor.generateFullMethodName(\"\(servicePath)\", \"\(method.name)\"),")
        println("                          ProtoLiteUtils.marshaller(\(methodInputName).getDefaultInstance()),")
        println("                          ProtoLiteUtils.marshaller(\(methodOutputName).getDefaultInstance()))")
        println()
        println("ClientCalls.asyncUnaryCall<\(methodInputName),")
        println("\(methodOutputName)>(channel.newCall(methodDescriptor, callOptions), request, listener)")
        println()
        outdent()
        println("}")


      default:
        println("其他模式暂时不支持")
      }
      println()
    }
    outdent()
    println("}")
  }

  private func printClientStreamingDetails() {
    println("/// Callers should use the `send` method on the returned object to send messages")
    println("/// to the server. The caller should send an `.end` after the final message has been sent.")
  }

  private func printParameters() {
    println("/// - Parameters:")
  }

  private func printRequestParameter() {
    println("///   - request: Request to send to \(method.name).")
  }

  private func printCallOptionsParameter() {
    println("///   - callOptions: Call options; `self.defaultCallOptions` is used if `nil`.")
  }

  private func printHandlerParameter() {
    println("///   - handler: A closure called when each response is received from the server.")
  }
}
