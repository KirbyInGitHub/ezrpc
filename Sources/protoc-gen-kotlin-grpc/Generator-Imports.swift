/*
 * Copyright 2020, gRPC Authors All rights reserved.
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
import SwiftProtobuf
import SwiftProtobufPluginLibrary



extension Generator {
  internal func printProtobufImports() {
//    println("// Provides conformance to `GRPCPayload` for request and response messages")
    for service in self.file.services {
      self.service = service
      for method in self.service.methods {
        self.method = method
        self.printImport(for: self.method.inputType)
        self.printImport(for: self.method.outputType)
      }
      println()
    }
  }

  private func printImport(for message: Descriptor) {
    guard !self.observedMessages.contains(message.fullName) else {
      return
    }
    self.println("import \(getImportInputClass(message.file)).\(message.name)")
    self.observedMessages.insert(message.fullName)
  }
    
    internal func hasConflictingClassName(_ file: FileDescriptor,
                                          _ classname: String) -> Bool {
        
        for enumType in file.enums where enumType.name.lowercased() == classname.lowercased() {
            return true
        }
        for service in file.services where service.name.lowercased() == classname.lowercased() {
            return true
        }
        for messageType in file.messages where messageType.name.lowercased() == classname.lowercased() {
            return true
        }
        return false
    }

    static let kOuterClassNameSuffix = "OuterClass"

    internal func getFileDefaultImmutableClassName(_ file: FileDescriptor) -> String {
        
        let fileName = file.name.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
        let basename = fileName.components(separatedBy: "_").map { $0.capitalized }.joined()
        
        return basename.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    internal func getFileImmutableClassName(_ file: FileDescriptor) -> String {
        if !file.proto.options.javaOuterClassname.isEmpty {
            return file.proto.options.javaOuterClassname
        }
        var classname = getFileDefaultImmutableClassName(file)
        if hasConflictingClassName(file, classname) {
            classname += Generator.kOuterClassNameSuffix
        }
        return classname
    }

    internal func getImportInputClass(_ file: FileDescriptor) -> String {
        
        return file.proto.options.javaPackage + "." + getFileImmutableClassName(file)
    }
}

