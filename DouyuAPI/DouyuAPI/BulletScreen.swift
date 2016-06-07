//
//  BulletScreen.swift
//  DouyuAPI
//
//  Created by Luo Sheng on 6/6/16.
//  Copyright © 2016 Luo Sheng. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

public class BulletScreen: GCDAsyncSocketDelegate {
    
    enum Tag: Int {
        case Login = 1
        case Join
        case General
    }
    
    let roomID: String
    var socket: GCDAsyncSocket!
    
    public init(roomID: String) {
        self.roomID = roomID
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        try! socket.connectToHost("openbarrage.douyutv.com", onPort: 8601, withTimeout: 10)
    }
    
    @objc public func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        let loginCommand = "type@=loginreq/roomid@=\(roomID)/"
        sendCommandTo(sock, command: loginCommand, tag: .Login)
    }
    
    @objc public func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        
    }
    
    @objc public func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        let subdata = data.subdataWithRange(NSRange(location: 12, length: data.length - 12))
        let response = String(data: subdata, encoding: NSUTF8StringEncoding)
        
        print(response)
        
        guard let t = Tag(rawValue: tag) else {
            return
        }
        
        switch t {
        case .Login:
            let joinCommand = "type@=joingroup/rid@=\(roomID)/gid@=-9999/"
            sendCommandTo(sock, command: joinCommand, tag: .Join)
        default:
            break
        }
        
        sock.readDataWithTimeout(-1, tag: Tag.General.rawValue)
    }
    
    private func toBytes(str: String) -> NSData {
        var bytes: [UInt8] = []
        let content = Array(str.utf8)
        let length: [UInt8] = [UInt8(content.count + 0x09), 0x00, 0x00, 0x00]
        bytes += length
        bytes += length
        bytes += [0xb1, 0x02, 0x00, 0x00]
        bytes += content
        bytes += [0x0]
        
        let data = NSData(bytes: bytes)
        return data
    }
    
    private func sendCommandTo(sock: GCDAsyncSocket, command: String, tag: Tag) {
        let data = toBytes(command)
        sock.writeData(data, withTimeout: -1, tag: tag.rawValue)
        sock.readDataWithTimeout(-1, tag: tag.rawValue)
    }
    
}