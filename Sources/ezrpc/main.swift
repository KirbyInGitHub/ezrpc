//
//  File.swift
//  
//
//  Created by 张鹏 on 2021/4/26.
//

import Foundation
import SwiftShell
import ArgumentParser

let protocURL = "https://github.com/protocolbuffers/protobuf/releases/download/v3.15.8/protoc-3.15.8-osx-x86_64.zip"

do {
    
    print("1. 初始化")
    
    // If there is an argument, try opening it as a file. Otherwise use standard input.
    let input = try main.arguments.first.map {try open($0)} ?? main.stdin

    input.lines().enumerated().forEach { (linenr,line) in
        print(linenr+1, ":", line)
    }

    // Add a newline at the end.
    print("")
} catch {
    exit(error)
}
