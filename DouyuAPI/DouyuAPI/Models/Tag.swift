//
//  Column.swift
//  Laosiji
//
//  Created by Luo Sheng on 16/6/4.
//  Copyright © 2016年 Luo Sheng. All rights reserved.
//

import Foundation
import ObjectMapper

public class Tag: Mappable {
    public var identifier: String?
    public var shortName: String?
    public var name: String?
    public var picName: String?
    public var iconName: String?
    public var picURL: NSURL?
    public var iconURL: NSURL?
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        identifier <- map["tag_id"]
        shortName <- map["short_name"]
        name <- map["tag_name"]
        picName <- map["pic_name"]
        iconName <- map["icon_name"]
        picURL <- (map["pic_url"], URLTransform())
        iconURL <- (map["icon_url"], URLTransform())
    }
}