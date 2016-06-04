//
//  API.swift
//  Laosiji
//
//  Created by Luo Sheng on 16/6/4.
//  Copyright © 2016年 Luo Sheng. All rights reserved.
//

import Foundation
import Alamofire

struct API {
    
    enum Router: URLRequestConvertible {
        static let baseURLString = "http://capi.douyucdn.cn/api/v1/"
        
        case GetColumnDetail(column: String)
        
        var URLRequest: NSMutableURLRequest {
            let result: (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .GetColumnDetail(let column):
                    return ("getColumnDetail", ["shortName": column])
                }
            }()
            
            let URL = NSURL(string: Router.baseURLString)!
            let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: result.parameters).0
        }
    }
}
