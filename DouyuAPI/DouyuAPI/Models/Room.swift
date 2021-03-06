//
//  Room.swift
//  DouyuAPI
//
//  Created by Luo Sheng on 16/6/5.
//  Copyright © 2016年 Luo Sheng. All rights reserved.
//

import Foundation
import ObjectMapper

public class Room: Mappable {
    
    public var identifier: String?
    public var src: NSURL?
    public var name: String?
    public var nickName: String?
    public var onlineNumber: Int?
    public var HTTPLiveStreamingURL: NSURL?
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        identifier <- map["room_id"]
        src <- (map["room_src"], URLTransform())
        name <- map["room_name"]
        nickName <- map["nickname"]
        onlineNumber <- map["online"]
        HTTPLiveStreamingURL <- (map["hls_url"], URLTransform())
    }
    
}