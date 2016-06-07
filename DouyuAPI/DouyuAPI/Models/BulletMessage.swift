//
//  BulletMessage.swift
//  DouyuAPI
//
//  Created by Luo Sheng on 6/7/16.
//  Copyright © 2016 Luo Sheng. All rights reserved.
//

import Foundation
import ObjectMapper

public class BulletMessage: Mappable, CustomDebugStringConvertible {
    
    public var text: String?
    public var name: String?
    public var level: String?
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        text <- map["txt"]
        name <- map["nn"]
        level <- map["level"]
    }
    
    public var debugDescription: String {
        return "\(name): \(text)"
    }
    
}