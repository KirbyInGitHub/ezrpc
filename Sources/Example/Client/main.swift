//
//  File.swift
//  
//
//  Created by zhangpeng on 2020/3/28.
//

import Foundation
import GRPCKit

var shouldExit = false

GRPCKit.grpcCient = LTServiceClient()

testLT()

autoreleasepool {
    let runLoop = RunLoop.current
    while (!shouldExit && (runLoop.run(mode: RunLoop.Mode.default, before: Date.distantFuture))) {}
}



