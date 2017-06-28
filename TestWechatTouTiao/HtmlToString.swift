//
//  HtmlToString.swift
//  TestWechatTouTiao
//
//  Created by jingjing on 2017/6/26.
//  Copyright © 2017年 jingjing. All rights reserved.
//

//import Foundation

//去除html中的标签

extension String{
    
    var htmlToAttributeString:NSAttributedString? {
        do {
            return try NSAttributedString(data:Data(utf8),options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:String.Encoding.utf8.rawValue],documentAttributes:nil)
        } catch  {
            print(error)
            return nil
        }
    }
    
    var htmlString:String{
        
        return htmlToAttributeString?.string ?? ""
    }
    
    
}
