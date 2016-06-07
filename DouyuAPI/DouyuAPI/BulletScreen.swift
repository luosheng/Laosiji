//
//  BulletScreen.swift
//  DouyuAPI
//
//  Created by Luo Sheng on 6/6/16.
//  Copyright © 2016 Luo Sheng. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public class BulletScreen: NSObject, GCDAsyncSocketDelegate {
    
    let roomID: String
    var socket: GCDAsyncSocket!
    
    public init(roomID: String) {
        self.roomID = roomID
        
        super.init()
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        try! socket.connectToHost("openbarrage.douyutv.com", onPort: 8601, withTimeout: 10)
    }
    
    public func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        
    }
    
    public func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        
    }
    
}