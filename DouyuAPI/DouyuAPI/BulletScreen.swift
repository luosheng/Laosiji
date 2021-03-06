//
//  BulletScreen.swift
//  DouyuAPI
//
//  Created by Luo Sheng on 6/6/16.
//  Copyright © 2016 Luo Sheng. All rights reserved.
//

import Foundation
import CocoaAsyncSocket
import ObjectMapper

public protocol BulletScreenDelegate {
    
    func didReceiveBulletMessage(message: BulletMessage)
    
}

public class BulletScreen: GCDAsyncSocketDelegate {
    
    enum Tag: Int {
        case Login = 1
        case Join
        case Sync
        case General
    }
    
    enum ResponseType: String {
        case Chat = "chatmsg"
    }
    
    struct Constants {
        static let syncTimeInterval: NSTimeInterval = 45
    }
    
    let roomID: String
    var socket: GCDAsyncSocket!
    var syncTimer: NSTimer?
    
    public var delegate: BulletScreenDelegate?
    
    public init(roomID: String) {
        self.roomID = roomID
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        try! socket.connectToHost("openbarrage.douyutv.com", onPort: 8601, withTimeout: 10)
    }
    
    @objc public func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        let loginCommand = "type@=loginreq/roomid@=\(roomID)/"
        sendCommandTo(sock, command: loginCommand, tag: .Login)
        
        syncTimer = NSTimer(timeInterval: Constants.syncTimeInterval, target: self, selector: #selector(sync), userInfo: nil, repeats: true)
        syncTimer?.fire()
    }
    
    @objc public func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        
    }
    
    @objc public func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        if let dict = parseResponse(data),
            rawType = dict["type"],
            type = ResponseType(rawValue: rawType) {
            switch type {
            case .Chat:
                if let message = Mapper<BulletMessage>().map(dict) {
                    delegate?.didReceiveBulletMessage(message)
                }
            default:
                break
            }
        }
        
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
    
    @objc func sync(timer: NSTimer) {
        let syncCommand = "type@=keeplive/tick@=\(Int(NSDate().timeIntervalSince1970))/"
        sendCommandTo(socket, command: syncCommand, tag: .Sync)
    }
    
    private func parseResponse(data: NSData) -> [String:String]? {
        let subdata = data.subdataWithRange(NSRange(location: 12, length: data.length - 12))
        if let response = String(data: subdata, encoding: NSUTF8StringEncoding) {
            let segs = response.componentsSeparatedByString("/")
            var dict: [String:String] = [:]
            segs.forEach { seg in
                let pair = seg.componentsSeparatedByString("@=")
                if pair.count == 2 {
                    dict[pair[0]] = pair[1]
                }
            }
            return dict
        }
        return nil
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