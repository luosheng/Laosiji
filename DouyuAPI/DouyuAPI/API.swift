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
import CryptoSwift

public struct API {
    
    enum Router: URLRequestConvertible {
        static let baseURLString = "http://capi.douyucdn.cn/api/v1/"
        
        case TagsForColumn(column: String)
        case RoomsForTag(tagID: String)
        case RoomForID(ID: String)
        
        var URLRequest: NSMutableURLRequest {
            let result: (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .TagsForColumn(let column):
                    return ("getColumnDetail", ["shortName": column])
                case .RoomsForTag(let tagID):
                    return ("live/\(tagID)", [:])
                case .RoomForID(let ID):
                    return ("room/\(ID)", [:])
                }
            }()
            
            let timestamp = Int(NSDate().timeIntervalSince1970)
            var path = "\(result.path)?aid=android&clientsys=android&time=\(timestamp)"
            let auth = "\(path)1231".md5()
            
            var p = result.parameters
            p["aid"] = "android"
            p["clientsys"] = "android"
            p["time"] = timestamp
            p["auth"] = auth
            
            let URL = NSURL(string: Router.baseURLString)!
            let URLRequest = NSURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            let encoded = encoding.encode(URLRequest, parameters: p).0
            return encoded
        }
    }
    
    public static func fetchTagsForColumn(column: String) -> Observable<[Tag]> {
        return requestArray(Router.TagsForColumn(column: column))
    }
    
    public static func fetchAllTags() -> Observable<[Tag]> {
        return fetchTagsForColumn("")
    }
    
    public static func fetchRoomsForTag(tagID: String) -> Observable<[Room]> {
        return requestArray(Router.RoomsForTag(tagID: tagID))
    }
    
    public static func fetchRoomForID(ID: String) -> Observable<Room> {
        return requestObject(Router.RoomForID(ID: ID))
    }
    
    private static func requestObject<T: Mappable>(router: Router) -> Observable<T> {
        return Observable.create { observer in
            let request = Alamofire.request(router.URLRequest).responseObject(keyPath: "data") { (response: Response<T, NSError>) in
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
