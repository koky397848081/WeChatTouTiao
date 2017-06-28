//
//  DetailViewController.swift
//  TestWechatTouTiao
//
//  Created by jingjing on 2017/6/15.
//  Copyright © 2017年 jingjing. All rights reserved.
//

import UIKit
import WebKit
import LeoDanmakuKit

class DetailViewController: UIViewController {
    var webView:WKWebView!
    var url:URL!
    var content:String!
    var post:Post!
    var danmuOff = true
    
    @IBOutlet weak var danmuView: LeoDanmakuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHtml()
        view.insertSubview(webView, at: 0)
        loadDanmu(comments: post.comments)
    }
    
    func loadDanmu(comments:[Comment]? = nil,postAComment:String? = nil){
        if danmuOff {
            danmuView.resume()
            //弹幕数组
            if let comments = comments{
                let danmus: [LeoDanmakuModel] = comments.map{
                    
                    let model = LeoDanmakuModel.randomDanmku(withColors: UIColor.danmu, maxFontSize: 30, minFontSize: 14)
                    model?.text =  $0.content.htmlString //使用扩展去除html标签
                    return model!
                }
                danmuView.addDanmaku(with: danmus)
            }
            
            //单条的
            if let comment = postAComment{
                
                let model = LeoDanmakuModel.randomDanmku(withColors: UIColor.danmu, maxFontSize: 30, minFontSize: 14)
                model?.text = comment
                danmuView.addDanmaku(model)
                
            }
        }else{
            danmuView.stop()
        }
    }
    
    func loadHtml() {
        let frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64)
        self.webView = WKWebView(frame:frame)
        view.addSubview(self.webView)
        
        //    self.webView.load(URLRequest(url:url))
        webView.loadHTMLString(content, baseURL: nil)  //直接解析自带的html，但是加载出来的没有样式（字体大小配图等丑，需要做h5移动端适配优化）
        
        
        let head =   """
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0\">
<style>
 img { width:100% } body {font-size:100%;}
</style>

</head>

<body>
"""
        
        let foot =   """

</body>
</html>
"""
        webView.loadHTMLString(head + content + foot, baseURL: nil)
        
        //
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
