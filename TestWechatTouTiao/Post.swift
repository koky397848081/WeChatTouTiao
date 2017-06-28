//
//  CategoryDetail.swift
//  TestWechatTouTiao
//
//  Created by jingjing on 2017/6/15.
//  Copyright © 2017年 jingjing. All rights reserved.
//

import Foundation

import ObjectMapper
import Moya

struct PostIndexResponse:Mappable {
    var status: String?
    var count : Int!
    var pages:Int!
    //var categories : [Category]!
    var posts:[Post]!
     
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        count <- map["count"]
     //   categories <- map["categories"]
        pages <- map["pages"]
        posts <- map["posts"]
    }
}

struct SubmitResponse:Mappable {
    var status: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
    }
}

struct Post:Mappable {
    var id : Int!
    var title :String!
    var url:String!
    var content:String!
    var date:String!
    var commentCount :Int!
    var comments:[Comment]!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        url <- map["url"]
        title <- map["title"]
        content <- map["content"]
        date <- map["date"]
        commentCount <- map["comment_count"]
        comments <- map["comments"]
        
        
    }
}

struct Comment:Mappable {
    var name :String!
    var content:String!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
    name <- map["name"]
    content <- map["content"]
    }
}

extension Post{ 
    //获取分类下文章列表
    static func request(id:Int ,completion:@escaping ([Post]?) -> Void ){
        let provider = MoyaProvider<NetworkService>()
        provider.request(.categoryPosts(id:id)){ (result) in
            switch result {
            case let .success(moyaResponse):
                //            let data = moyaResponse.data
                //            let statusCode = moyaResponse.statusCode
                //            print("data = \(data)",statusCode)
                let json = try! moyaResponse.mapJSON() as! [String:Any] //强制转字典键类型
                if let jsonResponse = PostIndexResponse(JSON:json){
                 //   print(jsonResponse.categories,jsonResponse.posts,jsonResponse.count)
                    completion(jsonResponse.posts)
                }
                
            case let .failure(error):
                print("网络错误 \(error)")
                completion(nil)
            }
        }
        
        
    }
    
}

 func submitComment(postId:Int ,name:String,email:String,content:String,completion:@escaping (Bool) -> Void ){
    let provider = MoyaProvider<NetworkService>()
    provider.request(.submitComment(postId:postId,name:name,email:email,content:content)){ (result) in
        switch result {
        case let .success(moyaResponse):
            let json = try! moyaResponse.mapJSON() as! [String:Any] //强制转字典键类型
            if let jsonResponse = SubmitResponse(JSON:json){
                
                if jsonResponse.status == "ok"{
                    
                    completion(true)
                }else{
                    completion(false)
                    
                }
            }
            
        case let .failure(error):
            print("网络错误 \(error)")
            completion(false)
        }
    }
    
    
}
