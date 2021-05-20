//
//  GRPCInterceptor.swift
//  
//
//  Created by 张鹏 on 2021/5/20.
//

import GRPC
import SwiftProtobuf
import NIO

class GRPCInterceptor<Request: SwiftProtobuf.Message, Response: SwiftProtobuf.Message>: ClientInterceptor<Request, Response> {
    

    override func send(_ part: GRPCClientRequestPart<Request>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Request, Response>) {
        
        context.send(part, promise: promise)
    }
    
    override func receive(_ part: GRPCClientResponsePart<Response>, context: ClientInterceptorContext<Request, Response>) {
        
        context.receive(part)
    }
    
    override func cancel(promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Request, Response>) {
        
        context.cancel(promise: promise)
    }
    
    override func errorCaught(_ error: Error, context: ClientInterceptorContext<Request, Response>) {
        
        context.errorCaught(error)
    }
}
