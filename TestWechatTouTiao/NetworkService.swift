//
//  NetworkService.swift
//  TestWechatTouTiao
//
//  Created by jingjing on 2017/6/14.
//  Copyright © 2017年 jingjing. All rights reserved.
//

import Foundation
//网络库
import Moya

//enum all API targets
enum NetworkService {
    case category
    case categoryPosts(id:Int)
    case submitComment(postId:Int,name:String,email:String,content:String)
   // case createUser(firstName: String, lastName: String)    //可以带参数
}

// MARK: - TargetType Protocol Implementation
extension NetworkService:TargetType{
    /*
     return URLEncoding.default // Send parameters in URL for GET, DELETE and HEAD. For other HTTP methods, parameters will be sent in request body
     return URLEncoding.queryString // Always sends parameters in URL, regardless of which HTTP method is used
     return JSONEncoding.default // Send parameters as JSON in request body
     
     */
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .category,.categoryPosts,.submitComment:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        // 用于单元测试
        switch self {
        case .category:
            return "success and the method has not paramter".utf8Encoded   //utf8扩展在下面
        case .categoryPosts(let id):
            return "success and the id is \(id)".utf8Encoded
        case .submitComment(let postId,let  name, let email,let  content):
            return "success and the id is \(postId),\(name),\(email),\(content)".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .category,.categoryPosts,.submitComment:
        return .request   //访问网址只取值，还可以下载，上传
        }
    }
    
    var baseURL: URL {
        return URL(string: "http://192.168.8.199:8888/wordpress/api")!
    }
    
    var path: String {
        switch self {
        case .category:
            return "/get_category_index"
        case .categoryPosts:
            return "get_category_posts"
        case .submitComment:
            return "/respond/submit_comment"
        }
    }
    
    var method: Moya.Method{
        switch self{
        case .category,.categoryPosts,.submitComment:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .category:
            return nil   //get请求通常没有参数
        case .categoryPosts(let id):
            return ["id" : id]
        case .submitComment(let postId,let  name, let email,let  content):
            return ["post_id":postId,"name":name,"email":email,"content":content]
        }
    }
    
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}


