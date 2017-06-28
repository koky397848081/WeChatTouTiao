//
//  Category.swift
//  TestWechatTouTiao
//
//  Created by jingjing on 2017/6/14.
//  Copyright © 2017年 jingjing. All rights reserved.
//

import Foundation
//JSON解析库
import ObjectMapper
import Moya

struct CategoryIndexResponse:Mappable {
    var status: String?
    var count : Int!
    var categories : [Category]!
    
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        count <- map["count"]
        categories <- map["categories"]
    }
    
}

//数组中的字典模型
struct Category: Mappable {
    var id : Int!
    var title :String!
    var count : Int!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        count <- map["post_count"]     //可以将json格式映射我们想要的，去掉下划线的样式
        title <- map["title"]
    }
}



//分类
extension Category{
    
    //获取分类
  static  func request(completion:@escaping ([Category]?) -> Void) {  //@escaping跳出函数外的返回   // 并不需要实例函数，可以添加static关键字  ,外部调用方法：Category.request
        
        let provider = MoyaProvider<NetworkService>()
        provider.request(.category) { result in
            switch result {
            case let .success(moyaResponse):
                //            let data = moyaResponse.data
                //            let statusCode = moyaResponse.statusCode
                //            print("data = \(data)",statusCode)
                let json = try! moyaResponse.mapJSON() as! [String:Any] //强制转字典键类型
                if let jsonResponse = CategoryIndexResponse(JSON:json){
                    print(jsonResponse.categories,jsonResponse.status,jsonResponse.count)
                    completion(jsonResponse.categories)
                }
                
            case let .failure(error):
                print("网络错误 \(error)")
                completion(nil)

            }
        }
    }
    
}
