//
//  File.swift
//  
//
//  Created by zhangpeng on 2020/3/30.
//

import GRPC
import SwiftProtobuf
import NIO

public var grpcCient: AnyGRPCClient? = nil

public protocol AnyGRPCClient: GRPCClient {
    
    var isUAT: Bool { get }
    
    func makeChannel() -> GRPCChannel
    
    func makeOptions() -> CallOptions
}

extension AnyGRPCClient {
    
    public var channel: GRPCChannel {
        return makeChannel()
    }
    
    public var defaultCallOptions: CallOptions {
        get {
            return makeOptions()
        }
        set {}
    }
}
