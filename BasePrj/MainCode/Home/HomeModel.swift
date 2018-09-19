//
//  HomeModel.swift
//  EFarmSwift
//
//  Created by n369 on 2017/8/31.
//  Copyright © 2017年 Shown. All rights reserved.
//

import Foundation

//枚举 同样默认其他类可以访问
enum ModelType : Int {
    case product = 1
    case productNews = 2
    case productCases = 3
    case productVideo = 4
    case farmNews = 5
    case other = 6
}

let CellHeightTitle : CGFloat = 80-72 + 72/115*(ScreenWidth/3-30.0/3)
let CellHeightOnePic : CGFloat = 120-72 + 72/115*(ScreenWidth/3-30.0/3)
let CellHeightThreePic : CGFloat = 140-72 + 72/115*(ScreenWidth/3-30.0/3)

class HomeModel {
    
    /// ID
    let id :Int

    /// 标题
    let title : String
    
    /// 副标题
    let detail : String?
    
    /// 图片数组
    let images : [String]?
    
    /// 类型
    var type : ModelType = ModelType.other
    
    /// 发布时间
    var time : String
    
    // MARK: - cell使用
    /// cell高度
    var cellHeight : CGFloat
    /// cell显示的详情
    var cellDetail : String
    
    init(id:Int,title:String,detail:String,images:[String]? = nil,type :ModelType ,time:String) {
        self.id = id
        self.title = title
        self.detail = detail
        self.images = images
        self.type = type
        self.time = time
        
        if (images?.count)! > 2 {
            self.cellHeight = CellHeightThreePic
        } else if (images?.count)! > 0 {
            self.cellHeight = CellHeightOnePic
        } else {
            self.cellHeight = CellHeightTitle
        }
        //返回一个Substring对象
        let detail = time.prefix(10);
//        let detail = (time as NSString).substring(to: 10)
        self.cellDetail = detail + "  " + self.detail!
        
    }
    
    init?() {
        print("can not create model")
        return nil
    }
}

class HomeModelList {
    
    var page : Int!
    
    var haveNextPage : Bool
    
    var news : [HomeModel]?
    
    init(page:Int, haveNextPage:Bool, news:[HomeModel]?){
        self.page = page
        
        self.haveNextPage = haveNextPage
        
        self.news = news
    }
}
