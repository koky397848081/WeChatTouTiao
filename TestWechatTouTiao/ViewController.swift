//
//  ViewController.swift
//  TestWechatTouTiao
//
//  Created by jingjing on 2017/6/14.
//  Copyright © 2017年 jingjing. All rights reserved.
//

import UIKit
import Moya
import PageMenu

class ViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    var controllerArray:[UITableViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMenu()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func showMenu(){
        //    label.text = "返回成功" + getCategory()!.description   //Int  转换字符串
        //会报错（网络请求的延迟导致请求还没有获取到值就返回了，可以通过添加安全判断来保证编译通过）
        Category.request { (cates) in
            
            //使用高阶函数
            self.controllerArray = cates!.map{
                //把请求的 cates 转化对应的SB控制器，把title赋值后的控制器放到数组里
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SBID_NEWSLIST") as! NewsTableViewController
                vc.title = $0.title   //$0 代表cates中的一个元素
                vc.parentNav = self.navigationController!
                vc.id = $0.id
                return vc
            }
            let parameters: [CAPSPageMenuOption] = [
               // .menuItemSeparatorWidth(1.3),
                 .menuItemWidth(80),
                .scrollMenuBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
                .viewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
                .selectionIndicatorColor(UIColor.orange),
               // .addBottomMenuHairline(false),
                .menuItemFont(UIFont(name: "HelveticaNeue", size: 20.0)!),
                .selectionIndicatorHeight(2.0),
                .selectedMenuItemLabelColor(UIColor.orange),
                .useMenuLikeSegmentedControl(false),
                .menuItemSeparatorRoundEdges(true)
            ]
            let frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64)
            
            self.pageMenu = CAPSPageMenu(viewControllers: self.controllerArray, frame: frame, pageMenuOptions: parameters)
            self.view.addSubview(self.pageMenu!.view)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

