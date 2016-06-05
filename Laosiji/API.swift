//
//  API.swift
//  Laosiji
//
//  Created by Luo Sheng on 16/6/4.
//  Copyright © 2016年 Luo Sheng. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import AlamofireObjectMapper
import ObjectMapper

struct API {
    
    enum Router: URLRequestConvertible {
        static let baseURLString = "http://capi.douyucdn.cn/api/v1/"
        
        case TagsForColumn(column: String)
        
        var URLRequest: NSMutableURLRequest {
            let result: (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .TagsForColumn(let column):
                    return ("getColumnDetail", ["shortName": column])
                }
            }()
            
            let URL = NSURL(string: Router.baseURLString)!
            let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: result.parameters).0
        }
    }
    
    static func fetchTagsForColumn(column: String) -> Observable<[Tag]> {
        return requestArray(Router.TagsForColumn(column: column))
    }
    
    static func fetchAllTags() -> Observable<[Tag]> {
        return fetchTagsForColumn("")
    }
    
    private static func requestArray<T: Mappable>(router: Router) -> Observable<[T]> {
        return Observable.create { observer in
            let request = Alamofire.request(router.URLRequest).responseArray(keyPath: "data") { (response: Response<[T], NSError>) in
                if let value = response.result.value {
                    observer.on(.Next(value))
                    observer.on(.Completed)
                }
            }
            return AnonymousDisposable {
                request.cancel()
            }
        }
    }
}
