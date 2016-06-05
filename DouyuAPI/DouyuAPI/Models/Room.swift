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
    
    public var id: String?
    public var src: String?
    public var name: String?
    public var nickName: String?
    public var onlineNumber: Int?
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        id <- map["room_id"]
        src <- map["room_src"]
        name <- map["room_name"]
        nickName <- map["nickname"]
        onlineNumber <- map["online"]
    }
    
}